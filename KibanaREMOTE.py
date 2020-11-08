import KibanaExtractTest as KE
import logging
import traceback
import sys
import os
import configparser
import numpy as np


securityconfig  = configparser.RawConfigParser()
Rawconfigfile   = securityconfig.read('security.cfg')
Scanner_Check   = securityconfig.sections()
username        = securityconfig.get("security","username")
password        = securityconfig.get("security","password")
query_name   = 'output_VISUALSIMPLE'
index_string = 'incident-signature'
curl_string = """curl -XGET https://localhost:9200/test/_search?pretty -H 'Content-Type: application/json'"""
query_string = ''

#os.system(""" """ + str(curl_string)+ """ """ + str(query_string)+ """ """ + """ | python -m json.tool > """ + str(query_name)+""".json """) 
os.system(""" """ + str(curl_string) + """ -u """ +str(username)+""":"""+str(password)+""" --insecure > """+(str(query_name))+""".json""")

#KE=KE.Kibana_Extract()
#KE.getvars(username,password,query_string,query_name,index_string)
#KE.curlQuery()
#KE.makeQueryCSV_SIGNATURE()
