import KibanaExtract as KE
import logging
import traceback
import sys
import os
import configparser
import numpy as np
import ast
import shutil

KE=KE.Kibana_Extract()
def GeneralQuery(configfile):
    global KE
    # intialize options default
    CustomMarketID              = False
    MetaData_Shell              = False
    Signature_Shell             = False
    Skip_Tar                    = False
    Log_Directory               = None
    # get security parameters
    securityconfig              = configparser.RawConfigParser()
    Rawconfigfile               = securityconfig.read('security.cfg')
    Scanner_Check               = securityconfig.sections()
    username                    = securityconfig.get("security","username")
    password                    = securityconfig.get("security","password")
    # get section enabler flags
    Rawconfig                   = configparser.RawConfigParser()
    Rawconfigfile               = Rawconfig.read(str(configfile))
    try:
        query_flag              = Rawconfig.getboolean("section flag enabler","query_flag")   
    except:
        query_flag              = False
        print('------------------------------------------')
        print('no query flag in section flag enabler')
        print('------------------------------------------')
    try:
        query_options_flag      = Rawconfig.getboolean("section flag enabler","query_options_flag")
    except:
        query_options_flag      = False
        print('------------------------------------------')
        print('no query options flag in section flag enabler')
        print('------------------------------------------')
    try:
        query_type_flag         = Rawconfig.getboolean("section flag enabler","query_type_flag")
    except:
        query_type_flag         = False
        print('------------------------------------------')
        print('no query type flag in section flag enabler')
        print('------------------------------------------')
    try:
        fields_options_flag     = Rawconfig.getboolean("section flag enabler","fields_options_flag")
    except:
        fields_options_flag     = False
        print('------------------------------------------')
        print('no fields options flag in section flag enabler')
        print('------------------------------------------')
    try:
        post_query_flag         = Rawconfig.getboolean("section flag enabler","post_query_flag")
    except:
        post_query_flag         = False
        print('------------------------------------------')
        print('no post query flag in section flag enabler')
        print('------------------------------------------')
    #
    if query_flag is True:
        print('query flag is true')
        query_name_list         = ast.literal_eval(Rawconfig.get("query","query_name"))
        query_fields            = ast.literal_eval(Rawconfig.get("query","query_fields"))
        query_time_list         = ast.literal_eval(Rawconfig.get("query","query_time"))
    if query_options_flag is True:
        print('query options flag is true')
        match_string            = """{}""".format(ast.literal_eval(Rawconfig.get("query options","match_string")))
        size                    = Rawconfig.getint("query options","size")
        fixed_interval          = Rawconfig.get("query options","fixed_interval")
        index_string            = Rawconfig.get("query options","index_string")
        query_sort              = Rawconfig.getboolean("query options","query_sort")
    if query_type_flag is True:
        print('query type flag is true')
        discover                = Rawconfig.getboolean("query type","discover")
        visual                  = Rawconfig.getboolean("query type","visual")
        open_distro             = Rawconfig.getboolean("query type","open_distro")
        prod                    = Rawconfig.getboolean("query type","prod")
    if fields_options_flag is True:
        print('fields options flag is true')
        fields_parameter        = Rawconfig.get("fields options","fields_parameter")
        CustomMarketID          = Rawconfig.getboolean("fields options","CustomMarketID")
    if post_query_flag is True:
       print('post query flag is true')
       if 'Log_Extraction_Flag' in Rawconfig['post query']:
           Log_Extraction_Flag = Rawconfig.getboolean("post query","Log_Extraction_Flag")
           if Log_Extraction_Flag is True:
                if 'MetaData_Shell' in Rawconfig['post query']:
                    MetaData_Shell           = Rawconfig.getboolean("post query","MetaData_Shell")
                if 'Signature_Shell' in Rawconfig['post query']:
                    Signature_Shell          = Rawconfig.getboolean("post query","Signature_Shell")
       # set up log extraction folders
                if 'Log_Directory' in  Rawconfig['post query']:
                    Log_Directory = Rawconfig.get("post query","Log_Directory")
                if 'Skip_Tar' in Rawconfig['post query']:
                    Skip_Tar    = Rawconfig.getboolean("post query","Skip_Tar")

    for query_name_index in range(len((query_name_list))):
        KE.getvars(username,
                   password,
                   index_string,
                   size,
                   fixed_interval,
                   match_string,
                   query_name_list[query_name_index],
                   query_time_list[0],
                   query_fields,
                   query_sort,
                   discover,
                   visual,
                   open_distro,
                   prod,
                   fields_parameter,
                   CustomMarketID,
                   MetaData_Shell,
                   Signature_Shell,
                   Log_Directory,
                   Skip_Tar)
        KE.curlQuery()
        if discover is True:
            print(' this is a discover query')
            KE.makeQueryCSV_Discover()
        elif visual is True:
            print(' this is a visual query')
            KE.makeQueryCSV_Visual()
        if Log_Extraction_Flag is True:
           KE.LogExtract() 
