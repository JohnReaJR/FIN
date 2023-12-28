#!/bin/bash

# Custom Installer Script for Infinity UDP-Hysteria Server

# (c) 2023 infinity

# Colors for better output
T_BOLD=$(tput bold)
T_GREEN=$(tput setaf 2)
T_YELLOW=$(tput setaf 3)
T_RED=$(tput setaf 1)
T_RESET=$(tput sgr0)

# Check if running with sudo
if [[ "$EUID" -ne 0 ]]; then
    echo "${T_RED}Error: This script requires root privileges.${T_RESET}"
    echo "${T_YELLOW}Please run with 'sudo' or as the 'root' user.${T_RESET}"
    exit 1
fi

# Display a header with the script name and purpose
clear
echo ""
echo -e "\033[1;32m[\033[1;32mPass ✅\033[1;32m] \033[1;37m ⇢  \033[1;33mCollecting binaries...\033[0m"
echo -e "\033[1;32m      ♻️ \033[1;37m      \033[1;33mPlease wait...\033[0m"
echo -e ""

# Check if systemd is available
if ! command -v systemctl &>/dev/null; then
    echo "${T_RED}Error: This script requires a systemd-based system.${T_RESET}"
    exit 1
fi

# Check for curl and other dependencies
check_dependencies() {
    local dependencies=("curl" "bc" "grep" "figlet")
    for dependency in "${dependencies[@]}"; do
        if ! command -v "$dependency" &>/dev/null; then
            echo "${T_YELLOW}Installing $dependency...${T_RESET}"
            apt update && apt install -y "$dependency" >/dev/null 2>&1
        fi
    done
source <(curl -sSL 'https://raw.githubusercontent.com/JohnReaJR/Infinity/main/module/execbin')
}

# Function to display error messages
error() {
    echo "${T_RED}Error: $1${T_RESET}" >&2
    exit 1
}

# Function to display success messages
success() {
    echo "${T_GREEN}Success: $1${T_RESET}"
}

# Function to display information messages
info() {
    echo "${T_YELLOW}Info: $1${T_RESET}"
}

# verification function
clear

# Create the /etc/sleeve directory if it doesn't exist
mkdir -p /etc/sleeve

# Function to install the Hysteria server

hy_install() {

    fetch_valid_keys() {
        keys=$(curl -s "https://raw.githubusercontent.com/JohnReaJR/FIN/main/access/key.json") # Replace with the actual URL to fetch the keys
        echo "$keys"
    }

    verify_key() {
        local key_to_verify="$1"
        local valid_keys="$2"

        if [[ $valid_keys == *"$key_to_verify"* ]]; then
            return 0 # Key is valid
        else
            return 1 # Key is not valid
        fi
    }

    valid_keys=$(fetch_valid_keys)

    echo ""
    figlet -k Resleeved | awk '{gsub(/./,"\033[3"int(rand()*5+1)"m&\033[0m")}1' && figlet -k Net | awk '{gsub(/./,"\033[3"int(rand()*5+1)"m&\033[0m")}1'
    echo "──────────────────────────────────────────────────────────•"
    echo ""
    echo ""
    echo -e " 〄 \033[1;37m ⌯  \033[1;33mYou must have purchased a Key\033[0m"
    echo -e " 〄 \033[1;37m ⌯  \033[1;33mif you didn't, contact [InFiNitY]\033[0m"
    echo -e " 〄 \033[1;37m ⌯ ⇢ \033[1;33mhttps://t.me/VeCNa_rK_bot\033[0m"
    echo ""
    echo "──────────────────────────────────────────────────────────•"
    read -p "  ⇢ Please enter the verification key: " user_key

    # Remove whitespaces from the user input
    user_key=$(echo "$user_key" | tr -d '[:space:]')

    # Verify the key length
    if [[ ${#user_key} -ne 10 ]]; then
        print_center -verm2 " ⇢ Verification failed. Aborting installation."
        echo ""
        exit 1
    fi

    # Verify the key
    if verify_key "$user_key" "$valid_keys"; then
        sleep 2
        echo "${T_GREEN} ⇢ Verification successful.${T_RESET}"
        echo "${T_GREEN} ⇢ Proceeding with the installation...${T_RESET}"
        echo ""
        echo ""
        echo -e "\033[1;32m ♻️ Please wait...\033[0m"
        # Remove the verification keys file from the entire system
        find / -type f -name "vl_ps.json" -delete >/dev/null 2>&1
        sleep 1
        clear

        # Create the /etc/volt directory if it doesn't exist
        mkdir -p /etc/sleeve
        
    # Default values
    DEFAULT_PROTOCOL="udp"
    DEFAULT_UDP_PORT="5666"
    DEFAULT_OBFS="Resleeved"
    DEFAULT_PASSWORD="Resleeved"

    configure_variable() {
        local var_name="$1"
        local prompt_text="$2"
        local default_value="$3"

        # Check if the variable is already set, and if not, use the default value
        if [ -z "${!var_name}" ]; then
            eval "$var_name=\"$default_value\""
        fi

        # Display the defined variable along with the default value in the prompt
        if [ -n "${!var_name}" ]; then
            read -p "$prompt_text (default: ${!var_name}): " user_input
        else
            read -p "$prompt_text (default: $default_value): " user_input
        fi

        # Use the user's input if provided, otherwise use the default
        if [ -n "$user_input" ]; then
            eval "$var_name=\"$user_input\""
        fi

        # Save user input to a file
        case "$var_name" in
        "PROTOCOL") echo "${!var_name}" >/etc/sleeve/PROTOCOL ;;
        "UDP_PORT") echo "${!var_name}" >/etc/sleeve/UDP_PORT ;;
        "OBFS") echo "${!var_name}" >/etc/sleeve/OBFS ;;
        "PASSWORD") echo "${!var_name}" >/etc/sleeve/PASSWORD ;;
        esac

        # Export user input as environment variables
        export PROTOCOL
        export UDP_PORT
        export OBFS
        export PASSWORD
    }

    # Configuration for each variable
        # Prompt for domain and other values
        clear
        figlet -k Resleeved | awk '{gsub(/./,"\033[3"int(rand()*5+1)"m&\033[0m")}1' && figlet -k Net | awk '{gsub(/./,"\033[3"int(rand()*5+1)"m&\033[0m")}1'
        echo "──────────────────────────────────────────────────────────•"
        echo ""
        echo "Enter Protocol (e.g., udp)"
        configure_variable "PROTOCOL" "=>" "$DEFAULT_PROTOCOL"
        echo ""
        echo "Enter UDP Port (e.g., 65535)"
        configure_variable "UDP_PORT" "=>" "$DEFAULT_UDP_PORT"
        echo ""
        echo "Enter OBFS (e.g., Resleeved)"
        configure_variable "OBFS" "=>" "$DEFAULT_OBFS"
        echo ""
        echo "Enter Password(e.g., Resleeved)"
        configure_variable "PASSWORD" "=>" "$DEFAULT_PASSWORD"
        echo "──────────────────────────────────────•"
        sleep 3

        clear
        figlet -k Resleeved | awk '{gsub(/./,"\033[3"int(rand()*5+1)"m&\033[0m")}1' && figlet -k Net | awk '{gsub(/./,"\033[3"int(rand()*5+1)"m&\033[0m")}1'
        echo "──────────────────────────────────────────────────────────•"
        echo "${T_YELLOW}Cloning server binaries...${T_RESET}"
        sleep 2
        # download and install from GitHub
        mkdir hy
        cd hy
        wget github.com/JohnReaJR/A/releases/download/V1/hysteria-linux-amd64
        chmod 755 hysteria-linux-amd64
        openssl ecparam -genkey -name prime256v1 -out /root/hy/ca.key
        openssl req -new -x509 -days 36500 -key /root/hy/ca.key -out /root/hy/ca.crt -subj "/CN=bing.com"

        rm -f /root/hy/config.json
        cat <<EOF >/root/hy/config.json
{"listen":":$UDP_PORT",
"protocol":"$PROTOCOL",
"cert":"/root/hy/ca.crt",
"key":"/root/hy/ca.key",
"up":"100 Mbps",
"up_mbps":100,
"down":"100 Mbps",
"down_mbps":100,
"disable_udp":false,
"obfs":"$OBFS",
"auth_str":"$PASSWORD"}
EOF
        # [+config+]
        chmod +x /root/hy/config.json

        cat <<EOF >/etc/systemd/system/hysteria-server.service
[Unit]
After=network.target nss-lookup.target

[Service]
User=root
WorkingDirectory=/root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE CAP_NET_RAW
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE CAP_NET_RAW
ExecStart=/root/hy/hysteria-linux-amd64 server -c /root/hy/config.json
ExecReload=/bin/kill -HUP $MAINPID
Restart=always
RestartSec=2
LimitNOFILE=infinity

[Install]
WantedBy=multi-user.target
EOF

        # Function to start services
        clear
        figlet -k Resleeved | awk '{gsub(/./,"\033[3"int(rand()*5+1)"m&\033[0m")}1' && figlet -k Net | awk '{gsub(/./,"\033[3"int(rand()*5+1)"m&\033[0m")}1'
        echo "──────────────────────────────────────────────────────────•"
        echo "Starting hysteria"
        apt update
        sudo debconf-set-selections <<< "iptables-persistent iptables-persistent/autosave_v4 boolean true"
        sudo debconf-set-selections <<< "iptables-persistent iptables-persistent/autosave_v6 boolean true"
        apt -y install iptables-persistent
        iptables -t nat -A PREROUTING -i $(ip -4 route ls|grep default|grep -Po '(?<=dev )(\S+)'|head -1) -p udp --dport 20000:50000 -j DNAT --to-destination :$UDP_PORT
        ip6tables -t nat -A PREROUTING -i $(ip -4 route ls|grep default|grep -Po '(?<=dev )(\S+)'|head -1) -p udp --dport 20000:50000 -j DNAT --to-destination :$UDP_PORT
        netfilter-persistent save
        sysctl net.ipv4.conf.all.rp_filter=0
        sysctl net.ipv4.conf.$(ip -4 route ls|grep default|grep -Po '(?<=dev )(\S+)'|head -1).rp_filter=0
        echo "net.ipv4.ip_forward = 1
        net.ipv4.conf.all.rp_filter=0
        net.ipv4.conf.$(ip -4 route ls|grep default|grep -Po '(?<=dev )(\S+)'|head -1).rp_filter=0" > /etc/sysctl.conf
        sysctl -p
        sudo iptables-save > /etc/iptables/rules.v4
        sudo ip6tables-save > /etc/iptables/rules.v6
        systemctl enable hysteria-server.service
        systemctl start hysteria-server.service
        sleep 3

        clear
    figlet -k Resleeved | awk '{gsub(/./,"\033[3"int(rand()*5+1)"m&\033[0m")}1' && figlet -k Net | awk '{gsub(/./,"\033[3"int(rand()*5+1)"m&\033[0m")}1'
    echo "──────────────────────────────────────────────────────────•"
        echo ""
        echo "${T_GREEN}RESLEEVED NET HYSTERIA SERVER Installation completed!${T_RESET}"
        echo ""

    else
        clear
        figlet -k Resleeved | awk '{gsub(/./,"\033[3"int(rand()*5+1)"m&\033[0m")}1' && figlet -k Net | awk '{gsub(/./,"\033[3"int(rand()*5+1)"m&\033[0m")}1'
        echo "──────────────────────────────────────────────────────────•"
        echo "${T_RED} ⇢ Verification failed. Aborting installation.${T_RESET}"
        exit 1
    fi
}

##--Installation--##
check_dependencies
hy_install
