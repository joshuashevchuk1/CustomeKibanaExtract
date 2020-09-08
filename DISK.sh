export DISK=
    if [ -e dms_data/dmsinfo.dat ]; then
	export DISK=`grep --binary-files=text -a diskType dms_data/dmsinfo.dat | cut -d '=' -f 2`
    fi

    echo ""
    echo "DISK is $DISK"
    echo ""
