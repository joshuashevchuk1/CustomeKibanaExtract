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
curl_string  = "curl -XGET http://" + str(username) + ":" +str(password) + "@lcf-uat-es-01.isg.directv.com:9200/"+str(index_string)+"/_search -H 'Content-Type: application/json'"
query_string = """ -d'{
  "aggs": {
    "2": {
      "terms": {
        "field": "signatureName.keyword",
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
        {
          "match_all": {}
        },
        {
          "bool": {
            "minimum_should_match": 1,
            "should": [
              {
                "match_phrase": {
                  "signatureDefinitionName.keyword": "extract_common_signatures"
                }
              },
              {
                "match_phrase": {
                  "signatureDefinitionName.keyword": "QA_extract_common_signatures_MULTIPLERULES"
                }
              }
            ]
          }
        },
        {
          "range": {
            "zipTimestamp": {
              "format": "strict_date_optional_time",
              "gte": "2020-08-01T12:00:00.000Z",
              "lte": "2020-08-01T13:00:00.000Z"
            }
          }
        }
      ],
      "should": [],
      "must_not": []
    }
  }
      }' """

KE=KE.Kibana_Extract()
KE.getvars(username,password,query_string,query_name,index_string)
KE.curlQuery()
#KE.makeQueryCSV_SIGNATURE()
