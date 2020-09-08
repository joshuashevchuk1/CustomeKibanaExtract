##!/bin/bash
#========================================================================================================
MSG= "$@"
echo "MSG=$MSG"

ROLL_OVER_LOGS=`find -name "messages.*log*" | sort | grep -v Logs | grep -E "messages.log.|backup"`
LAST_MSG_LOG=
if [ `find -name 'messages.log' | wc -l 2>/dev/null` -gt 0 ]; then
        LAST_MSG_LOG=`find -name 'messages.log' | xargs ls -tr | grep -v Logs`
fi

if [ "$ROLL_OVER_LOGS" != "" ]; then
        MSG=`echo -e "$ROLL_OVER_LOGS\n$LAST_MSG_LOG"`
else
        MSG=$LAST_MSG_LOG
fi

# get_info
#========================================================================================================
#
# order should be msg -> roll_over_logs -> version -> model -> submodel(if needed) -> stb_model -> stb_project
#
#========================================================================================================
#===========================================================================================
#-------------------------------------------------------------------------------------------
#
# VERSION
#

#Version
        #parse_system_detail_log VERSION\ INFORMATION <-- expects function parse_system_detail_log
        export VERSION=`echo $RESULT`
        #
        if [ "$VERSION" == "" ]; then
            export VERSION_FILE=`find -name "VERSION.TXT"`
            echo ">> $VERSION_FILE, pwd=$PWD"
            if [ "$VERSION_FILE" != "" ]; then
                export VERSION=`cat $VERSION_FILE 2> /dev/null`
            fi
        fi
        #
        if [ "$VERSION" == "" ]; then
            export VERSION_FILE=`find -name "VERSIONS.TXT"`
            echo ">> $VERSION_FILE, pwd=$PWD"
            if [ "$VERSION_FILE" != "" ]; then
                export VERSION=`grep --binary-files=text -m 1 IMAGE $VERSION_FILE | sed -s "s/ *//g" | cut -d ':' -f 2 2> /dev/null`
            fi
        fi
        #
        #Version
        VERSION_FILE=`find -name "VERSION.TXT"`
        echo ">> $VERSION_FILE, pwd=$PWD"
        if [ "$VERSION_FILE" != "" ]; then
        #
                VERSION=`cat $VERSION_FILE 2> /dev/null`
                # TD-2547 some STB have more then one file under VERSION_FILE
                # Only take the one that starts with vXbXXXX_XXXX
                for VERSION_LINE in $VERSION
                do
                        if [[ $VERSION_LINE =~ ^v\d*_* ]]; then
                        VERSION=$VERSION_LINE
                        break
                        fi
                done
        #
        elif [[ -n $(find -name "*mode.out") ]]; then
            export VERSION_FILE=`find -name "*mode.out"`
            echo ">> $VERSION_FILE, pwd=$PWD"
            if [ "$VERSION_FILE" != "" ]; then
                        VERSION=`grep --binary-files=text image_version $VERSION_FILE | tail -n 1 | sed -s "s/ *//g" | cut -d '=' -f 2 2> /dev/null`
            fi
        #
        else

         VERSION=""
        fi

        export VERSION
        if [ "$VERSION" == "" ]; then
        #
            export VERSION_FILE=`find -name "VERSIONS.TXT"`
            echo ">> $VERSION_FILE, pwd=$PWD"
            if [ "$VERSION_FILE" != "" ]; then
                export VERSION=`grep --binary-files=text -m 1 IMAGE $VERSION_FILE | sed -s "s/ *//g" | cut -d ':' -f 2 2> /dev/null`
            fi
        #
        fi

#-------------------------------------------------------------------------------------------
#===========================================================================================
#-------------------------------------------------------------------------------------------
#
#   ZIPCODE
#

# DAM-1614  Zipcode is now in its own file
    ZIPCODE_FILE=`find -name zipcode.txt | head -n 1`
    if [ "$ZIPCODE_FILE" != "" ]; then
        echo ">> $PWD >> Found $ZIPCODE_FILE"
        export ZIPCODE=`cat $ZIPCODE_FILE | tr -d '\001'-'\011''\013''\014''\016'-'\037''\200'-'\377'`
    else
        export ZIPCODE=`grep --binary-files=text -m 1 "ZIP code =" $MSG | head -n 1 | sed -s "s/.*ZIP code = \([0-9]*\).*/\1/"`
    fi

    if [ $ZIPCODE -ne $ZIPCODE 2> /dev/null ] || [ "$ZIPCODE" == "null00000" ] ; then
            export ZIPCODE=0
    fi

#-------------------------------------------------------------------------------------------
#===========================================================================================
#-------------------------------------------------------------------------------------------
#
# REC_COUNT
#

export REC_COUNT=
    if [ -e recordings.txt ]; then
        export REC_COUNT=`grep --binary-files=text root recordings.txt | grep -v Cptr | wc -l`
    fi

    if [ "$DISK_SIZE" == "" ]; then
        export DISK_SIZE=0
    fi

    if [ "$REC_COUNT" == "" ]; then
        export REC_COUNT=0
    fi

#-------------------------------------------------------------------------------------------
#===========================================================================================
#-------------------------------------------------------------------------------------------
#
# MODEL
#
#Model
        #parse_system_detail_log MODEL\ INFORMATION <-- requires function parse_system_detail
        export MODEL=`echo $RESULT|cut -d ' ' -f 1`
        export SUBMODEL=`echo $RESULT|cut -d ' ' -f 2`

        if [ "$MODEL" == "" ]; then
            export MODEL_FILE=`find -name "*mode.txt"`
            echo ">> $MODEL_FILE, pwd=$PWD"
            if [ "$MODEL_FILE" != "" ]; then
                export MODEL=`cat $MODEL_FILE | head -n 1 | cut -f 1 -d " " 2> /dev/null`
            fi
        fi

#Model
        export MODEL_FILE=`find -name "mode.txt"`
        echo ">> $MODEL_FILE, pwd=$PWD"
        if [ "$MODEL_FILE" != "" ]; then
            export MODEL=`cat $MODEL_FILE | head -n 1 | cut -f 1 -d " " 2> /dev/null`
        else
            export MODEL=
        fi

        if [ "$MODEL" == "" ]; then
            export MODEL_FILE=`find -name "*mode.out"`
            echo ">> $MODEL_FILE, pwd=$PWD"
            if [ "$MODEL_FILE" != "" ]; then
                export MODEL=`cat $MODEL_FILE | grep "getmode.sh -m" | head -n 1 | sed -s "s/ *//g" | cut -f 2 -d "=" 2> /dev/null`
                        if [ "$MODEL" == "" ]; then
                                export MODEL=`cat $MODEL_FILE | grep "extmodel" | head -n 1 | sed -s "s/ *//g" | cut -f 2 -d "=" 2> /dev/null`
                                export MODEL="$MODEL$UNDERSCORE`cat $MODEL_FILE | grep "manufacturer" | head -n 1 | sed -s "s/ *//g" | cut -f 2 -d "=" 2> /dev/null`"
                                export MODEL="$MODEL$UNDERSCORE`cat $MODEL_FILE | grep "image_mode" | head -n 1 | sed -s "s/ *//g" | cut -f 2 -d "=" 2> /dev/null`"
                        fi
            fi
        fi

#-------------------------------------------------------------------------------------------
#===========================================================================================
#-------------------------------------------------------------------------------------------
#
# STB_PROJECT
#
STB_MODEL=`echo $MODEL|cut -d '_' -f 1`
export STB_PROJECT=
    case $STB_MODEL in
     "lh26")
	export STB_PROJECT=dtvla
	 ;;
     "lh27")
	export STB_PROJECT=dtvla
	 ;;
     "lhr21")
	export STB_PROJECT=dtvla
	 ;;
     "lhr22")
	export STB_PROJECT=dtvla
	 ;;
     "lhr26")
	export STB_PROJECT=dtvla
	 ;;
     "lhr27")
	export STB_PROJECT=dtvla
	 ;;
     "lhr44")
	export STB_PROJECT=dtvla
	 ;;
     "lh44")
	export STB_PROJECT=dtvla
	 ;;
     "sbhr21")
	export STB_PROJECT=dtvla
	 ;;
     "sbh25")
	export STB_PROJECT=dtvla
	 ;;
     "shr25")
	export STB_PROJECT=dtvla
	 ;;
     "shr26")
	export STB_PROJECT=dtvla
	 ;;
     "shr44")
	export STB_PROJECT=dtvla
	 ;;
     "smhr21")
	export STB_PROJECT=dtvla
	 ;;
     "smh25")
	export STB_PROJECT=dtvla
	 ;;
     "smh26")
	export STB_PROJECT=dtvla
	 ;;
     "hmc30")
	export STB_PROJECT=hmc
	 ;;
     "hr34")
	export STB_PROJECT=hmc
	     ;;
     "hr44")
	export STB_PROJECT=hmc
	     ;;
     "h44")
		if [ "$VERSION" != "" ] && [[ "$VERSION" < "v1b2622" ]]; then
			export STB_PROJECT=porting
		else
			export STB_PROJECT=hmc
		fi
	     ;;
     "hr54")
		if [ "$VERSION" != "" ] && [[ "$VERSION" < "v1b2516" ]]; then
			export STB_PROJECT=porting
		else
			export STB_PROJECT=hmc
		fi
	     ;;
      "hs17")
        if [ "$VERSION" != "" ] && [[ "$VERSION" < "v1b3300" ]]; then
                export STB_PROJECT=porting
        else
                export STB_PROJECT=hmc
        fi
    	;;
	 "hs28")
		export STB_PROJECT=porting
    	;;
        "sh01")
		export STB_PROJECT=porting
    	;;
	esac	
     if [ "$STB_PROJECT" == "" ]; then
	export STB_PROJECT=hddvr
     fi

#-------------------------------------------------------------------------------------------
#===========================================================================================
#-------------------------------------------------------------------------------------------
#
# LOG_HOSTNAME
#

#LOG_HOSTNAME
        export LOG_HOSTNAME=`grep --binary-files=text DIRECTV ./network/hosts.txt | sed 's/.*\(DIR.*\)/\1/'`
        if [ "$LOG_HOSTNAME" == "" ]; then
                export LOG_HOSTNAME=`grep --binary-files=text DIRECTV hosts.txt | sed 's/.*\(DIR.*\)/\1/'`
        fi
        #LOG_HOSTNAME
        export LOG_HOSTNAME=`grep --binary-files=text DIRECTV ./network/hosts.txt | sed 's/.*\(DIR.*\)/\1/'`
        if [ "$LOG_HOSTNAME" == "" ]; then
                export LOG_HOSTNAME=`grep --binary-files=text DIRECTV hosts.txt | sed 's/.*\(DIR.*\)/\1/'`
        fi

#-------------------------------------------------------------------------------------------
#===========================================================================================
#-------------------------------------------------------------------------------------------
#
# RID_NUMBER
#

# RID

    if [ "$PARSE_GETTER_FULL_PATH" != "" ]; then
        export RID_NUMBER=`grep RID\ Number TDSysConfig.txt | cut -d '=' -f 2 | sed -e "s/  *//" | uniq | head -n 1`
    else
        export RID_NUMBER=`grep --binary-files=text RID stb_info.txt | cut -d ':' -f 2`
    fi
    if [ "$RID_NUMBER" == "" ]; then
                export RID_NUMBER=`grep --binary-files=text rid mode_all.txt | sed -e "s/ *//g" | cut -d '=' -f 2`
    fi
        # Skipping the bad box from NEL. HDDVR-40999
    if [ "$RID_NUMBER" == "023173092711" ]; then
                echo ">> $PWD >> We have been asked to skip RID=$RID_NUMBER.  Skip this one."
                storeLastFileName
                return 0;
    fi
echo ">> Log ID=$DB_LOG_ID, Log Type=$DB_LOG_TYPE, CELOG=$CELOG, CELOG_WATCHDOG=$CELOG_WATCHDOG, GETTER=$GETTER"

#-------------------------------------------------------------------------------------------
#===========================================================================================
#-------------------------------------------------------------------------------------------
#
# SUBMODEL
#

export SUBMODEL=`grep --binary-files=text -a SubModel ./versioninformation.txt | cut -f 2 -d ":" 2> /dev/null`
        #LOG_HOSTNAME
        export LOG_HOSTNAME=`grep --binary-files=text DIRECTV ./network/hosts.txt | sed 's/.*\(DIR.*\)/\1/'`
        if [ "$LOG_HOSTNAME" == "" ]; then
                export LOG_HOSTNAME=`grep --binary-files=text DIRECTV hosts.txt | sed 's/.*\(DIR.*\)/\1/'`
        fi

#-------------------------------------------------------------------------------------------
#===========================================================================================
#-------------------------------------------------------------------------------------------
#
# IS_MRV_ON
#

# MRV on?
    MRV_FILE=`find -name "aplDump.txt" | head -n 1`
    export IS_MRV_ON=false
    if [ "$MRV_FILE" != "" ]; then
        MRV_LINES=`cat $MRV_FILE | wc -l`
    elif [ "$MSG" != "" ]; then
        MRV_LINES=`grep --binary-files=text AGPLHolder $MSG | wc -l`
    fi

    if [ "$MRV_LINES" != "" ] && [ $MRV_LINES -gt 3 ]; then
        export IS_MRV_ON=true
    fi

#-------------------------------------------------------------------------------------------
#===========================================================================================
#-------------------------------------------------------------------------------------------
#
# TRANSCODING on?
#
#
        IS_TRANSCODING_ON=false

if [ "$MSG" != "" ]; then
                TRANSCODING_LINES=`grep "transfer\:\ next\ chunk" $MSG | wc -l`
        fi

        echo "TRANSCODING_LINES=$TRANSCODING_LINES"
        echo "MSG is $MSG"

if [ "$TRANSCODING_LINES" != "" ] && [ $TRANSCODING_LINES -gt 3 ]; then
           IS_TRANSCODING_ON=true
        fi

        export IS_TRANSCODING_ON;

export IS_TRANSCODING_ON;
if [ "$CELOG_WATCHDOG" == "TRUE" ] || [ "$CELOG_PREFIX" == "celog" ]; then
        REBOOT_AT_START_UP=`echo $SEND_DATE | grep "Jan 1 0"`
        if [ "$REBOOT_AT_START_UP" != "" ]; then
            SEND_DATE=
        fi
fi

echo ""
echo ">> Log ID=$DB_LOG_ID, Log Type=$DB_LOG_TYPE, CELOG=$CELOG, CELOG_WATCHDOG=$CELOG_WATCHDOG, GETTER=$GETTER"
echo ""

#-------------------------------------------------------------------------------------------
#===========================================================================================
#-------------------------------------------------------------------------------------------
#
# IS_NATIONAL
#

DRUID_PROPERTIES=druid.properties
    ULIMIT_TXT_FULLCORE=
    if [ -e  ulimit.txt.fullcore.prevboot ]; then
        ULIMIT_TXT_FULLCORE=ulimit.txt.fullcore.prevboot
    elif [ -e ulimit.txt.fullcore ]; then
        ULIMIT_TXT_FULLCORE=ulimit.txt.fullcore
    fi
    ACCESS_LEVEL_FIELD=powerToolsAccessLevels
        if [ "$STB_PROJECT" == "hmc" ] || [ "$STB_PROJECT" == "porting" ]; then
                ACCESS_LEVEL_FIELD=powerToolsAccessValue
        fi
    export IS_NATIONAL=FALSE
    echo -n "checking user access level..."
    USER_ACCESS_LEVEL=`grep --binary-files=text "^${ACCESS_LEVEL_FIELD}=" $DRUID_PROPERTIES | cut -f2 -d'=' 2>/dev/null`
    if [ $((USER_ACCESS_LEVEL & 3)) -gt 0 ]; then
            echo -n "valid access level (${USER_ACCESS_LEVEL})..."
    elif [ "$ULIMIT_TXT_FULLCORE" != "" ]; then
            export IS_NATIONAL=FALSE
    else
            echo "insufficient access level (${USER_ACCESS_LEVEL}), this must be from national release"
            export IS_NATIONAL=TRUE
    fi

#-------------------------------------------------------------------------------------------
#===========================================================================================
#-------------------------------------------------------------------------------------------
#
# DISK/DISK_SIZE
#

export DISK=
    if [ -e dms_data/dmsinfo.dat ]; then
        export DISK=`grep --binary-files=text -a diskType dms_data/dmsinfo.dat | cut -d '=' -f 2`
    fi

export DISK_SIZE=
    if [ -e dms_data/hardDisk.dat ]; then
        export DISK_SIZE=`grep --binary-files=text -a hardDiskSize dms_data/hardDisk.dat | cut -d '=' -f 2`
    fi

  if [ "$DISK_SIZE" == "" ]; then
        export DISK_SIZE=0
    fi

#-------------------------------------------------------------------------------------------
#===========================================================================================
#-------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------
#                                               SEND_DATE
#-------------------------------------------------------------------------------------------
    export YEAR=`date +%Y`
    GETTER=FALSE
    DETAIL=`find -name 'SYSTEM-DETAIL-LOG*'`
    if [ "$DETAIL" != "" ]; then
        GETTER=TRUE
    else
        GETTER=
    fi

    if [ "$GETTER" != "" ]; then
        export SEND_DATE=`grep --binary-files=text STRESS_TEST_MSG messages.log* | tail -n 1 | awk '/^([^:]+:)?[A-Z][a-z][a-z][ \t]+[0-9]+[ \t]+[0-9]+:[0-9]+:[0-9]+[ \t]+/{if (match($0,"^([^:]+:)?([A-Z][a-z][a-z][ \t]+[0-9]+[ \t]+[0-9]+:[0-9]+:[0-9]+)[ \t]+",matcharr)>0) {print ENVIRON["YEAR"]" "matcharr[2]}}' `
    else
        # TD-3235 mtischler : Changing send date extraction to prevent busy-wait hangs on missing timestamps
        # Send Date
        export SEND_DATE=`grep --binary-files=text SendReport messages.log* | tail -n 1 | awk '/^([^:]+:)?[A-Z][a-z][a-z][ \t]+[0-9]+[ \t]+[0-9]+:[0-9]+:[0-9]+[ \t]+/{if (match($0,"^([^:]+:)?([A-Z][a-z][a-z][ \t]+[0-9]+[ \t]+[0-9]+:[0-9]+:[0-9]+)[ \t]+",matcharr)>0) {print ENVIRON["YEAR"]" "matcharr[2]}}' `
    fi

    if [ "$SEND_DATE" == "" ]; then
        SEND_DATE=`date -u "+%b %d %R:%S" | sed -e "s/.*\([a-zA-Z][a-zA-Z][a-zA-Z] [0-9]* [0-2][0-9]:[0-5][0-9]:[0-5][0-9]\).*/$YEAR \1/" `
    fi

#-------------------------------------------------------------------------------------------
#===========================================================================================
#-------------------------------------------------------------------------------------------
#
#   ECHO STATEMENTS
#
    echo ""
    echo "==============="
    echo ""
    echo "ZIPCODE is $ZIPCODE"
    echo "VERSION is $VERSION"
    echo "SEND_DATE is $SEND_DATE"
    echo "REC_COUNT is $REC_COUNT"
    echo "LOG_HOSTNAME is $LOG_HOSTNAME"
    echo "RID_NUMBER is $RID_NUMBER"
    echo "STB_PROJECT is $STB_PROJECT"
    echo "STB_MODEL IS $STB_MODEL"
    echo "SUBMODEL is $SUBMODEL"
    echo "IS_MRV_ON is $IS_MRV_ON"
    echo "IS_TRANSCODING_ON is $IS_TRANSCODING_ON"
    echo "IS_NATIONAL is $IS_NATIONAL"
    echo "DISK is $DISK"
    echo "DISK_SIZE is $DISK_SIZE"
    echo ""
    echo "==============="

#LOGFILE=${PWD##*/}
#echo Y,$LOGFILE,$VERSION,$MODEL,$SUBMODEL,$STB_PROJECT,$IS_MRV_ON,$IS_TRANSCODING_ON,$ZIPCODE,$LOG_HOSTNAME,$DISK,$DISK_SIZE,$REC_COUNT,$RID_NUMBER,$IS_NATIONAL > ${SCRIPT_PATH}/RESULT

#-------------------------------------------------------------------------------------------
#===========================================================================================
