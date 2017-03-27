declare -A newarray
while read genome sample
do
	newarray[${genome}]="${newarray[${genome}]} $sample" 
	
done < filtered.txt

for key in ${!newarray[@]}; do
    echo ${key} ${newarray[${key}]} >> list_for_compare.txt
done
