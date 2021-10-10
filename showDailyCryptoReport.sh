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

~/DuDev_scripts/getDailyCrypto_via_coingecko.sh
~/DuDev_Scripts/getDailyCrypto_marketCap_via_coingecko.sh

favoriteList=`cat ~/DuDev_Scripts/list/dc_rep_favorites.rep | awk 'BEGIN {FS=","}; {printf("%s,",$1)}'  `
watch_List=`cat ~/DuDev_Scripts/list/dc_rep_watch_list.rep | awk 'BEGIN {FS=","}; {printf("%s,",$1)}'  `

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

# show number of fav / watch coins
echo " Number of favorites : `cat ~/tmp/dc_rep_favorites.rep  | wc -l` "
echo " Number of watch     : `cat ~/tmp/dc_rep_watch_list.rep  | wc -l` "

#Showing market cap with awk

cat ~/tmp/dc_MarketCap.json | awk -v todayDate=$(date "+%Y/%m/%d-%H:%M:%S" ) '
# set Record seperator / field seperator / marketCap is shown in multi currencies var marketCap indicate list start
BEGIN {RS=","; FS=":"; marketCap="No"}

# check if marketcap list start have been found
$1 == "\"total_market_cap\"" {marketCap="yes"}

# if marketcap list look for USD price
marketCap == "yes" && $1 == "\"usd\"" {marketCapusd=$2 ; marketCap="No"}

#print usd price
END {print todayDate "," marketCapusd }
' > ~/DuDev_Scripts/list/dc_rep_now_marketcap.csv

athMarketCapFil=`cat ~/DuDev_Scripts/list/dc_rep_ATH_marketcap.csv | awk 'BEGIN {FS=","}; {printf("%s,",$2)}'`

cat ~/DuDev_Scripts/list/dc_rep_now_marketcap.csv | \
awk -v athMarketCap=$athMarketCapFil '
   BEGIN { 
           FS=","
           split(athMarketCap,athMarketCapArr,",") 
	 }
         { 
	   persentage_ath = (1 - ($2/athMarketCapArr[1]) ) * 100
	   print persentage_ath "% below ATH " athMarketCapArr[1]
	   print "Coin market cap @ " $1 "  $" $2 }
'

echo "               ================"

# create Buy Sell report
#------------------------
cat ~/tmp/dc_rep_coingecko_markets.json | awk -v texRed=$awkTexRed -v texGreen=$awkTexGreen \
 -v texOff=$awkTexOff -v texBlue=$awkTexBlue -v texPurple=$awkTexPurple -v favList=$favoriteList -v watchList=$watch_List '
BEGIN { 
        # use json tag ID as record seperator
        RS="{\"id\""
	# use , as field seperator
        FS="," 
	# split scalar into array favorite list
	split(favList,favArr,",") 
	# split scalar into array watch list
	split(watchList,watchArr,",")
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
       
       # Reset colors
       texFav="" 
       texWatch=""
       percentageColor="" 
       texName=""
       
       # Check if in Favorite List         
       for ( item in favArr ) { if ( symbol == favArr[item]) {texFav=texBlue  }  }
       
       # Check if in Watch List         
       for ( item in watchArr ) { if ( symbol == watchArr[item]) {texWatch=texPurple  }  }
       
       # SELL when current price 15% below ATH (put in stop loss)
       if ( Per_ATH < 15) {percentageColor=texRed ; if (texFav != "") { texName=percentageColor}} 
       
       # Buy if current price 75% below ATH (put in stop loss)
       if (Per_ATH > 75)  {percentageColor=texGreen  ; if (texFav != "") { texName=percentageColor}} 
          
       # print Favorites and but/sell candidates
       if ( texFav != "" || texWatch != "") { 
         print texWatch texFav symbol texOff , percentageColor Per_ATH "%" texOff , percentageColor "$"USDPrice texOff, percentageColor "$"ath texOff,  texWatch texFav name texOff
	}
      }
   }
  }
' > ~/tmp/dc_rep_coingecko_buy_sell.rep

cat ~/tmp/dc_rep_coingecko_buy_sell.rep
