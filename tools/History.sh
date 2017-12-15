#!/bin/sh
dir=/root/target/T1W/HISTORY

dt=`date +%Y%m%d_%H:%M:%S`

sh /root/target/T1W/S.sh > $dir/hist.$dt

