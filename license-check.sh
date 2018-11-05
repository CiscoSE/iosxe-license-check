#!/bin/bash

# is SNMPRO set?
if [ -z "$SNMPRO" ]; then
	echo
	echo "Please set environment variable SNMPRO."
	echo "e.g.: export SNMPRO=CommunityString"
	echo
	exit
fi

inuse=".1.3.6.1.4.1.9.9.543.1.2.3.1.14.1.1"
feature=".1.3.6.1.4.1.9.9.543.1.2.3.1.3.1.1"
enddate=".1.3.6.1.4.1.9.9.543.1.2.3.1.16.1.1"
udi=".1.3.6.1.2.1.47.1.1.1.1.11.1"

# is site ${1} reachable?
if ping -c 1 -w 5 ${1} &>/dev/null; then

	# get snmp index for in use license
	cmd="snmpwalk -v 2c -c ${SNMPRO} ${1} ${inuse} | grep 3$ | cut -d' ' -f1 | rev | cut -d'.' -f1"
	license_index=$(snmpwalk -v 2c -c ${SNMPRO} ${1} ${inuse} | grep 3$ | cut -d' ' -f1 | rev | cut -d'.' -f1)

	# get feature
	license_feature=$(snmpwalk -v 2c -c ${SNMPRO} ${1} ${feature}.${license_index} | cut -d'"' -f2)

	# geat expiration date
	license_hex=$(snmpwalk -v 2c -c ${SNMPRO} ${1} ${enddate}.${license_index} | cut -d" " -f4-)
	hex_year=$(echo ${license_hex} | cut -d" " -f-2 | sed -e 's/\ //g')
	hex_month=$(echo ${license_hex} | cut -d" " -f3)
	hex_day=$(echo ${license_hex} | cut -d" " -f4)
	# convert to YYYY-MM-DD
	license_date=$(printf "%04d-%02d-%02d" $(( 16#${hex_year} )) $(( 16#${hex_month} )) $(( 16#${hex_day} )))
	udi_info=$(snmpwalk -v 2c -c ${SNMPRO} ${1} ${udi} | cut -d" " -f4 | cut -d\" -f2)

	#print it out
	echo "${1},${udi_info},${license_feature},${license_date}"


else
	echo ${1},N/A,NOT reachable,1901-01-01
fi
