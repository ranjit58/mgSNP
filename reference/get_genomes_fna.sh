#Usage sh get_genomes_fna.sh allgenomes.links
# allgenomes.links has name and URL seperated by tab for all reference genomes to be downloaded

LINK_FILE=$1

GENOME_DIR="all_genomes"
mkdir $GENOME_DIR
TEMP_DIR="temp_genome"
mkdir $TEMP_DIR
REF="genomes_ref.fa"
touch $REF

while read name url;
do
    if [ "${url: -3}" == "tgz" ]; then
            echo -e "\nINFO: Downloading genome $name\n"
            sleep 2
            curl -o $GENOME_DIR/${name}.tgz $url

            echo -e "\nINFO: Extracting genome $name to directory $TEMP_DIR\n"
            sleep 2
            tar xvf $GENOME_DIR/${name}.tgz -C $TEMP_DIR
    else
            echo -e "\nINFO: Downloading genome $name\n"
            sleep 2
            curl -o $GENOME_DIR/${name}.fna $url

            echo -e "\nINFO: Extracting genome $name to directory $TEMP_DIR\n"
            sleep 2
            cp  $GENOME_DIR/${name}.fna $TEMP_DIR/
    fi 


    echo -e "\nINFO: Copying genome $name to reference sequence $REF\n"
    sleep 2

    echo -e ">${name}" > header.txt
    cat $TEMP_DIR/*.fna | grep -v ">" >sequence.txt
    cat header.txt sequence.txt >> $REF


    echo -e "\nINFO: Cleaning the directory $TEMP_DIR\n"
    sleep 2
    rm $TEMP_DIR/*.fna
    rm header.txt
    rm sequence.txt

done < $LINK_FILE

fasta_formatter -i $REF -o tempref.txt -w 70
mv tempref.txt $REF
rm tempref.txt

echo -e "\nINFO: Cleaning everything\n"
sleep 2
rm -r $TEMP_DIR


