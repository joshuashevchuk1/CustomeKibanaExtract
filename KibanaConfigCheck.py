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
username        = 'jq998g'
password        = 'Goaly67!!!!'
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

Rawconfig       = configparser.RawConfigParser()
Rawconfigfile   = Rawconfig.read('KibanaConfig.cfg')
Scanner_Check   = Rawconfig.sections()
username        = Rawconfig.get("security","username")
password        = Rawconfig.get("security","username")
query_sort      = Rawconfig.getboolean("query options","query_sort")
query_name      = ast.literal_eval(Rawconfig.get("query","query_name"))
query_fields    = ast.literal_eval(Rawconfig.get("query","query_fields"))
query_time      = ast.literal_eval(Rawconfig.get("query","query_time"))
match_string    = ast.literal_eval(Rawconfig.get("query options","match_string"))
size            = Rawconfig.getint("query options","size")
fixed_interval  = Rawconfig.get("query options","fixed_interval")
index_string    = Rawconfig.get("query options","index_string")

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

