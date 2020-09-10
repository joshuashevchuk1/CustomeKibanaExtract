import numpy as np
import pandas as pd
import traceback
import os 
import sys
import json
import shutil
import glob

class Kibana_Extract(object):
    #
    def __init__(self):
        #
        print('||||||||||||||||||||||')
        print('begin initalization')
        print('||||||||||||||||||||||')
        #

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
                query_sort=False,
                discover=True,
                visual=False,
                open_distro=False,
                prod=False,
                fields_parameter=None,
                CustomMarketID=False,
                MetaData_Shell=False,
                Signature_Shell=False,
                Log_Directory=None):
    #
        self.username           = username
        self.password           = password
        self.index_string       = index_string
        self.size               = size
        self.fixed_interval     = fixed_interval
        self.match_string       = match_string
        self.query_name         = query_name
        self.query_time         = query_time
        self.query_fields       = query_fields
        self.query_sort         = query_sort
        self.discover           = discover
        self.visual             = visual
        self.open_distro        = open_distro
        self.prod               = prod
        self.fields_parameter   = fields_parameter
        self.CustomMarketID     = CustomMarketID
        self.MetaData_Shell     = MetaData_Shell
        self.Signature_Shell    = Signature_Shell
        self.Log_Directory      = Log_Directory
        #
        if open_distro is False:
            #
            if prod is False:
                self.curl_string  = "curl -XGET http://" + str(self.username) + ":" +str(self.password) +"@lcf-uat-es-01.isg.directv.com:9200/"+str(self.index_string)+"/_search -H 'Content-Type: application/json'"
            elif prod is True:
                self.curl_string  = "curl -XGET http://" + str(self.username) + ":" +str(self.password) +"@lcf-prod-es-01.isg.directv.com:9200/"+str(self.index_string)+"/_search -H 'Content-Type: application/json'"
                print("accessing production env")
            #
        elif open_distro is True:
            #
            print('======================')
            print('open_distro is '+str(open_distro))
            print('======================')
            #
        fixed_interval_string=""" "{}" """.format(fixed_interval)
        #
        if discover is True:
        #
        #
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
        #
        #
        #
        elif visual is True:
        #
        #
        #   
            if fields_parameter is None:
                fields_parameter= """ "field": "signatureName.keyword","""
            #field_parameter= """ "field": "marketInfo_N1.name_N2.keyword","""
            #field_parameter= """ "field": "marketInfo_N2.name_N2.keyword","""
            #field_parameter= """ "field": "marketInfo_N3.name_N2.keyword","""

            self.query_string = """ -d'{
              "aggs": {
                "2": {
                  "terms": {
                    """+str(fields_parameter)+"""
                    "order": {
                      "_count": "desc"
                    },
                    "size": 5000
                  }
                }
              },
              "size": 0,
              "_source": {
                "excludes": []
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
                  "field": "apglib.apgdb.timestamp",
                  "format": "date_time"
                },
                {
                  "field": "crashTimestamp",
                  "format": "date_time"
                },
                {
                  "field": "enterSleepMode.begin",
                  "format": "date_time"
                },
                {
                  "field": "enterSleepMode.end",
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
                  "field": "signatureClientTimestamp",
                  "format": "date_time"
                },
                {
                  "field": "signatureCollectedTimestamp",
                  "format": "date_time"
                },
                {
                  "field": "signatureTimestamp",
                  "format": "date_time"
                },
                {
                  "field": "swdl.failedTimestamp",
                  "format": "date_time"
                },
                {
                  "field": "vod.downloadEndTime",
                  "format": "date_time"
                },
                {
                  "field": "vod.downloadFailedTime",
                  "format": "date_time"
                },
                {
                  "field": "vod.downloadStartTime",
                  "format": "date_time"
                },
                {
                  "field": "vod.startTime",
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
              }
            }' """
        #
        #
        #

        print('======================')
        print('initalized vars')
        print('======================')
        return username,password
    #
    def curlQuery(self):
        query_name=self.query_name
        query_string=self.query_string
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
        #query_string=self.query_string
        os.system(""" """ + str(curl_string)+ """ """ + str(query_string)+ """ """ + """ | python -m json.tool > """ + str(query_name)+""".json """) 
        f.close()
        print('+++++++++++++++++++++++++++++')
        print('succesfully aquired json file')
        print('+++++++++++++++++++++++++++++')
    #
    #
    def makeQueryCSV_Discover(self):
        #
        query_sort      = self.query_sort
        query_name      = self.query_name
        query_fields    = self.query_fields
        discover        = self.discover
        visual          = self.visual
        CustomMarketID  = self.CustomMarketID
        #
        print(query_name)
        print('CustomMarketID is '+str(CustomMarketID))
        json_file=str(query_name)+".json"
        with open(json_file) as f:
            resp_dict = json.load(f)
        #
        query_data={}
        query_temp=[]
        #
        #---
        #============================================================================================
        if discover is True:
            #
            for j in range(len(query_fields)):
                query_temp=[]
                for i in range(resp_dict[u'hits'][u'total'][u'value']):
                #--
                    if CustomMarketID is True:
                        if query_fields[j] in 'incident-id':
                            query_temp.append(
                                resp_dict[u'hits'][u'hits'][i][u'_source'][u'{}'.format('incident-id')]
                                )
                            query_data.update(
                                {str(query_fields[j]):query_temp}
                                )
                        else:
                            market_temp_split=query_fields[j].split(".")
                            try:
                                query_temp.append(
                                    resp_dict[u'hits'][u'hits'][i][u'_source'][u'{}'.format(market_temp_split[0])][u'{}'.format(market_temp_split[1])]
                                    )
                                query_data.update(
                                        {str(query_fields[j]):query_temp}
                                        )
                            except:
                                #no query data
                                traceback.print_exc()
                                query_data.update(
                                        {str(query_fields[j]):'Missing'}
                                        )
                    else:          
                        query_temp.append(
                            resp_dict[u'hits'][u'hits'][i][u'_source'][u'{}'.format(query_fields[j])]
                            )
                        query_data.update(
                            {str(query_fields[j]):query_temp}
                            )
                    #--
                #---
            #----
            #
            df=pd.DataFrame(data=query_data)
            #
            if query_sort is True:
                print('query_sort is set to True')
                try:
                    df.sort_values(by=['incident-id'],inplace=True)
                    #df.sort_values(by=['signatureDefinitionName'],inplace=True)
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
            #
        #
        elif visual is True:
            print('======================')
            print('<<<< ERROR: visual is '+str(visual)+' >>>>>')
            print('you are trying to make a csv from a discover query')
            print('please use makeQueryCSV_Visual definition')
            print('That is to say replace') 
            print('makeQueryCSV_Discover -> makeQueryCSV_Visual')
            print('change to KibanaRoutine.py')
            print('======================')
            sys.exit()
        #============================================================================================

        os.system('chmod 775 ./*')
    #

    def makeQueryCSV_Visual(self):
        query_sort      = self.query_sort
        query_name      = self.query_name
        query_fields    = self.query_fields
        discover        = self.discover
        visual          = self.visual
        print(query_name)
        json_file=str(query_name)+".json"
        with open(json_file) as f:
            resp_dict = json.load(f)
        #
        query_data={}
        query_temp=[]
        query_visual=['key','doc_count']
        #
        #============================================================================================
        if visual is True:
            print('visual is '+str(visual))
            query_temp=[]
            query_data={}
            for j in range(len(query_visual)):
                query_temp=[]
                for i in range(len(resp_dict[u'aggregations'][u'2'][u'buckets'])):
                      query_temp.append(resp_dict[u'aggregations'][u'2'][u'buckets'][i][u'{}'.format(query_visual[j])])
                #
                # only after the list for all keys and buckets has been created does one go through the visualization
                #
                query_data.update({str(query_visual[j]):query_temp})                
        elif discover is True:
            print('======================')
            print('<<<< ERROR: discover is '+str(discover)+' >>>>>')
            print('you are trying to make a csv from a visual query')
            print('please use makeQueryCSV_Discover definition')
            print('That is to say replace') 
            print('makeQueryCSV_Visual -> makeQueryCSV_Discover')
            print('change to KibanaRoutine.py')
            print('======================')
            sys.exit()
        #============================================================================================
        df=pd.DataFrame(data=query_data)
        df=df.rename(columns={'key':str(query_fields[0])})
        df=df.rename(columns={'doc_count':str(query_fields[1])})
        os.system('chmod 775 ./*')
        #
        if query_sort is True:
            print('query_sort is set to True')
            try:
                df.sort_values(by=['signatureName'],inplace=True,ascending=False)
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

    def LogExtract(self):
        Log_Directory   = self.Log_Directory
        MetaData_Shell  = self.MetaData_Shell
        Signature_Shell = self.Signature_Shell
        print('Running Log Extract')
        Working_Directory=os.getcwd()
        #
        Log_Directory_Path=(os.getcwd()+'/'+str(Log_Directory))
        # copy over shell scripts into the log 
        shutil.copy('./METADATA_TEST.sh',Log_Directory_Path)
        shutil.copy('./Signature_Rule_Test.sh',Log_Directory_Path)
        shutil.copy('./createMostRecentLog.sh',Log_Directory_Path)
        #
        os.chdir(str(Log_Directory_Path))
        os.system('chmod 775 ./*')
        tgz_list=glob.glob("./*.tgz")
        dir_list=next(os.walk('.'))[1]
        #
        if tgz_list == []:
            print('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++')
            print('')
            print('no log files downloaded')
            print('if this is the first time you running the log extraction query')
            print('simply download the chosen files from the csv query') 
            print('and put them into your log directory name '+str(Log_Directory))
            print('')
            print('it should be in the form of incident-id.tgz')
            print('')
            print('once at least one .tgz file is in '+str(Log_Directory))
            print('run KibanaMain.py again and you should have text files in each tar output directory')
            print('')
            print('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++')
            os.chdir(str(Working_Directory))         
        else:
            for index in range(len(tgz_list)):
                    tgz_temp=tgz_list[index].split(".tgz")
                    tgz_temp_string=tgz_temp[0]
                    try:
                        os.mkdir(str(tgz_temp_string))
                    except:
                        print('directory exists named '+str(tgz_temp_string))
                    os.system('chmod 775 ./*')
            for index in range(len(tgz_list)):
                    tgz_temp=tgz_list[index].split(".tgz")
                    tgz_temp_path=tgz_temp[0]
                    tgz_temp_tar=str(tgz_list[index])
                    os.system('tar -xzvf '+str(tgz_temp_tar)+' -C '+str(tgz_temp_path))
            for index in range(len(dir_list)):
                    Log_TarOutput_Path=str(Log_Directory_Path)+'/'+str(dir_list[index])
                    os.chdir(str(Log_TarOutput_Path))
                    os.system('chmod 775 ./*')
                    os.chdir(str(Log_Directory_Path))
                    shutil.copy('./createMostRecentLog.sh',Log_TarOutput_Path)
                    shutil.copy('./METADATA_TEST.sh',Log_TarOutput_Path)
                    shutil.copy('./Signature_Rule_Test.sh',Log_TarOutput_Path)
                    os.chdir(str(Log_TarOutput_Path))
                    os.system('chmod 775 ./*')
                    if MetaData_Shell is True:
                        os.system('./METADATA_TEST.sh > METADATA_TEST.txt')
                        os.system('chmod 775 ./*')
                    if Signature_Shell is True:
                        os.system('./createMostRecentLog.sh')
                        os.system('chmod 775 ./*')
                        os.system('./Signature_Rule_Test.sh > Signature_Rule_Test.txt')
                        os.system('chmod 775 ./*')
                    os.chdir(str(Log_Directory_Path))
            os.chdir(str(Working_Directory)) 
