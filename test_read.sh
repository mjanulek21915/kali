address_count=0
date_count=0

declare -a address_array
declare -a date_array

while read line
do
    for word in $line
    do
        echo "dat ${word}"
        if [[ $word =~ ..\:..\:..\:..\:..\:..\,$ ]]
        then
            word=$( echo $word | sed 's/,//' )
            echo ">>>dis ${word}"
            address_array[$address_count]=$word
            $((address_count++))
        fi

        if [[ $word =~ ....-..-..$ ]]
        then
            word=$( echo $word | sed 's/,//' )

            echo ">>>dis ${word}"
            date_array[$date_count]=$word
        fi

        if [[ $word =~ ..\:..\:..\,$ ]]
        then
            word=$( echo $word | sed 's/,//' )

            echo ">>>dis ${word}"
            date_array[$date_count]="${date_array[$date_count]} $word"
            date_array[$date_count]=$( date --date="${date_array[$date_count]}" +"%s" )
            $((date_count++))
        fi
    done
done < rst-01.csv
echo ${address_array[@]}
echo ${date_array[@]}