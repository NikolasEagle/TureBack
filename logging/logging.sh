#!/bin/bash

get_date() {
    date +"%b %d %H:%M:%S";
}

get_hostname() {
    hostname
}

get_message() {
    if $1; then
        echo "[INFO]:"
    else
        echo "[ERROR]:"
    fi
}

export -f get_date get_hostname get_message