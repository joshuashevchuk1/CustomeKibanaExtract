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

# TRANSCODING on?
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
echo "IS_TRANSCODING_ON is $IS_TRANSCODING_ON"
echo "TRANSCODING_LINES is $TRANSCODING_LINES"
