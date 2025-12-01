# Импортирование функций

source $(dirname $0)/funcs/logging.sh
source $(dirname $0)/funcs/date.sh

gen_filename() {
    echo "$(get_date "file")_$(hostname).img.lz4"
}

backuping() {
    local backup_path=$1
    local count_backup_files=$2
    local disk=$3
    local compression_ratio=$4
    local logs_path=$5

    # Проверка наличия целевой директории

    if ! [[ -d $backup_path ]]; then
        logging "mkdir $backup_path" $logs_path false
    fi

    # Подсчет количества копий в целевой директории

    count_backup_files_in_folder=$(find $backup_path -name ".img.lz4" | wc -l)

    # Удаление старой копии при превышении количества копий в папке необходимого числа

    if [[ $count_backup_files_in_folder -gt $count_backup_files ]]; then
        logging "ls -t | tail -n 1 | xargs rm" $logs_path false
    fi

    # Клонирование диска и сжатие резервной копии в целевую директорию

    logging "dd if=$disk | lz4 -$compression_ratio > $backup_path/$(gen_filename)" $logs_path false
}