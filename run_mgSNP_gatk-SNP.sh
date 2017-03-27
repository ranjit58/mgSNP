mkdir GATK-SNP
cd GATK-SNP

### Please edit the variables ###
REF=/scratch/user/rkumar/work/METAG-COMMON/REFERENCE2/genomes_ref.fa
###

while read line
do
        GENOME_NAME=` echo "$line" | cut -d ':' -f 1`

        mkdir $GENOME_NAME
        cd $GENOME_NAME

        while read sample
        do
                SAMPLE_NAME=`echo "$sample" | cut -d '/' -f 2 | cut -d '_' -f 1`

                echo -e "java -Xmx30g -jar $GATK/GenomeAnalysisTK.jar -T HaplotypeCaller -R $REF -L $line --sample_ploidy 1 -I ../../$sample --emitRefConfidence BP_RESOLUTION -o ${SAMPLE_NAME}.g.vcf"  >> ${GENOME_NAME}_cmd.sh
		
        done < ../../bam.list

	cat <<EOF > ${GENOME_NAME}.job
#!/bin/bash
#SBATCH --partition=medium
#SBATCH --job-name=${GENOME_NAME}
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --mem=250000
#SBATCH --time=48:00:00
#SBATCH --output=${GENOME_NAME}.%N.%j.out
#SBATCH --error=${GENOME_NAME}.%N.%j.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=rkumar@uab.edu

cat ${GENOME_NAME}_cmd.sh | parallel -j23 --joblog log
#gzip *.vcf

EOF

sbatch ${GENOME_NAME}.job

        cd ..


done < ../genomes.list
cd ..


