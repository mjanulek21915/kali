scan ()
{
    yes | rm rst*
    # sudo airodump-ng -d $ap -c $channel -w rst "${interface}mon" & 
    sudo airodump-ng -d D8:9D:67:4D:EC:30 -c 11 -w rst wlan0mon &
    sleep $1
    sudo killall airodump-ng
}

scan 6
sleep 0.02
reset