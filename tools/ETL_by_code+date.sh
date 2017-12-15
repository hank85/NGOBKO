#!/bin/sh

###set env LANG to ZH_CN.UTF-8
export LANG=ZH_CN.UTF-8

DB=hankdb

file=$1
[ -z "$file" ] && echo "pls input file" && exit 9

dt=`echo $file | awk -F'/' '{print $NF}' | awk -F '.' '{print $2}' `
code=`echo $file | awk -F'/' '{print $NF}' | awk -F '.' '{print $1}' `
dir=/root/target/T1W/EXDB
bkdir=$dir/backup
logdir=$dir/log
log=$logdir/import.log
errlog=$logdir/import_err.log

#exec 1>>$log 
#exec 2>>$errlog


#sed -i "s/ÂòÅÌ/1/;s/ÂôÅÌ/-1/;s/ÖÐÐÔÅÌ/0/;/ÐÔÖÊ/d;s/^/$dt\t/" *.xls


if [ -s $file ] 
then
	printf "[%-s] %s:" "`date`" "$file"
	sed "s/ÂòÅÌ/1/;s/ÂôÅÌ/-1/;s/ÖÐÐÔÅÌ/0/;/ÐÔÖÊ/d;s/^/0\t/" $file >$file.c

	mysql $DB -e "delete from $code where dt=0;"
	mysqlimport -rL $DB $file.c
	
	mysql $DB -Ne "delete from $code where dt=$dt;"
	mysql $DB -e "insert into $code (dt,tm,price,pch,vol,count,type) select $dt,tm,price,pch,vol,count,type from $code where dt=0;"

	#( rm -f $file && gzip $file.c && mv $file.c.gz $bkdir/  &&  echo "$file gzip&backup OK" || echo "$file clear err" ) &
	( rm -f $file && gzip $file.c && mv $file.c.gz $bkdir/  || echo "$file clear err" ) &
else
	echo "$file not exist!"
fi
