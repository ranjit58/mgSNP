#!/bin/bash
#SBATCH --partition=long
#SBATCH --job-name=bwa2snp
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --share
#SBATCH --mem=100000
#SBATCH --time=150:00:00
#SBATCH --output=bwa2snp.%j.out
#SBATCH --error=bwa2snp.%j.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=rkumar@uab.edu

# Check for dependent folders and files

if [ ! -e RAWDATA_QC ]
then
	echo -e "\nERROR: Folder RAWDATA_QC not found. Please check the data and try again\n"
	exit
fi

if [ ! -e samples.list ]
then
        echo -e "\nERROR: File 'samples.list' not found. Please check the data and try again\n"
        exit
fi

if [ ! -e genomes.list ]
then
        echo -e "\nERROR: File 'genomes.list' not found. Please check the data and try again\n"
        exit
fi

###---------------------------
echo "Reading sample list"
SAMPLE_LIST=`cat samples.list|tr '\n' ' '`


###---------------------------
echo "Unzipping the compressed data in RAWDATA_QC folder"
run_unzip.sh


###----------------------------
echo "Runing BWA, 6 parallel threads each with 4 multithreading"
parallel -j6 mgSNP_bwa.sh ::: $SAMPLE_LIST


###-----------------------------
echo "Running BWA filter"
mkdir BWA_FILTERED
cd BWA_FILTERED

parallel -j23 'mgSNP_sam-filter.py -i ../BWA_FILES/{}.sam -o {}.filtered.sam' ::: $SAMPLE_LIST
parallel -j23 'grep -v "XA:" {}.filtered.sam >{}.filtered2.sam' ::: $SAMPLE_LIST
parallel -j23 'rm {}.filtered.sam' ::: $SAMPLE_LIST
parallel -j23 'mv {}.filtered2.sam {}.filtered.sam' ::: $SAMPLE_LIST

cd ..


###------------------------------
mkdir GATK_STEPS
cd GATK_STEPS

parallel -j23 mgSNP_gatk.sh  ::: $SAMPLE_LIST
cd ..

ls GATK_STEPS/*.bam >bam.list


###------------------------------
run_mgSNP_gatk-SNP.sh







