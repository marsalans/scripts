#!/bin/bash
# requirements: curl, sed, awk

USERNAME=""
PASSWORD=""
IPADDRESS=""

/usr/bin/curl --basic -s -u $USERNAME:$PASSWORD http://$IPADDRESS/status/status_deviceinfo.htm >> /dev/null

if [[ $@ == "down" ]]
then
	SHOWVAR=`/usr/bin/curl --basic -s -u $USERNAME:$PASSWORD \
	http://$IPADDRESS/status/status_deviceinfo.htm | sed '104!d' | awk '{ print $1 }'`
	echo -e '\E[1;32m'"\033[92m$SHOWVAR\033[0m kbps"
elif [[ $@ == "up" ]]
then
	SHOWVAR=`/usr/bin/curl --basic -s -u $USERNAME:$PASSWORD \
	http://$IPADDRESS/status/status_deviceinfo.htm | sed '105!d' | awk '{ print $1 }'`
	echo -e '\E[1;31m'"\033[91m$SHOWVAR\033[0m kbps"
elif [[ $@ = "maxrate" ]]
then
	D=`/usr/bin/curl --basic -s -u $USERNAME:$PASSWORD \
	http://$IPADDRESS/status/status_deviceinfo.htm | sed '108!d' | awk '{ print $1 }'`
	U=`/usr/bin/curl --basic -s -u $USERNAME:$PASSWORD \
	http://$IPADDRESS/status/status_deviceinfo.htm | sed '109!d' | awk '{ print $1 }'`
	echo -en "Max Data Rate:\t"
	echo -en '\E[1;32m'"\033[92m$D\033[0m kbps\t"
	echo -e '\E[1;31m'"\033[91m$U\033[0m kbps"
elif [[ $@ == "snr" ]]
then
	D=`/usr/bin/curl --basic -s -u $USERNAME:$PASSWORD \
	http://$IPADDRESS/status/status_deviceinfo.htm | sed '96!d' | awk '{ print $1 }'`
	U=`/usr/bin/curl --basic -s -u $USERNAME:$PASSWORD \
	http://$IPADDRESS/status/status_deviceinfo.htm | sed '97!d' | awk '{ print $1 }' | sed "s|</td><td||g"`
	echo -en "SNR Margin:\t"
	echo -en '\E[1;32m'"\033[92m$D\033[0m dB\t"
	echo -e '\E[1;31m'"\033[91m$U\033[0m dB"
elif [[ $@ == "dist" ]]
then
	LIAT=`/usr/bin/curl --basic -s -u $USERNAME:$PASSWORD \
	http://$IPADDRESS/status/status_deviceinfo.htm | sed '100!d' | awk '{ print $1 }'`
	LOSS="13.81"
	DIST=`echo "scale=3;$LIAT/$LOSS" | bc`
	echo -en "Distance from DSLAM:\t"
	echo -e '\E[1;33m'"\033[93m$DIST\033[0m km"
elif [[ $@ == "" ]]
then
	echo -n "Error: "
	echo -e '\E[1;31m'"\033[91mNo argument, please enter 'down', 'up', 'maxrate', 'snr' or 'dist'\033[0m"
else
	echo -n "Error: "
	echo -e '\E[1;31m'"\033[91mWrong argument, please enter 'down', 'up', 'maxrate', 'snr' or 'dist'\033[0m"
fi
