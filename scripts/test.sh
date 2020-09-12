#!/bin/bash
clear
echo
echo "Hello World"
echo
fortune
echo "going to list the contents of the directory..."
ls -la
tac ~/test.sh | sed '1,3 d' | tac > ~/test.sh
