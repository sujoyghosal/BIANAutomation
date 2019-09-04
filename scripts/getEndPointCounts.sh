rm -rf out
while read line
do
	count=`grep "operationId: " $line|wc -l`
	echo "$line - $count"
	echo "$line	$count"|tr -s " ">>out
done<AllYAMLS
