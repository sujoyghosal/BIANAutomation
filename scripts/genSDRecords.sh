cat $1SDInfo|sed -e $'s/\t/|/g' -e $'s/"//g'>s

while read line
do
	if [[ $line == CR* ]] ;
    then
		cr=`echo $line|cut -f1 -d"|" |sed 's/[ (/-]//g'`
		echo "Writing CR record to $cr"
	fi
	if [[ $line == BQ* ]] ;
    then
		break
	fi
	echo $line >>$cr
done<s
writeBQ="false"
while read line
do
	if [[ $line == BQ* ]] ;
    then
		bq=`echo $line|cut -f1 -d"|"|sed 's/[ (/-]//g'`
		echo "Writing a BQ record to $bq"
		writeBQ="true"
	fi
	if [[ "$writeBQ" == "true" ]]
	then
		echo $line >>$bq
	fi
done<s
