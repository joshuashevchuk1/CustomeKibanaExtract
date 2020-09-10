import KibanaRoutine as KR
import logging
import traceback
import sys
import os
import configparser
import ast
import json

def Query_Test(configList,configSetName):
    print('|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||')
    print('===================================================================================')
    print('Running '+str(configSetName)+' Test set')
    print('===================================================================================')
    for configfile in range(len(configList)):
        print('-------------------------------------------------------')
        print('getting query data for '+str(configList[configfile]))
        print('-------------------------------------------------------')
        KR.GeneralQuery(configList[configfile])
    print('===================================================================================')
    print('|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||')

MainConfig               = configparser.RawConfigParser()
Rawconfigfile            = MainConfig.read('Main.cfg')
Multiple_Rules           = ast.literal_eval(MainConfig.get("main","Multiple Rules"))
Custom_Filters           = ast.literal_eval(MainConfig.get("main","Custom Filters"))
Multiple_Def_PRE_QA      = ast.literal_eval(MainConfig.get("main","Multiple PREQA"))
Multiple_Def_SIG_QA      = ast.literal_eval(MainConfig.get("main","Multiple SIGQA"))
Multiple_Def_PRE_QA_PROD = ast.literal_eval(MainConfig.get("main","Multiple PREQAPROD"))
Multiple_Def_SIG_QA_PROD = ast.literal_eval(MainConfig.get("main","Multiple SIGQAPROD"))
Multiple_MN              = ast.literal_eval(MainConfig.get("main","Multiple MN"))
Multiple_Def_META_QA     = ast.literal_eval(MainConfig.get("main","Multiple METAQA"))
Kibana_Config            = ast.literal_eval(MainConfig.get("main","Kibana Config"))
Getter_Logs              = ast.literal_eval(MainConfig.get("main","Getter Logs"))

ConfigSets={'Kibana Config':Kibana_Config,
            'Multiple Rules':Multiple_Rules,
            'Custom Filters':Custom_Filters,
            'Multiple Def PRE QA':Multiple_Def_PRE_QA,
            'Multiple Def SIG QA':Multiple_Def_SIG_QA,
            'Multiple Def PRE QA PROD':Multiple_Def_PRE_QA_PROD,
            'Multiple Def SIG QA PROD':Multiple_Def_SIG_QA_PROD,
            'Multiple MN':Multiple_MN,
            'Multiple Def META QA':Multiple_Def_META_QA,
            'Getter Logs':Getter_Logs}

#
#   Uncomment to decide which test suite to use
#
#Query_Test(ConfigSets['Kibana Config'],'Kibana Config')
#Query_Test(ConfigSets['Multiple Rules'],'Multiple Rules')
#Query_Test(ConfigSets['Custom Filters'],'Custom Filters')
#Query_Test(ConfigSets['Multiple Def SIG QA'],'Multiple Def Sig QA')
#Query_Test(ConfigSets['Multiple Def PRE QA'],'Multiple Def Pre QA')
#Query_Test(ConfigSets['Multiple Def SIG QA PROD'],'Multiple Def Sig QA PROD')
#Query_Test(ConfigSets['Multiple Def PRE QA PROD'],'Multiple Def Pre QA PROD')
#Query_Test(ConfigSets['Multiple MN'],'Multiple MN')
#Query_Test(ConfigSets['Multiple Def META QA'],'Multiple Def META QA')
Query_Test(ConfigSets['Getter Logs'],'Getter Logs')
