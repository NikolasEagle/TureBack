# Импортирование функций

source $(dirname $0)/funcs/logging.sh
source $(dirname $0)/funcs/date.sh
source $(dirname $0)/funcs/check_package.sh

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
        mkdir $backup_path
        if [ $? -ne 0 ]; then
            logging "ERROR" "Error: Target directory could not be created" $logs_path
            exit 1
        fi
    fi

    # Проверка наличия считываемого диска или раздела

    if ! [ -b $disk ]; then
        logging "ERROR" "Error: Source disk or partition does not exist" $logs_path
        exit 1
    fi

    # Проверка наличия пакета lz4 для сжатия

    check_package "lz4"

    # Подсчет количества копий в целевой директории

    count_backup_files_in_folder=$(find $backup_path -name "*.img.lz4" | wc -l)

    # Удаление старой копии при превышении количества копий в папке необходимого числа

    if [ $count_backup_files_in_folder -ge $count_backup_files ]; then
        find $backup_path -name "*.img.lz4" | sort -r | tail -n $(($count_backup_files_in_folder - $count_backup_files + 1)) | xargs rm
        if [ $? -ne 0 ]; then
            logging "ERROR" "Error: Old backup files into target directory could not be deleted" $logs_path
            exit 1
        fi
    fi

    # Клонирование диска и сжатие резервной копии в целевую директорию

    dd if=$disk | lz4 -$compression_ratio > $backup_path/$(gen_filename)

    if [ $? -ne 0 ]; then
        logging "ERROR" "Error: error occurred while recording" $logs_path
        find $backup_path -name "*.img.lz4" | sort -r | head -n 1 | xargs rm
        if [ $? -ne 0 ]; then
            logging "ERROR" "Error: Empty backup file into target directory could not be deleted" $logs_path
            exit 1
        fi
        exit 1
    fi

    logging "INFO" "Success!" $logs_path
}