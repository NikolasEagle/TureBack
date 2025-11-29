#!/bin/bash

get_date() {
    date +"%b %d %H:%M:%S";
}

get_hostname() {
    hostname
}

logging() {
    local command=$1
    local logs_path=$2
    local backup_completed=$3

    local err=$($command 2>&1)

    if [[ -n $err ]]; then
        echo "$(get_date) $(get_hostname) [ERROR]: $err" >> $logs_path
        set -e
    elif [[ -z $err && $backup_completed ]]; then
        echo "$(get_date) $(get_hostname) [INFO]: Success!" >> $logs_path
    fi    
}

export -f logging