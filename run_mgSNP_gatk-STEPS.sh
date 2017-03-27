#!/bin/bash
#SBATCH --partition=long
#SBATCH --job-name=gatk1
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --share
#SBATCH --mem=200000
#SBATCH --time=150:00:00
#SBATCH --output=gatk1.%j.out
#SBATCH --error=gatk1.%j.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=rkumar@uab.edu

SAMPLE_LIST=`cat samples.list|tr '\n' ' '`
mkdir GATK_STEPS
cd GATK_STEPS

parallel -j23 mgSNP_gatk.sh  ::: $SAMPLE_LIST

