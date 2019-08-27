while read line
do
	sed 's/2.0.0/1.0.0/g' $line>outputfile
	mv ./outputfile $line
done<AllYAMLS
