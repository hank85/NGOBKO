#!/bin/sh

###set env LANG to ZH_CN.UTF-8
export LANG=ZH_CN.UTF-8

DB=hankdb

outdir=$1

[ -z "$outdir" ] && echo "pls input dirname" && exit 9
cd $outdir

dt=`echo $outdir | awk -F'/' '{print $NF}'`
dir=/root/target/T1W/EXDB
cfg=$dir/code.l
bkdir=$dir/backup
logdir=$dir/log
log=$logdir/import.log
errlog=$logdir/import_err.log

#exec 1>>$log 
#exec 2>>$errlog


#sed -i "s/ÂòÅÌ/1/;s/ÂôÅÌ/-1/;s/ÖÐÐÔÅÌ/0/;/ÐÔÖÊ/d;s/^/$dt\t/" *.xls
#sed -i "s/ÂòÅÌ/1/;s/ÂôÅÌ/-1/;s/ÖÐÐÔÅÌ/0/;/ÐÔÖÊ/d;s/^/$dt\t/" *.xls

grep -vE '^$|#' $cfg | while read code
do
	[ $code -ge 600000 ] && code=sh$code || code=sz$code
	file=$outdir/$code.$dt.xls

	if [ -s $file ] 
	then
		sed "s/ÂòÅÌ/1/;s/ÂôÅÌ/-1/;s/ÖÐÐÔÅÌ/0/;/ÐÔÖÊ/d;s/^/0\t/" $file >$file.c

		mysql $DB -e "delete from $code where dt='0';"
		mysqlimport -rL $DB $file
		
		ifcount=`mysql $DB -Ne "select count(dt) from $code where dt=$dt;"`
		[ "$ifcount" -gt 0 ] && echo "[$dt] row have $ifcount records already,pls clear" && continue
		mysql $DB -e "insert into $code (dt,tm,price,pch,vol,count)  select $dt,tm,price,pch,vol,count from $code where dt='0';"

		#( gzip $outdir/*.xls && mv $outdir $bkdir/  &&  echo "$outdir gzip&backup OK") &
	else
		echo "$file not exist!"
	fi
done
