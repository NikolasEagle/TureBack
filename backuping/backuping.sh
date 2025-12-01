backuping() {
    local backup_path=$1
    local count_backup_files=$2
    local disk=$3

    # Подсчет количества копий в целевой директории

    count_backup_files_in_folder=$(find $backup_path -name ".img.lzo" | wc -l)

    # Удаление старой копии при превышении количества копий в папке необходимого числа

    if [[ $count_backup_files_in_folder -gt $count_backup_files ]]; then
        ls -t | tail -n 1 | xargs rm
    fi
}