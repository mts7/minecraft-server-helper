#!/bin/bash
# Minecraft Server Helper
# Author: Mike Rodarte

thisDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# get configuration variables
. ${thisDir}/minecraft.conf

# set command string from variables
commandString="${javaBin}java -server -Xms${memMin} -Xmx${memMax} -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -XX:+CMSIncrementalPacing -XX:+UseFastAccessorMethods -XX:+AggressiveOpts -XX:+DisableExplicitGC -XX:+UseAdaptiveGCBoundary -XX:MaxGCPauseMillis=500 -XX:SurvivorRatio=16 -XX:UseSSE=3 -jar ${serverFile} nogui"

# script variables
dateFormat="%Y-%m-%d_%H:%M:%S"
hasScreen=0
serverStarted=0
version='0.1'

function serverStatus {
  # get the script name
  script=$(basename "${0}")
  # get the number of instances of the command string
  commandCount=$(ps -elf | grep "${serverFile}" | grep -v "${script}" | grep -v 'grep' | wc -l)

  # handle the command count
  if [ "${commandCount}" -eq 1 ]; then
    serverStarted=1
  elif [ "${commandCount}" -gt 1 ]; then
    echo "Command is running ${commandCount} times"
    serverStarted=1
  else
    serverStarted=0
  fi
}

function screenCheck {
  # determine the number of screens running that match this name
  screenCount=$(screen -ls "${screenName}" | wc -l)

  if [ "${screenCount}" -gt 2 ]; then
    hasScreen=1
  else
    hasScreen=0
  fi
}

function screenStart {
  if [ "${hasScreen}" -eq 0 ]; then
    screen -dmS "${screenName}"
    screenCheck
  fi
}

function serverStart {
  # verify server is stopped
  serverStatus
  if [ "${serverStarted}" -ne 0 ]; then
    echo "Server is already running"
    exit 1
  fi

  # verify screen exists
  screenCheck

  # if there is no screen, start screen
  if [ "${hasScreen}" -eq 0 ]; then
    # start a new screen session
    screenStart
  fi

  # send command to screen
  echo "Sending command string to ${screenName}"
  screen -r ${screenName} -X stuff "cd ${directory}"`echo -ne '\015'`
  screen -r ${screenName} -X stuff "${commandString}"`echo -ne '\015'`

  # verify server is started
  sleep 3
  serverStatus
  if [ "${serverStarted}" -eq 1 ]; then
    echo "Server is running"
  else
    echo "Server is not running"
    exit 4
  fi
}

function serverStop {
  serverStatus

  if [ "${serverStarted}" -eq 0 ]; then
    echo "The server is already stopped"
    exit 1
  fi

  screenCheck

  # check if screen is not running
  if [ "${hasScreen}" -eq 0 ]; then
    echo "There is no screen session"
    exit 2
  fi

  screen -dR "${screenName}" -X stuff "^C"`echo -ne '\015'`

  sleep 3
  serverStatus

  if [ "${serverStarted}" -eq 0 ]; then
    echo "Server stopped"
  else
    echo "Could not stop server"
    exit 4
  fi
}

# process command line arguments
if [ -n "${1}" ]; then
  case "${1}" in
    start)
      serverStart
      ;;
    stop)
      serverStop
      ;;
    restart)
      serverStop
      serverStart
      ;;
    status)
      serverStatus
      if [ "${serverStarted}" -eq 1 ]; then
        echo 'Server is started'
      else
        echo 'Server is stopped'
      fi
      ;;
    save)
      ;;
    backup)
      ;;
    *)
      ;;
  esac
fi
