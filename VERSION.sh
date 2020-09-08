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

echo "==============="
echo ""
echo "VERSION is $VERSION"
echo ""
echo "==============="

