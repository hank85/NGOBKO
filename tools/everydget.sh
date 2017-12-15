#!/bin/sh

today=`date +%Y%m%d`
dir=/root/target/T1W/EXDB
dirbin=$dir/bin
hdir=$dirbin/include
xdir=$dir/XLS
logdir=$dir/log/everyd
tmpdir=$dir/tmp
input=$dir/code.l
wd=/root/target/T1W/ctop/WKD.l

Errlog="$logdir"/Errlog-"$today".log
everydlog="$logdir"/every-"$today".log

#exec 1>>$everydlog
#exec 2>>$Errlog

N=10
grep -vE '^$|#' $wd | grep -w "$today" | while read day weekday
do
        ##init parall dir
        rm -rf $tmpdir/*.lock
        while [ $N -gt 0 ]
        do
                touch "$tmpdir"/"$N".lock
                N=$((N-1))
        done

        u='http://stock.gtimg.cn/data/index.php?appn=detail&action=download&c='
        dlog="$logdir"/dl_$today.log

        #echo $day $weekday
        outdir=$xdir/$day
        [ -d $outdir ] && rm -rf $outdir
        mkdir -p $outdir
        grep -vE '^$|#' $input | while read code
        do
                while :
                do
                        file=`find $tmpdir -name "*.lock" -size 0|head -n1 `
                        if [ -n "$file" ]
                        then
                                echo $code | grep '^6' >/dev/null && code=sh"$code" || code=sz"$code"
                                url="$u""$code"\&d="$day"
                                outxls="$outdir"/"$code"."$day".xls
                                ( echo "$code $day" > "$file" ; wget "$url" -a "$dlog" -O "$outxls" && echo "$code $day OK" || echo "$code $day ERR" ; >"$file" ) &
                                continue 2
                        fi
                done

        done
        #$hdir/clean.sh $outdir
        echo "importing $outdir ..."
        #$hdir/importdata.sh $outdir
done
