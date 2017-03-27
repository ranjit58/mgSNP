#!/bin/bash
#SBATCH --partition=medium
#SBATCH --job-name=get_cov
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --share
#SBATCH --mem=10000
#SBATCH --time=48:00:00
#SBATCH --output=get_cov.%N.%j.out
#SBATCH --error=get_cov.%N.%j.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=rkumar@uab.edu

mkdir COV_STATS
cd COV_STATS

while read line
do
        GENOME_NAME=` echo "$line" | cut -d ':' -f 1`

        mkdir $GENOME_NAME
        cd $GENOME_NAME

	for sample in `ls ../../GATK-SNP/${GENOME_NAME}/*.vcf | xargs -n 1 basename`        
	do
		echo "working on $GENOME_NAME --> $sample"
		vcftools --vcf ../../GATK-SNP/${GENOME_NAME}/$sample --depth --out d1_$sample --minDP 1
        done

	echo -ne "$GENOME_NAME\t" > ${GENOME_NAME}_d1.stats && cat d1_*.idepth | grep -v "MEAN_DEPTH" | tr "\n" "\t" >> ${GENOME_NAME}_d1.stats
        cd ..

done < ../genomes.list


