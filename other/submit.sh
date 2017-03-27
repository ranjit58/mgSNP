while read line
do
	cd GATK-SNP
        GENOME_NAME=` echo "$line" | cut -d ':' -f 1`

        cd $GENOME_NAME
	sleep 5
	sbatch ${GENOME_NAME}.job
	
	cd ..
	cd ..

done < temp.list
