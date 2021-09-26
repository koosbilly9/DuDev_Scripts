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

enter choice (anykey to exit) :
"
read choice
else
choice=$1
fi

case $choice in
1)~/DuDev_Scripts/showDailyCryptoReport.sh ;;
2)~/DuDev_Scripts/getDailyCrypto_marketCap_via_coingecko.sh ;;
3)~/DuDev_Scripts/getDailyCrypto_via_coingecko.sh ;;
4)~/DuDev_Scripts/crypto_favorite_list.sh;;
*)exit 0 ;;
esac

done
