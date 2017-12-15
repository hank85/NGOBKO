#!/bin/sh

#get workday for a y
#output YYmmdd

[ $# -ne 1 ] && echo "pls input a year like 20XX as a param" && exit 9

y=$1
m=01
d=01
day="$y""$m""$d"

tmp=/tmp/getwkd.tmp
>workday_$y.l

while [ "$m" -le 12 ]
do
	date +%u -d "$day" >$tmp
	rz=$?
	if [ "$rz" -eq 0 ]
	then
		###normal day,juge week
		u=`cat $tmp`
		if [ "$u" -le 5 ]
		then
			###out put
			printf "%-8s\t %s\n" "$day" "$u" >>workday_$y.l
		else
			:
		fi

		#day+1
		d=$((d+1))
		day=`printf "%s%02d%02d\n" "$y" "$m" "$d"`

	else
		###not normal day,mon+1,day=01
		m=$((m+1))
		d=01
		day=`printf "%s%02d%02d\n" "$y" "$m" "$d"`
		
	fi

done
