#LOG_HOSTNAME
	export LOG_HOSTNAME=`grep --binary-files=text DIRECTV ./network/hosts.txt | sed 's/.*\(DIR.*\)/\1/'`
	if [ "$LOG_HOSTNAME" == "" ]; then
		export LOG_HOSTNAME=`grep --binary-files=text DIRECTV hosts.txt | sed 's/.*\(DIR.*\)/\1/'`
	fi
	#LOG_HOSTNAME
	export LOG_HOSTNAME=`grep --binary-files=text DIRECTV ./network/hosts.txt | sed 's/.*\(DIR.*\)/\1/'`
	if [ "$LOG_HOSTNAME" == "" ]; then
		export LOG_HOSTNAME=`grep --binary-files=text DIRECTV hosts.txt | sed 's/.*\(DIR.*\)/\1/'`
	fi
