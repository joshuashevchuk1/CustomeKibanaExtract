import KibanaExtract as KE
import logging
import traceback
import sys
import os
import configparser
import numpy as np
import ast

KE=KE.Kibana_Extract()
def GeneralQuery(configfile):
    global KE
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
        print('no query flag in section flag enabler')
    try:
        query_options_flag      = Rawconfig.getboolean("section flag enabler","query_options_flag")
    except:
        query_options_flag      = False
        print('no query options flag in section flag enabler')
    try:
        query_type_flag             = Rawconfig.getboolean("section flag enabler","query_type_flag")
    except:
        query_type_flag         = False
        print('no query type flag in section flag enabler')
    try:
        fields_options_flag         = Rawconfig.getboolean("section flag enabler","fields_options_flag")
    except:
        print('no fields options flag in section flag enabler')
    #
    if query_flag is True:
        query_name_list         = ast.literal_eval(Rawconfig.get("query","query_name"))
        query_fields            = ast.literal_eval(Rawconfig.get("query","query_fields"))
        query_time_list         = ast.literal_eval(Rawconfig.get("query","query_time"))
    if query_options_flag is True: 
        match_string            = """{}""".format(ast.literal_eval(Rawconfig.get("query options","match_string")))
        size                    = Rawconfig.getint("query options","size")
        fixed_interval          = Rawconfig.get("query options","fixed_interval")
        index_string            = Rawconfig.get("query options","index_string")
        query_sort              = Rawconfig.getboolean("query options","query_sort")
    if query_type_flag is True:
        discover                = Rawconfig.getboolean("query type","discover")
        visual                  = Rawconfig.getboolean("query type","visual")
        open_distro             = Rawconfig.getboolean("query type","open_distro")
        prod                    = Rawconfig.getboolean("query type","prod")
    if fields_options_flag is True:
        print('fields options flag is true')
        fields_parameter        = Rawconfig.get("fields options","fields_parameter")
        CustomMarketID          = Rawconfig.getboolean("fields options","CustomMarketID")
    else: 
        CustomMarketID         = False
    #
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
                   CustomMarketID)
        KE.curlQuery()
        if discover is True:
            print(' this is a discover query')
            KE.makeQueryCSV_Discover()
        elif visual is True:
            print(' this is a visual query')
            KE.makeQueryCSV_Visual()
