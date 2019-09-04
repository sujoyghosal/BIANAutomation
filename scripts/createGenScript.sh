rm -rf runAll.sh
while read line
do
	count=`grep "operationId: " $line|wc -l`
	echo "$line - $count"
	echo "generateNewSwagger.sh $line $count"|tr -s " ">>runAll.sh
done<AllYAMLS
