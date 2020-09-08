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
echo "RID_NUMBER is $RID_NUMBER"
