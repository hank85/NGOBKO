#!/bin/sh

###set env LANG to ZH_CN.UTF-8
export LANG=ZH_CN.UTF-8

outdir=$1
[ -z "$outdir" ] && echo "pls input dirname" && exit 9
dt=`echo $outdir | awk -F'/' '{print $NF}'`
cd $outdir


#sed -i "s/����/1/;s/����/-1/;s/������/0/;/����/d;s/^/$dt\t/" *.xls

sed -i "s/����/1/;s/����/-1/;s/������/0/;/����/d;s/^/$dt\t/" *.xls
