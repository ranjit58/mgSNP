mkdir COV_STATS
cd COV_STATS

while read line
do
        GENOME_NAME=` echo "$line" | cut -d ':' -f 1`
        cd $GENOME_NAME

        FILE_NAME=cov_d1.stats

        for i in `ls d1_*`
        do
                echo -ne "$GENOME_NAME\t" >> $FILE_NAME && cat $i | grep -v "MEAN_DEPTH" >> $FILE_NAME
        done
        cd ..
done < ../genomes.list

