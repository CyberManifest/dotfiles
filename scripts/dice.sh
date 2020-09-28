#! /bin/bash
#Roll dice using bash

roll=$1
for((i=0;i<roll;i++))
do
die=$(($RANDOM % 6 + 1))
case $die in
        1) echo -n " ⚀ ";;
        2) echo -n " ⚁ ";;
        3) echo -n " ⚂ ";;
        4) echo -n " ⚃ ";;
        5) echo -n " ⚄ ";;
        6) echo -n " ⚅ ";;
esac
done
echo
