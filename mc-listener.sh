#!/bin/bash
# Author: Mike Rodarte
#
# Listen to the log file and respond as necessary.

serverDir='/home/minecraft/'
logDir="${serverDir}logs/"
logFile="${logDir}latest.log"
commandName='/mcapi'

# execute the listener while the log file exists
while [ -f $logFile ]; do
  last=$(tail -1 $logFile)

  # check to see if $commandName exists in $last
  if [[ "$last" == *"$commandName"* ]]; then
    # get whatever follows $commandName
    echo "TODO: get whatever follows $commandName"
  fi
done
