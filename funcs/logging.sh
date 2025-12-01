# Импортирование функции работы с датой

source $(dirname $0)/funcs/date.sh

logging() {
    local command=$1
    local logs_path=$2
    local backup_completed=$3

    local err=$(eval $command > /dev/null 2>&1)

    if [[ -n $err ]]; then
        echo "$(get_date "journal") $(hostname) [ERROR]: $err" | tee -a $logs_path
        exit 1
    elif [ -z $err ] && $backup_completed; then
        echo "$(get_date "journal") $(hostname) [INFO]: Success!" | tee -a $logs_path
    fi    
}

export -f logging