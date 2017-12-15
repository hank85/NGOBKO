#!/bin/sh
#cfg=$1
cfg=/root/target/T1W/own.l
dir=/root/target/T1W

file=$dir/show.output.A+B

exec 1>> $file

echo "----------------- `date` -----------------"

###
MKTVT=0
MKTVSZ=0
MKTVSH=0
REVN=0
CAPITAL=0
REVNPCT=0

>$dir/out.t

grep -vE '#|^$' $cfg |while read num price vol target_p
do
	[ -z "$target_p" ] && target_p=unset
	#echo $num $price $vol
	
	#juge which market
	[ $num -gt 600000 ] && num=sh"$num" || num=sz"$num"

	#get recent data
	curl http://hq.sinajs.cn/list="$num" >$dir/c.t 2>/dev/null
	
	#num vol price count pnow  diff percent target_p
	pnow=`cat $dir/c.t | awk -F ',' '{print $4}'`
	count=`echo "$pnow * $vol" | bc `
	diff=`echo "scale=2 ; $vol * $pnow - $vol * $price " |bc `
	percent=`echo "scale=2;$diff * 100 / $count" |bc`
	
	printf "%-8s %6s %8s %15s %8s %15s %7.2f %-6s\n" $num $vol $price $count $pnow  $diff $percent $target_p | tee -a $dir/out.t
	

###sth to do:
#install a db record value everyday,and count recent 20days anverage value -done 20171012

done

#show mkt value (T,SZ,SH),revenue/% ,recent 20 days(T+2) anverage mktval
MKTVT=`cat $dir/out.t | awk '{a=$4+a} END{print a}'`
MKTVSZ=`grep -i '^sz' $dir/out.t | awk '{a=$4+a} END{print a}'`
MKTVSH=`grep -i '^sh' $dir/out.t | awk '{a=$4+a} END{print a}'`
REVN=`cat $dir/out.t | awk '{a=$6+a} END{print a}'`
CAPITAL=`cat $dir/out.t | awk '{a=$2*$3+a} END{print a}'`
REVNPCT=`echo "scale=2.0; $REVN * 100 / $CAPITAL " | bc `

echo "------------------------------------------------------------------------------"
#echo $MKTVT $MKTVSZ $MKTVSH $REVN $CAPITAL $REVNPCT
printf "MKTV:%-8s SZ:%-8s SH:%-8s	CAP:%-8s REV:%-8s REV%%:%-.2f\n" $MKTVT $MKTVSZ $MKTVSH $CAPITAL $REVN $REVNPCT

sh  $dir/showmkv_avg.sh


echo "##########################################################################"
