#!/bin/sh
dir=/root/target/T1W/EXDB/bin
mysql hankdb -Ne "select code from codelist;" > $dir/code.lst

grep '^[0-9]' $dir/code.lst | while read code
do

	sh $dir/get_range_by_code.sh $code


done
