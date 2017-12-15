#!/bin/sh

cfg=/root/target/T1W/own.l
dir=/root/target/T1W

#cap=`grep '^BASE' /root/target/T1W/own.l | awk '{print $2}'`
cap=`grep '^capleft' /root/target/T1W/own.l | awk '{print $2}'`
echo $cap




	day=`mysql -N hankdb -e "select distinct T_date from mktvalue_day order by T_date desc limit 1" | sed 's/ /,/g' | sed 's/-//g' `
	szvalue=`mysql hankdb -N -e "select sum(Volume*Clsprice) from mktvalue_day where T_date=$day and Scode like 'sz%';"`
	shvalue=`mysql hankdb -N -e "select sum(Volume*Clsprice) from mktvalue_day where T_date=$day and Scode like 'sh%';"`
	isql="insert into day_value (T_date,szvalue,shvalue,cap_lft) values($day,$szvalue,$shvalue,$cap);"
	#echo $isql
	mysql hankdb -e "$isql"
