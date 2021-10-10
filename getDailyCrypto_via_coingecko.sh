#!/bin/bash

# ===================
# Purpose: get Dialy report from Coin Gecko - https://api.coingecko.com/api/v3/ping
# Documentation : https://www.coingecko.com/en/api/documentation
#
# 2021/09/19	Billy 	Create
# 2021/09/24    Billy   move reporting to ./showDailyCryptoReport
#=====================================================================================

# check if files was modified more than 1 hour ago = 0.0416
#                                       10 minutes = 0.0069
run_refresh=`find ~/tmp/ -name dc_rep_coingecko_markets.json -mtime 0.0416 | wc -l`

if [ $1 == "force" ] ; then
run_refresh=1
fi

# check if file is older than 1 hour
if (( ${run_refresh} == 1 )) ; then

echo "" > ~/tmp/dc_rep_coingecko_date.txt

curl -X 'GET' \
  'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false' \
  -H 'accept: application/json' > ~/tmp/dc_rep_coingecko_markets.json

cat ~/tmp/dc_rep_coingecko_markets.json

fi

# Create CSV 
#------------

cat ~/tmp/dc_rep_coingecko_markets.json | awk '
BEGIN { 
        # use json tag ID as record seperator
        RS="{\"id\""
	# use , as field seperator
        FS="," 
	print "symbol, name, USDPrice, ath, maxSupply, Per_ATH" }
  { 
  # loop thu fields 
  for(x=1; x < NF; x++)
  {
     # cherry pick needed fields , slit name value pair and resturn only value eith new variable
     if (index($x,"symbol") == 2 )                { split($x,arr1,":") ; symbol=arr1[2]  }
     if (index($x,"name") == 2 )                  { split($x,arr1,":") ; name=arr1[2] }
     if (index($x,"current_price") == 2 )         { split($x,arr1,":") ; USDPrice=arr1[2] }
     if (index($x,"ath\"") == 2 )                 { split($x,arr1,":") ; ath=arr1[2]  }
     if (index($x,"max_supply") == 2 )            { split($x,arr1,":") ; maxSupply=arr1[2]  }
     if (index($x,"ath_change_percentage") == 2 ) { split($x,arr1,":") ; Per_ATH=(( arr1[2] * -1 ))  }

     # check that ists the last field before printing variables		     
     if ( x == (NF-1)) { 
        OFS=","
        print symbol, name, USDPrice, ath, maxSupply, Per_ATH
      }
   }
  }
' > ~/tmp/dc_rep_coingecko_lookup.csv

