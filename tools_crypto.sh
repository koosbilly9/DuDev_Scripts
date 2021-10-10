#!/bin/bash
#=================================
# Purpose: Tools Menu for crypto scripts
#
# History
#---------
#
# 2021/09/25	Billy	Create
#==========================================

while (( 1 == 1 )) 
do

if [ -z $1 ] ; then
echo "
Crypto Tools 
-------------

1) Show crypto report : showDailyCryptoReport.sh
2) Get Market cap     : getDailyCrypto_marketCap_via_coingecko.sh
3) Get crypto prices  : getDailyCrypto_via_coingecko.sh
4) Manage favorites   : crypto_favorite_list.sh
5) Manage watch   : crypto_watch_list.sh
6) Start Pycharm

enter choice (anykey to exit) :
"
read choice
else
choice=$1
fi

case $choice in
1)~/DuDev_Scripts/showDailyCryptoReport.sh ;;
2)~/DuDev_Scripts/getDailyCrypto_marketCap_via_coingecko.sh force;;
3)~/DuDev_Scripts/getDailyCrypto_via_coingecko.sh force;;
4)~/DuDev_Scripts/crypto_favorite_list.sh;;
5)~/DuDev_Scripts/crypto_watch_list.sh;;
6)/home/kali/pycharm-community-2021.2.2/bin/pycharm.sh;;
*)exit 0 ;;
esac

done
