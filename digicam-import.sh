#!/usr/bin/env bash
#
# Intentionally created to import photos from my digicam.
set -e

# Verify gphoto2 is available since this script relies on it.
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
if [[ ! -z "${ACTION// }" ]]; then
    if [[ "${ACTION}" = "download" ]]; then
        echo "Fetched ${ARGUMENT}."
        readonly MTIME=$(stat --format="%Y" "${ARGUMENT}")
        # shellcheck disable=2086
        readonly EPOCH=$(date -d @${MTIME} +%Y/%m)
        readonly SUFFIX="${ARGUMENT##*.}"
        readonly SUFFIX_LOWERED="${SUFFIX,,}"
        if [[ "${SUFFIX_LOWERED}" = "jpg" ]] || [[ "${SUFFIX_LOWERED}" = "jpeg" ]]; then
            move_into "${ARGUMENT}" "${EPOCH}" 
        else
            move_into "${ARGUMENT}" "${EPOCH}/${SUFFIX}"
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
    p)  ${GPHOTO2_PATH} --quiet --port="${OPTARG}" --folder=/ --recurse --get-all-files --hook-script="$0"
        ;; 
    \?) 
        exit 1
        ;;
  esac
done
