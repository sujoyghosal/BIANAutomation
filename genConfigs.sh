#genSDRecords.sh $1
cat CR|sed -e $'s/\t/|/g' -e $'s/"//g'>p
cat $1SpecificModel|sed -e $'s/\t/|/g' -e $'s/"//g'>s
i=""
echo "Enter SD"
read sd
echo "Enter CR"
read cr
echo "Enter a CR Verb"
firstLine="CR $cr Instance Record|$cr||||||"
output="crbqmodel.txt"
pathConfig="crbqpath.txt"
rm -rf b out o bqfile o.txt $output $pathConfig
echo "sd=$sd" >$pathConfig
echo "sdpath=`echo $sd|sed 's/[ (/-]/-/g'| tr '[:upper:]' '[:lower:]'`" >>$pathConfig
echo "crpath=`echo $cr|sed 's/[ (/-]/-/g'| tr '[:upper:]' '[:lower:]'`">>$pathConfig
echo "crr=$cr Instance">>$pathConfig
echo "mcr=`echo $cr|sed 's/[ (/-]//g'`">>$pathConfig
echo "bqs=REPLACE WITH BQS">>$pathConfig
echo "CONFIG">>$pathConfig
insertCR="true"
insertBQ="true"
while read verb
do
	if [[ "$verb" == "done" ]];
	then
		break;
	fi
	i="|"$i
	verb="$(tr '[:lower:]' '[:upper:]' <<< ${verb:0:1})${verb:1}"
	firstLine=$firstLine"CR $cr $verb""|"
	verb=`echo $verb|sed 's/[ (/-]//g'| tr '[:upper:]' '[:lower:]'`
	while read line
		do
			a=`echo $line|cut -f1 -d"|"|sed 's/[ (/-]//g'| tr '[:upper:]' '[:lower:]'`
			if [[ "$a" == "mandatory" ]] && [[ "$insertCR" == "true" ]]
			then
				echo $line|cut -f1-7 -d"|"|sed "s/#CR/$cr/g"|sed "s/#SD/$sd/g">>out
				continue
			fi
			if [[ "$a" == "$verb" ]]
			then
				#echo "Writing $line"
				f7=`echo $line|cut -f1-7 -d"|"|sed "s/#CR/$cr/g"|sed "s/#SD/$sd/g"`
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
			if [[ "$a" == "insertcrhere" ]] && [[ "$insertCR" == "true" ]]
			then
				while read sdline
				do
					if [[ $sdline == BQ* ]] ;
					then
						insertCR="false"
						break
					fi
					#echo $sdline |cut -f2- -d"|">>out
					echo $sdline>>out
				done<s
			fi
	done<p
	echo "Processed $verb"
	crp=`echo $cr|sed 's/[ (/-]//g'`
	echo "$crp	$verb	#summary		$verb$crp		#desc" >>$pathConfig
	cat out>o.txt
done
cat BQ|sed -e $'s/\t/|/g' -e $'s/"//g'>bqfile
bqs=
echo "Enter BQ"
while read bq
do
	if [[ "$bq" == "done" ]];
	then
		echo "Thanks! Finished processing. Output file generated at $output"
		break;
	fi
	insertBQ="true"
	insertMan="true"
	bqnospace=`echo $bq|sed 's/[ (/-]//g'`
	bqs="$bqs $bq"
	echo "BQ $bq Instance Record|$bq||||||">bqout
	echo "Enter verb for $bq"
	while read verb
	do
		verb=`echo $verb|sed 's/[ (/-]//g'| tr '[:upper:]' '[:lower:]'`
		if [[ "$verb" == "done" ]];
		then
			break;
		fi
		i="|"$i
		bqm=`echo $bq|sed 's/[ (/-]//g'`
		crm=`echo $cr|sed 's/[ (/-]//g'`
		vu="$(tr '[:lower:]' '[:upper:]' <<< ${verb:0:1})${verb:1}"
		firstLine=$firstLine"BQ $bq $vu""|"
		while read line
		do
			b=`echo $line|cut -f1 -d"|"|sed 's/[ (/-]//g'| tr '[:upper:]' '[:lower:]'`
			if [[ "$b" == "mandatory" ]] && [[ "$insertMan" == "true" ]]
			then
				#echo "Writing BQ Mandatory.."
				echo $line|cut -f1-7 -d"|"|sed "s/#CR/$cr/g"|sed "s/#BQ/$bq/g">>bqout
				continue
			fi
			if [[ "$b" == "$verb" ]]
			then
				f7=`echo $line|cut -f1-7 -d"|"| sed "s/#BQ/$bq/g"`
				case $verb in
					initiate|create|activate|register|evaluate|provide)
						fr=$i`echo $line|cut -f17 -d"|"`
						operations="$bqm	$verb	#summary	$verb$crm$bqm	$verb$crm$bqm		Details of a new $bq instance"
						;;
					update)
						fr=$i`echo $line|cut -f18 -d"|"`
						operations="$bqm	$verb	#summary	$verb$crm$bqm	$verb$crm$bqm		Update to any amendable fields of the $bq instance"
						;;
					control) 
						fr=$i`echo $line|cut -f19 -d"|"`
						operations="$bqm	$verb	#summary	$verb$crm$bqm	$verb$crm$bqm		Request specific processing (e.g. suspend, skip, terminate)"
						;;
					exchange) 
						fr=$i`echo $line|cut -f20 -d"|"`
						operations="$bqm	$verb	#summary	$verb$crm$bqm	$verb$crm$bqm		Handle an external exchange (e.g. accept, reject, verify)"
						;;
					capture) 
						fr=$i`echo $line|cut -f21 -d"|"`
						operations="$bqm	$verb	#summary	$verb$crm$bqm	$verb$crm$bqm		Provide a structured input transaction/record (e.g. timesheet, event)"
						;;
					execute) 
						fr=$i`echo $line|cut -f22 -d"|"`
						operations="$bqm	$verb	#summary	$verb$crm$bqm	$verb$crm$bqm		Invoke an automated execute action against the $bq instance"
					;;
					request) 
						fr=$i`echo $line|cut -f23 -d"|"`
						operations="$bqm	$verb	#summary	$verb$crm$bqm	$verb$crm$bqm		Invoke a service request action against the $bq instance"
					;;
					grant) 
						fr=$i`echo $line|cut -f24 -d"|"`
						operations="$bqm	$verb	#summary	$verb$crm$bqm	$verb$crm$bqm		Invoke a grant request action from the $bq instance to obtain access permission"
					;;
					retrieve) 
						fr=$i`echo $line|cut -f25 -d"|"`
						operations="$bqm	$verb	#summary	$verb$crm$bqm	$verb$crm$bqm		Invoke a reporting action to obtain a $bq instance related report"
					;;
					*)
					;;
				esac
				echo $f7$fr>>bqout
			fi
			if [[ "$b" == "insertbqhere" ]] && [[ "$insertBQ" == "true" ]]
			then
				start="false"
				while read sdline
				do
					if [[ $sdline == BQ* ]]
					then
						e=`echo $sdline|cut -f1 -d"|"|sed 's/[ (/-]//g'|tr '[:upper:]' '[:lower:]'`
						f="bq`echo $bq|sed 's/[ (/-]//g'|tr '[:upper:]' '[:lower:]'`""instancerecord"
						#echo "e,f = $e, $f"
						if [[ "$e" == "$f" ]] ;
						then
							start="true"
						else
							start="false"
						fi
					fi
					if [[ "$start" == "true" ]]
					then
						bqobject=`echo $sdline |cut -f3- -d"|"`
						echo "||"$bqobject>>bqout
					fi
				done<s
				insertBQ="false"
			fi
		done<bqfile
		echo "Processed $verb for $bq"
		echo "$operations">>$pathConfig
		insertMan="false"
	done ## end read bq verb

	cat bqout>>o.txt
	echo "Enter another BQ..."

done ## end read BQ
echo $firstLine>$output
cat o.txt >>$output
cat $pathConfig|sed "s/REPLACE WITH BQS/$bqs/g" >obtain
mv obtain $pathConfig
