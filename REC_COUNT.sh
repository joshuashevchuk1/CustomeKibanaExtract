export REC_COUNT=
    if [ -e recordings.txt ]; then
	export REC_COUNT=`grep --binary-files=text root recordings.txt | grep -v Cptr | wc -l`
    fi

    if [ "$DISK_SIZE" == "" ]; then
	export DISK_SIZE=0
    fi

    if [ "$REC_COUNT" == "" ]; then
	export REC_COUNT=0
    fi

    echo ""
    echo "REC_COUNT is $REC_COUNT"
    echo ""
