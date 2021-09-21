#!/bin/bash

# ===================
# Purpose: create list of favorites
#
# 2021/09/19	Billy 	Create
#=====================================================================================

getcoin() {
  if $( grep $1 ~/tmp/dc_rep_coingecko_lookup.csv > /dev/null ) ; then
   grep $1 ~/tmp/dc_rep_coingecko_lookup.csv
  else
   echo "no $1" 
  fi
}

# Display favorite list
echo " Favorite list stored in ~/tmp/dc_rep_favorites.rep "
echo "----------------------------------------------------"
cat ~/tmp/dc_rep_favorites.rep

echo " 
Menu 
====
1) Add coin to list
2) Remove coin from list
3) Get Info for a coin

enter choice : " 
read option

case $option in
1) echo " 
Enter Ticker for new coin - will attemp to look up detail to add to list
enter ticker : (include \" eg. \"btc\" )" ;
read ticker ;
getcoin $ticker ;

echo " Add these coins to favorite list ? (y/n) : " 
read answ

if [[ $answ == "y" ]] ; then
getcoin $ticker >> ~/tmp/dc_rep_favorites.rep ;
cat ~/tmp/dc_rep_favorites.rep ;
fi
;;
2)echo "
enter ticker : (include \" eg. \"btc\" )" ; 
read ticker ;

grep ticker ~/tmp/dc_rep_favorites.rep

echo " Delete these coins from favorite list ? (y/n) : " 
read answ

if [[ $answ == "y" ]] ; then
grep -v ticker ~/tmp/dc_rep_favorites.rep
fi

;;
3) echo " 
enter ticker : (include \" eg. \"btc\" )" ; 
read ticker ;
getcoin $ticker
;;

*) echo "goodbye" ;
exit 0 ;
;;
esac
