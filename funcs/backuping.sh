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
        mkdir $backup_path
        if [ $? -ne 0 ]; then
            logging "ERROR" "Error: Target directory could not be created" $logs_path
            exit 1
        fi
    fi

    # Проверка наличия считываемого диска или раздела

    device=$(echo $disk | sed 's|^/dev/||')

    if ! $(lsblk 2>&1 | grep -q $device); then
        logging "ERROR" "Error: Source disk or partition does not exist" $logs_path
        exit 1
    fi

    # Проверка наличия пакета lz4 для сжатия

    os_name=$(grep "^ID=" /etc/os-release | sed 's/^ID=//')

    if [[ $os_name == "ubuntu" ]] || [[ $os_name == "debian" ]]; then
        if ! $(dpkg -l lz4 2>&1 | grep -q "ii"); then
            apt install lz4 -y
            if [ $? -ne 0 ]; then
                logging "ERROR" "Error: Packet lz4 can't be installed" $logs_path
                exit 1
            fi
        fi
    elif [ $os_name == "alpine" ]; then
        if ! $(apk info --installed lz4 > /dev/null 2>&1); then
            apk add lz4
            if [ $? -ne 0 ]; then
                logging "ERROR" "Error: Packet lz4 can't be installed" $logs_path
                exit 1
            fi
        fi
    fi

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