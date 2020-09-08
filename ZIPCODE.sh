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

    echo "$ZIPCODE"
