user="50:3E:AA:E3:3A:55"
ap="D8:9D:67:4D:EC:30"
channel="11"
interface="wlan0"

echo "check kill"
sudo airmon-ng check kill
echo "check kill ok"
echo "start"
sudo airmon-ng start $interface
echo "start ok"
echo "airodump"
sudo airodump-ng -d $ap -c $channel -w rst "${interface}mon"
echo "airodump ok"
