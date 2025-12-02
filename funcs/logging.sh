# Импортирование функции работы с датой

source $(dirname $0)/funcs/date.sh

logging() {
    local status=$1
    local message=$2

    echo "$(get_date "journal") $(hostname) [$status]: $message" | tee -a $logs_path

}

export -f logging