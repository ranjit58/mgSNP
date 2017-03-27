#Run BWA
#Threads to run

### Please edit the variables ###
THREAD=4
REF=/data/scratch/rkumar/work/METAG-COMMON/REFERENCE2/genomes_ref.fa
###

SAMPLE=$1
mkdir BWA_FILES
cd BWA_FILES

# preparing readgroup info
READGROUP="@RG\tID:G${SAMPLE}\tSM:${SAMPLE}\tPL:Illumina\tLB:lib1\tPU:unit1"
		
# alignment using BWA MEM with -M and -R options
#bwa mem -M -t $THREAD -R $READGROUP $REF ../RAWDATA_QC/${SAMPLE}_F.fastq ../RAWDATA_QC/${SAMPLE}_R.fastq > ${SAMPLE}.sam
#use if trimmomatic is used
bwa mem -M -t $THREAD -R $READGROUP $REF ../RAWDATA_QC/${SAMPLE}_F_P.fastq ../RAWDATA_QC/${SAMPLE}_R_P.fastq > ${SAMPLE}.sam
echo -e "\nINFO: BWA alignment complete for sample ${SAMPLE}"

cd ..



