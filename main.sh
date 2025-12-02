# Изменение параметров оболочки исполняемого сценария

set -ou pipefail

# Импорт функций

source $(dirname $0)/funcs/backuping.sh

main() {
    local backup_path=$1
    local count_backup_files=$2
    local disk=$3
    local compression_ratio=$4
    local logs_path="$backup_path/tureback.log"

    backuping $backup_path $count_backup_files $disk $compression_ratio $logs_path
}

export -f main