# iosxe-license-check

Used to check the feature and expiration date of active and in-use licenses on IOS-XE router.

NOTE:	Be sure to set the environment variable SNMPRO to the SNMP community string
	that you wish to query the device with.

Examples:

	./license-check.sh <device>

	or
	
	cat ./file_with_list_of_devices.txt | while read line; do
             ./license-check.sh ${line}; done


Output:

	[user@host ~]$ export SNMPRO=public
	[user@host ~]$ license-check.sh iosxe-device
	iosxe-device,9ATJXXXXAHF,appx_1G,2019-01-27
	[user@host ~]$

