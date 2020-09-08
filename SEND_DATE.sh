if [ "$VERSION" == "" ]; then
#
	    export VERSION_FILE=`find -name "VERSIONS.TXT"`
	    echo ">> $VERSION_FILE, pwd=$PWD"
	    if [ "$VERSION_FILE" != "" ]; then
		export VERSION=`grep --binary-files=text -m 1 IMAGE $VERSION_FILE | sed -s "s/ *//g" | cut -d ':' -f 2 2> /dev/null`
	    fi
#
fi

if [ "$CELOG_WATCHDOG" == "TRUE" ]; then
#
	    # Check error
	    checkErrorInLog
	    if [ $? != 0 ]; then
		echo ">> $PWD >> checkErrorInLog error. Do not look in log for send date."
	    else
		# TD-3235 mtischler : Changing send date extraction to prevent busy-wait hangs on missing timestamps
		# DAM-1036 We used to get 1 single messages.log in watchdog report. Now, we get 3 separate files.
		export SEND_DATE=`grep --binary-files=text DTV_WATCHDOG_REBOOT messages.log* | tail -n 1 | awk '/^([^:]+:)?[A-Z][a-z][a-z][ \t]+[0-9]+[ \t]+[0-9]+:[0-9]+:[0-9]+[ \t]+/{if (match($0,"^([^:]+:)?([A-Z][a-z][a-z][ \t]+[0-9]+[ \t]+[0-9]+:[0-9]+:[0-9]+)[ \t]+",matcharr)>0) {print ENVIRON["YEAR"]" "matcharr[2]}}' `
	    fi
#
fi

if [ -e $FULL_FILE_PATH ] && [ "$SEND_DATE" == "" ]; then
#
	ACTUAL_DATE=`date -u -r $FULL_FILE_PATH "+%b %d %R:%S"`
	echo ">> $PWD >> Update the SEND_DATE from $SEND_DATE to $ACTUAL_DATE"
	export SEND_DATE=`echo $ACTUAL_DATE | sed -e "s/.*\([a-zA-Z][a-zA-Z][a-zA-Z] [0-9]* [0-2][0-9]:[0-5][0-9]:[0-5][0-9]\).*/$YEAR \1/" `
    fi

    if [ "$SEND_DATE" == "" ]; then
	SEND_DATE=`date -u "+%b %d %R:%S" | sed -e "s/.*\([a-zA-Z][a-zA-Z][a-zA-Z] [0-9]* [0-2][0-9]:[0-5][0-9]:[0-5][0-9]\).*/$YEAR \1/" `
#
fi

echo "==============="
echo ""
echo "SEND_DATE is $SEND_DATE"
echo ""
echo "==============="
