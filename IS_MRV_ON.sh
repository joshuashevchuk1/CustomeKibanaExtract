#========================================================================================================
MSG="$@"
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

    echo ""
    echo "IS_MRV_ON is $IS_MRV_ON"
    echo ""	
