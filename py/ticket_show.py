#!/usr/bin/python
#encoding:utf-8

#authoer#zhangh@126.com;20171215
#comments:#this is TKshow.sh build with python 

import sys
import subprocess
code=sys.argv[1]




if code.startswith('6'):
	code='sh'+str(code)
else:
	code='sz'+str(code)

url='http://hq.sinajs.cn/list='+code

subprocess.call(['curl',url])


######source code with shell
#[ $code -gt 600000 ] && code=sh$code || code=sz$code
#curl http://hq.sinajs.cn/list=$code
