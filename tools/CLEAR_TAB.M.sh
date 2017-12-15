#!/bin/sh

dir=/root/target/T1W/EXDB/bin
logdir=/root/target/T1W/EXDB/log/
codelst=$dir/code.lst




###set env LANG to ZH_CN.UTF-8
export LANG=ZH_CN.UTF-8
DB=hankdb

dt="20171212"
log=$logdir/clear.log

exec 1>>$log 
exec 2>>$log


cat $codelst | while read code
do
	[ $code -ge 600000 ] && code=sh"$code" || code=sz"$code"
	printf "[%-s] [%s]:" "`date`" "$code + $dt"

	mysql $DB -Ne "delete from $code where dt=$dt;"
	mysql $DB -e "insert into $code (dt,tm,price,pch,vol,count,type)  select $dt,tm,price,pch,vol,count,type from $code where dt=0;" && echo OK
done
