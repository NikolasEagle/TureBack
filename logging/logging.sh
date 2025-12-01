#!/bin/bash

get_date() {
    date +"%b %d %H:%M:%S";
}

logging() {
    local command=$1
    local logs_path=$2
    local backup_completed=$3

    local err=$($command 2>&1)

    if [[ -n $err ]]; then
        echo "$(get_date) $(hostname) [ERROR]: $err" >> $logs_path
        exit 1
    elif [[ -z $err && $backup_completed ]]; then
        echo "$(get_date) $(hostname) [INFO]: Success!" >> $logs_path
    fi    
}

export -f logging