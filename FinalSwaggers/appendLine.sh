while read line
do
	sed -e '/## Executive Summary/  a\
	\
	' -e '/## Example of Use/ a\ 
	\
	' -e '/## Description/ a\ 
	\
	' ./$line > ./outputfile
	mv ./outputfile $line
done<AllYAMLS
