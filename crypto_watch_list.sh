#!/bin/bash

# ===================
# Purpose: create list of cryptos to watch
#
# 2021/09/30	Billy 	Create
#=====================================================================================

getcoin() {
  if $( grep -i $1 ~/tmp/dc_rep_coingecko_lookup.csv > /dev/null ) ; then
   grep $1 ~/tmp/dc_rep_coingecko_lookup.csv
  else
   echo "no $1" 
  fi
}

while (( 1 == 1 )) ; do

# Display watch list

echo " 
Menu 
====
1) Show watch list - cat ~/DuDev_Scripts/list/dc_rep_watch_list.rep
2) Add coin to watch list
3) Remove coin from watch list
4) Get Info for a coin

enter choice (e to exit ): " 
read option

case $option in
1) 
clear ;
echo " No of Favorites : ` cat ~/DuDev_Scripts/list/dc_rep_watch_list.rep | wc -l`" ;
echo "       -------------  " ;
cat ~/DuDev_Scripts/list/dc_rep_watch_list.rep ;;

2) echo " 
Enter Ticker for new coin - will attemp to look up detail to add to list
enter ticker : (include \" eg. \"btc\" )" ;
read ticker ;
getcoin $ticker ;

echo " Add these coins to favorite list ? (y/n) : "  ;
read answ ;

if [[ $answ == "y" ]] ; then
getcoin $ticker >> ~/DuDev_Scripts/list/dc_rep_watch_list.rep ;
cat ~/DuDev_Scripts/list/dc_rep_watch_list.rep ;
else
echo " enter coin manually?(y/n) (needs: name,ticker,price,ATH,MaxSupply ): "
read addManCoin ;
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

echo "\"${coinTicker}\", \"${coinName}\", $coinPrice, $coinAth, $coinMaxSup, $belowAth " >> ~/DuDev_Scripts/list/dc_rep_watch_list.rep

fi

fi
fi
;;
3)echo "
enter ticker : (include \" eg. \"btc\" )" ; 
read ticker ;

grep $ticker ~/DuDev_Scripts/list/dc_rep_watch_list.rep

echo " Delete these coins from favorite list ? (y/n) : " 
read answ

if [[ $answ == "y" ]] ; then
grep -v $ticker ~/DuDev_Scripts/list/dc_rep_watch_list.rep > ~/tmp/dc_rep_watch_list_del.rep
mv ~/tmp/dc_rep_watch_list_del.rep ~/DuDev_Scripts/list/dc_rep_watch_list.rep
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
