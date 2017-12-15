#!/bin/sh
dir=/root/target/T1W/
cfg=$dir/own.l
wkday=/root/target/T1W/ctop/WKD.l

DB=hankdb

type=""
if [ $# -ne 1 ] 
then
	dt=`date +%Y%m%d`
else
	dt=$1
	type="manu_mod"
	#dt=20171109
fi


###judge if date is a trans day
grep -vE '#|^$' $wkday | grep -w $dt >/dev/null 2>&1 
if [ $? -ne 0 ] 
then
	echo not transday
	exit 1
fi
echo 0 > $dir/sz.c
echo 0 > $dir/sh.c
szc=0
shc=0

###add clear sql for redo
mysql $DB -e "delete from  mktvalue_day  where T_date=$dt"


grep -vE '#|^$' $cfg |while read num price vol target_p
do
	[ -z "$target_p" ] && target_p=unset
	#echo $num $price $vol
	
	#juge which market
	if [ $num -gt 600000 ] 
	then
		num=sh"$num" 
		shc=`echo "$shc + 1" | bc `
		echo $shc > $dir/sh.c
	else
		num=sz"$num"
		szc=`echo "$szc + 1" | bc `
		echo $szc > $dir/sz.c
	fi

	#get recent data
	curl http://hq.sinajs.cn/list="$num" >c.t 2>/dev/null
	
	#num vol price count pnow  diff percent target_p
	###add clear sql for redo
	if [ $type = "manu_mod" ]
	then
		##record at today
		clsprice=`cat c.t | awk -F ',' '{print $3}'`
	else
		##record at the next day
		clsprice=`cat c.t | awk -F ',' '{print $4}'`
	fi
	
	#install a db record value everyday,and count recent 20days anverage value
	#sql="insert into  mktvalue_day  set Scode='$num' , Volume=$vol , Clsprice=$clsprice, T_date=$dt"
	#echo $sql
	
	mysql $DB -e "insert into  mktvalue_day  set Scode='$num' , Volume=$vol , Clsprice=$clsprice, T_date=$dt"

###sth to do:
done


szc=`cat $dir/sz.c`
[ "$szc" -eq 0 ] && mysql $DB -e "insert into  mktvalue_day  set Scode='sz000000' , Volume=0, Clsprice=0, T_date=$dt"
shc=`cat $dir/sh.c`
[ "$szc" -eq 0 ] && mysql $DB -e "insert into  mktvalue_day  set Scode='sh000000' , Volume=0, Clsprice=0, T_date=$dt"



###insert value every day
$dir/BASE/insert_day_rcd.sh 
