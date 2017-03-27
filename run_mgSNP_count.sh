#!/bin/bash
#SBATCH --partition=medium
#SBATCH --job-name=get_count
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --share
#SBATCH --mem=10000
#SBATCH --time=48:00:00
#SBATCH --output=get_count.%j.out
#SBATCH --error=get_count.%j.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=rkumar@uab.edu

mkdir READ-COUNT
cd READ-COUNT

mkdir RAW-COUNT
cd RAW-COUNT
DIR='../../RAWDATA/'
for i in `ls ${DIR}*.gz`
do
        FILE_NAME=`echo $i | xargs -n 1 basename`
	echo $i `zcat $i | wc -l`> ${FILE_NAME}_rawcount.txt
done
cd ..

mkdir BAM-COUNT
cd BAM-COUNT

DIR='../../BWA_FILES/'

for i in `ls ${DIR}*.sam`
do
        FILE_NAME=`echo $i | xargs -n 1 basename`
        samtools flagstat ${i} > ${FILE_NAME}.flagstat
#	echo $i
done
cd ..



mkdir BAM-FIL-COUNT
cd BAM-FIL-COUNT

DIR='../../BWA_FILTERED/'

for i in `ls ${DIR}*.sam`
do
        FILE_NAME=`echo $i | xargs -n 1 basename`
        samtools flagstat ${i} > ${FILE_NAME}.flagstat
	#echo $i
done
cd ..


mkdir GATK-COUNT
cd GATK-COUNT

DIR='../../GATK_STEPS/'

for i in `ls ${DIR}*.bam`
do
        FILE_NAME=`echo $i | xargs -n 1 basename`
        samtools flagstat ${i} > ${FILE_NAME}.flagstat
        #echo $i
done
cd ..








