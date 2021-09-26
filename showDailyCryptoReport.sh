#!/bin/bash
#===================================================================================
# Purpose: show daily crypto report combinding json from other getDaily* scripts
#
# History
#--------
# 2021/09/24 Billy Create
#
#=================================================================================
# source colors
source ./setTextColor.source

# Get Data from url's
#---------------------

./getDailyCrypto_via_coingecko.sh
./getDailyCrypto_marketCap_via_coingecko.sh
favoriteList=`cat ~/tmp/dc_rep_favorites.rep | awk 'BEGIN {FS=","}; {printf("%s,",$1)}'  `

# create Buy Sell report
#-------------------------

echo "--------------------------------------------------"
echo " CRYPTO REPORT @ `date`"
echo "--------------------------------------------------" 
echo " "
echo " Rule 1 : DON'T LOSS ANY MONEY" 
echo " Report info last updated at: `date` " 
echo " ================================================================"
echo " "

# show number of fav coins
echo " Number of favorites : `cat ~/tmp/dc_rep_favorites.rep  | wc -l` "

#Showing market cap with awk

cat ~/tmp/dc_MarketCap.json | awk '
# set Record seperator / field seperator / marketCap is shown in multi currencies var marketCap indicate list start
BEGIN {RS=","; FS=":"; marketCap="No"}

# check if marketcap list start have been found
$1 == "\"total_market_cap\"" {marketCap="yes"}

# if marketcap list look for USD price
marketCap == "yes" && $1 == "\"usd\"" {marketCapusd=$2 ; marketCap="No"}

#print usd price
END {print "Todays total market cap:" marketCapusd }
'

echo " "

# create Buy Sell report
#------------------------
cat ~/tmp/dc_rep_coingecko_markets.json | awk -v texRed=$awkTexRed -v texGreen=$awkTexGreen \
 -v texOff=$awkTexOff -v texBlue=$awkTexBlue -v favList=$favoriteList '
BEGIN { 
        # use json tag ID as record seperator
        RS="{\"id\""
	# use , as field seperator
        FS="," 
	# split scalar into array
	split(favList,arr2,",") 
	# Print header
	printf("%s \t\t %s \t %s \t %s \t\t %s \n","Ticker","Below ATH","Current","Price","Name")
	print "-------------------------------------------------------------------------"
	print " "
      }
  { 
   
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
        
       OFS="    \t"
       
       # check if in favorites list  
       # loop thu fields 
       
       texFav="" 
       percentageColor=""          
       for ( item in arr2 ) { if ( symbol == arr2[item]) {texFav=texBlue  }  }
       
       if ( Per_ATH < 10) {percentageColor=texRed}  # SELL when current price 10% below ATH (put in stop loss)
       if (Per_ATH > 80)  {percentageColor=texGreen} # Buy if current price 70% below ATH (put in stop loss)
          
       # print Favorites and but/sell candidates
       if ( texFav != "" || percentageColor != "") { 
         print texFav symbol texOff , percentageColor Per_ATH "%" texOff , "$"USDPrice, "$"ath,  name
	}
      }
   }
  }
' > ~/tmp/dc_rep_coingecko_buy_sell.rep

cat ~/tmp/dc_rep_coingecko_buy_sell.rep
