cat AllSDs2|sed -e $'s/\t/|/g' -e $'s/"//g'>p
while read line
do
if [ "$line" == "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||" ]
then
    read line
    if [ "$line" == "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||" ]
    then
        echo "Found Double lines"
        echo "EOS|">>q
    fi
fi
echo $line>>q
done<p