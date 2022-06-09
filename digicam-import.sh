#!/usr/bin/env bash
#
# Intentionally created to import photos from my digicam.
set -e

# This script utilizes gphoto2. Thus it is required to have gphoto2 installed.
readonly GPHOTO2_PATH=$(which gphoto2 2>/dev/null)
if [[ "${GPHOTO2_PATH}" = "" ]]; then
    echo "This script requires gphoto2 to be in PATH!"
    exit 1 
fi  

#######################################
# Moves given file to given director. 
# Creates directory if absent.
# Globals:
#   None
# Arguments:
#   $1 - Name of file to move
#   $2 - Directory to move into
# Returns:
#   None
#######################################
move_into() {
    mkdir --parent "$2"
    echo "Moving $1 into $2/$1 ..."
    mv "$1" "$2"
}

# Triggered from gphoto2 to move the downloaded file appropriately.
# ACTION=download
#        gphoto2 has just downloaded a file to the computer, storing it in the file indicated by the environment variable ARGUMENT.
if [[ ! -z "${ACTION// }" ]]; then
    if [[ "${ACTION}" = "download" ]]; then
        echo "Fetched ${ARGUMENT}."
        readonly MTIME=$(stat --format="%Y" "${ARGUMENT}")
        # shellcheck disable=2086
        readonly EPOCH=$(date -d @${MTIME} +%Y/%m)
        readonly EXT="${ARGUMENT##*.}"
        readonly EXT_LOWERED="${EXT,,}"
        if [[ "${EXT_LOWERED}" = "jpg" ]] || [[ "${EXT_LOWERED}" = "jpeg" ]] || [[ "${EXT_LOWERED}" = "mov" ]]; then
            move_into "${ARGUMENT}" "${EPOCH}" 
        else
            move_into "${ARGUMENT}" "${EPOCH}/${EXT}"
        fi
    fi
    # Return on any other ACTION to avoid having gphoto falls through.
    exit 0
fi

# Print help to enable usage.
if [[ $# -eq 0 ]]; then
    echo -e "\n"
    ${GPHOTO2_PATH} --auto-detect
    if [[ "$?" = "1" ]]; then
        echo "Exit on previous error."
        exit 1
    fi
    echo -e "\n\nRun \033[1m$0 -p Port\033[0m to get all files from connected device.\n"
fi

# Process command line arguments to provide extended functionality.
while getopts p: opt
do
  case $opt in
    p)  readonly FOLDERS=$(gphoto2 --debug --debug-logfile=my-logfile.txt --quiet --port=usb:002,008 --list-folders |grep -i "dcim$")
        for folder in $FOLDERS; do
            echo "Trial to download from: '${folder}' ..."
            ${GPHOTO2_PATH} --quiet --port="${OPTARG}" --folder="${folder}" --get-all-files --hook-script="$0" || true
        done
        ;; 
    \?) 
        exit 1
        ;;
  esac
done
