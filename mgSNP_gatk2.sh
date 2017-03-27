
#-------------------------------------------------------------------------
# Name - MULTISAMPLE SNP CALLING IN METAGENOMICS
# Tools - BWAMEM, GATK, VCFTools
# Author - Ranjit Kumar (ranjit58@gmail.com)
# University of Alabama at Birmingham
#-------------------------------------------------------------------------

#Golbal variables - Needs to be defined by user
# Note : same as version 1 but have addition option -fixMisencodedQuals  in indel relaignment. required for some runs.
### Please edit the variables ###
REF=/scratch/user/rkumar/work/METAG-COMMON/REFERENCE2/genomes_ref.fa
TEMP=/scratch/user/rkumar/tmp
###

i=$1
# Sort sam file using picard and generate bam file
echo -e "INFO: Sorting sam file and generating bam file"
java \
-Xmx8g \
-Djava.io.tmpdir=$TEMP \
-jar ${PICARD}/picard.jar SortSam \
INPUT=../BWA_FILTERED/${i}.filtered.sam \
OUTPUT=${i}_sorted.bam \
SORT_ORDER=coordinate
echo -e "\nINFO: Step Completed!"

#rm $BWA_FILES/${i}.sam
# Mark duplicates using picard
echo -e "INFO: Marking duplicates using picard"
java \
-Xmx8g \
-Djava.io.tmpdir=$TEMP \
-jar ${PICARD}/picard.jar MarkDuplicates \
VALIDATION_STRINGENCY=SILENT \
CREATE_INDEX=True \
TMP_DIR=$TEMP \
INPUT=${i}_sorted.bam \
OUTPUT=${i}_dedup.bam \
METRICS_FILE=${i}_dedup_metrics.txt \
ASSUME_SORTED=True
echo -e "\nINFO: Step Completed!"


rm ${i}_sorted.bam
# Indexing bam file using picard
echo -e "INFO: Indexiing bam file using picard"
java \
-Xmx8g \
-Djava.io.tmpdir=$TEMP \
-jar ${PICARD}/picard.jar BuildBamIndex \
INPUT=${i}_dedup.bam
echo -e "\nINFO: Step Completed!"

# generate flagstat of bam files using samtools
#echo -e "INFO: Generating flagstat stats using bam files"
#samtools flagstat ${i}_dedup.bam > ${i}.flagstast.txt
#echo -e "\nINFO: Step Completed!"

 # Creating targets for indel realignment
echo -e "INFO: Generating targets for indel realignment"
java \
-Xmx8g \
-Djava.io.tmpdir=$TEMP \
-jar $GATK/GenomeAnalysisTK.jar \
-T RealignerTargetCreator \
-fixMisencodedQuals \
-R $REF \
-o ${i}.intervals \
-I ${i}_dedup.bam
echo -e "\nINFO: Step Completed!"

# Indel realignment
echo -e "INFO: Doing Indel realignment"
java \
-Xmx8g \
-Djava.io.tmpdir=$TEMP \
-jar $GATK/GenomeAnalysisTK.jar \
-T IndelRealigner \
-R $REF \
-fixMisencodedQuals \
-targetIntervals ${i}.intervals \
-I ${i}_dedup.bam \
-o ${i}_realigned.bam
 echo -e "\nINFO: Step Completed!"

rm ${i}.intervals
rm ${i}_dedup.bam
rm ${i}_dedup.bai
rm ${i}_dedup_metrics.txt
