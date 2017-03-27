#!/bin/bash
#SBATCH --partition=medium
#SBATCH --job-name=check_qc
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --share
#SBATCH --mem=10000
#SBATCH --time=10:00:00
#SBATCH --output=check_qc.%j.out
#SBATCH --error=check_qc.%j.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=rkumar@uab.edu

quality_check_rawdata.sh RAWDATA_QC 

