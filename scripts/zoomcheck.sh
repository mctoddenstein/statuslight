#!/bin/bash

SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

#declare global variables

#check if zoom is running. this is for both the launcher client and the active zoom session
ACTIVEZOOM=$(ps auwx | grep -Ei "zoom.us" | grep -cv grep)
ACTIVEWEBEX=$(ps auwx | grep -Ei "webex" | grep -cv grep)
#use variable for file pathname
ZOOMSTATUS=~/tmp/zoomstatus.txt

#if the grep count from the ACTIVEZOOM global variable has a value equal to 2, then begin through the logic tree
if [[ ($(echo $ACTIVEZOOM) -gt 2) || ($(echo $ACTIVEWEBEX) -gt 3) ]]; then
	#if the concatenated output from the zoomstatus file is already set to "true", we do nothing
	if [[ $(cat $ZOOMSTATUS) == 'true' ]]; then
		:
	#if the concatenated output from the zoomstatus file is not set to "true", we echo "true" into the file
	else
		echo "true" > $ZOOMSTATUS
	fi
#if the grep count from the ACTIVEZOOM global variable has a value less than 2, then begin through the logic tree
elif [[ ($(echo $ACTIVEZOOM) -le 2) || ($(echo $ACTIVEWEBEX) -le 3) ]]; then
	#if the concatenated output from the zoomstatus file is already set to "true", we do nothing
	if [[ $(cat $ZOOMSTATUS) == 'false' ]]; then
		:
	#if the concatenated output from the zoomstatus file is not set to "true", we echo "true" into the file
	else
		echo "false" > $ZOOMSTATUS
	fi
fi

sleep 1

#checks if the zoomstatus.txt file has been modified within the last two minutes
if [[ $(find /Users/$USER/tmp -name zoomstatus.txt -type f -cmin -2 -print) == "/Users/$USER/tmp/zoomstatus.txt" ]]; then
	#if it has been modified and the value inside the file is "true", turn the light to blue and being blinking
	if [[ $(cat $ZOOMSTATUS) == 'true' ]]; then
		status blue
		status @blink
	#if the file has been modified and the value inside is "false", turn the light solid and then to yellow
	elif [[ $(cat $ZOOMSTATUS) == 'false' ]]; then
		status @solid
		status yellow
	#if the file has not been modified within the last two minutes, do nothing to allow for custom status light color changes
	else
		:
	fi
fi
