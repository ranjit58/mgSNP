#!/bin/bash
#SBATCH --partition=long
#SBATCH --job-name=getgff
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --share
#SBATCH --mem=10000
#SBATCH --time=100:00:00
#SBATCH --output=x.%j.out
#SBATCH --error=x.%j.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=rkumar@uab.edu

sh get_genomes_gff_gbk.sh allgenome_links
