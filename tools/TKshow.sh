#!/bin/sh

code=$1

[ $code -gt 600000 ] && code=sh$code || code=sz$code
curl http://hq.sinajs.cn/list=$code
