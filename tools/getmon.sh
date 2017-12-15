#!/bin/sh
############################################################################
#20171204	monitor special ticket and info to judge get or out
#1.get new list and compare with will be limit ,to plan mktValue distribution. 
#2.
############################################################################
#cfg=$1
MONdir=/root/target/T1W/MON
mon=$MONdir/mon.l

##DB=hankdb

tmpout=$MONdir/t.out

grep -vE '^$|#' $mon | while read code name price tgt_price mk_date mon_reason
do
	[ $code -gt 600000 ] && code=sh$code || code=sz$code
	curl http://hq.sinajs.cn/list=$code >$tmpout 2>/dev/null

	price_now=`awk -F',' '{print $4}' $tmpout`

	tgtdiff=`echo "scale=3; ($price_now - $tgt_price) * 100 / $price " | bc |  awk '{printf "%.3f%", $0}'`
	
	mktdiff=`echo "scale=3; ($price_now - $price) * 100 / $price " | bc |  awk '{printf "%.3f%", $0}'`
	
	#echo $tgtdiff;echo $mktdiff
	
	printf "%-8s %-6s %-8.3f %-8.3f"  $code $name $price_now $tgt_price
	printf "%-8s %-8s(%-s@%-s) "  $tgtdiff $mktdiff $price $mk_date

	#tgtdiff=-0.1%
	if [[ $tgtdiff == -* ]] 
	then
		diffsz=`echo $tgtdiff | sed 's/-//'`
		diffsz=`echo $diffsz  | sed 's/%//' | awk '{printf"%d",$1}'`
		#echo $diffsz

		if [ $diffsz -le 1 ]
		then
			printf "!\n"
		else
			if [ $diffsz -le 5 ]
			then
				printf "!!\n"
			else
				if [ $diffsz -le 10 ]
				then
					printf "!!!\n"
				else
					if [ $diffsz -le 20 ]
					then
						printf "!!!!\n"
					else
						printf "!!!bang!!!bang!!!\n"
					fi
				fi
			fi
		fi

	else
		printf "\n"
	fi

done
