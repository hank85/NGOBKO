#!/bin/sh
#cfg=$1
cfg=/root/target/T1W/own.l
dir=/root/target/T1W
NEWdir=$dir/NEW
tmpout=$dir/t.out
#tab=$dir/tables/Table.xls
tab=$dir/tables/Table.txt
hist=$dir/hist.count

###
MKTVT=0
MKTVSZ=0
MKTVSH=0
REVN=0
CAPITAL=0
REVNPCT=0

>$tmpout
cal
echo "----------NOW:--------------------------------------------------------------------------------"

BASE_CAP=`grep '^BASE_CAP' $cfg | awk '{print $2}'`
grep -vE '#|^$' $cfg |grep '^[0-9]' |sort -n |while read num price vol target_p
do
	[ -z "$target_p" ] && target_p=unset
	#echo $num $price $vol
	
	#juge which market
	[ $num -gt 600000 ] && num=sh"$num" || num=sz"$num"

	#get recent data
	curl http://hq.sinajs.cn/list="$num" >$dir/c.t 2>/dev/null
	
	#num vol price count pnow  diff percent target_p
	pnow=`cat $dir/c.t | awk -F ',' '{print $4}'`
	pytd=`cat $dir/c.t | awk -F ',' '{print $3}'`
	Tcount=`cat $dir/c.t | awk -F ',' '{print $10/10000}'`
	count=`echo "$pnow * $vol" | bc `
	diff=`echo "scale=2 ; $vol * $pnow - $vol * $price " |bc `
	pdiff=`echo "scale=2 ; 100 * ($pnow - $pytd ) / $pytd " |bc `
	percent=`echo "scale=2;$diff * 100 / $count" |bc`

###MARK: coreect to LTVol
	#GB,and LTGB
	Zvalue=`grep -i $num  $tab | awk '{print $4/10000/10000}'`
	LTvalue=`grep -i $num  $tab | awk '{print $3/10000/10000}'`
	LTratio=`echo "scale=2 ; 100 * $LTvalue / $Zvalue " |bc `
	hsratio=`echo "scale=2 ; 100 * $Tcount /10000 / $LTvalue " |bc `
	
	#printf "%-8s %6s %8s %15s %8s %15s %7.2f %6.2f %-6s\n" $num $vol $price $count $pnow  $diff $percent "$pdiff"  $target_p | tee -a $tmpout
	#printf "%-8s|%6s|%8s|%15s|%8s|%15s|%7.2f|%6.2f|%8.2f|%-6s\n" $num $vol $price $count $pnow  $diff $percent "$pdiff" "$Tcount"  $target_p | tee -a $tmpout

	###add huangshoulv and ltratio 
	printf "%-8s|%6s|%8s|%15s|%8s|%15s|%7.2f|%6.2f|%7.0f|%6.2f|%5.0f|%6.2f|%-6s\n" $num $vol $price $count $pnow  $diff $percent "$pdiff" "$Tcount" $hsratio $LTvalue $LTratio $target_p | tee -a $tmpout


###sth to do:
#install a db record value everyday,and count recent 20days anverage value -done 20171012

done

#show mkt value (T,SZ,SH),revenue/% ,recent 20 days(T+2) anverage mktval
MKTVT=`cat $tmpout | awk '{a=$4+a} END{print a}'`
MKTVSZ=`grep -i '^sz' $tmpout | awk '{a=$4+a} END{print a}'`
MKTVSH=`grep -i '^sh' $tmpout | awk '{a=$4+a} END{print a}'`
REVN=`cat $tmpout | awk '{a=$6+a} END{print a}'`
CAPITAL=`cat $tmpout | awk '{a=$2*$3+a} END{print a}'`
REVNPCT=`echo "scale=2.0; $REVN * 100 / $CAPITAL " | bc `

HIST_REV=0
###20171101 add HIST_REV and HIST_REV%
#grep -vE '#|^$' $hist |sort -n |while read dt num ttrev ct ip op
HIST_REV=`awk '{sum=sum+$3} END{print sum}' $hist`
HIST_REVP=`echo "scale=2.0; ( $REVN + $HIST_REV ) * 100 / $CAPITAL " | bc `
#echo $HIST_REV $HIST_REVP
	

echo
echo "----------STATUS:--------------------------------------------------------------------------------"
#echo $MKTVT $MKTVSZ $MKTVSH $REVN $CAPITAL $REVNPCT
#printf "MKTV:%-8s SZ:%-8s SH:%-8s	CAP:%-8s REV:%-8s REV%%:%-.2f\n" $MKTVT $MKTVSZ $MKTVSH $CAPITAL $REVN $REVNPCT

###20171101 add HIST_REV and HIST_REV%
###20171123 add capleft
capleft=`grep '^capleft' /root/target/T1W/own.l | awk '{print $2}'`

#printf "MKTV:%-8s SZ:%-8s SH:%-8s	CAP:%-8s REV:%-8s REV%%:%-.2f (Hist:REV:%-8s REV%%:%-.2f)\n" $MKTVT $MKTVSZ $MKTVSH $CAPITAL $REVN $REVNPCT $HIST_REV $HIST_REVP | tee $NEWdir/mkv_now.out
printf "MKTV:%-8s SZ:%-8s SH:%-8s	CAP:%-10s Capleft:%-8.2f\n" $MKTVT $MKTVSZ $MKTVSH $CAPITAL "$capleft" | tee $NEWdir/mkv_now.out
printf "REV:%-9s REV%%:%-20.2f HRev:%-9s HRev%%:%-.2f\n" $REVN $REVNPCT $HIST_REV $HIST_REVP

sh  $dir/showmkv_avg.sh | tee $NEWdir/showmkv_avg.out
echo "Total Rate: `sh $dir/NEW/showtotal.rate.sh`"
echo "----------MON:--------------------------------------------------------------------------------"
sh  $dir/MON/getmon.sh
echo
echo "----------NEW:--------------------------------------------------------------------------------"
sh  $dir/NEW/getnew.sh
echo
echo "----------HISTORY:--------------------------------------------------------------------------------"
sh  $dir/showhist.sh

