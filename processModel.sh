readingRecord="false"
r=""
a=""
name="BaseWithIdAndRoot"
input=$1"ModelConfig"
output=$1"Model.yaml"
idArray=()
echo "definitions:">$output
while read line
do
    if  [[ $line == BQR* ]] || [[ $line == CRR* ]] ;
    then
        readingRecord="true"
        r=`echo $line|cut -f2 -d"-"|cut -f1 -d"("|sed 's/[ (/-]//g'`
        s=`echo $line|cut -f2 -d"-"|cut -f1 -d"("`
        r="$(tr '[:upper:]' '[:lower:]' <<< ${r:0:1})${r:1}"
        info=`echo $line|cut -f2 -d"-"|cut -f2 -d"("|sed 's/[)]//g'`
        echo "   $r:">>$output
        echo "    type: string">>$output
        z=`echo $r | tr '[:upper:]' '[:lower:]'`
        case $z in
            *amount)
                echo "    example: USD 250">>$output
                ;;
            *currency)
                echo "    example: USD">>$output
                ;;
            *date)
                echo "    example: \"09-22-2018\"">>$output
                ;;
            *datetime)
                echo "    example: \"09-22-2018\"">>$output
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
                echo "    example: \"$e\"">>$output
                ;;
            *perioid)
                echo "    example: \"09-22-2018\" - \"09-29-2018\"">>$output
                ;;
            *interval)
                echo "    example: monthly">>$output
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
                echo "    example:">>$output
                ;;
        esac
#        echo "    example:">>$output
        echo "    description: |">>$output
        echo "     \`status: Not Mapped\`">>$output
        z=`echo $r | tr '[:upper:]' '[:lower:]'`
        case $z in
            *amount)
                echo "      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Amount">>$output
                ;;
            *currency)
                echo "      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Currency">>$output
                ;;
            *date)
                echo "      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::DateTime">>$output
                ;;
            *datetime)
                echo "      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::DateTime">>$output
                ;;
            *reference)
                echo "      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::ISO20022andUNCEFACT::Identifier">>$output
                ;;
            *perioid)
                echo "      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Duration">>$output
                ;;
            *interval)
                echo "      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Duration">>$output
                ;;
            *reporttype)
                echo "      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Code">>$output
                ;;
            *record)
                echo "      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Binary">>$output
                ;;
            *report)
                echo "      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Binary">>$output
                ;;
            *)
                echo "      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Text">>$output
                ;;
        esac
        echo "      general-info: $info">>$output
        continue
    else 
        if [[ $line == -* ]]
        then
            readingRecord="true"
            a=`echo $line|cut -f2 -d"-"|cut -f1 -d"("|sed 's/[ (/-]//g'`
            s=`echo $line|cut -f2 -d"-"|cut -f1 -d"("`
            a="$(tr '[:upper:]' '[:lower:]' <<< ${a:0:1})${a:1}"
            info=`echo $line|cut -f2 -d"-"|cut -f2 -d"("|sed 's/[)]//g'`
            z=`echo $a | tr '[:upper:]' '[:lower:]'`
            echo "   $a:">>$output
            case $z in
                *record)
                    echo "    type: object">>$output
                    ;;
                *report)
                    echo "    type: object">>$output
                    ;;
                *)
                    echo "    type: string">>$output
                    ;;
            esac
            case $z in
                *amount|*charge|*fee)
                    echo "    example: USD 250">>$output
                    ;;
                *currency)
                    echo "    example: USD">>$output
                    ;;
                *date)
                    echo "    example: \"09-22-2018\"">>$output
                    ;;
                *datetime)
                    echo "    example: \"09-22-2018\"">>$output
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
                    echo "    example: \"$e\"">>$output
                    ;;
                *perioid)
                    echo "    example: \"09-22-2018\" - \"09-29-2018\"">>$output
                    ;;
                *interval)
                    echo "    example: monthly">>$output
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
#            echo "    example:">>$output
            echo "    description: |">>$output
            echo "     \`status: Not Mapped\`">>$output
            case $z in
                *amount)
                    echo "      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Amount">>$output
                    ;;
                *currency)
                    echo "      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Currency">>$output
                    ;;
                *date)
                    echo "      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::DateTime">>$output
                    ;;
                *datetime)
                    echo "      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::DateTime">>$output
                    ;;
                *reference)
                    echo "      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::ISO20022andUNCEFACT::Identifier">>$output
                    ;;
                *perioid)
                    echo "      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Duration">>$output
                    ;;
                *interval)
                    echo "      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Duration">>$output
                    ;;
                *reporttype)
                    echo "      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Code">>$output
                    ;;
                *record)
                    echo "      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Binary">>$output
                    ;;
                *report)
                    echo "      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Binary">>$output
                    ;;
                *)
                    echo "      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Text">>$output
                    ;;
            esac
            echo "      general-info: $info">>$output
        else
            readingRecord="false"
        fi
    fi
    if [ $readingRecord == "false" ]
    then 
        r=`echo $line|cut -f1 -d"("|sed 's/ //g'`
        echo " $1$r$name:" >>$output
        echo "Generating model $1$r$name..."
        echo "  type: object" >>$output
        echo "  properties:" >>$output
        continue
    fi 
done<$input
readingRecord="false"
r=""
a=""
name="Base"
while read line
do
    if  [[ $line == BQR* ]] || [[ $line == CRR* ]] ;
    then
        continue
    else 
        if [[ $line == -* ]]
        then
            readingRecord="true"
            a=`echo $line|cut -f2 -d"-"|cut -f1 -d"("|sed 's/[ (/-]//g'`
            s=`echo $line|cut -f2 -d"-"|cut -f1 -d"("`
            a="$(tr '[:upper:]' '[:lower:]' <<< ${a:0:1})${a:1}"
            info=`echo $line|cut -f2 -d"-"|cut -f2 -d"("|sed 's/[)]//g'`
            z=`echo $a | tr '[:upper:]' '[:lower:]'`
            echo "   $a:">>$output
            case $z in
                *record)
                    echo "    type: object">>$output
                    ;;
                *report)
                    echo "    type: object">>$output
                    ;;
                *)
                    echo "    type: string">>$output
                    ;;
            esac
            case $z in
                *amount)
                    echo "    example: USD 250">>$output
                    ;;
                *currency)
                    echo "    example: USD">>$output
                    ;;
                *date)
                    echo "    example: \"09-22-2018\"">>$output
                    ;;
                *datetime)
                    echo "    example: \"09-22-2018\"">>$output
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
                    echo "    example: \"$e\"">>$output
                    ;;
                *perioid)
                    echo "    example: \"09-22-2018\" - \"09-29-2018\"">>$output
                    ;;
                *interval)
                    echo "    example: monthly">>$output
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
#            echo "    example:">>$output
            echo "    description: |">>$output
            echo "     \`status: Not Mapped\`">>$output
            
            case $z in
                *amount)
                    echo "      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Amount">>$output
                    ;;
                *currency)
                    echo "      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Currency">>$output
                    ;;
                *date)
                    echo "      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::DateTime">>$output
                    ;;
                *datetime)
                    echo "      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::DateTime">>$output
                    ;;
                *reference)
                    echo "      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::ISO20022andUNCEFACT::Identifier">>$output
                    ;;
                *perioid)
                    echo "      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Duration">>$output
                    ;;
                *interval)
                    echo "      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Duration">>$output
                    ;;
                *reporttype)
                    echo "      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Code">>$output
                    ;;
                *record)
                    echo "      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Binary">>$output
                    ;;
                *report)
                    echo "      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Binary">>$output
                    ;;
                *)
                    echo "      core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Text">>$output
                    ;;
            esac
            echo "      general-info: $info">>$output
        else
            readingRecord="false"
        fi
    fi
    if [ $readingRecord == "false" ]
    then 
        r=`echo $line|cut -f1 -d"("|sed 's/ //g'`
        echo "Generating model $1$r$name..."
        echo " $1$r$name:" >>$output
        echo "  type: object" >>$output
        echo "  properties:" >>$output
        continue
    fi 
done<$input
echo "Generated Model Definitions YAML File $output :)"
