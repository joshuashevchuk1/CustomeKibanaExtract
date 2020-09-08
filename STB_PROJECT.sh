
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

	echo""
	echo""

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



STB_MODEL=`echo $MODEL|cut -d '_' -f 1`

echo "======"
echo "check"
echo "STB_MODEL is $STB_MODEL"
echo "version is $VERSION"
echo "======"

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
	if [ "$VERSION" != "" ] && [[ "$VERSION" < "v1b2622" ]]; then
			export STB_PROJECT=porting
		else
			export STB_PROJECT=hmc
		fi

     if [ "$STB_PROJECT" == "" ]; then
	export STB_PROJECT=hddvr
     fi

     echo ""
     echo "STB_PROJECT is $STB_PROJECT"
     echo "STB_MODEL is $STB_MODEL"
     echo "MODEL is $MODEL"
     echo "VERSION is $VERSION"
     echo ""
