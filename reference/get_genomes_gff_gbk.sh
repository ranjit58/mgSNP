#Usage sh get_genomes.sh allgenomes.links
# allgenomes.links has name and URL seperated by tab for all reference genomes to be downloaded

LINK_FILE=$1

GFF_DIR="gff_genomes"
mkdir $GFF_DIR

while read name url;
do
	newurl="${url/fna/gff}"
    if [ "${newurl: -3}" == "tgz" ]; then
            echo -e "\nINFO: Downloading genome $name\n"
            sleep 2
            curl -o $GFF_DIR/${name}.gff.tgz $newurl

    else
            echo -e "\nINFO: Downloading genome $name\n"
            sleep 2
            curl -o $GFF_DIR/${name}.gff $newurl

    fi 
done < $LINK_FILE

GBK_DIR="gbk_genomes"
mkdir $GBK_DIR

while read name url;
do
        newurl="${url/fna/gbk}"
    if [ "${newurl: -3}" == "tgz" ]; then
            echo -e "\nINFO: Downloading genome $name\n"
            sleep 2
            curl -o $GBK_DIR/${name}.gbk.tgz $newurl

    else
            echo -e "\nINFO: Downloading genome $name\n"
            sleep 2
            curl -o $GBK_DIR/${name}.gbk $newurl

    fi
done < $LINK_FILE
