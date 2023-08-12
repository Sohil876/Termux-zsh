#!/data/data/com.termux/files/usr/bin/bash
# Vars
if [ -n "${TERMUX_VERSION}" ]; then
	T_APP_VERSION="\nv${TERMUX_VERSION}"
elif [ -n "${TERMUX_APP__VERSION_NAME}" ]; then
	T_APP_VERSION="\nv${TERMUX_APP__VERSION_NAME}"
fi
if [ -n "${TERMUX_APK_RELEASE}" ]; then
	T_APK_RELEASE="\e[0;32m|\033[0m ${TERMUX_APK_RELEASE}"
elif [ -n "${TERMUX_APP__APK_RELEASE}" ]; then
	T_APK_RELEASE="\e[0;32m|\033[0m ${TERMUX_APP__APK_RELEASE}"
fi
if [ -n "${T_APP_VERSION}" ] || [ -n "${T_APK_RELEASE}" ]; then
	nl="\n"
fi
# Welcome message
echo -e "\e[0;32m$(toilet -t -f smslant -F crop Termux)\033[0m
${T_APP_VERSION} ${T_APK_RELEASE}${nl}
\e[0;32mWorking with packages\033[0m:
  Search:  pkg search <query>
  Install: pkg install <package>
  Update:  pkg update
\e[0;32mSubscribing to additional repos\033[0m:
  Root:    pkg install root-repo
  X11:     pkg install x11-repo
\e[0;32mFor fixing any repository issues\033[0m:
  Try \e[4mtermux-change-repo\e[0m command\n"
