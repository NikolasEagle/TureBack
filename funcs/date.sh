get_date() {
    local type=$1
    if [[ $type == "journal" ]]; then
        date +"%b %d %H:%M:%S";
    elif [[ $type == "file" ]]; then
        date +"%b_%d_%H:%M:%S";
    fi
}

export -f get_date