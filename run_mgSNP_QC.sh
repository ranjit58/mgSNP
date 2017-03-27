#!/bin/bash
#SBATCH --partition=long
#SBATCH --job-name=qc_
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=15
#SBATCH --share
#SBATCH --mem=100000
#SBATCH --time=150:00:00
#SBATCH --output=ant_qc.%j.out
#SBATCH --error=ant_qc.%j.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=rkumar@uab.edu

mkdir RAWDATA_QC
cd RAWDATA_QC

### Please edit the variables ### 
TOOL=/share/apps/ngs-ccts/TRIMMOMATIC/Trimmomatic-0.36/trimmomatic-0.36.jar
RAWDATA=/home/rkumar/workdir/work/JG/RAWDATA
cp /share/apps/ngs-ccts/TRIMMOMATIC/Trimmomatic-0.36/adapters/NexteraPE-PE.fa .
###

for SAMPLE in JG5000A JG5000B JG5000D JG5000E JG5012A JG5012B JG5017A JG5017B JG5028A JG5028B JG5028C
do
        java -jar $TOOL PE -threads 15 -phred33 ${RAWDATA}/${SAMPLE}_F.fastq.gz ${RAWDATA}/${SAMPLE}_R.fastq.gz ${SAMPLE}_F_P.fastq.gz ${SAMPLE}_F_S.fastq.gz ${SAMPLE}_R_P.fastq.gz ${SAMPLE}_R_S.fastq.gz ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 CROP:100 SLIDINGWINDOW:50:20 MINLEN:50
        #java -jar $TOOL PE -phred33 ${RAWDATA}/${SAMPLE}F ${RAWDATA}/${SAMPLE}R ${SAMPLE}_F_P.fastq ${SAMPLE}_F_S.fastq ${SAMPLE}_R_P.fastq ${SAMPLE}_R_S.fastq CROP:100 ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 SLIDINGWINDOW:50:20 MINLEN:80

done
