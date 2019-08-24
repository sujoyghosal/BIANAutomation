cat SDSpecific|sed -e $'s/\t/|/g' -e $'s/"//g'>sdfile
readingCR="false"
readingBQ="false"
while read line
do
    if [[ "$line" == CR* ]];
    then
        readingCR="true"
        crrow=`echo $line|cut -f2-6 -d"|"`
done<sdfile