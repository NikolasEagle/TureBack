#!/bin/bash

# Директория скрипта

current_path=$(dirname $0)

# Импорт функций

source $current_path/logging/*

# Чтение флагов

usage() {
    echo "Usage: $0 [-o backup_path] [-n count_backup_files] [-d disk]"
    exit 1
}

while getopts ":o:n:d:" opt; do
    case $opt in
        o)
            echo "Backup Path: $OPTARG"
            ;;
        n)
            echo "Count Backup Files: $OPTARG"
            ;;
        d)
            echo "Disk: $OPTARG"
            ;;
        c)
            echo "Compression ratio: $OPTARG"
            ;;            
        \?)
            echo "Error: Invalid option -$OPTARG" >&2
            usage
            ;;
        :)
            echo "Error: Option -$OPTARG requires an argument." >&2
            usage
            ;;
    esac
done
