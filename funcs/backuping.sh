# Импортирование функции работы с датой

source $(dirname $0)/date.sh

gen_filename() {
    echo "$(get_date)_$(hostname).img.lz4"
}

backuping() {
    local backup_path=$1
    local count_backup_files=$2
    local disk=$3
    local compression_ratio=$4

    # Подсчет количества копий в целевой директории

    count_backup_files_in_folder=$(find $backup_path -name ".img.lz4" | wc -l)

    # Удаление старой копии при превышении количества копий в папке необходимого числа

    if [[ $count_backup_files_in_folder -gt $count_backup_files ]]; then
        ls -t | tail -n 1 | xargs rm
    fi

    # Клонирование диска и сжатие резервной копии в целевую директорию

    dd if=$disk | lz4 -$compression_ratio > $backup_path/$(gen_filename)
}