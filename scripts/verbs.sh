rm -rf Verbs
cat $1"Headers"|sed -e $'s/\t/|/g'>p
sd=`cat p|head -1|tail -1|cut -f2 -d"="`
cr=`cat p|head -2|tail -1|cut -f2 -d"="`
allBQs=`cat p|head -3|tail -1|cut -f2 -d"="`
desc=`cat p|head -4|tail -1|sed -e $'s/\t//g' -e $'s/"//g'`
example=`cat p|head -5|tail -1|sed -e $'s/\t//g' -e $'s/"//g'`
execSum=`cat p|head -6|tail -1|sed -e $'s/\t//g' -e $'s/"//g'`
line1=`cat p |head -7|tail -1`
line2=`cat p |head -8|tail -1`
count=`echo $line1|tr '|' '\n'|wc -l`
globalCount=$count
i=0
summaries=""
while read line
do
    i=`expr $i + 1`
    if [ $i -gt 8 ]
    then
        summaries="$summaries|`echo $line|cut -f2- -d" "`"
    fi
done<p
summaries=`echo $summaries|cut -f2- -d"|"`
echo $sd>Verbs
echo $cr>>Verbs
echo $allBQs>>Verbs
echo $desc>>Verbs
echo $example>>Verbs
echo $execSum>>Verbs
echo $summaries>>Verbs
echo "SD=$sd, CR=$cr, BQs=$allBQs"
echo "Count of Verbs is $count"
icol=1

while [ $count -gt 0 ]
do
    count=`expr $count - 1`
    verb=`echo $line2|cut -f$icol -d"|"|sed 's/[ (/-]//g'`
    crbq=`echo $line1|cut -f$icol -d"|"`
    if [[ ! -z "$crbq" ]]
    then
        if [[ $crbq == CR* ]]
        then
            #echo "New CR $crbq"
            crbq=`echo $crbq|cut -f2 -d"-"`
#            echo $crbq>>CRverbs
        fi
        if [[ $crbq == BQ* ]]
        then
            #echo "New BQ $crbq"
            crbq=`echo $crbq|cut -f2 -d"-"`
            echo done>>Verbs
            echo $crbq>>Verbs
        fi
    fi
    case $verb in
        In)
            verb="Initiate"
            ;;
        Ev)
            verb="Evaluate"
            ;;
        Cr)
            verb="Create"
            ;;
        Rg)
            verb="Register"
            ;;
        Pr)
            verb="Provide"
            ;;
        Up)
            verb="Update"
            ;;
        Co)
            verb="Control"
            ;;
        Ec)
            verb="Exchange"
            ;;
        Ca)
            verb="Capture"
            ;;
        Ex)
            verb="Execute"
            ;;
        Rq)
            verb="Request"
            ;;
        Gr)
            verb="Grant"
            ;;
        Re)
            verb="Retrieve"
            ;;
        *)
            echo "****************Unknown Verb $verb***********"
            ;;
    esac
    echo $verb >>Verbs
    icol=`expr $icol + 1`
done
echo "done">>Verbs
echo "done">>Verbs
echo ""
echo "********** Showing config file to be processed by genConfigs.sh...please validate and proceed ********"
cat Verbs
sd=`echo $sd|sed 's/[ (/-]//g'`
echo "Running genConfigs $sd"
genConfigs.sh $sd<Verbs
echo "Generating Swagger :)"
modelcfg=`echo $sd|sed 's/[ (/-]//g'`"ModelConfig"
echo "Model Config File is $modelcfg"
cp crbqpath.txt `echo $sd|sed 's/[ (/-]//g'`"PathConfig"
cat crbqmodel.txt|head -6 >$modelcfg
cr7="||"`cat crbqmodel.txt|head -7|tail -1|cut -f3- -d"|"`
echo "CR7=$cr7"
echo $cr7>>$modelcfg
#cp $modelcfg $modelcfg.txt
cat crbqmodel.txt|tail +8>>$modelcfg
echo "Generating $globalCount endpoints"
generateNewSwagger.sh  `echo $sd|sed 's/[ (/-]//g'` $globalCount
echo "Done"