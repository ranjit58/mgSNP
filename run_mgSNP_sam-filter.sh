#!/bin/bash
#SBATCH --partition=medium
#SBATCH --job-name=sam-filter
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --share
#SBATCH --mem=200000
#SBATCH --time=48:00:00
#SBATCH --output=sam-filter.%j.out
#SBATCH --error=sam-filter.%j.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=rkumar@uab.edu

SAMPLE_LIST=`cat samples.list|tr '\n' ' '`
mkdir BWA_FILTERED
cd BWA_FILTERED

parallel -j23 'mgSNP_sam-filter.py -i ../BWA_FILES/{}.sam -o {}.filtered.sam' ::: $SAMPLE_LIST
parallel -j23 'grep -v "XA:" {}.filtered.sam >{}.filtered2.sam' ::: $SAMPLE_LIST
parallel -j23 'rm {}.filtered.sam' ::: $SAMPLE_LIST
parallel -j23 'mv {}.filtered2.sam {}.filtered.sam' ::: $SAMPLE_LIST
