#!/usr/bin/env bash


function createConsolidateMessages(){

	if [ -f CONSOLIDATE_MESSAGES ] ; then
		echo Y
		return
	fi
	MESSAGE_FILE_COUNT=$(ls messages.log.*|wc -l)
	if [ $MESSAGE_FILE_COUNT -eq 0 ] ; then
		echo N
		return 
	fi
	rm -f CONSOLIDATE_MESSAGES
	LOGS=$(ls messages.log.*|sort -t . -k 3 -g)

	for LOG in $LOGS;do
		  cat $LOG >>CONSOLIDATE_MESSAGES
	done
	echo Y
}

function getRebootLineNumbers(){

	REBOOT_STRING1="klogd"
	REBOOT_STRING2="IMAGE VERSION"
	REBOOT_STRING3="grep 'Jan 1 .* Jan 1 ' CONSOLIDATE_MESSAGES - n|grep 'Kernel command line'"
	TIMES1=$(grep "$REBOOT_STRING1" CONSOLIDATE_MESSAGES |wc -l)
	TIMES2=$(grep "$REBOOT_STRING2" CONSOLIDATE_MESSAGES |wc -l)

	 
	if [ "$TIMES2" -gt "$TIMES1" ] ; then
	  REBOOT_STRING=$REBOOT_STRING2
	else
	  REBOOT_STRING=$REBOOT_STRING1
	fi

	LINES=$(grep "$REBOOT_STRING" CONSOLIDATE_MESSAGES  -n|tail -2|cut -d: -f1)
	echo $LINES
}

function createMostRecentLog(){
	LINE_NUMBERS=$(getRebootLineNumbers)
	LAST_TWO=$(echo $LINE_NUMBERS | wc -w)
	if [ -z "$LINE_NUMBERS" ] ; then
		 LAST_TWO=0
	fi
	if [ $LAST_TWO -eq "0" ] ; then
			cp CONSOLIDATE_MESSAGES MOST_RECENT_LOG
			return
	elif [ $LAST_TWO -eq "1" ] ; then 
		head -$LINE_NUMBERS CONSOLIDATE_MESSAGES > MOST_RECENT_LOG
	elif [ $LAST_TWO -gt "1" ] ; then
		 LINE1=$(echo $LINE_NUMBERS |cut -d' ' -f1)
		 LINE2=$(echo $LINE_NUMBERS |cut -d' ' -f2)
		  head -$LINE2 CONSOLIDATE_MESSAGES | tail -n +$LINE1 > MOST_RECENT_LOG
		elif [ -f CONSOLIDATE_MESSAGES ] && [ ! -f MOST_RECENT_LOG ] ; then
			cp CONSOLIDATE_MESSAGES MOST_RECENT_LOG
		fi

}

if [ "$(createConsolidateMessages)" = "Y" ] ; then
	createMostRecentLog
fi
