#!/bin/sh
#cfg=$1
cfg=/root/target/T1W/own.l
wkday=/root/target/T1W/ctop/WKD.l

DB=hankdb
DB=test

dt=`date +%Y%m%d`
dt=20171010

###judge if date is a trans day
grep -vE '#|^$' $wkday | grep -w $dt >/dev/null 2>&1 
if [ $? -ne 0 ] 
then
	echo not transday
	exit 1
fi

grep -vE '#|^$' $cfg |while read num price vol target_p
do
	[ -z "$target_p" ] && target_p=unset
	#echo $num $price $vol
	
	#juge which market
	[ $num -gt 600000 ] && num=sh"$num" || num=sz"$num"

	#get recent data
	curl http://hq.sinajs.cn/list="$num" >c.t 2>/dev/null
	
	#num vol price count pnow  diff percent target_p
	clsprice=`cat c.t | awk -F ',' '{print $4}'`
	
	#install a db record value everyday,and count recent 20days anverage value
	#sql="insert into  mktvalue_day  set Scode='$num' , Volume=$vol , Clsprice=$clsprice, T_date=$dt"
	#echo $sql
	mysql $DB -e "insert into  mktvalue_day  set Scode='$num' , Volume=$vol , Clsprice=$clsprice, T_date=$dt"

	
###sth to do:


done
