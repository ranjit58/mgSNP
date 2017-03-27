#!/bin/bash
### Please edit the variables ###
REF=/scratch/user/rkumar/work/METAG-COMMON/REFERENCE2/genomes_ref.fa
###

mkdir GATK-MULTISNP
cd GATK-MULTISNP

while read line
do

        GENOME_NAME=` echo "$line" | cut -d ':' -f 1`

	mkdir $GENOME_NAME
	cd $GENOME_NAME
	
	cat <<EOF > ${GENOME_NAME}.job
#!/bin/bash
#SBATCH --partition=medium
#SBATCH --job-name=${GENOME_NAME}
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --share
#SBATCH --mem=50000
#SBATCH --time=48:00:00
#SBATCH --output=${GENOME_NAME}.%N.%j.out
#SBATCH --error=${GENOME_NAME}.%N.%j.err
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=rkumar@uab.edu

	ls ../../GATK-SNP/${GENOME_NAME}/*.g.vcf > allvcf.list
	java -Xmx50g -jar \$GATK/GenomeAnalysisTK.jar -T GenotypeGVCFs -R $REF --sample_ploidy 1 --variant allvcf.list --includeNonVariantSites -o ${GENOME_NAME}.vcf
	
EOF
sbatch ${GENOME_NAME}.job
cd ..

done < ../genomes.list

cd ..
