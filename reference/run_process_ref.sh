
# create BWA index
bwa index genomes_ref.fa
 
# create samtools faidx index
samtools faidx genomes_ref.fa

# create picard dictionary
java -jar ${PICARD}/picard.jar CreateSequenceDictionary R=genomes_ref.fa O=genomes_ref.fa.dict
java -jar ${PICARD}/picard.jar CreateSequenceDictionary R=genomes_ref.fa O=genomes_ref.dict
