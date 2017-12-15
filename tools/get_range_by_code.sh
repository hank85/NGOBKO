#!/bin/sh

code=$1
[ -z $code ] && echo "pls input a num" && exit 9
[ $code -ge 600000 ] && code=sh"$code" || code=sz"$code"

today=`date +%Y%m%d`
dir=/root/target/T1W/EXDB
dirbin=$dir/bin
hdir=$dirbin/include
xdir=$dir/XLS
logdir=$dir/log/everyd
tmpdir=$dir/tmp
wd=/root/target/T1W/ctop/WKD.l


Errlog="$logdir"/Errlog-"$today".log
everydlog="$logdir"/every-"$today".log

exec 1>>$everydlog
exec 2>>$Errlog

#########################get recent 50 days if not download before
cfgdir=$dir/cfg
dlrcd=$cfgdir/download/"$code".dl
[ ! -f $dlrcd ] && >$dlrcd

u='http://stock.gtimg.cn/data/index.php?appn=detail&action=download&c='
dlog="$logdir"/dl_$today.log

tm=`date +%H%M`
if [ $tm -ge 1630 ]
then
	grep -vE '^$|#' $wd | grep -wB 50 $today | grep -vwf $dlrcd >$tmpdir/dldcode.lst
else
	grep -vE '^$|#' $wd | grep -wB 50 $today | grep -vwf $dlrcd |grep -vw $today >$tmpdir/dldcode.lst
fi

cat $tmpdir/dldcode.lst| while read day wk
do
	outdir=$xdir/$day && [ ! -d $outdir ] && mkdir -p $outdir
		url="$u""$code"\&d="$day"
		outxls="$outdir"/"$code"."$day".xls
		echo "$day" >>$dlrcd
		wget "$url" -a "$dlog" -O "$outxls"

		#############ETL data into DB:
		if [ -s "$outxls" ] 
		then
			sh $hdir/ETL_by_code+date.sh $outxls 
		else
			echo "$outxls is null"
		fi

done

gzip $dlog &
