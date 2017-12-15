#!/bin/sh

dir=/root/target/T1W/EXDB
cfgdir=$dir/cfg
dlrcd=$cfgdir/download/"$code".dl


#clear bk files
mv /root/target/T1W/EXDB/backup/s*20171212* bk1/

#clear dt rcd in dl rcd
sed -i '/20171212/d' /root/target/T1W/EXDB/cfg/download/*.dl

#clear dt rcd in ct rcd 
ctrcd=$cfgdir/download/"$code".ct

sed -i '/20171212/d' /root/target/T1W/EXDB/cfg/download/*.ct


########## or :
#sed -i '/20171212/d' /root/target/T1W/EXDB/cfg/download/*.*

