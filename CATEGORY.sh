
function extractCategory {


 REBOOT_STRING="klogd\|IMAGE VERSION"
 KLOGD=$(grep "$REBOOT_STRING" LOGS_BEFORE_FIRST_REBOOT)

 $(grep watchdog ls_tmp.txt|rev|cut -d" " -f1|rev|cut -dg -f2- > processes_involved.csv)

 PROCESS_INVOLVED_HAS_MEMRESET=$(grep -m 1 "MemReset" processes_involved.csv | wc -l)

 IS_SOFTRESET=$(grep softReset ls_tmp.txt|wc -l)


 export lcf_additionalcsvarr_PROCESSES_INVOLVED="processes_involved.csv"
 export lcf_additionalstr_IS_SOFTRESET=${IS_SOFTRESET}
 export lcf_additionalstr_PROCESS_INVOLVED_HAS_MEMRESET=${PROCESS_INVOLVED_HAS_MEMRESET}


 if [ -z "$KLOGD" ] ; then
	export lcf_additionalstr_SUBCATEGORY="NCI,NoKLogd"
    export CATEGORY="NonCustomerImpacting"

	return 0
 else
	LINES=$(wc -l LOGS_BEFORE_FIRST_REBOOT |cut -d" " -f1)
	if [ "$LINES" -lt "1000" ] ; then
		export lcf_additionalstr_SUBCATEGORY="NCI,TooFewLogs"
        export CATEGORY="NonCustomerImpacting"

		return 0
	fi
 fi

# $SERVER_ACTIVE the only reason
 SUBCATEGORY=""

if [ $PROCESS_INVOLVED_HAS_MEMRESET -gt 0 ] ; then
	SUBCATEGORY="NCI,MemReset"
	CATEGORY="NonCustomerImpacting"
else
	if [  "$HEADEND_REBOOT_REQUEST" -gt  "0" ] ; then
		SUBCATEGORY="NCI,HEADND CAP"
		CATEGORY="NonCustomerImpacting"
	else
	    if [ -z "$LAST_KEY_PRESSED" ] ; then
				SUBCATEGORY="NCI,NoKeyPress"
				CATEGORY="NonCustomerImpacting"
			else
#
				if [ "$ACTIVE_CLIENT_COUNT" -gt "1" ] ; then
					SUBCATEGORY="CI,KeyPresses"
					CATEGORY="CustomerImpacting"
				 elif [ "$SERVER_ACTIVE" = "1" ] ; then
					 if [ "$LAST_KEY_PRESSED" = "1e508" ] || [ "$LAST_KEY_PRESSED" = "1e000" ] || [ "$LAST_KEY_PRESSED" = "1e506" ] ; then
						 SUBCATEGORY="NCI,ServerOnlyStandbyTVOff"
						 CATEGORY="NonCustomerImpacting"
						else
							SUBCATEGORY="CI,ServerKeyPresses"
							CATEGORY="CustomerImpacting"
						fi
				 elif [ "$IS_SERVER_IN_STANDBY" -gt "0" ] ; then
					 SUBCATEGORY="NCI,ServerIStandby"
					 CATEGORY="NonCustomerImpacting"
				 else
					 SUBCATEGORY="CI,ClientKeyPresses"
					 CATEGORY="CustomerImpacting"
				fi
		  fi
	fi
fi

FOUND_SUBCATEGORY=$(echo $SUBCATEGORY |cut -d"," -f1)
if [ "$FOUND_SUBCATEGORY" = "CI" ] ; then
	if [ "$IS_LOW_BOOT_TIME" = "N" ] ; then
		SUBCATEGORY="NCI,HighBootTime"
		CATEGORY="NonCustomerImpacting"
	else
		PREV_REASON=$(echo $SUBCATEGORY |cut -d, -f2)
		SUBCATEGORY="CI,${PREV_REASON}_LowBootTime"
		CATEGORY="CustomerImpacting"
  fi
fi
 export lcf_additionalstr_LAST_KEY_PRESSED=${LAST_KEY_PRESSED}
 export lcf_additionalstr_IS_SERVER_IN_STANDBY=${IS_SERVER_IN_STANDBY}
 export lcf_additionalstr_ACTIVE_CLIENTS=${ACTIVE_CLIENTS}
 export lcf_additionalstr_SERVER_ACTIVE=${SERVER_ACTIVE}
 export lcf_additionalstr_ACTIVE_CLIENT_COUNT=${ACTIVE_CLIENT_COUNT}
 export lcf_additionalstr_HEADEND_REBOOT_REQUEST=${HEADEND_REBOOT_REQUEST}
 export lcf_additionalstr_deltaC=${deltaC}
 export lcf_additionalstr_IS_LOW_BOOT_TIME=${IS_LOW_BOOT_TIME}
 export lcf_additionalstr_SUBCATEGORY=${SUBCATEGORY}
 export CATEGORY=${CATEGORY}
}

DECRYPTED_FILES_COUNT=0
DECRYPTED_FILES_SUCCESS_COUNT=0
DECRIPTION_TIME_MS=0


function decryptFile {
    FILE=$1
    if [[ $(file --mime-type --no-pad "$FILE") == *\ application/octet-stream ]]; then
        ((DECRYPTED_FILES_COUNT++))
        if $DECRYPT_TOOL --decrypt --input "$FILE" --output "$FILE.dec" && [ $(stat -c %s "$FILE.dec") -gt 0 ]; then
            echo "[Decrypted] $FILE"
            mv -f "$FILE.dec" "$FILE"
            ((DECRYPTED_FILES_SUCCESS_COUNT++))
        else
            rm -f "$FILE".dec
        fi
    fi
}

echo "==============="
echo ""
echo "CATEGORY is $CATEGORY"
echo ""
echo "==============="

