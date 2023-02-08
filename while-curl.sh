#used by me for basic network and api resillient testing

#take inputs
echo "Enter the url to curl: "
read url
echo "Enter the number of times to curl, or 0 for forever: "
read num
echo "Enter the time between curls in seconds: "
read time

#run curl
if [ $num -ne 0 ]; then
    for ((i=1;i<=$num;i++))
    do
        curl $url
        sleep $time
    done
else
    while true
    do
        curl $url
        sleep $time
    done
fi