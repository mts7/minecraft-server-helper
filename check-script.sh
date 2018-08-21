#!/bin/bash
# author: Mike Rodarte
# Verify the script provided is running only once

script="${1}"
fullPath="${2:-./}"

# determine the number of instances of the script
instances=$(ps -e | grep $script | grep -v 'check-script.sh' | grep -v 'grep' | wc -l)
echo "found ${instances} instances of ${script}"

# determine if the script needs to be started, stopped, both, or neither
needToStart=0
needToStop=0
if [ "${instances}" -eq 0 ]; then
  echo "${script} is not running"
  needToStart=1
elif [ "${instances}" -gt 1 ]; then
  echo "${script} is running ${instances} times and needs to be stopped and then started"
  needToStop=1
  needToStart=1
elif [ "${instances}" -eq 1 ]; then
  echo "${script} is running"
fi

if [ "${needToStop}" -eq 1 ]; then
  pkill ${script}
fi

if [ "${needToStart}" -eq 1 ]; then
  command="${fullPath}${script}"
  echo "using ${command} as the script to start"
  if [ -x ${command} ]; then
    # execute the script in the background
    ${fullPath}${script} &
    echo "Script ${script} should be running in the background"
  else
    echo "Could not find ${command} to execute"
  fi
fi

