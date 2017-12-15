#!/bin/sh

code=$1
[ -z $code ] && echo "pls input a num" && exit 9
[ $code -ge 600000 ] && code=sh"$code" || code=sz"$code"

DB=hankdb

today=`date +%Y%m%d`
dir=/root/target/T1W/EXDB
dirbin=$dir/bin
hdir=$dirbin/include
xdir=$dir/XLS
logdir=$dir/log/everyd
tmpdir=$dir/tmp
outdir=$dir/tmp
wd=/root/target/T1W/ctop/WKD.l

SQL=$dirbin/count1.sql


Errlog="$logdir"/Count_Errlog-"$today".log
everydlog="$logdir"/Count_every-"$today".log

exec 1>>$everydlog
exec 2>>$Errlog

#########################get recent 50 days if not download before
cfgdir=$dir/cfg
ctrcd=$cfgdir/download/"$code".ct
dlrcd=$cfgdir/download/"$code".dl

[ ! -f $ctrcd ] && >$ctrcd

file=$outdir/wy1.$code.out
>$file

#grep -vE '^$|#' $wd | grep -wB 50 $today | grep -vwf $ctrcd |grep -vw $today | while read day wk
grep -vE '^$|#' $wd | grep -wB 51 $today | grep -vwf $ctrcd |grep -wf $dlrcd | while read day wk
do
	sql=`sed "s/CODE/$code/;s/DATE/$day/" "$SQL"`
	echo "$day" >>$ctrcd
	echo `echo $sql | mysql -N $DB` | sed "s/^/$code $day /;s/NULL/0/g" >$outdir/"$code"_"$day".out
	cat $outdir/"$code"_"$day".out >>"$file"
done

#############import data into DB:
printf "[%-s] %s:" `date` $file
mysqlimport $DB --fields-terminated-by=' ' -rL $file
