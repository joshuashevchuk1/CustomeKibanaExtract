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

    echo ""
    echo "IS_NATIONAL is $IS_NATIONAL"
    echo ""
