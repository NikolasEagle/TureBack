check_package() {
    local package=$1
    
    # Проверяем, какая система

    if command -v apt >/dev/null 2>&1; then
        # Debian/Ubuntu
        if ! $(command -v $package >/dev/null 2>&1); then
            apt install $package -y
            if [ $? -ne 0 ]; then
                logging "ERROR" "Error: Packet $package can't be installed" $logs_path
                exit 1
            fi
        fi
        
    elif command -v dnf >/dev/null 2>&1; then
        # RHEL/CentOS/Fedora
        if ! $(dnf list installed $package >/dev/null 2>&1); then
            dnf install -y $package
            if [ $? -ne 0 ]; then
                logging "ERROR" "Error: Packet $package can't be installed" $logs_path
                exit 1
            fi
        fi
        
    elif command -v pacman >/dev/null 2>&1; then
        # Arch
        if ! $(pacman -Qi $package >/dev/null 2>&1); then
            pacman -S --noconfirm $package
            if [ $? -ne 0 ]; then
                logging "ERROR" "Error: Packet $package can't be installed" $logs_path
                exit 1
            fi
        fi
        
    elif command -v zypper >/dev/null 2>&1; then
        # OpenSUSE
        if ! $(zypper se -i $package >/dev/null 2>&1); then
            zypper install -y $package
            if [ $? -ne 0 ]; then
                logging "ERROR" "Error: Packet $package can't be installed" $logs_path
                exit 1
            fi
        fi

    elif command -v apk >/dev/null 2>&1; then
        # Alpine
         if ! $(apk info --installed lz4 > /dev/null 2>&1); then
            apk add $package
            if [ $? -ne 0 ]; then
                logging "ERROR" "Error: Packet $package can't be installed" $logs_path
                exit 1
            fi
        fi
        
    else
        logging "ERROR" "Error: Packet $package can't be installed. Unable to determine package manager" $logs_path
        exit 1
    fi
}

export -f check_package