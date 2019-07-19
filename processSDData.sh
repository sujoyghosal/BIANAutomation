cat SDData|sed -e $'s/\t/|/g' -e $'s/"//g'>sdfile
rm -rf o.txt
output="SDData.txt"
firstLine="CR $cr Instance Record|$cr||||||"
bqs=
echo "Enter SD"
read sd
echo "Enter CR"
read cr
echo "Enter BQ"
col=8
i=""
#cat sdfile|cut -f1-7 -d"|"|sed "s/#CR/$cr/g"|sed "s/#BQ/$bq/g">bqout
cat sdfile|cut -f1-7 -d"|"|sed "s/#CR/$cr/g">frout
while read bq
do
#    col=`expr $col + 9`
	if [[ "$bq" == "done" ]];
	then
		echo "Thanks! Finished processing. Output file generated at $output"
		break;
	fi
#	echo "$bq Instance Record|$bq||||||">bqout
	echo "Enter verb for $bq"
	while read verb
	do
		verb=`echo $verb|sed 's/[ (/-]//g'| tr '[:upper:]' '[:lower:]'`
		if [[ "$verb" == "done" ]];
		then
			break;
		fi
#		i="|||||||||"$i
        i=""
		bqm=`echo $bq|sed 's/[ (/-]//g'`
		crm=`echo $cr|sed 's/[ (/-]//g'`
		vu="$(tr '[:lower:]' '[:upper:]' <<< ${verb:0:1})${verb:1}"
		firstLine=$firstLine" $bq $vu""|"
		while read line
		do
#			b=`echo $line|cut -f1 -d"|"|sed 's/[ (/-]//g'| tr '[:upper:]' '[:lower:]'`
#			if [[ "$b" == "$verb" ]]
#			then
				#echo "Writing $line"
#				f7=`echo $line|cut -f1-7 -d"|"| sed "s/#BQ/$bq/g"`
                f7=`echo $line|cut -f1-7 -d"|"|sed "s/#CR/$cr/g"|sed "s/#BQ/$bq/g"`
				case $verb in
					initiate|create|activate|register|evaluate|provide)
                        #echo "col=$col"
						fr=$i`echo $line|cut -f$col -d"|"`
						;;
					update)
                        n=`expr $col + 1`
                        #echo "n=$n"
						fr=$i`echo $line|cut -f$n -d"|"`
						;;
					control)
                        n=`expr $col + 2`
						fr=$i`echo $line|cut -f$n -d"|"`
						;;
					exchange)
                        n=`expr $col + 3`
						fr=$i`echo $line|cut -f$n -d"|"`
						;;
					capture)
                        n=`expr $col + 4`
						fr=$i`echo $line|cut -f$n -d"|"`
						;;
					execute)
                        n=`expr $col + 5`
						fr=$i`echo $line|cut -f$n -d"|"`
					;;
					request)
                        n=`expr $col + 6`
						fr=$i`echo $line|cut -f$n -d"|"`
					;;
					grant)
                        n=`expr $col + 7`
						fr=$i`echo $line|cut -f$n -d"|"`
					;;
					retrieve)
                        n=`expr $col + 8`
						fr=$i`echo $line|cut -f$n -d"|"`
					;;
					*)
					;;
				esac
			echo $fr>>fr
#			fi
		done<sdfile
		echo "Processed $verb"
        paste -d"|" frout fr>frf
        mv frf frout
        rm fr
	done ## end read bq verb
    
	echo "Enter another BQ..."
    col=`expr $col + 9`
done ## end read BQ
echo $firstLine>$output
#cat o.txt >>$output
cat frout>>$output