#!/bin/bash
#SBATCH --partition=long
#SBATCH --job-name=bwa
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --share
#SBATCH --mem=100000
#SBATCH --time=150:00:00
#SBATCH --output=bwa.%j.out
#SBATCH --error=bwa.%j.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=rkumar@uab.edu

SAMPLE_LIST=`cat samples.list|tr '\n' ' '`
parallel -j6 mgSNP_bwa.sh ::: $SAMPLE_LIST

