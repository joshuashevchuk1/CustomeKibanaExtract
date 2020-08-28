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
                query_string,
                query_name,
                index_string):
        #
        self.username=username
        self.password=password
        self.query_name=query_name
        self.index_string=index_string
        #
        self.curl_string  = "curl -XGET http://" + str(self.username) + ":" +str(self.password) + "@lcf-uat-es-01.isg.directv.com:9200/"+str(self.index_string)+"/_search -H 'Content-Type: application/json'"
        #
        self.query_string=query_string
        print('======================')
        print('initalized vars')
        print(query_name)
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
