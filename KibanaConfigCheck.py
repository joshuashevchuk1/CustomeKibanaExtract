import KibanaExtract as KE
import logging
import traceback
import sys
import os
import configparser
import numpy as np
import ast
import json

query_sort      = True
query_name      = 'output_CHECK'
index_string    = 'incident-signature'
size            = 5000
fixed_interval  = '30s'
query_name_list = ['output_QS']
query_fields    = ['incident-id','zipSize','zipCode']
query_time      = """ "gte": "2020-08-10T17:00:00.000Z",
              "lte": "2020-08-10T17:15:00.000Z" """
query_time1     = query_time
query_time_list = [query_time1]
match_string    = """ {
          "match_phrase": {
             "incident-type": {
              "query": "reboot"
                }
            }
        }, """

securityconfig  = configparser.RawConfigParser()
Rawconfigfile   = securityconfig.read('security.cfg')
Scanner_Check   = securityconfig.sections()
username        = securityconfig.get("security","username")
password        = securityconfig.get("security","password")
Rawconfig       = configparser.RawConfigParser()
Rawconfigfile   = Rawconfig.read('Kibana_DefSigM12.cfg')
query_sort      = Rawconfig.getboolean("query options","query_sort")
query_name      = ast.literal_eval(Rawconfig.get("query","query_name"))
query_fields    = ast.literal_eval(Rawconfig.get("query","query_fields"))
query_time      = ast.literal_eval(Rawconfig.get("query","query_time"))
match_string    = ast.literal_eval(Rawconfig.get("query options","match_string"))
size            = Rawconfig.getint("query options","size")
fixed_interval  = Rawconfig.get("query options","fixed_interval")
index_string    = Rawconfig.get("query options","index_string")

print('||||||||||||||||||||||||||||||||')
print('==================')
print('query_sort')
print(str(query_sort))
print(type(query_sort))
print('==================')
print('query_name')
print(query_name)
print(type(query_name))
print('==================')
print('query_fields')
print(query_fields)
print(type(query_fields))
print(len(query_fields))
print('==================')
print('query_time')
print(query_time)
print(type(query_time))
print('==================')
print('match_string')
print(match_string)
print(type(match_string))
print('==================')
print('size')
print(size)
print(type(size))
print('==================')
print('fixed_interval')
print(fixed_interval)
print(type(fixed_interval))
print('==================')
print('index_string')
print(index_string)
print(type(index_string))
print('==================')
print('||||||||||||||||||||||||||||||||')
