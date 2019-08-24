readingRecord="false"
input=$1"ModelConfig"
outputWithIdRoot=$1"WithIdRootModel.yaml"
outputBase=$1"BaseModel.yaml"
isofile=$1"ISOMapping"
idArray=()
rm -rf p $outputBase $outputWithIdRoot bq el bqel rest isobq
echo "definitions:"> $outputWithIdRoot
while read line
do
    if  [[ $line == BQR* ]] || [[ $line == CRR* ]] || [[ $line == -* ]];
    then
        if  [[ $line == BQR* ]] || [[ $line == CRR* ]];
        then
            output="$outputWithIdRoot"
        fi
        if  [[ $line == -* ]];
        then
            output="$outputWithIdRoot $outputBase"
        fi
        readingRecord="true"
        r=`echo $line|cut -f2 -d"-"|cut -f1 -d"("|sed 's/[ (/-]//g'`
        s=`echo $line|cut -f2 -d"-"|cut -f1 -d"("`
        r="$(tr '[:upper:]' '[:lower:]' <<< ${r:0:1})${r:1}"
        info=`echo $line|cut -f2 -d"-"|cut -f2 -d"("|sed 's/[)]//g'`
        echo "   $r:"|tee -a $output>>/dev/null
        z=`echo $r | tr '[:upper:]' '[:lower:]'`
        case $z in
            *record)
                echo "    type: object"|tee -a $output>>/dev/null
                ;;
            *report)
                echo "    type: object"|tee -a $output>>/dev/null
                ;;
            *)
                echo "    type: string"|tee -a $output>>/dev/null
                ;;
        esac
        case $z in
            *amount|*charge|*fee)
                echo "    example: USD 250"|tee -a $output>>/dev/null
                defaultdatatype="core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Amount"
                ;;
            *currency)
                echo "    example: USD"|tee -a $output>>/dev/null
                defaultdatatype="core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Currency"
                ;;
            *date|*datetime|*time)
                echo "    example: \"09-22-2018\""|tee -a $output>>/dev/null
                defaultdatatype="core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::DateTime"
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
                echo "    example: \"$e\""|tee -a $output>>/dev/null
                defaultdatatype="core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::ISO20022andUNCEFACT::Identifier"
                ;;
            *perioid)
                echo "    example: \"09-22-2018\" - \"09-29-2018\""|tee -a $output>>/dev/null
                defaultdatatype="core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Duration"
                ;;
            *interval)
                echo "    example: monthly"|tee -a $output>>/dev/null
                defaultdatatype="core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Duration"
                ;;
            *reporttype)
                defaultdatatype="core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Code"
                ;;
            *record|*report)
                defaultdatatype="core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Binary"
                ;;
            *)
                defaultdatatype="core-data-type-reference: BIAN::DataTypesLibrary::CoreDataTypes::UNCEFACT::Text"
                ;;
        esac
        echo "    description: |"|tee -a $output>>/dev/null
        element=`echo $line|cut -f2 -d"-"|cut -f1 -d"("|sed 's/[ (/-]//g'`
        if [ -f "$isofile" ]
        then
            cat $isofile|sed -e $'s/\t/|/g'>p
            cat p|cut -f1 -d"|"|cut -f1 -d"("|sed 's/[ (/-]//g'>bq
            cat p|cut -f2 -d"|"|cut -f1 -d"("|sed 's/[ (/-]//g'>el
            paste -d"|" bq el>bqel
            cat p|cut -f3,4 -d"|">rest
            paste -d"|" bqel rest>q
            cat q|grep -i "$bq|$element">isobq
            inisofile="false"
            coredatatype="false"
            while read isorec
            do
                if [ ! -z "$isorec" -a "$isorec" != " " ]; then
                    inisofile="true"
                    status=`echo "$isorec" | cut -f4 -d"|"`
                    s1=`echo $status|grep -i "ISO 20022 Business Model"`
                    s2=`echo $status|grep -i "https://www.iso20022.org"`
                    s3=`echo $status|grep -i "Core Data Type"`
                    if [ ! -z "$s1" -a "$s1" != " " ]; then
                        bref=`echo "$isorec" | cut -f3 -d"|"`
                        echo "     \`status: Provisionally Registered\`"|tee -a $output>>/dev/null
                        echo "      bian-reference: $bref"|tee -a $output>>/dev/null
                    fi
                    if [ ! -z "$s2" -a "$s2" != " " ]; then
                        bref=`echo "$isorec" | cut -f3 -d"|"`
                        href=`echo "$isorec" | cut -f4 -d"|"`
                        echo "     \`status: Registered\`"|tee -a $output>>/dev/null
                        echo "      iso-link: $href"|tee -a $output>>/dev/null
                        echo "      bian-reference: $bref"|tee -a $output>>/dev/null
                    fi
                    if [ ! -z "$s3" -a "$s3" != " " ]; then
                        coredatatype="true"
                    fi
                else
                    inisofile="false"
                fi
            done<isobq
        else
            inisofile="false"
        fi
        if [ $inisofile == "false" ] || [ $coredatatype == "true" ]
        then
            echo "     \`status: Not Mapped\`"|tee -a $output>>/dev/null
            echo "      $defaultdatatype"|tee -a $output>>/dev/null
        fi
        echo "      general-info: $info"|tee -a $output>>/dev/null
        continue
    else  
        readingRecord="false"
    fi
    if [ $readingRecord == "false" ]
    then 
        bq=`echo $line|cut -f1 -d"("|sed 's/ //g'`
        name="WithIdAndRoot"
        echo " $1$bq$name:" >>$outputWithIdRoot
        name="Base"
        echo " $1$bq$name:" >>$outputBase
        echo "Generating models for $1$bq..."
        echo "  type: object"|tee -a $outputWithIdRoot $outputBase  >>/dev/null
        echo "  properties:" |tee -a $outputWithIdRoot $outputBase  >>/dev/null
        continue
    fi 
done<$input
cat $outputWithIdRoot $outputBase>$1"Model.yaml"
rm -rf p $outputBase $outputWithIdRoot bq el bqel rest isobq p q
echo "Generated Model Definitions YAML File $1"Model.yaml" :)"