#!/usr/bin/python
# input files are list of genomes and samples to be seleted. list .tx in=s 2 column file where first column is genome and second column is sample name.


INFILE  = open("selected_samples.list",'r')
data = INFILE.read()
samples = data.splitlines()
INFILE.close()

INFILE  = open("selected_genomes.list",'r')
data = INFILE.read()
genomes = data.splitlines()
INFILE.close()

INFILE  = open("list.txt",'r')
OUTFILE = open ("filtered.txt",'w')
for line in INFILE:
	line = line.rstrip('\r\n|\n')  # to remove endlines if any
	info = line.split()
	if info[1] in samples and info[0] in genomes:
		OUTFILE.write(line + "\n")

INFILE.close()
OUTFILE.close()
