#!/bin/bash
# Minecraft Server Helper
# Author: Mike Rodarte

# set the directory for this script
thisDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# get configuration variables
. ${thisDir}/minecraft.conf

# set command string from variables
commandString=''
buildCommand

# script variables
dateFormat="%Y-%m-%d_%H:%M:%S"
hasScreen=0
serverStarted=0
version='0.37'

#######################################
# Build the command string
# Globals:
#   javaBin (from .conf)
#   memMin (from .conf)
#   memMax (from .conf)
#   serverFile (from .conf)
#   commandString
# Arguments:
#   None
# Returns:
#   None
#######################################
function buildCommand {
  # define local variables for building the Java command string
  local javaServer="${javaBin}java -server"
  local javaMemory=" -Xms${memMin} -Xmx${memMax}"
  local javaGC=" -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -XX:+DisableExplicitGC -XX:+UseAdaptiveGCBoundary -XX:MaxGCPauseMillis=500"
  local javaOptions=" -XX:+CMSIncrementalPacing -XX:+UseFastAccessorMethods -XX:+AggressiveOpts -XX:SurvivorRatio=16 -XX:UseSSE=3"
  local javaFile=" -jar ${serverFile} nogui"

  # build the command string
  commandString="${javaServer}${javaMemory}${javaGC}${javaOptions}${javaFile}"
}

#######################################
# Get the current server status
# Globals:
#   serverFile
#   serverStarted
# Arguments:
#   None
# Returns:
#   None
#######################################
function serverStatus {
  # get the script name
  local script=$(basename "${0}")
  # get the number of instances of the command string
  local commandCount=$(ps -elf | grep "${serverFile}" | grep -v "${script}" | grep -v 'grep' | wc -l)

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

#######################################
# Get the current screen status
# Globals:
#   screenName (from .conf)
#   hasScreen
# Arguments:
#   None
# Returns:
#   None
#######################################
function screenCheck {
  # determine the number of screens running that match this name
  local screenCount=$(screen -ls "${screenName}" | wc -l)

  if [ "${screenCount}" -gt 2 ]; then
    hasScreen=1
  else
    hasScreen=0
  fi
}

#######################################
# Start the screen and update the variable
# Globals:
#   hasScreen
#   screenName (from .conf)
# Arguments:
#   None
# Returns:
#   None
#######################################
function screenStart {
  if [ "${hasScreen}" -eq 0 ]; then
    screen -dmS "${screenName}"
    screenCheck
  fi
}

#######################################
# Start the server
# Globals:
#   serverStarted
#   hasScreen
#   directory (from .conf file)
#   commandString
# Arguments:
#   None
# Returns:
#   None
#######################################
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
  screen -dR ${screenName} -X stuff "cd ${directory}"`echo -ne '\015'`
  screen -dR ${screenName} -X stuff "${commandString}"`echo -ne '\015'`

  # verify server is started
  sleep 3
  serverStatus
  if [ "${serverStarted}" -eq 1 ]; then
    echo "Server is running"
  else
    echo "Server is not running"
    exit 2
  fi
}

#######################################
# Stop the server
# Globals:
#   serverStarted
#   screenName
# Arguments:
#   None
# Returns:
#   None
#######################################
function serverStop {
  serverStatus

  if [ "${serverStarted}" -eq 0 ]; then
    echo "The server is already stopped"
    exit 4
  fi

  screenCheck

  # check if screen is not running
  if [ "${hasScreen}" -eq 0 ]; then
    echo "There is no screen session"
    exit 8
  fi

  screen -dR "${screenName}" -X stuff "^C"`echo -ne '\015'`

  sleep 3
  serverStatus

  if [ "${serverStarted}" -eq 0 ]; then
    echo "Server stopped"
  else
    echo "Could not stop server"
    exit 16
  fi
}

#######################################
# Get the current server status
# Globals:
#   hasScreen
#   dateFormat
#   screenName
#   directory (from .conf)
#   backupDir (from .conf)
# Arguments:
#   excludeStr (from .conf)
# Returns:
#   None
#######################################
function serverBackup {
  screenCheck

  # wrap screen commands with screen check
  if [ "${hasScreen}" -eq 1 ]; then
    # get the start date and time
    local start=$(date +"${dateFormat}")

    # Let the users know the backup started
    screen -dR ${screenName} -X stuff "say Backup starting at ${start}. World no longer saving!... $(printf '\r')"
    screen -dR ${screenName} -X stuff "save-off $(printf '\r')"
    screen -dR ${screenName} -X stuff "save-all $(printf '\r')"
  fi

  # get today to use in file name
  local today=$(date +"%Y-%m-%d-%H")

  # go to the correct directory
  cd ${directory}

  # create a tar file in the backup directory
  tar -cvzf ${backupDir}/mcbackup_${today}.tar.gz * --exclude='backups' --exclude='minecraft-server-helper' --exclude='Server-Utilities' ${1}

  # wrap screen commands with screen check
  if [ "${hasScreen}" -eq 1 ]; then
    # get the end date and time
    local end=$(date +"${dateFormat}")

    # let the users know the backup is complete
    screen -dR ${screenName} -X stuff "save-on $(printf '\r')"
    screen -dR ${screenName} -X stuff "say Backup complete at ${end}! World now saving. $(printf '\r')"
  fi

  # remove files in the backup directory that are older than 3 days
  find ${backupDir} -mtime +3 -print | xargs /bin/rm -f
}

#######################################
# Send the date and time to the users
# Globals:
#   hasScreen
#   dateFormat
#   screenName
# Arguments:
#   None
# Returns:
#   None
#######################################
function sendDate {
  screenCheck

  # wrap screen commands with screen check
  if [ "${hasScreen}" -eq 1 ]; then
    # get the current date and time
    local now=$(date +"$dateFormat")

    # send the current date and time to the users
    screen -r ${screenName} -X stuff "say Current time: ${now} $(printf '\r')"
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
      elif [ "${serverStarted}" -gt 1 ]; then
        echo "There are ${serverStarted} instances of the server running"
        exit 32
      else
        echo 'Server is stopped'
      fi
      ;;
    save)
      serverBackup ${excludeStr}
      ;;
    backup)
      serverBackup
      ;;
    date)
      sendDate
      ;;
    *)
      echo ''
      echo "minecraft.sh by Mike Rodarte (mts7777777)"
      echo ''
      echo "Available options"
      echo "start        Start the server"
      echo "stop         Stop the server"
      echo "restart      Stop then start the server"
      echo "status       Check running instances of server"
      echo "save         Do a backup of files, excluding logs and crash-reports"
      echo "backup       Do a full backup of files"
      echo "date         Send the current date and time to the users"
      ;;
  esac
fi
