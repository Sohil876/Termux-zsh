#!/data/data/com.termux/files/usr/bin/bash
# Welcome message
echo -e "
$(toilet -t -f smslant -F crop Termux)

v${TERMUX_VERSION} | ${TERMUX_APK_RELEASE}

Working with packages:
  Search:  pkg search <query>
  Install: pkg install <package>
  Update:  pkg update
Subscribing to additional repos:
  Root:    pkg install root-repo
  X11:     pkg install x11-repo
For fixing any repository issues:
  Try \e[4mtermux-change-repo\e[0m command
"