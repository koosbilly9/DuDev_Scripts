#!/bin/bash
#======================================================
#Purpose: To get the market cap from coingecko
#
#History: 
#--------
#
#2021/09/20 Heino create initial report
#=======================================================

#Call Url

curl -X 'GET' \
  'https://api.coingecko.com/api/v3/global' \
  -H 'accept: application/json' > ~/tmp/dc_MarketCap.json
  
#cat ~/tmp/dc_MarketCap.json

#Showing market cap with awk

cat ~/tmp/dc_MarketCap.json | awk '
BEGIN {RS=","; FS=":"; marketCap="No"}
$1 == "\"total_market_cap\"" {marketCap="yes"}
marketCap == "yes" && $1 == "\"usd\"" {marketCapusd=$2 ; marketCap="No"}
END {print "Todays total market cap:" marketCapusd }
'
