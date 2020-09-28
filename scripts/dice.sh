! /bin/bash
#Roll dice using bash

roll=$1
for((i=0;i<roll;i++))
do
die=$(($RANDOM % 6 + 1))
case $die in
        1) echo "⚀";;
        2) echo "⚁";;
        3) echo "⚂";;
        4) echo "⚃";;
        5) echo "⚄";;
        6) echo "⚅";;
esac
done
