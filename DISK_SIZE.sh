 export DISK_SIZE=
    if [ -e dms_data/hardDisk.dat ]; then
	export DISK_SIZE=`grep --binary-files=text -a hardDiskSize dms_data/hardDisk.dat | cut -d '=' -f 2`
    fi

  if [ "$DISK_SIZE" == "" ]; then
	export DISK_SIZE=0
    fi

    echo ""
    echo "DISK_SIZE is $DISK_SIZE"
    echo ""
