#!/bin/sh
dir=/root/target/T1W/BASE

SZ=$dir/SZ.txt
SH=$dir/SH.txt

#1.1 init: del " in SZ.txt
sed -i 's/\"//g;s/,//g' $SZ

#1.2 clear deactive code
grep -vw 0 $SZ | grep '^[0-9]' >$SZ.c

#1.3 trans to UTF-8 
iconv -f gbk -t utf-8 $SZ.c -o $dir/codelist.SZ.utf8

#1.4 import to codelist
mysqlimport  -rL --default-character-set=utf8 hankdb $dir/codelist.SZ.utf8



#2.1 init: trans vol from W to int in SH
awk '{printf"%s\t%s\t%s\t%s\t%s\n",$1,$2,$3,$4*10000,$5*10000}' $SH |grep '^[0-9]' >$SH.c

#2.2 trans to UTF-8 
iconv -f gbk -t utf-8 $SH.c -o $dir/codelist.SH.utf8

#1.4 import to codelist
mysqlimport  -rL --default-character-set=utf8 hankdb $dir/codelist.SH.utf8
