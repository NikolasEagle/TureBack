# Импортирование функции работы с датой

source $(dirname $0)/date.sh

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