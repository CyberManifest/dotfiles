#!/bin/bash
clear
echo
echo "Hello World"
echo
fortune
echo "going to list the contents of the directory..."
ls -la
echo "this line will get deleted..."
printf '$-1,$d\nw\nq\n' | ed -s ~/test.sh
