#!/bin/sh
dir=/root/target/T1W/EXDB/bin
[ ! -s $dir/code.lst ] && mysql hankdb -Ne "select code from codelist;" > $dir/code.lst

grep '^[0-9]' $dir/code.lst | while read code
do

	sh $dir/count_range_by_code.sh $code

done
