#!/bin/zsh

# ==========================

# Purpose : Get daily crypto report
# se
# Billy - 2021/09/07

# History:
#---------

# 2021/09/07 -- Billy -- Initial

# ==========================

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
			      if (index($x,"low24h") == 2 )    { low24h=$x }
			      if (index($x,"high24h") == 2 )   { high24h=$x }
			      if (index($x,"ath") == 2 )       { ath=$x","  }
			      if (index($x,"maxSupply") == 2 ) { maxSupply=$x","  }
			      if (index($x,"dominance") == 2 ) { dominance=$x","  }
			      
			      # Get quote of USD price
			      Get quote of USD price
			      if (index($x,"{\"name\":\"USD\"") == 2 ) { readNextPrice=True  } else {readNextPrice=False}
			      if (index($x,"price") == 2 )      { USDPrice=$x"," }
			     
			      if ( x == (NF-1) ) { print symbol cmcrank name USDPrice dominance high24h low24h ath symbol cmcrank maxSupply  }
			      
			    }
			   } 
	           ' > ~/tmp/daily_crypto_dump5.tmp
		   
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
			      
			      for ( x in favorite_list)
			       {
			        
			        if ( index($1,favorite_list[x]) > 0 )
				{ 
				  print $0
				}
			       }
			    }
                    ' > ~/tmp/daily_crypto_DailyCryptoReport.rep
		   
# --  seperate out crypto token data --------


# ----------   print Daily Crypto report ----------

DDate=`date `

clear

awk  -v DDATE=${DDate} ' 
  BEGIN { FS="," 
           print "       ===================================="
	   print "The DAILY Crypto Report @ " DDATE
	   print "       ==================================== " 
	}
	{
	  print $0
	}
  END   {
          print " =============== END =============== "
	}
  
' ~/tmp/daily_crypto_DailyCryptoReport.rep
