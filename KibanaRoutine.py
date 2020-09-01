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
    securityconfig  = configparser.RawConfigParser()
    Rawconfigfile   = securityconfig.read('security.cfg')
    Scanner_Check   = securityconfig.sections()
    username        = securityconfig.get("security","username")
    password        = securityconfig.get("security","password")
    Rawconfig       = configparser.RawConfigParser()
    Rawconfigfile   = Rawconfig.read(str(configfile))
    query_sort      = Rawconfig.getboolean("query options","query_sort")
    query_name_list = ast.literal_eval(Rawconfig.get("query","query_name"))
    query_fields    = ast.literal_eval(Rawconfig.get("query","query_fields"))
    query_time_list = ast.literal_eval(Rawconfig.get("query","query_time"))
    match_string    = """{}""".format(ast.literal_eval(Rawconfig.get("query options","match_string")))
    size            = Rawconfig.getint("query options","size")
    fixed_interval  = Rawconfig.get("query options","fixed_interval")
    index_string    = Rawconfig.get("query options","index_string")
    discover        = Rawconfig.getboolean("query type","discover")
    visual          = Rawconfig.getboolean("query type","visual")
    open_distro     = Rawconfig.getboolean("query type","open_distro")
    prod            = Rawconfig.getboolean("query type","prod")

    #KE=KE.Kibana_Extract()
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
                   prod)
        KE.curlQuery()
        if discover is True:
            KE.makeQueryCSV_Discover()
        elif visual is True:
            KE.makeQueryCSV_Visual()
