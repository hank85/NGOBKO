#!/bin/sh
#import data and compress data to bkdir
DB=hankdb

outdir=$1
[ -z "$outdir" ] && echo "pls input dirname" && exit 9

dir=/root/target/T1W/EXDB
bkdir=$dir/backup
logdir=$dir/log
log=$logdir/import.log
errlog=$logdir/import_err.log

#exec 1>>$log 
#exec 2>>$errlog

if [ -d $outdir ] 
then
	#import data and mv to bk dir
	#mysqlimport -dL test $outdir/*.xls >>$log 

	mysqlimport -rL $DB $outdir/*.xls 
	#( gzip $outdir/*.xls && mv $outdir $bkdir/  &&  echo "$outdir gzip&backup OK") &
	
else
	echo "dir not exist!"
fi
