#!/bin/sh
############################################################################
#20171107 show history
#1.show recent ten transactions for holding tickets
#2.show recent 5 tranactions for soldout tickets
############################################################################
#cfg=$1
cfg=/root/target/T1W/own.l
dir=/root/target/T1W
tmpdir=$dir/tmp
tmpout=$dir/t.hist.out
hist=$dir/hist.count

>$tmpout
rm -rf $tmpdir/*
#> $tmpdir/tmp.t

grep -vE '#|^$' $cfg |sort -n |while read num price vol target_p comments
do
	[ -z "$target_p" ] && target_p=unset
	#echo $num $price $vol
	grep '#T'$num $cfg >$tmpdir/$num.t
	#paste $tmpdir/$num.t $tmpdir/tmp.t >>$tmpout
	#cat $tmpout >$tmpdir/tmp.t
done

wc -l $tmpdir/[0-9]*.t | grep -v total |sort -rn | awk '{print $2}' | xargs paste |sed 's/^#T//g' | sed 's/#T/| /g'
echo "------------------------------------------------------------------------------------------------------------------"

