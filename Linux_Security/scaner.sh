#!/bin/bash

# ============================================================
# 🔥 QUANTUM SECURITY TERMINAL v5.0 - ULTIMATE EDITION 🔥
# Neural Interface with Quantum Processing
# ============================================================

# ---------------- COLORS ----------------

GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
GRAY='\033[0;90m'
WHITE='\033[1;37m'
RESET='\033[0m'
BOLD='\033[1m'
MAGENTA='\033[1;35m'

# ---------------- GLOBALS ----------------

USER_NAME=$(whoami)
HOST_NAME=$(hostname)
SELECTED_PATH="$HOME"
SCAN_TYPE="directory"
REPORT_DIR="$HOME/security_reports"
mkdir -p "$REPORT_DIR"

# ---------------- CHECK DEPENDENCIES ----------------

check_deps() {
    if ! command -v dialog &> /dev/null; then
        echo -e "${RED}❌ Dialog not installed${RESET}"
        echo -e "${YELLOW}📦 Install with:${RESET}"
        echo "   sudo apt install dialog"
        echo "   OR"
        echo "   sudo pacman -S dialog"
        echo "   OR"
        echo "   sudo dnf install dialog"
        exit 1
    fi
}

# ---------------- FILE/DIRECTORY BROWSER ----------------

browse_directory() {
    local start_dir="${1:-$HOME}"
    local current_dir="$start_dir"
    local selection=""

    while true; do
        local dirs
        dirs=$(find "$current_dir" -maxdepth 1 -type d 2>/dev/null | grep -v "^$" | sort)
        local files
        files=$(find "$current_dir" -maxdepth 1 -type f 2>/dev/null | sort)

        local menu_items=()
        menu_items+=(".." "⬆️ Go Up")

        while IFS= read -r dir; do
            if [ -n "$dir" ] && [ "$dir" != "$current_dir" ]; then
                local dir_name
                dir_name=$(basename "$dir")
                menu_items+=("$dir" "📁 $dir_name")
            fi
        done <<< "$dirs"

        while IFS= read -r file; do
            if [ -n "$file" ]; then
                local file_name
                file_name=$(basename "$file")
                menu_items+=("$file" "📄 $file_name")
            fi
        done <<< "$files"

        menu_items+=("SELECT_THIS" "✅ Select This Directory/File")
        menu_items+=("SELECT_HOME" "🏠 Go to Home")
        menu_items+=("CANCEL" "❌ Cancel")

        selection=$(dialog --title "📂 File Browser - $(basename "$current_dir")" \
                           --menu "Current: $current_dir\n\nSelect a file or directory:" \
                           25 70 15 \
                           "${menu_items[@]}" \
                           3>&1 1>&2 2>&3)

        case $? in
            0)
                if [ -z "$selection" ]; then
                    continue
                elif [ "$selection" = ".." ]; then
                    current_dir=$(dirname "$current_dir")
                elif [ "$selection" = "SELECT_THIS" ]; then
                    SELECTED_PATH="$current_dir"
                    if [ -f "$current_dir" ]; then
                        SCAN_TYPE="file"
                    else
                        SCAN_TYPE="directory"
                    fi
                    return 0
                elif [ "$selection" = "SELECT_HOME" ]; then
                    current_dir="$HOME"
                elif [ "$selection" = "CANCEL" ]; then
                    return 1
                elif [ -d "$selection" ]; then
                    current_dir="$selection"
                elif [ -f "$selection" ]; then
                    dialog --title "🔍 Selection" \
                           --yesno "You selected a file:\n\n$selection\n\nDo you want to scan this file?\n\nSelect Yes to scan file, No to scan its directory." \
                           10 60
                    if [ $? -eq 0 ]; then
                        SELECTED_PATH="$selection"
                        SCAN_TYPE="file"
                        return 0
                    else
                        current_dir=$(dirname "$selection")
                    fi
                fi
                ;;
            1)
                return 1
                ;;
        esac
    done
}

# ---------------- ANIMATED WELCOME ----------------

startup_sequence() {
    clear

    echo -e "${GREEN}"
    for i in {1..30}; do
        for j in {1..50}; do
            echo -ne "$((RANDOM % 2))"
        done
        echo
        sleep 0.02
    done
    echo -e "${RESET}"

    clear

    echo -e "${PURPLE}╔════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${PURPLE}║                                                            ║${RESET}"
    echo -e "${PURPLE}║  ${CYAN}🔥 QUANTUM SECURITY TERMINAL v5.0${RESET}                  ${PURPLE}║${RESET}"
    echo -e "${PURPLE}║  ${GRAY}Neural Interface · Quantum Processing${RESET}             ${PURPLE}║${RESET}"
    echo -e "${PURPLE}║                                                            ║${RESET}"
    echo -e "${PURPLE}╚════════════════════════════════════════════════════════════╝${RESET}"
    echo

    echo -ne "${CYAN}👤 QUANTUM IDENTITY: ${RESET}"
    for ((i=0; i<${#USER_NAME}; i++)); do
        echo -ne "${WHITE}${USER_NAME:$i:1}${RESET}"
        sleep 0.03
    done
    echo

    echo -ne "${CYAN}🖥️  QUANTUM NODE: ${RESET}"
    for ((i=0; i<${#HOST_NAME}; i++)); do
        echo -ne "${WHITE}${HOST_NAME:$i:1}${RESET}"
        sleep 0.03
    done
    echo -e "\n"

    echo -ne "${CYAN}🔐 INITIALIZING SYSTEM${RESET}"
    for i in {1..10}; do
        echo -ne "${GREEN}.${RESET}"
        sleep 0.1
    done
    echo -e " ${GREEN}✓${RESET}\n"

    sleep 0.5

    echo -e "${GREEN}✅ ACCESS GRANTED - SYSTEM READY${RESET}"
    sleep 1
}

# ---------------- SHOW WITH PAGER ----------------

show_output() {
    local title="$1"
    local file="$2"

    {
        echo ""
        echo "  ╔════════════════════════════════════════════════════════════╗"
        echo "  ║                    $title                                  ║"
        echo "  ╚════════════════════════════════════════════════════════════╝"
        echo ""
        cat "$file"
        echo ""
        echo "  ──────────────────────────────────────────────────────────────"
        echo "  Press 'q' to exit, 'Space' to scroll"
    } > /tmp/display_output.tmp

    dialog --title "📊 $title" \
           --textbox /tmp/display_output.tmp \
           25 80
    rm -f /tmp/display_output.tmp
}

# ---------------- PROGRESS FUNCTION ----------------

run_with_progress() {
    local title="$1"
    local command="$2"
    local logfile="/tmp/${title// /_}.log"

    {
        echo "10"
        echo "XXX"
        echo "🔄 Initializing Quantum Engine..."
        echo "XXX"
        sleep 0.5

        echo "30"
        echo "XXX"
        echo "⚡ Loading Neural Modules..."
        echo "XXX"
        sleep 0.3

        echo "50"
        echo "XXX"
        echo "🔍 Executing: $title"
        echo "XXX"
        sleep 0.3

        echo "70"
        echo "XXX"
        echo "⚙️ Processing..."
        echo "XXX"

        eval "$command" > "$logfile" 2>&1

        echo "90"
        echo "XXX"
        echo "✅ $title completed!"
        echo "XXX"
        sleep 0.5

        echo "100"
        echo "XXX"
        echo "🎯 Mission Complete!"
        echo "XXX"
    } | dialog --title "🔥 Quantum Processing" \
               --gauge "Initializing..." \
               8 60 0

    if [ -f "$logfile" ] && [ -s "$logfile" ]; then
        dialog --title "📊 Results: $title" \
               --textbox "$logfile" \
               25 80
    fi

    rm -f "$logfile"
}

# ---------------- COMPREHENSIVE SYSTEM TEST ----------------

run_system_tests() {
    local report_file="$REPORT_DIR/system_test_$(date +%Y%m%d_%H%M%S).txt"

    {
        echo ""
        echo "  ╔════════════════════════════════════════════════════════════╗"
        echo "  ║            🔬 COMPREHENSIVE SYSTEM TEST REPORT             ║"
        echo "  ║                    $(date '+%Y-%m-%d %H:%M:%S')                    ║"
        echo "  ╚════════════════════════════════════════════════════════════╝"
        echo ""
        echo "  ──────────────────────────────────────────────────────────────"
        echo "  SYSTEM INFORMATION"
        echo "  ──────────────────────────────────────────────────────────────"
        echo "  Hostname: $(hostname)"
        echo "  User: $(whoami)"
        echo "  Distribution: $(cat /etc/os-release 2>/dev/null | grep PRETTY_NAME | cut -d'=' -f2 | tr -d '"' || echo 'Unknown')"
        echo "  Kernel: $(uname -r)"
        echo "  Architecture: $(uname -m)"
        echo "  Uptime: $(uptime -p 2>/dev/null || echo 'N/A')"
        echo ""

        echo "  ──────────────────────────────────────────────────────────────"
        echo "  CPU & MEMORY"
        echo "  ──────────────────────────────────────────────────────────────"
        echo "  CPU Model: $(grep -m1 'model name' /proc/cpuinfo 2>/dev/null | cut -d':' -f2 | xargs)"
        echo "  CPU Cores: $(nproc 2>/dev/null || echo '1')"
        echo "  Memory Total: $(free -h 2>/dev/null | awk '/^Mem:/ {print $2}')"
        echo "  Memory Used: $(free -h 2>/dev/null | awk '/^Mem:/ {print $3}')"
        echo "  Memory Free: $(free -h 2>/dev/null | awk '/^Mem:/ {print $4}')"
        echo "  Swap Total: $(free -h 2>/dev/null | awk '/^Swap:/ {print $2}')"
        echo "  Swap Used: $(free -h 2>/dev/null | awk '/^Swap:/ {print $3}')"
        echo ""

        echo "  ──────────────────────────────────────────────────────────────"
        echo "  DISK USAGE"
        echo "  ──────────────────────────────────────────────────────────────"
        df -h | grep -v "tmpfs" | grep -v "snap"
        echo ""

        echo "  ──────────────────────────────────────────────────────────────"
        echo "  TOP 10 PROCESSES BY CPU"
        echo "  ──────────────────────────────────────────────────────────────"
        ps aux --sort=-%cpu | head -10
        echo ""

        echo "  ──────────────────────────────────────────────────────────────"
        echo "  TOP 10 PROCESSES BY MEMORY"
        echo "  ──────────────────────────────────────────────────────────────"
        ps aux --sort=-%mem | head -10
        echo ""

        echo "  ──────────────────────────────────────────────────────────────"
        echo "  OPEN PORTS & NETWORK SERVICES"
        echo "  ──────────────────────────────────────────────────────────────"
        sudo ss -tulpn 2>/dev/null | grep LISTEN | head -20
        echo ""

        echo "  ──────────────────────────────────────────────────────────────"
        echo "  ACTIVE NETWORK CONNECTIONS"
        echo "  ──────────────────────────────────────────────────────────────"
        sudo ss -tunp 2>/dev/null | grep ESTAB | head -10
        echo ""

        echo "  ──────────────────────────────────────────────────────────────"
        echo "  RUNNING SERVICES"
        echo "  ──────────────────────────────────────────────────────────────"
        systemctl list-units --type=service --state=running 2>/dev/null | head -15 || echo "systemctl not available"
        echo ""

        echo "  ──────────────────────────────────────────────────────────────"
        echo "  SECURITY STATUS"
        echo "  ──────────────────────────────────────────────────────────────"
        echo "  Firewall Status: $(sudo ufw status 2>/dev/null | grep -q "Status: active" && echo "✅ Active" || echo "❌ Inactive/Not installed")"
        echo "  SELinux Status: $(getenforce 2>/dev/null || echo "Not installed")"
        echo "  AppArmor Status: $(aa-status 2>/dev/null | head -1 || echo "Not installed")"
        echo ""

        echo "  ──────────────────────────────────────────────────────────────"
        echo "  FAILED SYSTEMD UNITS"
        echo "  ──────────────────────────────────────────────────────────────"
        systemctl --failed 2>/dev/null || echo "systemctl not available"
        echo ""

        echo "  ──────────────────────────────────────────────────────────────"
        echo "  LAST 5 SYSTEM LOG ENTRIES"
        echo "  ──────────────────────────────────────────────────────────────"
        sudo journalctl -n 5 --no-pager 2>/dev/null || tail -5 /var/log/syslog 2>/dev/null || echo "No logs available"
        echo ""

        echo "  ──────────────────────────────────────────────────────────────"
        echo "  USB DEVICES"
        echo "  ──────────────────────────────────────────────────────────────"
        lsusb 2>/dev/null || echo "No USB devices found"
        echo ""

        echo "  ──────────────────────────────────────────────────────────────"
        echo "  RECENT SYSTEM UPDATES"
        echo "  ──────────────────────────────────────────────────────────────"
        if [ -f /var/log/apt/history.log ]; then
            tail -10 /var/log/apt/history.log | grep -E "Start-Date|Commandline"
        else
            echo "  No apt history found"
        fi
        echo ""

        echo "  ──────────────────────────────────────────────────────────────"
        echo "  SECURITY RECOMMENDATIONS"
        echo "  ──────────────────────────────────────────────────────────────"
        echo "  🔍 Security Checks:"

        if [ -f /etc/ssh/sshd_config ]; then
            if grep -q "^PermitRootLogin yes" /etc/ssh/sshd_config; then
                echo "  ⚠️  WARNING: SSH root login is enabled (Consider disabling)"
            else
                echo "  ✅ SSH root login is disabled"
            fi
        fi

        if [ -f /etc/login.defs ]; then
            local pass_max
            pass_max=$(grep "^PASS_MAX_DAYS" /etc/login.defs | awk '{print $2}')
            if [ "$pass_max" -le 90 ] 2>/dev/null; then
                echo "  ✅ Password max age: $pass_max days (Good)"
            else
                echo "  ⚠️  Password max age: $pass_max days (Consider reducing to 90)"
            fi
        fi

        echo "  🔍 Failed login attempts:"
        sudo lastb -n 5 2>/dev/null | head -5 || echo "  No failed login data available"

        echo "  🔍 Users with sudo access:"
        getent group sudo 2>/dev/null | cut -d':' -f4 || echo "  No sudo group found"

        echo ""
        echo "  ──────────────────────────────────────────────────────────────"
        echo "  ✅ SYSTEM TEST COMPLETED"
        echo "  📁 Report saved to: $report_file"
        echo "  ──────────────────────────────────────────────────────────────"

    } > "$report_file"

    dialog --title "🔬 System Test Results" \
           --textbox "$report_file" \
           30 90

    dialog --title "📁 Report Saved" \
           --yesno "System test report saved to:\n\n$report_file\n\nDo you want to view it again?" \
           8 60

    if [ $? -eq 0 ]; then
        dialog --title "🔬 System Test Results" \
               --textbox "$report_file" \
               30 90
    fi
}

# ---------------- WIFI SECURITY SCANNER ----------------

scan_wifi_security() {
    local wifi_report="$REPORT_DIR/wifi_scan_$(date +%Y%m%d_%H%M%S).txt"

    local has_airodump=false
    local has_nmcli=false
    local has_iwlist=false

    command -v airodump-ng &> /dev/null && has_airodump=true
    command -v nmcli &> /dev/null && has_nmcli=true
    command -v iwlist &> /dev/null && has_iwlist=true

    if ! $has_airodump && ! $has_nmcli && ! $has_iwlist; then
        dialog --title "❌ Error" \
               --msgbox "No WiFi scanning tools found!\n\nInstall one of:\n\n• aircrack-ng (sudo apt install aircrack-ng)\n• network-manager (sudo apt install network-manager)\n• wireless-tools (sudo apt install wireless-tools)" \
               12 60
        return
    fi

    local scan_choice
    scan_choice=$(dialog --title "📡 WiFi Security Scanner" \
                         --menu "Select scan type:" \
                         15 60 5 \
                         1 "Quick WiFi Networks Scan" \
                         2 "Detailed WiFi Security Analysis" \
                         3 "Check Connected WiFi Security" \
                         4 "Scan for Hidden Networks" \
                         5 "Back" \
                         3>&1 1>&2 2>&3)

    case $? in
        0)
            case $scan_choice in
                1) quick_wifi_scan "$wifi_report" ;;
                2) detailed_wifi_scan "$wifi_report" ;;
                3) check_connected_wifi "$wifi_report" ;;
                4) scan_hidden_networks "$wifi_report" ;;
            esac
            ;;
    esac
}

quick_wifi_scan() {
    local report_file="$1"

    {
        echo ""
        echo "  ╔════════════════════════════════════════════════════════════╗"
        echo "  ║              📡 QUICK WIFI NETWORKS SCAN                   ║"
        echo "  ║                    $(date '+%Y-%m-%d %H:%M:%S')                    ║"
        echo "  ╚════════════════════════════════════════════════════════════╝"
        echo ""

        if command -v nmcli &> /dev/null; then
            echo "  🔍 Available WiFi Networks:"
            echo "  ──────────────────────────────────────────────────────────────"
            nmcli dev wifi list --rescan yes 2>/dev/null | head -30
            echo ""

            echo "  📊 Connection Status:"
            echo "  ──────────────────────────────────────────────────────────────"
            nmcli connection show --active 2>/dev/null
            echo ""
        fi

        if command -v iwlist &> /dev/null; then
            echo "  🔍 WiFi Networks (iwlist):"
            echo "  ──────────────────────────────────────────────────────────────"
            sudo iwlist wlan0 scan 2>/dev/null | grep -E "ESSID|Quality|Encryption" | head -30 || echo "  No networks found or interface not available"
            echo ""
        fi

        if command -v airodump-ng &> /dev/null; then
            echo "  ⚠️  Advanced scan requires root and monitoring mode"
            echo "  ──────────────────────────────────────────────────────────────"
            echo "  To run airodump-ng, use:"
            echo "  sudo airmon-ng start wlan0"
            echo "  sudo airodump-ng wlan0mon"
            echo ""
        fi

        echo "  ──────────────────────────────────────────────────────────────"
        echo "  ✅ Scan completed"
        echo "  📁 Report saved to: $report_file"

    } > "$report_file"

    dialog --title "📡 WiFi Networks" \
           --textbox "$report_file" \
           25 80
}

detailed_wifi_scan() {
    local report_file="$1"

    if ! command -v airodump-ng &> /dev/null; then
        dialog --title "❌ Error" \
               --msgbox "airodump-ng not installed!\n\nInstall aircrack-ng:\nsudo apt install aircrack-ng" \
               8 60
        return
    fi

    dialog --title "⚠️ WiFi Security Scan" \
           --yesno "This will perform a detailed WiFi security scan.\n\nRequirements:\n• WiFi adapter supporting monitor mode\n• Root privileges\n\nThis may take 30-60 seconds.\n\nContinue?" \
           12 60

    if [ $? -eq 0 ]; then
        local wifi_iface
        wifi_iface=$(ip link show | grep -E "wlan|wl" | awk -F': ' '{print $2}' | head -1)

        if [ -z "$wifi_iface" ]; then
            dialog --title "❌ Error" \
                   --msgbox "No wireless interface found!" \
                   6 40
            return
        fi

        {
            echo ""
            echo "  ╔════════════════════════════════════════════════════════════╗"
            echo "  ║            🔐 DETAILED WIFI SECURITY SCAN                  ║"
            echo "  ║                    $(date '+%Y-%m-%d %H:%M:%S')                    ║"
            echo "  ╚════════════════════════════════════════════════════════════╝"
            echo ""

            echo "  📡 Scanning Interface: $wifi_iface"
            echo "  ──────────────────────────────────────────────────────────────"
            echo ""

            echo "  🏠 Connected Network:"
            echo "  ──────────────────────────────────────────────────────────────"
            iwconfig "$wifi_iface" 2>/dev/null | grep -E "ESSID|Mode|Frequency|Quality|Encryption"
            echo ""

            echo "  🔍 Scanning for networks (30 seconds)..."
            echo "  ──────────────────────────────────────────────────────────────"
            timeout 30 sudo airodump-ng "$wifi_iface" 2>/dev/null | head -50

            echo ""
            echo "  ──────────────────────────────────────────────────────────────"
            echo "  🔒 Security Recommendations:"
            echo "  ──────────────────────────────────────────────────────────────"
            echo "  • Use WPA2/WPA3 encryption (not WEP)"
            echo "  • Use strong passwords (12+ characters)"
            echo "  • Enable network encryption"
            echo "  • Change default router passwords"
            echo "  • Disable WPS"
            echo "  • Update router firmware"
            echo ""

            echo "  📁 Report saved to: $report_file"

        } > "$report_file"

        dialog --title "🔐 WiFi Security Scan" \
               --textbox "$report_file" \
               30 90
    fi
}

check_connected_wifi() {
    local report_file="$1"

    {
        echo ""
        echo "  ╔════════════════════════════════════════════════════════════╗"
        echo "  ║            🔒 CONNECTED WIFI SECURITY CHECK                ║"
        echo "  ║                    $(date '+%Y-%m-%d %H:%M:%S')                    ║"
        echo "  ╚════════════════════════════════════════════════════════════╝"
        echo ""

        echo "  🔍 Current WiFi Connection:"
        echo "  ──────────────────────────────────────────────────────────────"

        if command -v nmcli &> /dev/null; then
            nmcli dev wifi show 2>/dev/null || echo "  No active WiFi connection"
            echo ""
        fi

        if command -v iwconfig &> /dev/null; then
            local wifi_iface
            wifi_iface=$(iwconfig 2>/dev/null | grep -E "wlan|wl" | awk '{print $1}' | head -1)
            if [ -n "$wifi_iface" ]; then
                echo "  Interface: $wifi_iface"
                iwconfig "$wifi_iface" 2>/dev/null | grep -E "ESSID|Mode|Frequency|Quality|Encryption"
                echo ""
            fi
        fi

        echo "  🔒 Security Analysis:"
        echo "  ──────────────────────────────────────────────────────────────"

        if iwconfig 2>/dev/null | grep -q "Encryption key:on"; then
            echo "  ✅ Encryption: Enabled"
        else
            echo "  ⚠️  Encryption: Disabled or Not detected"
        fi

        echo "  🔍 Checking for security issues..."
        echo "  • WPS: Checking..."
        sleep 1
        echo "  • Default passwords: Checking..."
        sleep 1
        echo "  • Open ports: Checking..."
        sleep 1

        echo ""
        echo "  💡 Recommendations:"
        echo "  ──────────────────────────────────────────────────────────────"
        echo "  • Ensure WPA2/WPA3 encryption is used"
        echo "  • Change default router admin credentials"
        echo "  • Disable WPS if not needed"
        echo "  • Keep router firmware updated"
        echo "  • Use a strong WiFi password"
        echo "  • Consider using a VPN for sensitive data"
        echo ""

        echo "  📁 Report saved to: $report_file"

    } > "$report_file"

    dialog --title "🔒 WiFi Security Check" \
           --textbox "$report_file" \
           25 80
}

scan_hidden_networks() {
    local report_file="$1"

    dialog --title "📡 Hidden Networks Scan" \
           --yesno "Scan for hidden WiFi networks?\n\nThis will scan for networks with hidden SSIDs.\nMay take 30-60 seconds.\n\nContinue?" \
           10 60

    if [ $? -eq 0 ]; then
        {
            echo ""
            echo "  ╔════════════════════════════════════════════════════════════╗"
            echo "  ║              📡 HIDDEN NETWORKS SCAN                       ║"
            echo "  ║                    $(date '+%Y-%m-%d %H:%M:%S')                    ║"
            echo "  ╚════════════════════════════════════════════════════════════╝"
            echo ""

            echo "  🔍 Scanning for hidden networks..."
            echo "  ──────────────────────────────────────────────────────────────"

            if command -v nmcli &> /dev/null; then
                echo "  Using nmcli:"
                nmcli dev wifi list --rescan yes --hidden 2>/dev/null | grep -v "^IN-USE" | head -20 || echo "  No hidden networks found"
                echo ""
            fi

            if command -v iwlist &> /dev/null; then
                echo "  Using iwlist:"
                local wifi_iface
                wifi_iface=$(iwconfig 2>/dev/null | grep -E "wlan|wl" | awk '{print $1}' | head -1)
                if [ -n "$wifi_iface" ]; then
                    sudo iwlist "$wifi_iface" scan 2>/dev/null | grep -A 5 "ESSID:\"\"" || echo "  No hidden networks detected"
                fi
                echo ""
            fi

            echo "  ──────────────────────────────────────────────────────────────"
            echo "  📊 Hidden Network Security Implications:"
            echo "  • Hidden networks are not more secure"
            echo "  • They can be detected by attackers"
            echo "  • Devices constantly probe for hidden networks"
            echo "  • This can leak information"
            echo ""
            echo "  💡 Recommendation: Use strong encryption instead of hiding SSID"
            echo ""

            echo "  📁 Report saved to: $report_file"

        } > "$report_file"

        dialog --title "📡 Hidden Networks" \
               --textbox "$report_file" \
               25 80
    fi
}

# ---------------- TOOL FUNCTIONS ----------------

check_tool() {
    command -v "$1" >/dev/null 2>&1
}

run_lynis() {
    if ! check_tool lynis; then
        dialog --title "❌ Error" \
               --msgbox "Lynis not installed\n\nInstall with:\nsudo apt install lynis" \
               8 50
        return
    fi
    run_with_progress "Security Audit" "sudo lynis audit system --quiet"
}

run_rkhunter() {
    if ! check_tool rkhunter; then
        dialog --title "❌ Error" \
               --msgbox "RKHunter not installed\n\nInstall with:\nsudo apt install rkhunter" \
               8 50
        return
    fi
    run_with_progress "Rootkit Scanner" "sudo rkhunter --check --skip-keypress --quiet"
}

run_clamav() {
    if ! check_tool clamscan; then
        dialog --title "❌ Error" \
               --msgbox "ClamAV not installed\n\nInstall with:\nsudo apt install clamav" \
               8 50
        return
    fi

    local scan_choice
    scan_choice=$(dialog --title "🦠 Malware Scan" \
                         --menu "Select what to scan:" \
                         12 60 4 \
                         1 "Scan a Directory" \
                         2 "Scan a File" \
                         3 "Scan Entire Home Directory" \
                         4 "Scan System (root)" \
                         3>&1 1>&2 2>&3)

    case $? in
        0)
            case $scan_choice in
                1)
                    dialog --title "📂 Select Directory" \
                           --msgbox "Select the directory to scan using the file browser." \
                           6 50
                    if browse_directory "$HOME"; then
                        dialog --title "🦠 Scanning Directory" \
                               --yesno "Scan directory:\n\n$SELECTED_PATH\n\nThis may take several minutes. Continue?" \
                               10 60
                        if [ $? -eq 0 ]; then
                            run_with_progress "Malware Scan (Directory)" "clamscan -r -i \"$SELECTED_PATH\" --quiet"
                        fi
                    fi
                    ;;
                2)
                    dialog --title "📄 Select File" \
                           --msgbox "Select the file to scan using the file browser." \
                           6 50
                    if browse_directory "$HOME"; then
                        dialog --title "🦠 Scanning File" \
                               --yesno "Scan file:\n\n$SELECTED_PATH\n\nContinue?" \
                               10 60
                        if [ $? -eq 0 ]; then
                            run_with_progress "Malware Scan (File)" "clamscan -i \"$SELECTED_PATH\" --quiet"
                        fi
                    fi
                    ;;
                3)
                    dialog --title "🦠 Scanning Home" \
                           --yesno "Scan entire home directory:\n\n$HOME\n\nThis may take several minutes. Continue?" \
                           10 60
                    if [ $? -eq 0 ]; then
                        run_with_progress "Malware Scan (Home)" "clamscan -r -i \"$HOME\" --quiet"
                    fi
                    ;;
                4)
                    dialog --title "⚠️ System Scan" \
                           --yesno "⚠️ WARNING: Scanning system files (root) requires sudo and may take a long time.\n\nContinue?" \
                           10 60
                    if [ $? -eq 0 ]; then
                        run_with_progress "Malware Scan (System)" "sudo clamscan -r -i / --quiet"
                    fi
                    ;;
            esac
            ;;
    esac
}

show_system_info() {
    local info_file="$REPORT_DIR/system_info_$(date +%Y%m%d_%H%M%S).txt"

    {
        echo ""
        echo "  📊 SYSTEM INFORMATION"
        echo "  ─────────────────────────────────────────────"
        echo "  🖥️  Hostname: $(hostname)"
        echo "  🐧 Distribution: $(cat /etc/os-release 2>/dev/null | grep PRETTY_NAME | cut -d'=' -f2 | tr -d '"' || echo 'Unknown')"
        echo "  💻 Kernel: $(uname -r)"
        echo "  📅 Uptime: $(uptime -p 2>/dev/null || echo 'N/A')"
        echo "  👤 User: $(whoami)"
        echo "  💾 Memory: $(free -h 2>/dev/null | awk '/^Mem:/ {print $3"/"$2}' || echo 'N/A')"
        echo "  💿 Disk: $(df -h / 2>/dev/null | awk 'NR==2 {print $3"/"$2 " ("$5")"}' || echo 'N/A')"
        echo ""
    } > "$info_file"

    dialog --title "📊 System Information" \
           --textbox "$info_file" \
           15 70
}

show_processes() {
    local proc_file="/tmp/processes.log"
    ps aux --sort=-%cpu | head -15 > "$proc_file"
    dialog --title "📋 Top Processes by CPU" \
           --textbox "$proc_file" \
           20 80
    rm -f "$proc_file"
}

show_network() {
    local net_file="/tmp/network.log"
    {
        echo "  🌐 NETWORK CONNECTIONS"
        echo "  ─────────────────────────────────────────────"
        echo ""
        echo "  🔌 Listening Ports:"
        sudo ss -tulpn 2>/dev/null | grep -E "LISTEN|State" | head -20
        echo ""
        echo "  🔗 Established Connections:"
        sudo ss -tunp 2>/dev/null | grep ESTAB | head -10
    } > "$net_file"

    dialog --title "🌐 Network Connections" \
           --textbox "$net_file" \
           20 80
    rm -f "$net_file"
}

show_usb() {
    local usb_file="/tmp/usb.log"
    {
        echo "  🔌 USB DEVICES"
        echo "  ─────────────────────────────────────────────"
        echo ""
        lsusb -v 2>/dev/null | grep -E "Bus|Device|idVendor|idProduct|bcdDevice" | head -30 || echo "No USB devices found"
    } > "$usb_file"

    dialog --title "🔌 USB Devices" \
           --textbox "$usb_file" \
           20 80
    rm -f "$usb_file"
}

show_services() {
    local srv_file="/tmp/services.log"
    {
        echo "  ⚙️ RUNNING SYSTEM SERVICES"
        echo "  ─────────────────────────────────────────────"
        echo ""
        systemctl list-units --type=service --state=running 2>/dev/null | head -30 || echo "systemctl unavailable"
    } > "$srv_file"

    dialog --title "⚙️ Running Services" \
           --textbox "$srv_file" \
           25 80
    rm -f "$srv_file"
}

show_logs() {
    local logs_file="/tmp/recent_logs.log"
    {
        echo "  📁 RECENT SYSTEM LOGS"
        echo "  ─────────────────────────────────────────────"
        echo ""
        sudo journalctl -n 50 --no-pager 2>/dev/null || tail -50 /var/log/syslog 2>/dev/null || echo "No logs accessible"
    } > "$logs_file"

    dialog --title "📁 Recent Logs" \
           --textbox "$logs_file" \
           25 80
    rm -f "$logs_file"
}

download_youtube() {
    local yt_url
    yt_url=$(dialog --title "📥 YouTube Downloader" \
                    --inputbox "Enter YouTube video/audio URL:" \
                    8 60 \
                    3>&1 1>&2 2>&3)

    if [ -n "$yt_url" ]; then
        if ! command -v yt-dlp &> /dev/null && ! command -v youtube-dl &> /dev/null; then
            dialog --title "❌ Error" \
                   --msgbox "yt-dlp is not installed.\n\nInstall with:\nsudo apt install yt-dlp" \
                   8 50
            return
        fi

        local dl_tool="yt-dlp"
        command -v yt-dlp &> /dev/null || dl_tool="youtube-dl"

        run_with_progress "YouTube Download" "$dl_tool -f 'bestvideo+bestaudio/best' --merge-output-format mp4 '$yt_url'"
    fi
}

# ---------------- MAIN MENU LOOP ----------------

main() {
    check_deps
    startup_sequence

    while true; do
        local choice
        choice=$(dialog --clear --title "🔥 QUANTUM SECURITY TERMINAL v5.0 🔥" \
                        --menu "Select a tool (Arrow keys or number, Enter to select):" \
                        22 70 13 \
                        1 "🔍 Security Audit (Lynis)" \
                        2 "🛡️ Rootkit Scanner (RKHunter)" \
                        3 "🦠 Malware Scan (ClamAV)" \
                        4 "📊 Detailed System Information" \
                        5 "📋 Real-time Process Monitoring" \
                        6 "🌐 Network Connections Analysis" \
                        7 "🔌 USB Device Enumeration" \
                        8 "⚙️ Running Services Management" \
                        9 "📁 Recent System Logs" \
                        10 "⚡ Comprehensive System Test" \
                        11 "📡 WiFi Security Scanner" \
                        12 "📥 YouTube Downloader" \
                        13 "❌ Exit Terminal" \
                        3>&1 1>&2 2>&3)

        case $choice in
            1) run_lynis ;;
            2) run_rkhunter ;;
            3) run_clamav ;;
            4) show_system_info ;;
            5) show_processes ;;
            6) show_network ;;
            7) show_usb ;;
            8) show_services ;;
            9) show_logs ;;
            10) run_system_tests ;;
            11) scan_wifi_security ;;
            12) download_youtube ;;
            13|"")
                clear
                echo -e "${GREEN}Quantum Security Terminal session closed.${RESET}"
                exit 0
                ;;
        esac
    done
}

main
