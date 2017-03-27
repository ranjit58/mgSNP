#############################################
Tool_name : mgSNP (metagenomic SNP) analysis 
Author : Ranjit Kumar (ranjit58@gmail.com)
version = '1.0'
Date = '10 Aug 2016'
#############################################

Note: The described workflow below (consists or several scripts described are) for analysing the data on the SLURM computing cluster. The scripts were initially written to work on SLURM cluster and hence has SLURM specific code (for job submission) embedded in it. Each node had 24 CPU, so it may have CPU number coded in scripts and will try to maximize node usage, making extensive use of parallel command (if multithreading is not available).

To-do list (for developer)
----------
1. Create a config file which stores all the configuration information.
2. Sperate SLURM specific code from the main program.


Requirements
------------
1. BWA
2. PICARD (create env variable $PICARD to PICARD folder, such that ${PICARD}/picard.jar points to the jar file)
3. GATK (create env variable $GATK to GATK folder, such that $GATK/GenomeAnalysisTK.jar points to the jar file)
4. VCFTools
5. BEDTools 
6. Trimmomatic (to perform QC filtering)

Installation
------------
No installation is necessary, just add the scripts folder to your PATH variable, to make them accessible.


Directory Structure of the data
-------------------------------

A typical diretory structure for any project (PROJECT_DIR) involves creation of several folders within to store and process data for different stages. 

PROJECT_DIR
├── RAWDATA
├── RAWDATA_QC
├── BWA_FILES
├── BWA_FILTERED
├── GATK_STEPS
├── GATK-SNP
├── GATK-MULTISNP
├── COMPARE
├── COV_STATS
├── filter4comparision
├── samples.list
├── genomes.list
├── bam.list


Usage
-----

Every script has a section "### Please edit the variables ###" which can be used to change project specific path and variables. Before running the script, please check this section to make sure it is correct.

Create a directory for a project (PROJECT_DIR) and enter in it. We will run most of the commands here (unless specified). The samples.list file contain the name of all samples (without any extension which is used across the pipeline). The genomes.list contain the list of genomes (like chromosome) with the size. This file is used to restrict the analysis for certain genomes (if required). 
Creating samples.list (if all sample names carry 'JG' - ls RAWDATA_QC/ | cut -f1 -d '_' | sort|uniq|grep "JG" >samples.list)
Creating genomes.list (e.g. each line represent one genome with size e.g. Bacteroides_vulgatus:1-4781701). Use picard createdictionary command to generate data for this list (e.g. java -jar ${PICARD}/picard.jar CreateSequenceDictionary R=genomes_ref.fa O=genomes_ref.dict)

A reference sequence is created which consist of 93 genomes (as 93 different fasta sequences). For each sequence/genome, if several contigs are present, they were concatenated. Reference sequences were created using code present in folder reference.

The stepwise analysis process is as described below

---   From RAW data to Multisample VCF file   ---

1. Get the raw data. The data is stored in folder RAWDATA. Assume two files (paired) for each samplie. For sample1 the file names are like sample1_F.fastq.gz & sample1_R.fastq.gz. If they are different then either change them as described of change the code for file names in step 2.

2. Perform QC. We use trimmomatic which preserves the mapping/correspondance of paired reads. We ignore single end reads (created after QC) for the analysis. The Trimmomatic expression used is as ILLUMINACLIP:NexteraPE-PE.fa:2:30:10 CROP:100 SLIDINGWINDOW:50:20 MINLEN:50. 
  Run as : run_mgSNP_QC.sh  (code's for loop needs list of sample)
  Output : Creates a directory RAWDATA_QC with four files for each sample (two paired files and two single unmapped reads file). The unpaired files sample1_F_P.fastq.gz sample1_F_S.fastq.gz are used for further analysis.

2.1 Ucompress the content for RAWDATA_QC (paired files). cd RAWDATA_QC; parallel -j23 gunzip ::: *_P.fastq.gz

3. Uses BWA-mem to map raw reads on reference sequence to generate SAM file.
  Run as : run_mgSNP_bwa.sh. This script uses script mgSNP_bwa.sh, make changes if required.
  Output : Creates a folder BWA_FILES with all bam files. 

4. Filter SAM file to exclude reads mapped on multiple location (XA: alernative hits) or if they are less than 95% similar.
  Run as run_mgSNP_sam-filter.sh. This script uses mgSNP_sam-filter.sh, make changes if required.
  Output : Creates a folder BWA_FILTERED with filtered sam files.

5. Follow GATK best practices before SNP calling. 
	a - Sorting sam file and generating bam file using PICARD
	b - Mark duplicates using PICARD
	c - Indexing bam file using PICARD
	d - Creating targets for indel realignment
	e - Indel realignment using GATK

  Run as run_mgSNP_gatk-STEPS.sh. This script uses main script mgSNP_gatk-STEPS.sh, make changes if required.
  Output : Creates a folder GATK_STEPS with BAM files, one for each sample.

5.5 Create a list of bam files. ls GATK_STEPS/*.bam >bam.list

6 Call SNPs - Calls SNP (VCF files) using GATK for each samples and for each genome seperately. The program create a script file and SLURM job file for each genome (each genome file has commands to process all samples). The Jobs files created are submitted on the fly (default).  If you want to check the job scirpt before submitting, then comment the line with word "sbatch" and rerun the script, which will recreate all job scripts (number of genomes).

  Run as run_mgSNP_gatk-SNP.sh. Make changes if required.
  Output : Creates a folder GATK-SNP, inside that, one folder for each genome having VCF files.

Note: If everything is set properly, the workflow script "run_workflow_bwa_snp.sh" can run steps 2.1-7 .

7 Make joint SNP calls (Multisample SNP calling) for each genome (all samples). It creates a vcf list of all samples for a given genome and creates a multisample VCF file for that genome. The program create a SLURM job script file and Jobs files created are submitted on the fly (default).  If you want to check the job scirpt before submitting, then comment the line with word "sbatch" and rerun the script , which will recreate all scripts. 

  Run as run_mgSNP_gatk-GVCF.sh. Make changes if required.
  Output : Creates a folder GATK-SNP, inside that, one folder for each genome which has the multisample VCF file.

------


--- WSS SNP Comparision pipeline ---

General idea - For a given pair of samples, the program tries to identify the genomic windows which has no SNP difference.
The VCFTools is used to extract SNP information from the multisample VCF file, to create a VCF file for two samples being compared.
e.g. vcftools --vcf multisample.vcf --keep sample_ids_to_keep --remove-indels --recode -c > sample_pair.vcf (provide sample_ids_to_keep file with two ids in two line)
The program mgSNP_annotator.py is used to annotate the genomic loci. The file is used for calclation in next step.
e.g. python mgSNP_annotator.py -i sample_pair.vcf -o sample_pair.ann
The program mgSNP_windowmaker.py takes the annotated vcf file and calculate the WSS Score alognwith other information.
e.g. python mgSNP_windowmaker.py -i sample_pair.ann -o sample_pair.win -w WINDOW_SIZE -g GENOME_SIZE (provide genome size and window size)
The result includes following information for the paired analysis in tab delimited format.

Minimum genome coverage for two sample
WSS Score (percent identical windows)
Total windows 
Total good/usable windows
Count of Identical windows
Count of Non-identical windows
Count of No SNP windows
Same SNP loci
Different SNP loci 01 (snp in sample2)
Different SNP loci 10 (snp in sample1)

Implementation of general idea for large scale analysis
When we are analysing 100s of samples, there are too many pairwise calculation which can take long time. So we can filter the genomes and samples for which we want to perform the analysis. The analysis is only suitable for pairs with sample depth > 5X and coverage >20%, so its better to filter non-suitable samples from given genomes.

1. Calculate coverage and depth. VCFtools is used to output how many bases are covered by atleast 1 read (used to calculated coverage), and what is the mean depth in that region. e.g. vcftools --vcf sample1.vcf --depth --out output --minDP 1

  Run as run_mgSNP_cov.sh. to calculate the coverage and depth for all samples for all genomes.
  Run as run_mgSNP_cov_merge.sh. to merge all the coverage stats.
  Run the command cat COV_STATS/*/cov_d1.stats >allcov.stats.
  Output - Creates a folder COV_STATS with the file allcov.stats, that has information which can be used to calculate coverage (use excel). Depth information is already included.

2. The genome and sample for which pairwise calculation needs to be done is put on a file name filtered.txt.
  Run as mgSNP_transform.sh, which can organise the data where each row has a genome and the samples being compared.
  output file produced is called list_for_compare.txt

  Note: If you want to filter the specific genomes and samples, you can use script mgSNP_filter_sample_genome.py. 

3. Run the pairwise comparision - The script "run_mgSNP_compare.sh" reads the list_for_compare.txt and create several SLURM jobs for each genome (equal to number of samples - 1) and submit them to the cluster. For each genome, if it has 10 samples then 45 comparisions need to be done, the program create 9 jobs each performing 9,8,7,6,5,4,3,2,1 comparisions.

  Run as 'run_mgSNP_compare.sh list_for_compare.txt'. Check if the job script created are ok and try running one of it. If it works, then uncomment the line with word "sbatch" and rerun the script which will recreate and submit all scripts (for all samples and genomes).

  Output : Creates a folder COMPARE, inside that, one folder for each genome which has all the job script for pairwise comparision.  

4. Analyse the comparisions. 
  Run rm COMPARE/*/*shealy*; cat COMPARE/*/*.out > all_comparision.out. A table is created that has the pairwise similarity information with WSS Score. The list of Columns are as (tab delimited and "=" delimited)

Genome/Species
Sample1
Sample2
Minimum genome coverage for two sample
WSS Score (percent identical windows)
Total windows count
Total good/usable windows count
Count of Identical windows count
Count of Non-identical windows count
Count of No SNP windows count
Loci count having Same SNP
Loci count having different base/SNP - 01 (snp in sample2 but not in sample 1)
Loci count having different base/SNP - 10 (snp in sample1 but not in sample 2)

------
