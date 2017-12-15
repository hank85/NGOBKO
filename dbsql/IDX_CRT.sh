#!/bin/sh
DB=hankdb
dir=/root/target/T1W/hankdb

###get codelist from db
#mysql hankdb -Ne "select code from codelist;" > $dir/code.lst

cat $dir/newcode.lst | while read code
do
	[ $code -ge 600000 ] && code=sh$code || code=sz$code
	SQL="alter table $code ADD INDEX idx_$code(dt);"
	#echo $SQL
	mysql hankdb -Ne "$SQL" && echo "$code"|tee $dir/index.ok



done
