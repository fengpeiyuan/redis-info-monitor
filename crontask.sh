#!/usr/bin/env python
import redis
import httplib,urllib
import datetime
import sys

#parameter input is port: sys.argv[1]
rdshost="w"+sys.argv[1]+".wdds.redis.com"
rdsport=sys.argv[1]
rdsdomain=rdshost
httphost="localhost"
httpport=8086

##input
rds=redis.Redis(host=rdshost,port=rdsport,db=0)
rds_info=rds.info()
params='i'+rdsport+',host='+rdshost+',role=m '
for key in rds_info:
  #print "%s: %s" % (key, str(rds_info[key]))
  params=params+key+"=\""+str(rds_info[key])+"\","

##output
try:
  headers={"Content-type":"application/x-www-form-urlencoded","Accept":"text/plain"}
  httpcli=httplib.HTTPConnection(httphost,httpport, timeout=30)
  httpcli.request("POST", "/write?db=redis_info_monitor", params[:-1], headers)
  response=httpcli.getresponse()
  #print response.status
  #print response.reason
except Exception, e:
    print e
finally:
    if httpcli:
        httpcli.close()

now = datetime.datetime.now()
styled_time = now.strftime("%Y-%m-%d %H:%M:%S")
print styled_time+" completed"
