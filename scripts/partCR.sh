readingRecord="false"
r=""
a=""
name="BaseWithIdAndRoot"
input=$1"ModelConfig"
output="PartModel.yaml"
idArray=()
echo "definitions:">$output
lastRead=""
space=""
l3=""
context=""
crr=""
while read line
do
    if  [[ $line == BQ* ]] || [[ $line == CR* ]] ;
    then
        read line
        crr=`echo $line|cut -f2 -d"|"|cut -f1 -d"("|sed 's/[ (/-]//g'`
        echo " $crr:" >>$output
        echo "  type: object" >>$output
        continue;
    fi
    if  [[ $line == Properties* ]] || [[ $line == Options* ]] || [[ $line == Variables* ]];
    then
        context=`echo $line|cut -f1 -d"|"|cut -f1 -d"("|sed 's/[ (/-]//g'`
        context=`echo $context | tr '[:upper:]' '[:lower:]'`
        echo "  $context:" >>$output
        continue;
    fi
    a=`echo $line|cut -f3 -d"|"|cut -f1 -d"("|sed 's/[ (/-]//g'`
    a2=`echo $line|cut -f4 -d"|"|cut -f1 -d"("|sed 's/[ (/-]//g'`
    a3=`echo $line|cut -f5 -d"|"|cut -f1 -d"("|sed 's/[ (/-]//g'`
    a4=`echo $line|cut -f6 -d"|"|cut -f1 -d"("|sed 's/[ (/-]//g'`
    s=`echo $line|cut -f1 -d"|"|cut -f1 -d"("`
    if  [[ ! -z "$a" ]]
    then
        lastRead=$a;
        space=""
    fi
    ## check for L2
    if  [[ ! -z "$a" ]] && [[ "$a2" == "#" ]] ;
    then
        echo "   $lastRead:">>$output
        space=" $space"
        continue
    fi

    if  [[ -z "$a" ]] && [[ ! -z "$a2" ]] && [[ "$l3" != "true" ]];
    then
        a=$a2
    fi
    ## end L2 check
    ## check for L3
    if  [[ ! -z "$a" ]] && [[ "$a3" == "#" ]] ;
    then
        echo "   $a:">>$output
        l3="true"
        continue
    fi
    if  [[ -z "$a" ]] && [[ ! -z "$a2" ]] && [[ "$l3" == "true" ]];
    then
            echo "     $a2:">>$output
            space="  $space"
            continue;
    fi
    if  [[ -z "$a" ]] && [[ -z "$a2" ]] && [[ ! -z "$a3" ]];
    then
        a=$a3
    fi
    ## end L3 check
    

    a="$(tr '[:upper:]' '[:lower:]' <<< ${a:0:1})${a:1}"
    echo "$a"
    info=`echo $line|cut -f5 -d"|"|sed 's/[)]//g'`
    z=`echo $a | tr '[:upper:]' '[:lower:]'`
    echo "$space   $a:">>$output
    case $z in
        *record)
            echo "$space    type: object">>$output
            ;;
        *report)
            echo "$space    type: object">>$output
            ;;
        *)
            echo "$space    type: string">>$output
            ;;
    esac
    case $z in
        *amount)
            echo "$space    example: USD 250">>$output
            ;;
        *currency)
            echo "$space    example: USD">>$output
            ;;
        *date)
            echo "$space    example: \"09-22-2018\"">>$output
            ;;
        *datetime)
            echo "$space    example: \"09-22-2018\"">>$output
            ;;
        *reference)
            i=1
            count=`echo $s|wc -w`
            g=
            while [ $i -le $count ]
            do
                w=`echo $s|cut -f"$i" -d" "|cut -b1`
                i=`expr $i + 1`
                g=$g$w
            done
            g=`echo $g|tr '[:lower:]' '[:upper:]'`
            foundInArray="false"
            for m in "${idArray[@]}"
            do
                if [[ $m =~ $g ]];
                then
                    e=$m
                    foundInArray="true"
                    break
                fi
            done
            if [ $foundInArray == "false" ]
            then
                # whatever you want to do when arr doesn't contain value
                    ra=`jot -r 1 700000 799990`
                    e=$g$ra
                    idArray+=($e)
            fi
            echo "$space    example: \"$e\"">>$output
            ;;
        *perioid)
            echo "$space    example: \"09-22-2018\" - \"09-29-2018\"">>$output
            ;;
        *interval)
            echo "$space    example: monthly">>$output
            ;;
        *reporttype)
            # echo "    example: USD 250">>$output
            ;;
        *record)
            #echo "    example: USD 250">>$output
            ;;
        *report)
            #echo "    example: USD 250">>$output
            ;;
        *)
            #echo "    example:">>$output
            ;;
    esac
    echo "$space    description: |">>$output
    echo "$space     \`status: Not Mapped\`">>$output
    case $z in
        *amount)
            echo "$space      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Amount">>$output
            ;;
        *currency)
            echo "$space      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Currency">>$output
            ;;
        *date)
            echo "$space      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::DateTime">>$output
            ;;
        *datetime)
            echo "$space      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::DateTime">>$output
            ;;
        *reference)
            echo "$space      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::ISO20022andUNCEFACT::Identifier">>$output
            ;;
        *perioid)
            echo "$space      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Duration">>$output
            ;;
        *interval)
            echo "$space      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Duration">>$output
            ;;
        *reporttype)
            echo "$space      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Code">>$output
            ;;
        *record)
            echo "$space      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Binary">>$output
            ;;
        *report)
            echo "$space      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Binary">>$output
            ;;
        *)
            echo "$space      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Text">>$output
            ;;
    esac
    echo "$space      general-info: $info">>$output

done <partCRModel