#!/bin/bash
# Author: Mike Rodarte
#
# Listen to the log file and respond as necessary.

serverDir='/home/minecraft/minecraft'
logDir="${serverDir}/logs/"
logFile="${logDir}latest.log"
commandName='mcapi'
lastLine=''

# execute the listener while the log file exists
while [ -f $logFile ]; do
  last=$(tail -1 $logFile)

  # check to see if $commandName exists in $last
  if [ "$last" != "$lastLine" ] && [[ "$last" == *"$commandName"* ]]; then
    # get whatever follows $commandName
    position=$(echo `echo "$last" | grep -aob "$commandName" | grep -oE '^[0-9]+'`)
    posCommand=$(( $position + ${#commandName} ))
    cmd="${last:$posCommand}"

    "${serverDir}/minecraft-server-helper/mcapi" $cmd

    # do not keep doing this same command
    lastLine="$last"
  fi
done
