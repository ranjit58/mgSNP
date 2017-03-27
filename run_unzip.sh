#!/bin/bash
#SBATCH --partition=medium
#SBATCH --job-name=unzip
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --mem=100000
#SBATCH --time=12:00:00
#SBATCH --output=unzip.%j.out
#SBATCH --error=unzip.%j.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=rkumar@uab.edu

cd RAWDATA_QC
parallel -j23 gunzip ::: *.fastq.gz

cd ..

