#!/bin/bash -x
# Get the location of the xinput program
xinputCMD=$(which xinput)

# Start a Loop
while true
do
        # Get the device ID of because it can change with every reboot based
	# on what’s on the USB Bus
        trackPad=$(xinput list|egrep -i 'ALPS GlidePoint'|awk -F= '{ print $2 }'|awk '{ print $1 }')
        # Get the USB Mouse device ID of because it can change with every 
	# connection based on what’s on the USB Bus
        USBMouse=$(xinput list|egrep -i 'USB Receiver'|awk -F= '{ print $2 }'|awk '{ print $1 }')
        # Check to see if the trackpad is enabled or not
        isEnabled=$(xinput list-props ${trackPad}|grep Enabled|awk '{ print $4 }')
        # If there is no USB Mouse the next line will be false and 
        # the if statement will be skipped. Otherwise check to see
        # if it’s enabled and disable it if it is.  Then jump to 
        # the sleep 30 command at the bottom.
        if [ ${USBMouse} ]
        then
                if [ ${isEnabled} == 1 ]
                then
                        # Write to syslog that we detected a mouse and
                        # disabled the trackpad.
                        logger "USB Mouse Detected"
                        logger "Disabling Trackpad"
                        grabForLogger=$(${xinputCMD} set-prop ${trackPad} 'Device Enabled' 0 2>&1 )
                        # if the command worked then there is no output.
                        # if it failed for any reason the result of the 
                        # next command will be greater than 0 or no words.
                        # That output can then be logged so you can fix it.
                        outputCount=$(echo $grabForLogger|wc -w)
                        # if the output is greater than 0 then log it.
                        if [ $outputCount -gt 0 ]
                        then
                                logger "Something went wrong trying to disable the trackpad"
                                logger $grabForLogger
                        fi
                fi
        else
                # Since there is no mouse check to see if the trackpad is 
                # enabled.  If not then enable it.  If so then skip to the 
                # sleep 30 statement.
                if [ ${isEnabled} == 0 ] 
                then
                        # Write to syslog that we detected a mouse and
                        # disabled the trackpad.
                        logger "No USB Mouse Detected"
                        logger "Enabling Trackpad"


                        grabForLogger=$(${xinputCMD} set-prop ${trackPad} 'Device Enabled' 1 2>&1 )
# if the command worked then there is no output.
                        # if it failed for any reason the result of the 
                        # next command will be greater than 0 or no words.
                        # That output can then be logged so you can fix it.
                        outputCount=$(echo $grabForLogger|wc -w)
                        # if the output is greater than 0 then log it.
                        if [ $outputCount -gt 0 ]
                        then
                                logger "Something went wrong trying to enable the trackpad"
                                logger $grabForLogger
                        fi
                fi
        fi
        # Wait here for 30 seconds and then check again.
        sleep 30
done

