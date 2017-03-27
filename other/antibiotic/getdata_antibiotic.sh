#!/bin/bash
#SBATCH --partition=long
#SBATCH --job-name=get_data
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=23
#SBATCH --share
#SBATCH --mem=50000
#SBATCH --time=150:00:00
#SBATCH --output=get_data.%j.out
#SBATCH --error=get_data.%j.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=rkumar@uab.edu

cd RAWDATA

cat data_links_f.txt | parallel -j23 --joblog log
cat data_links_r.txt | parallel -j23 --joblog log

cd ..

