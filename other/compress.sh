
cd BWA_FILTERED
parallel -j20 gzip {} ::: *.sam
cd ..

tar -czf GATK-SNP.tar.gz GATK-SNP

