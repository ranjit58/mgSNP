mkdir RAWDATA2

for i in `ls -d RAWDATA/SAME*`
do
	j=`echo $i|cut -c16-`	
	cat ${i}/*_1.fastq.gz > RAWDATA2/${j}_F.fastq.gz
	cat ${i}/*_2.fastq.gz > RAWDATA2/${j}_R.fastq.gz
done
