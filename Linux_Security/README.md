# 🔐 Linux Security Toolkit

> **A lightweight, interactive Bash toolkit for Linux system security, diagnostics, scanning, and network analysis.**

[![Linux](https://img.shields.io/badge/OS-Linux-FCC624?style=for-the-badge\&logo=linux\&logoColor=black)](https://www.linux.org/)
[![Bash](https://img.shields.io/badge/Bash-4%2B-121011?style=for-the-badge\&logo=gnu-bash\&logoColor=white)](https://www.gnu.org/software/bash/)
[![ShellCheck](https://img.shields.io/badge/ShellCheck-compatible-blue?style=for-the-badge)](https://www.shellcheck.net/)

**Scan. Inspect. Analyze. Understand your Linux system — from one terminal.**

---

## ⚡ What is this?

**Linux Security Toolkit** is a Bash-based utility designed to bring commonly used Linux security and diagnostic tasks into a single interactive terminal environment.

Instead of remembering dozens of commands and tools, the project provides a centralized interface for running security-related checks and system utilities.

It's built with a simple philosophy:

```text
One terminal → Multiple security tools → Simple workflow
```

---

## 🛡️ Features

### 🦠 Security & Malware

* Malware/security scanning
* System security checks
* Suspicious-file analysis
* Security-related utilities

### 📡 Network & WiFi

* Network analysis
* WiFi-related diagnostics
* Network information
* Connectivity inspection

### 📁 File Analysis

* File scanning
* File/system inspection
* Useful file-related security checks

### ⚙️ System Diagnostics

* System information
* Hardware/software inspection
* Environment information
* Linux configuration checks

### ▶️ Utility Tools

* Additional terminal utilities
* Media/download functionality
* Dependency management

> **Note:** Available functionality depends on the tools installed on your system.

---

## 🚀 Installation

Clone the repository:

```bash
git clone https://github.com/i-m-klaa/Linux.git
```

Enter the project:

```bash
cd Linux/Linux_Security
```

Move the scripts to your home directory:

```bash
mv depend_installer.sh scaner.sh ~/
```

Make the dependency installer executable:

```bash
chmod +x ~/depend_installer.sh
```

Run it:

```bash
~/depend_installer.sh
```

---

## ⚡ Quick Setup

If both scripts are already in your `~/Downloads` folder:

```bash
cd ~/Downloads && mv depend_installer.sh scaner.sh ~/ && chmod +x ~/depend_installer.sh && ~/depend_installer.sh
```

---

## 🎯 Usage

After installation, run the scanner from your home directory:

```bash
chmod +x ~/scaner.sh
~/scaner.sh
```

Follow the interactive terminal interface and select the tool or scan you want to run.

---

## 📂 Project Structure

```text
Linux_Security/
│
├── README.md
├── depend_installer.sh
└── scaner.sh
```

### `depend_installer.sh`

Handles installation and preparation of required dependencies.

### `scaner.sh`

Main interactive security and system utility script.

---

## 🐧 Linux Compatibility

The project is designed for Linux environments.

Package-management commands may differ between distributions.

| Distribution Family             | Package Manager |
| ------------------------------- | --------------- |
| Debian / Ubuntu / Kali / Parrot | `apt`           |
| Fedora / RHEL                   | `dnf`           |
| Arch / Manjaro                  | `pacman`        |
| openSUSE                        | `zypper`        |
| Alpine                          | `apk`           |

> Distribution compatibility depends on the dependencies used by individual features.

---

## ⚠️ Security & Responsible Use

This project is intended for:

* System administration
* Linux security learning
* Defensive security testing
* Personal systems
* Authorized environments
* Security research and education

**Only use security and network-related functionality on systems and networks you own or have explicit permission to test.**

Some utilities may require `sudo` privileges.

Always review scripts before executing them with elevated privileges.

---

## 🔍 Why Bash?

The project intentionally uses Bash because it is:

* Available on most Linux systems
* Lightweight
* Easy to inspect
* Easy to modify
* Excellent for system administration
* Well suited for combining existing Linux security utilities

The goal is not to replace specialized security tools.

**The goal is to provide a convenient interface around them.**

---

## 🧰 Dependencies

The exact dependencies are handled by:

```bash
depend_installer.sh
```

The installer is intended to simplify setup by preparing the required command-line tools.

If a dependency fails to install, check your distribution's package manager and verify that your repositories are configured correctly.

---

## 🧪 Project Status

🚧 **Active development**

This project is still evolving.

Possible future improvements include:

* [ ] Better distribution detection
* [ ] Improved dependency handling
* [ ] More security checks
* [ ] Better error handling
* [ ] Logging/report generation
* [ ] Configuration support
* [ ] More modular architecture
* [ ] Improved portability
* [ ] Additional Linux security utilities

Suggestions and contributions are welcome.

---

## 🤝 Contributing

Found a bug?

Have an improvement?

Want to add another Linux security utility?

Feel free to:

1. Fork the repository
2. Create a branch
3. Make your changes
4. Test your changes
5. Open a pull request

For larger changes, opening an issue first is recommended.

---

## ⭐ Support the Project

If you find this project useful:

⭐ **Star the repository**

🐛 **Report bugs**

💡 **Suggest features**

🔧 **Contribute improvements**

Sharing the project with other Linux users also helps.

---

## 📜 License

See the repository for licensing information.

---

<div align="center">

### 🐧 Built for Linux.

### 🔐 Built for security-minded users.

### ⚡ Built in Bash.

**If you like terminal-based Linux tools, give it a try.**

</div>
