#!/bin/bash

# ===================
# Purpose: create list of favorites
#
# 2021/09/19	Billy 	Create
#=====================================================================================


# Display favorite list

cat ~/tmp/dc_rep_favorites.rep

echo " 
Menu 
====
1) Add coin to list
2) Remove coin from list
3) Get Info for a coin

enter choice : \r"
read option

case $option in
1) echo " 
Enter coin name for new coin - will attemp to look up detail to add to list
enter ticker : \r" ;
read coinname ;
;;
2)echo "
Enter coin name to remove : \r ";
read coinname ;
;;
3) echo " 
Enter coin name: \r " ;
read coinname ;
;;

*) echo "goodbye" ;
exit 0 ;
;;
esac
