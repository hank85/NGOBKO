#!/bin/sh

dir=/root/target/T1W/EXDB/
bindir=$dir/bin


$bindir/IMPORT_DATA.sh

sleep 60

$bindir/COUNT_MODEL1.sh
