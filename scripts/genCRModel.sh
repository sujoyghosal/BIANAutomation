cat CR|sed -e $'s/\t/|/g' -e $'s/"//g'>p
cat p|head -3|cut -f1-7 -d"|">h3
rm -rf b out
i=""
echo "Enter a CR Verb"
while read verb
do
	i="|"$i
	verb=`echo $verb|sed 's/[ (/-]//g'| tr '[:upper:]' '[:lower:]'`
	if [[ "$verb" == "done" ]];
	then
		break;
	fi
	while read line
		do
			a=`echo $line|cut -f1 -d"|"|sed 's/[ (/-]//g'| tr '[:upper:]' '[:lower:]'`
			if [[ "$a" == "$verb" ]]
			then
				#echo "Writing $line"
				f7=`echo $line|cut -f1-7 -d"|"`
				case $verb in
					initiate|create|activate|register|evaluate|provide)
						fr=$i`echo $line|cut -f8 -d"|"`
					;;
					update)
						fr=$i`echo $line|cut -f9 -d"|"`
					;;
					control) 
						fr=$i`echo $line|cut -f10 -d"|"`
					;;
					exchange) 
						fr=$i`echo $line|cut -f11 -d"|"`
					;;
					capture) 
						fr=$i`echo $line|cut -f12 -d"|"`
					;;
					execute) 
						fr=$i`echo $line|cut -f13 -d"|"`
					;;
					request) 
						fr=$i`echo $line|cut -f14 -d"|"`
					;;
					grant) 
						fr=$i`echo $line|cut -f15 -d"|"`
					;;
					retrieve) 
						fr=$i`echo $line|cut -f16 -d"|"`
					;;
					*)
					;;
				esac
			echo $f7$fr>>out
			fi
	done<p
	echo "Processed $verb"
	cat q out>o
done
cat BQ|sed -e $'s/\t/|/g' -e $'s/"//g'>bqfile
#cat p|head -3|cut -f1-7 -d
echo "Enter BQ"
while read bq
do
	echo "BQ #BQ Instance Record	#BQ	">>o
	echo "Enter verb for $bq"
	while read verb
	do
		i="|"$i
		verb=`echo $verb|sed 's/[ (/-]//g'| tr '[:upper:]' '[:lower:]'`
		if [[ "$verb" == "done" ]];
		then
			break;
		fi
		while read line
		do
				a=`echo $line|cut -f1 -d"|"|sed 's/[ (/-]//g'| tr '[:upper:]' '[:lower:]'`
				if [[ "$a" == "$verb" ]]
				then
					#echo "Writing $line"
					f7=`echo $line|cut -f1-7 -d"|"`
					case $verb in
						initiate|create|activate|register|evaluate|provide)
							fr=$i`echo $line|cut -f8 -d"|"`
							;;
						update)
							fr=$i`echo $line|cut -f9 -d"|"`
							;;
						control) 
							fr=$i`echo $line|cut -f10 -d"|"`
							;;
						exchange) 
							fr=$i`echo $line|cut -f11 -d"|"`
							;;
						capture) 
							fr=$i`echo $line|cut -f12 -d"|"`
							;;
						execute) 
							fr=$i`echo $line|cut -f13 -d"|"`
						;;
						request) 
							fr=$i`echo $line|cut -f14 -d"|"`
						;;
						grant) 
							fr=$i`echo $line|cut -f15 -d"|"`
						;;
						retrieve) 
							fr=$i`echo $line|cut -f16 -d"|"`
						;;
						*)
						;;
					esac
				echo $f7$fr>>out
				fi
		done<bqfile
		echo "Processed $verb"
		cat out>>o
	done ## end read bq verb
done ## end read BQ
