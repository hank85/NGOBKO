#!/bin/sh
############################################################################
#20171122	show get new plan and rate
#1.get new list and compare with will be limit ,to plan mktValue distribution. 
#2.create tb to rcd "date  code    max             price   rate    QIAN" and count "ratio" to count total ratio
############################################################################
#cfg=$1
NEWdir=/root/target/T1W/NEW
new=$NEWdir/req.new.l
wkday=/root/target/T1W/ctop/WKD.l

DB=hankdb

mkvnow=$NEWdir/mkv_now.out
mkvavg=$NEWdir/showmkv_avg.out

sznow=`awk '{print $2}' $mkvnow | awk -F ':' '{print $2}'`
shnow=`awk '{print $3}' $mkvnow | awk -F ':' '{print $2}'`

dt1=`awk '{print $2 }' $mkvavg`
sz1=`awk '{print $4 }' $mkvavg `
sh1=`awk '{print $6 }' $mkvavg `

dt2=`awk '{print $7 }' $mkvavg`
sz2=`awk '{print $9 }' $mkvavg `
sh2=`awk '{print $11 }' $mkvavg`


tmpdir=$NEWdir/tmp
tmpout=$NEWdir/t.out

lastdt=`grep -vE '#|^$' $new |sort -rn | head -n 1 | awk '{print $1}'`

sed -n "/^$dt1/,/^$lastdt/p" /root/target/T1W/ctop/WKD.l |grep -Ev '^$|#' | while read dt wk
do
	printf "%-8s %-1s|\t"  "$dt" "$wk"
	if [ "$dt" = "$dt1" ] 
	then
		sz_avg=`echo "scale=3;$sz1/100000"|bc | awk '{printf "%.3f", $0}'`
		sh_avg=`echo "scale=2;$sh1/100000"|bc | awk '{printf "%.2f", $0}'`
	else
		if [ "$dt" = "$dt2" ] 
		then
			sz_avg=`echo "scale=3;$sz2/100000"|bc | awk '{printf "%.3f", $0}'`
			sh_avg=`echo "scale=2;$sh2/100000"|bc | awk '{printf "%.2f", $0}'`
		else
			#count avg pre
			#get days
			days=`grep -vE '^$|#' $wkday | grep -B 21 $dt | head -n 20 | awk '{ print $1 }'`
			days=`echo $days | sed 's/ /,/g'|sed 's/-//g'`
			daycount=`mysql -N $DB -e "select count(distinct T_date) from mktvalue_day where T_date in ($days);"`
			daydiff=`echo 20 - $daycount |bc`
			sz_avg=`mysql -N $DB -e "select cast((sum(Volume*Clsprice)+$daydiff*$sznow)/20/100000 as decimal(4,3)) from mktvalue_day where T_date in ($days) and Scode like 'sz%'"`
			sh_avg=`mysql -N $DB -e "select cast((sum(Volume*Clsprice)+$daydiff*$shnow)/20/100000 as decimal(3,2)) from mktvalue_day where T_date in ($days) and Scode like 'sh%'"`
		fi
	fi
	################################get code max ratio output by diff mkt
	>$tmpout.sz
	>$tmpout.sh
	grep -wc $dt $new | while read count
	do
		if [ $count -gt 0 ] 
		then
			grep -w $dt $new | sort -n -k2 | while read dt code max price ratio qian
			do
				if [ $code -gt 600000 ] 
				then
					printf "%-s/%-s/%-s " $code $max $ratio >>$tmpout.sh
				else
					printf "%-s/%-s/%-s " $code $max $ratio >>$tmpout.sz
				fi
			done
			printf "%-55s|%-55s\n" "$sz_avg: `cat $tmpout.sz`" "$sh_avg: `cat $tmpout.sh`"
		else
			printf "%-55s|%-55s\n" "$sz_avg:" "$sh_avg:"
		fi

	done
done

