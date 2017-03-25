#!/usr/bin/env bash

BSDUP_VERSION="0.6"
BSD_VERSION[0]=`uname -r`
BSD_VERSION[1]="echo $BSD_VERSION[0] | tr -d '.'"
LOG_FILE="/var/log/freebsd-update.log"
PORT_TRACKER_FILE="/tmp/port-track.db"
UPDATING_LIMIT="30"
JQ_CMD=`which jq`
CURL_CMD=`which curl`
UPDATING_DATES=`${CURL_CMD} -s 'http://updating.braincomb.com/UPDATING.json' | ${JQ_CMD} '.updating[] .date' | sed "s/^\([\"']\)\(.*\)\1\$/\2/g"`
DEBUG="1" # 0 for off, 1 for on

debug(){
	echo "***"
	echo "*** Settings"
	echo "*** BSDUP_VERSION = $BSDUP_VERSION"
	echo "*** BSD_VERSION[0] = $BSD_VERSION[0]"
	echo "*** BSD_VERSION[1] = $BSD_VERSION[1]"
	echo "*** LOG_FILE = $LOG_FILE"
	echo "*** PORT_TRACKER_FILE = $PORT_TRACKER_FILE"
	echo "*** UPDATING_LIMIT = $UPDATING_LIMIT"
	echo "*** JQ_CMD = $JQ_CMD"
	echo "*** CURL_CMD = $CURL_CMD"
}

version(){
	echo "***"
	echo "*** FreeBSD Updater v$BSDUP_VERSION"
	echo "*** FreeBSD Version $BSD_VERSION[0]"
	echo "***"
}

os-update(){
	echo "Starting updates: `date`" | tee ${LOG_FILE}
	echo "***"
	echo "*** Checking for FreeBSD patches..."
	echo "***"
	/usr/sbin/freebsd-update fetch | tee ${LOG_FILE}
	/usr/sbin/freebsd-update install | tee ${LOG_FILE}
}

corrupt-db(){
	sleep .5
	# Place marker for corrupt database handling
}

check-updating(){
	sleep .5
	# Place marker for checking the /usr/ports/UPDATING file for notes within the range specified in $UPDATING_LIMIT, expressed in days
	# Compare to $PORT_TRACKER_FILE and alert if there is a match
	# $UPDATING_DATES contains the dates that are in /usr/ports/UPDATING
	
}

ports-check(){
	echo "***"
	echo "*** Updating pkg database"
	echo "***"
	/usr/sbin/pkg update | tee ${LOG_FILE}
	echo "***"
	echo "*** Updating ports database"
	echo "***"
	/usr/sbin/portsnap fetch update | tee ${LOG_FILE}
	PORT_TRACKER_FILE
	CHK_PORTSDB="1"
}

ports-update(){
	if [ "$CHK_PORTSDB" != "1" ]; then ports-check; else :; fi
	echo "***"
	echo "*** Updating pkg database..."
	echo "***"
	#/usr/local/sbin/portmaster
}

ports-audit(){
	echo "***"
	echo "*** Checking installed ports for known security problems..."
	echo "***"
	/usr/sbin/pkg audit | tee ${LOG_FILE}
}

# End of functions #
# Test for DEBUG flag #
if [ "$DEBUG" == "1" ]; then debug; else :; fi

while test $# -gt 0; do
		case "$1" in
			-h|--help)
					version
					echo "options:"
					echo "-h, --help		Its what youre looking at!"
					echo "-b, --base		Update FreeBSD base"
					echo "-u, --upgrade		Perform full upgrade of ports"
					echo "-c, --check-update	Check ports for updates"
					echo "-v, --version		Show version"
					exit 0
					;;
			-b|--base)
					os-update
					;;
			-u|--upgrade)
					updating_warning && sleep 5
					ports-update
					shift
					exit 0
					;;
			-c|--check-update)
					shift
					exit 0
					;;
			-v|--version)
					version
					exit 0
					;;
			*)
					break
					;;
					esac
done

echo "You should probably have me do something, if you need help, use -h"
exit 1
