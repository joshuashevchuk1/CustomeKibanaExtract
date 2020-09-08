export SUBMODEL=`grep --binary-files=text -a SubModel ./versioninformation.txt | cut -f 2 -d ":" 2> /dev/null`
	#LOG_HOSTNAME
	export LOG_HOSTNAME=`grep --binary-files=text DIRECTV ./network/hosts.txt | sed 's/.*\(DIR.*\)/\1/'`
	if [ "$LOG_HOSTNAME" == "" ]; then
		export LOG_HOSTNAME=`grep --binary-files=text DIRECTV hosts.txt | sed 's/.*\(DIR.*\)/\1/'`
	fi

echo ""
echo "SUBMODEL is $SUBMODEL"
echo ""
