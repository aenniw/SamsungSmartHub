#!/bin/sh
#T111013.sg - based on STA driver
#T111105.sg - based on AP driver

DEV_NAME=ra0

AP_LIST_PATH1=/tmp/ap_list.txt
AP_LIST_PATH2=/tmp/ap_list2.txt
AP_LIST_PATH3=/tmp/ap_list3.txt
AP_INFO_PATH=/tmp/ap_info.txt
AP_INFO_MAC_PATH=/tmp/ap_info_mac.txt



get_site_survey(){
	rm -rf $AP_LIST_PATH1
	iwpriv $DEV_NAME set SiteSurvey=1
	iwpriv $DEV_NAME get_site_survey | sed 1d2d > $AP_LIST_PATH1
	iwpriv $DEV_NAME set SiteSurvey=0
	return $?
}



get_ap_list(){
	rm -rf $AP_LIST_PATH2
	rm -rf $AP_LIST_PATH3
	
	get_site_survey
	cat $AP_LIST_PATH1 | awk '{if($8) print $1" "$2" "$3" "$4" "$5" "$6'} > $AP_LIST_PATH2
	#cat $AP_LIST_PATH2 | awk '{print " [CH"$1"] "$2" ("$4")"'} > $AP_LIST_PATH3
	cat $AP_LIST_PATH2 | awk '{print $2"\&nbsp ("$3")"'} > $AP_LIST_PATH3
	
}

get_ap_info(){
	rm -rf $AP_INFO_PATH
	rm -rf $AP_INFO_MAC_PATH

	if [ $1 -ne '0' ]; then
		cat $AP_LIST_PATH2 | sed -n $1p | awk '{print "[CH "$1"] Security:"$4" Signal:"$5"%"}' > $AP_INFO_PATH
		cat $AP_LIST_PATH2 | sed -n $1p | awk '{print $3}' > $AP_INFO_MAC_PATH
	fi
}




case "$1" in

	site_survey)
		get_site_survey
		return $?
	;;
	

	get_ap_list)
		get_ap_list
	;;

	get_ap_info)
		get_ap_info $2
	;;

	*)
		echo "usage: $0 { site_survey | get_ap_list | get_ap_info }" >&2
		return 1;
	;;
esac


