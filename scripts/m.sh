j=0
k=0
m=""
n[0]=""
while read l
do
	k=`expr $k + 1`
	if [ $k -gt  2 ]
	then
			if [ "$l" != "done" ]
			then
					if [ "$l" != "Retrieve" ]
					then
						m[$j]="|I"${m[$j]}
					fi
					echo $l
					n[$j]=${n[$j]}"|"
			else
					echo "${n[j]}"
					echo "${m[j]}"
					r=$j
					j=`expr $j + 1`
					n[$j]=${n[$r]}
					read l
			fi
	fi
done<Verbs
