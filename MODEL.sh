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
echo "MODEL IS $MODEL"
