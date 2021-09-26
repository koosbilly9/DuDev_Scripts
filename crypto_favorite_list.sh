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

while (( 1 == 1 )) ; do

# Display favorite list

echo " 
Menu 
====
1) Show favorite list - cat ~/tmp/dc_rep_favorites.rep
2) Add coin to list
3) Remove coin from list
4) Get Info for a coin

enter choice (e to exit ): " 
read option

case $option in
1) 
clear ;
echo " No of Favorites : ` cat ~/tmp/dc_rep_favorites.rep | wc -l`" ;
echo "       -------------  " ;
cat ~/tmp/dc_rep_favorites.rep ;;

2) echo " 
Enter Ticker for new coin - will attemp to look up detail to add to list
enter ticker : (include \" eg. \"btc\" )" ;
read ticker ;
getcoin $ticker ;

echo " Add these coins to favorite list ? (y/n) : " 
read answ

if [[ $answ == "y" ]] ; then
getcoin $ticker >> ~/tmp/dc_rep_favorites.rep ;
cat ~/tmp/dc_rep_favorites.rep ;
else
echo " enter coin manually?(y/n) (needs: name,ticker,price,ATH,MaxSupply ): "
read addManCoin
if [ $addManCoin == "y" ] ; then

    echo " Enter Ticker : "
    read coinTicker
    echo " Enter name : " 
    read coinName
    echo " Current Price : " 
    read coinPrice   
    echo " Enter ATH : "
    read coinAth
    echo " Enter max supply : "
    read coinMaxSup


belowAth=` echo " " | awk -v AcoinPrice=$coinPrice -v AcoinAth=$coinAth ' {x=AcoinPrice/AcoinAth ; print (1-x)*100}'`
echo " currently $coinPrice $belowAth % below ATH:$coinAth" 
    
echo "add : \"${coinTicker}\", \"${coinName}\", $coinPrice, $coinAth, $coinMaxSup, $belowAth : (y/n) "
read addAns

if [ $addAns == "y" ] ; then

echo "\"${coinTicker}\", \"${coinName}\", $coinPrice, $coinAth, $coinMaxSup, $belowAth " >> ~/tmp/dc_rep_favorites.rep

fi

fi
fi
;;
3)echo "
enter ticker : (include \" eg. \"btc\" )" ; 
read ticker ;

grep $ticker ~/tmp/dc_rep_favorites.rep

echo " Delete these coins from favorite list ? (y/n) : " 
read answ

if [[ $answ == "y" ]] ; then
grep -v $ticker ~/tmp/dc_rep_favorites.rep > ~/tmp/dc_rep_favorites_del.rep
mv ~/tmp/dc_rep_favorites_del.rep ~/tmp/dc_rep_favorites.rep
fi

;;
4) echo " 
enter ticker : (include \" eg. \"btc\" )" ; 
read ticker ;
getcoin $ticker
;;

e) echo "goodbye" ;
exit 0 ;
;;

*) echo "goodbye" ;
exit 0 ;
;;
esac

done
