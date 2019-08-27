while read line
do
	sed 's/1.0.0/2.0.0/g' $line>outputfile
	mv ./outputfile $line
done<AllYAMLS
