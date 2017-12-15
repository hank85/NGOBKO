#!/bin/sh


cap=0




days=`mysql -N hankdb -e "select distinct T_date from mktvalue_day "`
for day in $days
do
	day=`echo $day | sed 's/ /,/g'|sed 's/-//g'`
	szvalue=`mysql hankdb -N -e "select sum(Volume*Clsprice) from mktvalue_day where T_date=$day and Scode like 'sz%';"`
	shvalue=`mysql hankdb -N -e "select sum(Volume*Clsprice) from mktvalue_day where T_date=$day and Scode like 'sh%';"`
	isql="insert into day_value (T_date,szvalue,shvalue,cap_lft) values($day,$szvalue,$shvalue,'0');"
	#echo $isql
	mysql hankdb -e "$isql"
done
