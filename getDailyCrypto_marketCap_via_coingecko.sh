#!/bin/bash
#======================================================
#Purpose: To get the market cap from coingecko
#
#History: 
#--------
#
# 2021/09/20 Heino 	create initial report
# 2021/09/24 Billy 	move reporting to ./showDailyCryptoReport
#==============ls=========================================

# check if files was modified more than 1 hour ago = 0.0416
#                                       10 minutes = 0.0069
run_refresh=`find ~/tmp/ -name dc_MarketCap.json -mtime 0.0416 | wc -l`

if [ $1 == "force" ] ; then
run_refresh=1
fi

# check if file is older than 1 hour
if (( ${run_refresh} == 1 )) ; then

curl -X 'GET' \
  'https://api.coingecko.com/api/v3/global' \
  -H 'accept: application/json' > ~/tmp/dc_MarketCap.json

cat ~/tmp/dc_MarketCap.json

fi
