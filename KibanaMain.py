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

ConfigSets={'Multiple Rules':Multiple_Rules,
            'Custom Filters':Custom_Filters,
            'Multiple Def PRE QA':Multiple_Def_PRE_QA,
            'Multiple Def SIG QA':Multiple_Def_SIG_QA,
            'Multiple Def PRE QA PROD':Multiple_Def_PRE_QA_PROD,
            'Multiple Def SIG QA PROD':Multiple_Def_SIG_QA_PROD}

#Query_Test(ConfigSets['Multiple Rules'],'Multiple Rules')
#Query_Test(ConfigSets['Custom Filters'],'Custom Filters')
Query_Test(ConfigSets['Multiple Def SIG QA'],'Multiple Def Sig QA')
Query_Test(ConfigSets['Multiple Def PRE QA'],'Multiple Def Pre QA')
Query_Test(ConfigSets['Multiple Def SIG QA PROD'],'Multiple Def Sig QA PROD')
Query_Test(ConfigSets['Multiple Def PRE QA PROD'],'Multiple Def Pre QA PROD')
