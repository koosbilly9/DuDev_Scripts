#!/bin/zsh

# ==========================

# Purpose : Get daily crypto report
# se
# Billy - 2021/09/07

# History:
#---------

# 2021/09/07 -- Billy -- Initial

# ==========================


refresh_web_file() {
# Clean up tmp 
rm ~/tmp/daily_crypto_*

# use curl to get home page of crypto market cap
curl -fsS https://coinmarketcap.com > ~/tmp/daily_crypto_web.dump


# --  seperate out crypto token data --------
# Get data tag 
grep '\"data\":\[' ~/tmp/daily_crypto_web.dump > ~/tmp/daily_crypto_dump.tmp

# create new file with data as record seperator
cat ~/tmp/daily_crypto_dump.tmp | awk ' BEGIN { RS="\"data\":" }
		           {print $0 } 
	           ' > ~/tmp/daily_crypto_dump2.tmp

# grep only data relevant data tags
grep fullyDilluttedMarketCap ~/tmp/daily_crypto_dump2.tmp > ~/tmp/daily_crypto_dump3.tmp


# create new file if id as record seperator to have each coin as a seperate line
cat ~/tmp/daily_crypto_dump3.tmp | awk ' BEGIN { RS=",{\"id\"" }
		           {print $0 } 
	           ' > ~/tmp/daily_crypto_dump4.tmp

# create file with only relevant data per line		   
cat ~/tmp/daily_crypto_dump4.tmp | awk ' BEGIN { FS="," }
                      
		           {
			    for(x=1; x < NF; x++)
			    {
			      if (index($x,"cmcRank") == 2 )   { cmcrank=$x","  }
			      if (index($x,"symbol") == 2 )    { symbol=$x","  }
			      if (index($x,"name") == 2 )      { name=$x"," }
			      if (index($x,"low24h") == 2 )    { low24h=$x"," }
			      if (index($x,"high24h") == 2 )   { high24h=$x"," }
			      if (index($x,"ath") == 2 )       { ath=$x","  }
			      if (index($x,"maxSupply") == 2 ) { maxSupply=$x","  }
			      if (index($x,"dominance") == 2 ) { dominance=$x","  }
			      
			      # Get quote of USD price
			      
			      if (index($x,"{\"name\":\"USD\"") == 2 ) { readNextPrice=True  } else {readNextPrice=False}
			      if (index($x,"price") == 2 )      { USDPrice=$x"," }
			     
			      if ( x == (NF-1) ) { print symbol cmcrank name USDPrice dominance high24h low24h ath symbol cmcrank maxSupply  }
			      
			    }
			   } 
	           ' > ~/tmp/daily_crypto_dump5.tmp

if [[ $2 == "favorite" ]] ; then
echo "true \$1 = $1"		   
cat ~/tmp/daily_crypto_dump5.tmp | awk ' BEGIN { FS="," }
                            { 
			      favorite_list[0]="ADA"
			      favorite_list[1]="BTC"
			      favorite_list[2]="HBAR"
			      favorite_list[3]="XRP"
			      favorite_list[4]="GRT"
			      favorite_list[5]="SOL"
			      favorite_list[6]="UNI"
			      favorite_list[7]="SNX"
			      favorite_list[8]="DOT"
			      favorite_list[9]="BETH"
			      favorite_list[10]="AVAX"
			      
			      for ( x in favorite_list)
			       {
			        
			        if ( index($1,favorite_list[x]) > 0 )
				{ 
				  print $0
				}
			       }
			    }
                    ' > ~/tmp/daily_crypto_DailyCryptoReport.rep
else
echo "false \$1= $1"
cp ~/tmp/daily_crypto_dump5.tmp ~/tmp/daily_crypto_DailyCryptoReport.rep

fi
		   
# --  seperate out crypto token data --------
}


# check if files was modified more than 1 hour ago = 0.0416
#                                       10 minutes = 0.0069
run_refresh=`find ~/tmp/ -name daily_crypto_DailyCryptoReport.rep -mtime 0.0416 | wc -l`

if [[ $1 == "force" ]] ; then run_refresh=1; fi 

if (( ${run_refresh} == 1 )) ; then
echo " Refresh web files .... "
refresh_web_file
else
echo "Web files have been refreshed in the last hour "
fi


# ----------   print Daily Crypto report ----------

DDate=`date `


#-- output CSV file


awk  -v DDATE=${DDate} ' 
  BEGIN { FS="," 
           print "       ===================================="
	   print "The DAILY Crypto Report @ " DDATE
	   print "       ==================================== \n" 
	   printf("%5s %20s %20s %20s \n","Ticker","Price","ATH","% from ATH")
	}
	{
	  split($1,sym,":")
	  split($4,price,":")
	  split($8,ath,":")
	  split($2,cmcRank,":")
	  
	  pf_ath=((price[2]/ath[2]) * 100)
	  
	  printf("%5s %5s %20s %20s %20s \n",sym[2],cmcRank[2],price[2],ath[2],pf_ath)
	}
  END   {
          print " =============== END =============== "
	}
  
' ~/tmp/daily_crypto_DailyCryptoReport.rep
