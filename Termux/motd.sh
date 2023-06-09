#!/data/data/com.termux/files/usr/bin/bash
# Welcome message
echo -e "\e[0;32m$(toilet -t -f smslant -F crop Termux)\033[0m\n
v${TERMUX_VERSION} \e[0;32m|\033[0m ${TERMUX_APK_RELEASE}\n
\e[0;32mWorking with packages\033[0m:
  Search:  pkg search <query>
  Install: pkg install <package>
  Update:  pkg update
\e[0;32mSubscribing to additional repos\033[0m:
  Root:    pkg install root-repo
  X11:     pkg install x11-repo
\e[0;32mFor fixing any repository issues\033[0m:
  Try \e[4mtermux-change-repo\e[0m command\n"