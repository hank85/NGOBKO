#!/bin/sh
dir=/root/target/T1W/NEW
grep -v will $dir/req.new.l|grep -v '#' | grep -v rate |awk '{sum=1-(1-$5/100)^$6+sum} END{printf"%-6.3f%\n",sum*100}'
