#!/usr/bin/env bash

BSDUP_VERSION="0.6.99 [pre 0.7]"
BSD_VERSION[0]=`uname -r`
BSD_VERSION[1]=`echo $BSD_VERSION[0] | tr -d '.'`
LOG_FILE="/var/log/freebsd-update.log"
PORT_TRACKER_FILE="/tmp/port-track.db"
UPDATING_LIMIT="30"
JQ_CMD=`which jq`
CURL_CMD=`which curl`
SERVICE_CMD=`which service`
UPDATING_DATES[0]=`${CURL_CMD} -s 'http://updating.braincomb.com/UPDATING.json' | ${JQ_CMD} '.updating[] .date' | sed "s/^\([\"']\)\(.*\)\1\$/\2/g" | head -n ${UPDATING_LIMIT}`
UPDATING_DATES[1]=`${CURL_CMD} -s 'http://updating.braincomb.com/UPDATING.json' | ${JQ_CMD} '.updating[] .date' | sed "s/^\([\"']\)\(.*\)\1\$/\2/g" | head -n ${UPDATING_LIMIT}`
DEBUG="1" # 0 for off, 1 for on
AUTO_SVC_RESTART="1" # 1 to automatically restart all services after port upgrades

is_Screen(){
	if [ "${TERM}" != "screen" ]; then 
		echo "***"
		echo "*** ERROR [${TERM}]: You MUST run this script from a SCREEN session"
		echo "***"
		exit 1
	else
		echo "***"
		echo "*** SCREEN session [${STY}] detected!"
		echo "***"
	fi
}

restart_Services(){
	if [ ${AUTO_SVC_RESTART} == "1" ]; then
		echo "***"
		echo "*** Restarting services"
		echo "***"
		${SERVICE_CMD} -R
	else
		echo "***"
		echo "*** Skipping service restart"
		echo "***"
	fi
}

debug(){
	echo "***"
	echo "*** Settings"
	echo "*** BSDUP_VERSION = ${BSDUP_VERSION}"
	echo "*** BSD_VERSION[0] = ${BSD_VERSION[0]}"
	echo "*** BSD_VERSION[1] = ${BSD_VERSION[1]}"
	echo "*** LOG_FILE = ${LOG_FILE}"
	echo "*** PORT_TRACKER_FILE = ${PORT_TRACKER_FILE}"
	echo "*** UPDATING_LIMIT = ${UPDATING_LIMIT}"
	echo "*** JQ_CMD = ${JQ_CMD}"
	echo "*** CURL_CMD = ${CURL_CMD}"
	echo "*** AUTO_SVC_RESTART = ${AUTO_SVC_RESTART}"
}

version(){
	echo "***"
	echo "*** FreeBSD Updater v${BSDUP_VERSION}"
	echo "*** FreeBSD Version ${BSD_VERSION[0]}"
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
	#PORT_TRACKER_FILE
	CHK_PORTSDB="1"
}

ports-update(){
	echo "***"
	echo "*** Upgrading ports..."
	echo "***"
	/usr/local/sbin/portmaster -adwv
}

ports-audit(){
	echo "***"
	echo "*** Checking installed ports for known security problems..."
	echo "***"
	/usr/sbin/pkg audit | tee ${LOG_FILE}
}

updating_warning(){
	echo "***"
	echo "*** IT IS HIGHLY RECOMMENDED YOU CHECK THE UPDATING FILE AND MANUALLY INSTALL AFFECTED PORTS BEFORE RUNNING THIS SCRIPT!"
	echo "***"
	return
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
					echo "-e, --exclude-flagged     Automatically exclude ports flagged in UPDATING file"
					echo "-i, --install-required    Install all required packages for FreeBSD Updater to work"
					echo "-v, --version		Show version"
					exit 0
					;;
                        -c|--check-update)
                                        ports-check
                                        shift
                                        exit 0
                                        ;;

			-b|--base)
					os-update
					;;
			-u|--upgrade)
					updating_warning
					is_Screen
					ports-update
					restart_Services
					shift
					exit 0
					;;
			-e|--exclude-flagged)
					shift
					exit 0
					;;
			-i|--install-required)
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
