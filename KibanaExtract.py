import numpy as np
import pandas as pd
import traceback
import os 
import sys
import json

class Kibana_Extract(object):
    #
    def __init__(self):
        print('======================')
        print('begin initalization')
        print('======================')

    def getvars(self,
                username,
                password,
                index_string,
                size,
                fixed_interval,
                match_string,
                query_name,
                query_time,
                query_fields,
                query_sort=False):
    #
        self.username=username
        self.password=password
        self.index_string=index_string
        self.size=size
        self.fixed_interval=fixed_interval
        self.match_string=match_string
        self.query_name=query_name
        self.query_time=query_time
        self.query_fields=query_fields
        self.query_sort=query_sort
        #
        self.curl_string  = "curl -XGET http://" + str(self.username) + ":" +str(self.password) +"########"+str(self.index_string)+"/_search -H 'Content-Type: application/json'"
        fixed_interval_string=""" "{}" """.format(fixed_interval)
        #
        self.query_string = """ -d'{
          "version": true,
          "size": """+str(self.size)+""",
          "sort": [
            {
              "zipTimestamp": {
                "order": "desc",
                "unmapped_type": "boolean"
              }
            }
          ],
          "_source": {
            "excludes": []
          },
          "aggs": {
            "2": {
              "date_histogram": {
                "field": "zipTimestamp",
                "fixed_interval": """+str(fixed_interval_string)+""",
                "time_zone": "America/Los_Angeles",
                "min_doc_count": 1
              }
            }
          },
          "stored_fields": [
            "*"
          ],
          "script_fields": {},
          "docvalue_fields": [
            {
              "field": "@timestamp",
              "format": "date_time"
            },
            {
              "field": "crashTimestamp",
              "format": "date_time"
            },
            {
              "field": "metadaCollectedTimestamp",
              "format": "date_time"
            },
            {
              "field": "rebootTimestamp",
              "format": "date_time"
            },
            {
              "field": "sendDate",
              "format": "date_time"
            },
            {
              "field": "zipTimestamp",
              "format": "date_time"
            }
          ],
          "query": {
            "bool": {
              "must": [],
              "filter": [
                {
                  "match_all": {}
                },
                """+str(self.match_string)+"""
                {
                  "range": {
                    "zipTimestamp": {
                      "format": "strict_date_optional_time",
                      """+str(self.query_time)+"""
                    }
                  }
                }
              ],
              "should": [],
              "must_not": []
            }
          },
          "highlight": {
            "pre_tags": [
              "@kibana-highlighted-field@"
            ],
            "post_tags": [
              "@/kibana-highlighted-field@"
            ],
            "fields": {
              "*": {}
            },
            "fragment_size": 2147483647
          }
        }' """
        print('======================')
        print('initalized vars')
        print(query_name)
        print(query_time)
        print(query_fields)
        print('======================')
        return username,password
    #
    def curlQuery(self):
        query_name=self.query_name
        os.system('chmod 775 ./*')
        #
        try:
            f = open(str(query_name)+".json","w+")
        except:
            print('file already made')
        #
        os.system('chmod 775 ./*')
        username=self.username
        password=self.password
        curl_string=self.curl_string
        query_string=self.query_string
        os.system(""" """ + str(curl_string)+ """ """ + str(query_string)+ """ """ + """ | python -m json.tool > """ + str(query_name)+""".json """) 
        f.close()
    #
    #
    def makeQueryCSV(self):
        query_sort=self.query_sort
        query_name=self.query_name
        query_fields=self.query_fields
        print(query_name)
        json_file=str(query_name)+".json"
        with open(json_file) as f:
            resp_dict = json.load(f)
        #
        query_data={}
        query_temp=[]
        #
        #---
        for j in range(len(query_fields)):
            query_temp=[]
            for i in range(resp_dict[u'hits'][u'total'][u'value']):
                #--
                query_temp.append(
                        resp_dict[u'hits'][u'hits'][i][u'_source'][u'{}'.format(query_fields[j])]
                        )
                query_data.update(
                        {str(query_fields[j]):query_temp}
                        )
                #--
        #---
        #
        df=pd.DataFrame(data=query_data)
        #
        if query_sort is True:
            print('query_sort is set to True')
            try:
                df.sort_values(by=['incident-id'],inplace=True)
                print('query_sort passed successfully') 
            except:
                print('exception occured on query_sort')
                traceback.print_exc()
        else:
            print('query_sort is set to False')
        #
        try:
            df.to_csv(str(query_name)+".csv",index=False)
            print('csv generation passed successfully') 
        except:
            print('exception occured on csv generation ')
            traceback.print_exc()
        os.system('chmod 775 ./*')
    #
