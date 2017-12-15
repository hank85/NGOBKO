#!/bin/sh
DB=hankdb
dir=/root/target/T1W/hankdb

#get codelist from db

mysql hankdb -Ne "select code from codelist;" > $dir/code.lst

mysql hankdb -Ne "show tables ;" | grep '^s' | cut -c 3-8 > $dir/tab.lst

grep '^[0-9]' $dir/code.lst |grep -vwf $dir/tab.lst >$dir/newcode.lst
cat $dir/newcode.lst | while read code
do

[ $code -ge 600000 ] && code=sh$code || code=sz$code
SQL="create table $code (
dt date not null,
tm time not null,
price decimal(7,2) not null,
pch decimal(5,2) not null,
vol int(8) unsigned not null,
count int(10) unsigned not null,
type tinyint(4) not null,
uptime TIMESTAMP not null DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
)
ROW_FORMAT=COMPRESSED  
KEY_BLOCK_SIZE=8;
"
#echo $SQL
mysql hankdb -Ne "$SQL" && echo "$code OK"



done
