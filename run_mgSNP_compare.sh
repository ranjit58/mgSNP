LIST_FOR_COMPARE=$1
mkdir COMPARE
cd COMPARE

while read line
do

	genome=` echo "$line" | cut -d ' ' -f 1`

        mkdir $genome
        cd $genome
	
	count=1
        #while read sample
        #do
        #        array[$count]=$sample
	#	count=$[$count +1]
        #done < samples.list
	#echo $count
	#genome="Prevotella_copri_DSM_18205"
	array=(`echo "$line" | cut -d ' ' -f 2-`)
	count=${#array[@]}
	#echo $count	
	for (( i=0; i<$((count - 1 )); i++ ))
	do
	#	echo ${array[@]:$i} 
	#done

        cat <<EOF > z${genome}_${i}.job
#!/bin/bash
#SBATCH --partition=medium
#SBATCH --job-name=z${genome}_${i}
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --share
#SBATCH --mem=10000
#SBATCH --time=24:00:00
#SBATCH --output=z${genome}_${i}.%N.%j.out
#SBATCH --error=z${genome}_${i}.%N.%j.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=rkumar@uab.edu

	LIST_SAMPLES="`echo ${array[@]:$i}`"

	OUT=`echo "z${genome}_${i}.out"`
	echo -en "" >\$OUT
	
	#echo -e "Working on genome $genome"
	set -- \$LIST_SAMPLES
	for a; do
    		shift
    		for b; do
			shift
			echo -en "${genome}:\${a}:\${b}=" >> \$OUT
			echo -e "\$a\n\$b" > ids${i}
			vcftools --vcf ../../GATK-MULTISNP/${genome}/${genome}.vcf --keep ids${i} --remove-indels --recode -c > temp${i}.vcf
			mgSNP_annotator.py -i temp${i}.vcf -o temp${i}.ann
                        GETNAME=\`echo ${genome},length=\`
                        GETSTR=\`grep "\$GETNAME" < ../../GATK-MULTISNP/${genome}/${genome}.vcf\`
                        GETLENGTH=\`echo \$GETSTR | cut -d '=' -f 4 | tr -d '>'\`
			XX=\`mgSNP_windowmaker.py -i temp${i}.ann -o temp${i}.win -w 1000 -g \$GETLENGTH\`
			echo -en "\${XX}\n" >> \$OUT 

		done
	done
	
	rm temp${i}.vcf
	rm temp${i}.ann
	rm temp${i}.win
	rm ids${i}	
EOF

sbatch z${genome}_${i}.job

done

cd ..

done < ../$LIST_FOR_COMPARE


