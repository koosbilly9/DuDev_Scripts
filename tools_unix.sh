#!/bin/bash

# Purpose: List common used unix commands

# 2021/09/09     Billy       Created

echo "
Common unix commands - often forgotten 
======================================
date : `date`
1) Current shell : \" ps -p \$\$    \"
2) Date format example : \" date +\"%Y%m%d%H%M%S\" \" = `date +"%Y%m%d%H%M%S"`
"

if [ $# -ge 1 ]
then
choice=$1
else
echo "\n Please enter choice : \c"
read choice
fi

case $choice in
*) echo "Sorry sport you are on your own with option $choice " ;;
esac

