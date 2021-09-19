#~/DuDev_Scripts/getDailyCrypto.sh | awk -v per=${1:-20} '
#$5 < per { print $0 } 
#' 
cat ~/tmp/daily_crypto_dump4.tmp | awk ' BEGIN { FS="," }
                      
		           {
			    for(x=1; x < NF; x++)
			    {
			      if (index($x,"cmcRank") == 2 )   { cmcrank=$x","  ; print $x}
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
	           ' #> ~/tmp/daily_crypto_dump5.tmp
