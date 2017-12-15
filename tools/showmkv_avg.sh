#!/bin/sh
dir=/root/target/T1W
wkday=/root/target/T1W/ctop/WKD.l

DB=test
DB=hankdb

dtc=`mysql -N $DB -e "select count(distinct T_date) from mktvalue_day "`
if [ $dtc -ge 21 ]
then
	D=20
	Ddiff=21
else
	Ddiff=$dtc
	D=`echo $Ddiff - 1 | bc `
fi

#dt=`date +%Y%m%d`
#dt=`mysql -N $DB -e "select distinct T_date from mktvalue_day order by T_date desc limit 1"`
#tm=`date +%H%M%S`

###
T2sz_avg=0
T1sz_avg=0
T0sz_avg=0

T2sh_avg=0
T1sh_avg=0
T0sh_avg=0

T1=`mysql -N $DB -e "select distinct T_date from mktvalue_day order by T_date desc limit 1 " | sed 's/-//g' `
T0=`grep -vE '^$|#' $wkday | grep -wA1 $T1 | tail -n 1 |awk '{print $1}' `
Tm1=`grep -vE '^$|#' $wkday | grep -wA1 $T0 |tail -n 1 |awk '{print $1}'`

###SZ
	days=`mysql -N $DB -e "select distinct T_date from mktvalue_day order by T_date desc limit $Ddiff "|tail -n $D `
	days=`echo $days | sed 's/ /,/g'|sed 's/-//g'`

	T2sz_avg=`mysql -N $DB -e "select sum(Volume*Clsprice)/$D from mktvalue_day where T_date in ($days) and Scode like 'sz%'"`

	days=`mysql -N $DB -e "select distinct T_date from mktvalue_day order by T_date desc limit $D "`
	days=`echo $days | sed 's/ /,/g'|sed 's/-//g'`

	T1sz_avg=`mysql -N $DB -e "select sum(Volume*Clsprice)/$D from mktvalue_day where T_date in ($days) and Scode like 'sz%'"`

###SH
	days=`mysql -N $DB -e "select distinct T_date from mktvalue_day order by T_date desc limit $Ddiff "|tail -n $D `
	days=`echo $days | sed 's/ /,/g'|sed 's/-//g'`

	T2sh_avg=`mysql -N $DB -e "select sum(Volume*Clsprice)/$D from mktvalue_day where T_date in ($days) and Scode like 'sh%'"`

	days=`mysql -N $DB -e "select distinct T_date from mktvalue_day order by T_date desc limit $D "`
	days=`echo $days | sed 's/ /,/g'|sed 's/-//g'`

	T1sh_avg=`mysql -N $DB -e "select sum(Volume*Clsprice)/$D from mktvalue_day where T_date in ($days) and Scode like 'sh%'"`

	#printf "SZ T2: %-8.0f T1:%-8.0f\t\tSH T2: %-8.0f T1:%-8.0f\n"  $T2sz_avg $T1sz_avg $T2sh_avg $T1sh_avg
	#printf "%-s/20     $T0:%-.0f/%-.0f 	$Tm1:%-.0f/%-.0f\n" "$D"days $T2sz_avg $T2sh_avg $T1sz_avg $T1sh_avg
	printf "%-s/20     $T0 : %-.0f / %-.0f 	$Tm1 : %-.0f / %-.0f\n" "$D"days $T2sz_avg $T2sh_avg $T1sz_avg $T1sh_avg
	#printf "SZ T2: %-8.0f T1:%-8.0f\t\tSH T2: %-8.0f T1:%-8.0f\n"  $T2sz_avg $T1sz_avg $T2sh_avg $T1sh_avg

