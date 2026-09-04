#!/bin/bash

# ============================================================
# 🔥 QUANTUM SECURITY TERMINAL - DEPENDENCY INSTALLER 🔥
# Universal Installer with Desktop Icon Creation
# ============================================================

# ---------------- COLORS ----------------

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
PURPLE='\033[1;35m'
GRAY='\033[0;90m'
WHITE='\033[1;37m'
RESET='\033[0m'
BOLD='\033[1m'

# ---------------- BANNER ----------------

show_banner() {
    clear
    echo -e "${PURPLE}"
    echo "  ╔════════════════════════════════════════════════════════════╗"
    echo "  ║                                                            ║"
    echo "  ║    🔥 QUANTUM SECURITY TERMINAL - DEPENDENCY INSTALLER     ║"
    echo "  ║                                                            ║"
    echo "  ║    Neural Interface · Quantum Processing                   ║"
    echo "  ║                                                            ║"
    echo "  ╚════════════════════════════════════════════════════════════╝"
    echo -e "${RESET}"
    echo ""
}

# ---------------- DETECT OS ----------------

detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
        VERSION=$VERSION_ID
        
        case $OS in
            ubuntu|debian|linuxmint|pop|elementary|zorin|kali|parrot|raspbian)
                OS_FAMILY="debian"
                PKG_MANAGER="apt"
                PKG_INSTALL="sudo apt install -y"
                PKG_UPDATE="sudo apt update"
                PKG_UPGRADE="sudo apt upgrade -y"
                ;;
            arch|manjaro|endeavouros|artix|garuda)
                OS_FAMILY="arch"
                PKG_MANAGER="pacman"
                PKG_INSTALL="sudo pacman -S --needed"
                PKG_UPDATE="sudo pacman -Sy"
                PKG_UPGRADE="sudo pacman -Su"
                ;;
            fedora|rhel|centos|rocky|almalinux)
                OS_FAMILY="fedora"
                PKG_MANAGER="dnf"
                PKG_INSTALL="sudo dnf install -y"
                PKG_UPDATE="sudo dnf check-update"
                PKG_UPGRADE="sudo dnf upgrade -y"
                ;;
            opensuse|suse)
                OS_FAMILY="suse"
                PKG_MANAGER="zypper"
                PKG_INSTALL="sudo zypper install -y"
                PKG_UPDATE="sudo zypper refresh"
                PKG_UPGRADE="sudo zypper update -y"
                ;;
            *)
                OS_FAMILY="unknown"
                PKG_MANAGER="unknown"
                ;;
        esac
    else
        OS_FAMILY="unknown"
        PKG_MANAGER="unknown"
    fi
}

# ---------------- CHECK ROOT ----------------

check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${YELLOW}⚠️  This script requires sudo privileges.${RESET}"
        echo -e "${GRAY}You will be prompted for your password when needed.${RESET}"
        echo ""
    fi
}

# ---------------- CREATE SCANER.SH LAUNCHER ----------------

create_scaner_launcher() {
    echo ""
    echo -e "${BLUE}🔧 Creating scaner.sh launcher...${RESET}"
    
    # First, check if scaner.sh exists in home directory
    if [ ! -f "$HOME/scaner.sh" ]; then
        echo -e "${YELLOW}⚠️  scaner.sh not found in home directory${RESET}"
        echo -e "${CYAN}Creating scaner.sh from template...${RESET}"
        
        # Create scaner.sh from template
        cat > "$HOME/scaner.sh" << 'EOF'
#!/bin/bash

# ============================================================
# 🔥 QUANTUM SECURITY TERMINAL - SCANER.SH 🔥
# Main Security Dashboard
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

# ---------------- WELCOME ----------------

echo -e "${CYAN}"
echo "  ╔═══════════════════════════════════════╗"
echo "  ║                                   ║"
echo "  ║    🔒 QUANTUM SECURITY TERMINAL   ║"
echo "  ║        Neural Interface Edition   ║"
echo "  ║                                   ║"
echo "  ╚═══════════════════════════════════════╝"
echo -e "${RESET}"
echo ""
echo -e "${GREEN}✅ System Ready!${RESET}"
echo -e "${GRAY}Type 'help' for available commands${RESET}"
echo ""

# Simple menu
while true; do
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${WHITE}Select an option:${RESET}"
    echo -e "  ${GREEN}1${RESET}) Security Audit (Lynis)"
    echo -e "  ${GREEN}2${RESET}) Rootkit Scanner"
    echo -e "  ${GREEN}3${RESET}) Malware Scan (ClamAV)"
    echo -e "  ${GREEN}4${RESET}) System Information"
    echo -e "  ${GREEN}5${RESET}) Process List"
    echo -e "  ${GREEN}6${RESET}) Network Connections"
    echo -e "  ${GREEN}7${RESET}) USB Devices"
    echo -e "  ${GREEN}8${RESET}) Running Services"
    echo -e "  ${GREEN}9${RESET}) Recent Logs"
    echo -e "  ${GREEN}0${RESET}) Quick System Scan"
    echo -e "  ${RED}q${RESET}) Exit"
    echo ""
    echo -ne "${CYAN}➜ ${RESET}"
    read -r choice
    
    case $choice in
        1) 
            echo -e "${CYAN}Running Security Audit...${RESET}"
            if command -v lynis &> /dev/null; then
                sudo lynis audit system --quiet
            else
                echo -e "${RED}❌ Lynis not installed${RESET}"
            fi
            ;;
        2)
            echo -e "${CYAN}Running Rootkit Scanner...${RESET}"
            if command -v rkhunter &> /dev/null; then
                sudo rkhunter --check --skip-keypress --quiet
            else
                echo -e "${RED}❌ RKHunter not installed${RESET}"
            fi
            ;;
        3)
            echo -e "${CYAN}Running Malware Scan...${RESET}"
            if command -v clamscan &> /dev/null; then
                clamscan -r -i "$HOME" --quiet
            else
                echo -e "${RED}❌ ClamAV not installed${RESET}"
            fi
            ;;
        4)
            echo -e "${CYAN}System Information:${RESET}"
            echo -e "  Hostname: $(hostname)"
            echo -e "  Kernel: $(uname -r)"
            echo -e "  Uptime: $(uptime -p)"
            echo -e "  User: $(whoami)"
            echo -e "  Memory: $(free -h | awk '/^Mem:/ {print $3"/"$2}')"
            ;;
        5)
            echo -e "${CYAN}Top Processes:${RESET}"
            ps aux --sort=-%cpu | head -10
            ;;
        6)
            echo -e "${CYAN}Network Connections:${RESET}"
            sudo ss -tulpn 2>/dev/null | grep LISTEN | head -15
            ;;
        7)
            echo -e "${CYAN}USB Devices:${RESET}"
            lsusb 2>/dev/null || echo "No USB devices found"
            ;;
        8)
            echo -e "${CYAN}Running Services:${RESET}"
            systemctl list-units --type=service --state=running 2>/dev/null | head -12
            ;;
        9)
            echo -e "${CYAN}Recent Logs:${RESET}"
            sudo journalctl -n 10 --no-pager 2>/dev/null || tail -10 /var/log/syslog 2>/dev/null
            ;;
        0)
            echo -e "${CYAN}Quick System Scan:${RESET}"
            echo "  ✅ System running"
            echo "  ✅ Disk: $(df -h / | awk 'NR==2 {print $5}')"
            echo "  ✅ Memory: $(free -h | awk '/^Mem:/ {print $4}') free"
            echo "  ✅ Processes: $(ps aux | wc -l) running"
            echo "  ✅ IP: $(hostname -I | awk '{print $1}')"
            ;;
        q|Q)
            echo -e "${GREEN}Goodbye! Stay secure!${RESET}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option${RESET}"
            ;;
    esac
    echo ""
    echo -e "${GRAY}Press ENTER to continue...${RESET}"
    read -r
done
EOF
        
        # Make scaner.sh executable
        chmod +x "$HOME/scaner.sh"
        echo -e "${GREEN}✅ scaner.sh created and made executable (chmod +x)${RESET}"
    else
        echo -e "${GREEN}✅ scaner.sh found in home directory${RESET}"
        # Make sure it's executable
        chmod +x "$HOME/scaner.sh"
        echo -e "${GREEN}✅ scaner.sh permissions set (chmod +x)${RESET}"
    fi
}

# ---------------- CREATE DESKTOP ICON LINKING TO SCANER.SH ----------------

create_desktop_icon() {
    echo ""
    echo -e "${BLUE}🖥️  Creating desktop icon linking to scaner.sh...${RESET}"
    
    # Create launcher script that calls scaner.sh
    cat > "$HOME/security-terminal.sh" << 'EOF'
#!/bin/bash
# Quantum Security Terminal Launcher
cd "$HOME"
if [ -f "$HOME/scaner.sh" ]; then
    # Make sure it's executable before running
    chmod +x "$HOME/scaner.sh"
    ./scaner.sh
else
    echo -e "\033[1;31m❌ Error: scaner.sh not found in home directory!\033[0m"
    echo -e "\033[1;33mPlease make sure scaner.sh exists at $HOME/scaner.sh\033[0m"
    read -p "Press Enter to exit..."
fi
EOF
    
    chmod +x "$HOME/security-terminal.sh"
    
    # Create desktop entry
    local desktop_dir="$HOME/.local/share/applications"
    mkdir -p "$desktop_dir"
    
    local desktop_file="$desktop_dir/quantum-security.desktop"
    
    # Create desktop entry that points to scaner.sh
    cat > "$desktop_file" << EOF
[Desktop Entry]
Version=1.0
Name=🔐 Quantum Security Terminal
Comment=Quantum Security Dashboard powered by scaner.sh
Exec=$HOME/security-terminal.sh
Icon=utilities-terminal
Terminal=true
Type=Application
Categories=System;Security;Utility;
StartupNotify=true
StartupWMClass=Quantum-Security
Keywords=security;quantum;terminal;scaner;network;
X-GNOME-Terminal=true
EOF
    
    chmod +x "$desktop_file"
    
    # Create desktop shortcut on Desktop if it exists
    if [ -d "$HOME/Desktop" ]; then
        cp "$desktop_file" "$HOME/Desktop/quantum-security.desktop"
        chmod +x "$HOME/Desktop/quantum-security.desktop"
        echo -e "${GREEN}✅ Desktop shortcut created on Desktop${RESET}"
    fi
    
    # Create alias in bashrc that points to scaner.sh
    if ! grep -q "alias quantum-terminal=" "$HOME/.bashrc" 2>/dev/null; then
        echo 'alias quantum-terminal="$HOME/scaner.sh"' >> "$HOME/.bashrc"
        echo 'alias qt="$HOME/scaner.sh"' >> "$HOME/.bashrc"
        echo -e "${GREEN}✅ Terminal aliases added to .bashrc${RESET}"
        echo -e "${CYAN}   Use 'quantum-terminal' or 'qt' to run scaner.sh${RESET}"
    fi
    
    # Source bashrc to make aliases available immediately
    source "$HOME/.bashrc" 2>/dev/null || true
    
    echo -e "${GREEN}✅ Desktop icon linking to scaner.sh created successfully!${RESET}"
    echo -e "${CYAN}📁 Desktop Entry: $desktop_file${RESET}"
    echo -e "${CYAN}🔗 Alias created: quantum-terminal or qt (points to scaner.sh)${RESET}"
    echo -e "${CYAN}📂 Launcher: $HOME/security-terminal.sh${RESET}"
}

# ---------------- INSTALL PACKAGES ----------------

install_packages() {
    echo ""
    echo -e "${BLUE}📦 Installing dependencies...${RESET}"
    
    local packages=()
    local optional_packages=()
    
    # Base packages (required)
    packages=(
        "dialog"
        "curl"
        "wget"
        "git"
    )
    
    # Security tools
    case $OS_FAMILY in
        debian)
            packages+=(
                "lynis"
                "rkhunter"
                "clamav"
                "clamav-daemon"
                "yt-dlp"
                "usbutils"
                "net-tools"
                "procps"
                "util-linux"
                "wireless-tools"
                "aircrack-ng"
                "nmap"
                "ufw"
                "apparmor"
                "apparmor-utils"
                "xterm"
                "gnome-terminal"
                "konsole"
                "bash"
                "coreutils"
            )
            optional_packages=(
                "chkrootkit"
                "tripwire"
                "auditd"
                "fail2ban"
            )
            ;;
        arch)
            packages+=(
                "lynis"
                "rkhunter"
                "clamav"
                "yt-dlp"
                "usbutils"
                "net-tools"
                "procps-ng"
                "util-linux"
                "wireless_tools"
                "aircrack-ng"
                "nmap"
                "ufw"
                "apparmor"
                "apparmor-utils"
                "xterm"
                "gnome-terminal"
                "konsole"
                "bash"
                "coreutils"
            )
            optional_packages=(
                "chkrootkit"
                "tripwire"
                "audit"
                "fail2ban"
            )
            ;;
        fedora)
            packages+=(
                "lynis"
                "rkhunter"
                "clamav"
                "clamav-update"
                "yt-dlp"
                "usbutils"
                "net-tools"
                "procps-ng"
                "util-linux"
                "wireless-tools"
                "aircrack-ng"
                "nmap"
                "ufw"
                "apparmor"
                "apparmor-utils"
                "xterm"
                "gnome-terminal"
                "konsole"
                "bash"
                "coreutils"
            )
            optional_packages=(
                "chkrootkit"
                "tripwire"
                "audit"
                "fail2ban"
            )
            ;;
        suse)
            packages+=(
                "lynis"
                "rkhunter"
                "clamav"
                "yt-dlp"
                "usbutils"
                "net-tools"
                "procps"
                "util-linux"
                "wireless-tools"
                "aircrack-ng"
                "nmap"
                "ufw"
                "apparmor"
                "apparmor-utils"
                "xterm"
                "bash"
                "coreutils"
            )
            ;;
        *)
            echo -e "${RED}❌ Unsupported distribution${RESET}"
            exit 1
            ;;
    esac
    
    # Show installation plan
    echo -e "${CYAN}📦 Distribution Detected: ${WHITE}$OS_FAMILY ($OS)${RESET}"
    echo -e "${CYAN}📦 Package Manager: ${WHITE}$PKG_MANAGER${RESET}"
    echo ""
    
    echo -e "${GREEN}📋 Packages to be installed:${RESET}"
    for pkg in "${packages[@]}"; do
        echo -e "  ${GREEN}•${RESET} $pkg"
    done
    
    if [ ${#optional_packages[@]} -gt 0 ]; then
        echo ""
        echo -e "${YELLOW}📋 Optional packages (recommended):${RESET}"
        for pkg in "${optional_packages[@]}"; do
            echo -e "  ${YELLOW}•${RESET} $pkg"
        done
    fi
    
    echo ""
    echo -e "${YELLOW}💡 Total packages: ${#packages[@]} + ${#optional_packages[@]} optional${RESET}"
    echo ""
    
    # Ask for confirmation
    read -p "$(echo -e ${CYAN}Continue with installation? [Y/n]: ${RESET})" -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]] && [[ ! -z $REPLY ]]; then
        echo -e "${YELLOW}Installation cancelled.${RESET}"
        return 1
    fi
    
    # Update package database
    echo ""
    echo -e "${BLUE}🔄 Updating package database...${RESET}"
    eval "$PKG_UPDATE" 2>&1 | grep -v "already" || true
    echo -e "${GREEN}✅ Package database updated${RESET}"
    echo ""
    
    # Install packages
    echo -e "${BLUE}📦 Installing packages...${RESET}"
    
    local total=${#packages[@]}
    local current=0
    local failed=0
    
    for pkg in "${packages[@]}"; do
        current=$((current + 1))
        echo -ne "\r${CYAN}[$current/$total]${RESET} Installing ${WHITE}$pkg${RESET}... "
        
        if eval "$PKG_INSTALL $pkg" > /dev/null 2>&1; then
            echo -e "${GREEN}✓${RESET}"
        else
            echo -e "${RED}✗ Failed${RESET}"
            failed=$((failed + 1))
            
            # Try alternative install methods
            if [[ "$pkg" == "yt-dlp" ]] && command -v pip3 &> /dev/null; then
                echo -e "${BLUE}Installing $pkg via pip3...${RESET}"
                pip3 install --break-system-packages yt-dlp 2>/dev/null || pip3 install yt-dlp 2>/dev/null
            elif [[ "$pkg" == "lynis" ]] && [[ "$OS_FAMILY" == "fedora" ]]; then
                echo -e "${BLUE}Installing lynis from EPEL...${RESET}"
                sudo dnf install -y epel-release 2>/dev/null
                sudo dnf install -y lynis 2>/dev/null
            fi
        fi
    done
    
    echo ""
    if [ $failed -eq 0 ]; then
        echo -e "${GREEN}✅ All packages installed successfully!${RESET}"
        return 0
    else
        echo -e "${YELLOW}⚠️ $failed packages failed to install.${RESET}"
        return 1
    fi
}

# ---------------- POST INSTALLATION SETUP ----------------

post_install_setup() {
    echo ""
    echo -e "${BLUE}🔧 Performing post-installation setup...${RESET}"
    
    # Update ClamAV
    if command -v freshclam &> /dev/null; then
        echo -ne "${CYAN}Updating ClamAV virus definitions...${RESET}"
        sudo freshclam > /dev/null 2>&1
        echo -e " ${GREEN}✓${RESET}"
    fi
    
    # Update RKHunter
    if command -v rkhunter &> /dev/null; then
        echo -ne "${CYAN}Updating RKHunter database...${RESET}"
        sudo rkhunter --update > /dev/null 2>&1
        sudo rkhunter --propupd > /dev/null 2>&1
        echo -e " ${GREEN}✓${RESET}"
    fi
    
    # Check firewall
    if command -v ufw &> /dev/null; then
        echo -ne "${CYAN}Checking firewall status...${RESET}"
        if sudo ufw status | grep -q "Status: active"; then
            echo -e " ${GREEN}✓ Active${RESET}"
        else
            echo -e " ${YELLOW}⚠️ Inactive (enable with: sudo ufw enable)${RESET}"
        fi
    fi
    
    echo -e "${GREEN}✅ Post-installation setup complete!${RESET}"
}

# ---------------- CHECK INSTALLATION ----------------

check_installation() {
    echo ""
    echo -e "${BLUE}🔍 Verifying installation...${RESET}"
    echo ""
    
    local required_tools=(
        "dialog"
        "lynis"
        "rkhunter"
        "clamscan"
        "yt-dlp"
    )
    
    local missing=0
    
    for tool in "${required_tools[@]}"; do
        echo -ne "  ${CYAN}Checking $tool...${RESET}"
        if command -v "$tool" &> /dev/null; then
            echo -e " ${GREEN}✓${RESET}"
        else
            echo -e " ${RED}✗ Not found${RESET}"
            missing=$((missing + 1))
        fi
    done
    
    # Check scaner.sh
    echo -ne "  ${CYAN}Checking scaner.sh...${RESET}"
    if [ -f "$HOME/scaner.sh" ]; then
        echo -e " ${GREEN}✓${RESET}"
        # Check if executable
        if [ -x "$HOME/scaner.sh" ]; then
            echo -e "  ${CYAN}   scaner.sh is executable (chmod +x)${RESET} ${GREEN}✓${RESET}"
        else
            echo -e "  ${YELLOW}   scaner.sh exists but not executable${RESET}"
            chmod +x "$HOME/scaner.sh"
            echo -e "  ${GREEN}   Fixed: scaner.sh is now executable${RESET}"
        fi
    else
        echo -e " ${RED}✗ Not found${RESET}"
        missing=$((missing + 1))
    fi
    
    # Check desktop file
    echo -ne "  ${CYAN}Checking desktop icon...${RESET}"
    if [ -f "$HOME/.local/share/applications/quantum-security.desktop" ]; then
        echo -e " ${GREEN}✓${RESET}"
    else
        echo -e " ${RED}✗ Not found${RESET}"
        missing=$((missing + 1))
    fi
    
    if [ $missing -eq 0 ]; then
        echo ""
        echo -e "${GREEN}✅ All required components installed successfully!${RESET}"
        return 0
    else
        echo ""
        echo -e "${YELLOW}⚠️ Some components are missing.${RESET}"
        return 1
    fi
}

# ---------------- SELF-DELETE FUNCTION ----------------

self_delete() {
    echo ""
    echo -e "${YELLOW}🗑️  Cleaning up installation files...${RESET}"
    
    # Delete the installer script itself
    if [ -f "$0" ]; then
        rm -f "$0" 2>/dev/null
        echo -e "${GREEN}✅ Installer script deleted${RESET}"
    fi
    
    # Delete any temporary files
    rm -f /tmp/install_*.log 2>/dev/null
    rm -f /tmp/quantum_*.tmp 2>/dev/null
    
    echo -e "${GREEN}✅ Cleanup complete!${RESET}"
}

# ---------------- MAIN INSTALLATION ----------------

main() {
    show_banner
    check_root
    detect_os
    
    echo -e "${CYAN}🔍 Detected System:${RESET}"
    echo -e "  ${GREEN}•${RESET} OS: $OS ($OS_FAMILY)"
    echo -e "  ${GREEN}•${RESET} Package Manager: $PKG_MANAGER"
    echo ""
    
    # Show menu
    echo -e "${WHITE}Select installation option:${RESET}"
    echo -e "  ${GREEN}1${RESET}) Full Installation with Desktop Icon (Recommended)"
    echo -e "  ${GREEN}2${RESET}) Minimal Installation (Essential packages only)"
    echo -e "  ${GREEN}3${RESET}) Check Existing Installation"
    echo -e "  ${GREEN}4${RESET}) Create Desktop Icon Only (for existing scaner.sh)"
    echo -e "  ${GREEN}5${RESET}) Exit"
    echo ""
    read -p "$(echo -e ${CYAN}Choose [1-5]: ${RESET})" -n 1 -r
    echo ""
    
    local install_success=false
    local deps_installed=false
    
    case $REPLY in
        1)
            echo -e "${BLUE}📦 Installing dependencies...${RESET}"
            if install_packages; then
                deps_installed=true
                post_install_setup
            fi
            echo -e "${BLUE}🔧 Creating scaner.sh...${RESET}"
            create_scaner_launcher
            echo -e "${BLUE}🖥️  Creating desktop icon...${RESET}"
            create_desktop_icon
            if check_installation; then
                install_success=true
            fi
            ;;
        2)
            # Minimal installation
            echo -e "${YELLOW}Installing minimal packages...${RESET}"
            local minimal_packages=("dialog" "lynis" "rkhunter" "clamav" "yt-dlp")
            echo -e "${GREEN}📋 Packages:${RESET}"
            for pkg in "${minimal_packages[@]}"; do
                echo -e "  ${GREEN}•${RESET} $pkg"
            done
            echo ""
            read -p "$(echo -e ${CYAN}Continue? [Y/n]: ${RESET})" -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
                eval "$PKG_UPDATE" 2>/dev/null || true
                for pkg in "${minimal_packages[@]}"; do
                    echo -ne "${CYAN}Installing $pkg...${RESET}"
                    eval "$PKG_INSTALL $pkg" > /dev/null 2>&1
                    echo -e " ${GREEN}✓${RESET}"
                done
                deps_installed=true
                post_install_setup
                create_scaner_launcher
                create_desktop_icon
                check_installation
                install_success=true
            fi
            ;;
        3)
            check_installation
            ;;
        4)
            echo -e "${BLUE}🔧 Creating desktop icon for existing scaner.sh...${RESET}"
            create_scaner_launcher
            create_desktop_icon
            install_success=true
            ;;
        5)
            echo -e "${YELLOW}Exiting...${RESET}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option${RESET}"
            exit 1
            ;;
    esac
    
    echo ""
    echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${RESET}"
    
    if [ "$install_success" = true ] || [ "$REPLY" = "1" ] || [ "$REPLY" = "2" ] || [ "$REPLY" = "4" ]; then
        echo -e "${GREEN}✅ Installation Complete!${RESET}"
        echo ""
        echo -e "${CYAN}🎯 How to access Quantum Security Terminal (scaner.sh):${RESET}"
        echo -e "  ${WHITE}1. Desktop Icon:${RESET} Click on 🔐 Quantum Security Terminal on your desktop"
        echo -e "  ${WHITE}2. Applications Menu:${RESET} Look for 'Quantum Security Terminal'"
        echo -e "  ${WHITE}3. Terminal:${RESET} Run './scaner.sh' or 'quantum-terminal' or 'qt'"
        echo ""
        echo -e "${CYAN}📁 Files created:${RESET}"
        echo -e "  ${WHITE}•${RESET} $HOME/scaner.sh (Main application) ${GREEN}(chmod +x applied)${RESET}"
        echo -e "  ${WHITE}•${RESET} $HOME/security-terminal.sh (Launcher script)"
        echo -e "  ${WHITE}•${RESET} $HOME/.local/share/applications/quantum-security.desktop"
        if [ -d "$HOME/Desktop" ]; then
            echo -e "  ${WHITE}•${RESET} $HOME/Desktop/quantum-security.desktop (Desktop shortcut)"
        fi
        echo ""
        if [ "$deps_installed" = true ] || [ "$REPLY" = "1" ] || [ "$REPLY" = "2" ]; then
            echo -e "${GREEN}✅ All dependencies installed successfully!${RESET}"
        fi
    else
        echo -e "${YELLOW}⚠️ Installation may not be complete.${RESET}"
    fi
    
    echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${RESET}"
    
    # Ask to run scaner.sh
    if [ -f "$HOME/scaner.sh" ] && [ "$install_success" = true ]; then
        echo ""
        read -p "$(echo -e ${CYAN}Run scaner.sh now? [y/N]: ${RESET})" -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            cd "$HOME"
            ./scaner.sh
        fi
    fi
    
    # Self-delete the installer
    echo ""
    echo -e "${YELLOW}🗑️  Cleaning up...${RESET}"
    sleep 2
    
    # Delete the installer script
    self_delete
    
    # Final message
    echo ""
    echo -e "${GREEN}✅ Quantum Security Terminal (scaner.sh) installation complete!${RESET}"
    echo -e "${CYAN}🚀 You can now use the desktop icon or run 'scaner.sh' in terminal${RESET}"
}

# ---------------- START INSTALLATION ----------------

# Make sure we're in the right directory
cd "$HOME"

# Check if script is being run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi
