#!/usr/bin/env bash
#
## Termux-zsh
#

# Color Codes
red="\e[0;31m"   # Red
green="\e[0;32m" # Green
nocol="\033[0m"  # Default

# Exit on error and trace commands
set -e
# set -x  # Uncomment for debugging

# Variables
WORKING_DIR="$(dirname "${BASH_SOURCE[0]}")"
LANG_CODE="en"

# Pre-scan all arguments for -l <lang_code> before loading lang files
for ((i = 1; i <= "${#}"; i++)); do
	arg="${!i}"
	next_index=$((i + 1))
	next_arg="${!next_index}"

	if [[ ${arg} == "-l" ]]; then
		if [[ -z ${next_arg} || ${next_arg} == -* ]]; then
			printf "${red}Missing language code after -l|--lang\n"
			printf "Use -ls to list available languages or -h for help${nocol}\n"
			exit 1
		fi
		lang_input="${next_arg,,}"
		if [[ -d "${WORKING_DIR}/Termux/lang/${lang_input}" ]]; then
			LANG_CODE="${lang_input}"
		else
			printf "${red}No localization found for language code${nocol} ${lang_input}\n"
			printf "${red}Check available languages with -ls or use -h for help${nocol}\n"
			exit 1
		fi
		break
	fi
done

# Load lang files
mapfile -t LANG_STRINGS < "${WORKING_DIR}/Termux/lang/${LANG_CODE}/setup.lang"
mapfile -t COMMON_STRINGS < "${WORKING_DIR}/Termux/lang/${LANG_CODE}/common.lang"

while [[ ${#} -gt 0 ]]; do
	case "${1}" in
		-ls)
			printf "${green}${COMMON_STRINGS[9]}${nocol}:\n"
			find "${WORKING_DIR}/Termux/lang" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;
			exit 0
			;;
		-h)
			printf "${green}${COMMON_STRINGS[10]}${nocol}: setup.sh [-l <${COMMON_STRINGS[12]}>]\n"
			printf "${green}${COMMON_STRINGS[11]}${nocol}:\n"
			printf "    -l <${COMMON_STRINGS[12]}> ${COMMON_STRINGS[13]}\n"
			printf "    -ls                ${COMMON_STRINGS[14]}\n"
			printf "    -h                 ${COMMON_STRINGS[15]}\n"
			exit 0
			;;
		*)
			shift
			;;
	esac
done

install_dependencies() {
	printf "${green}${LANG_STRINGS[0]}...${nocol}\n"
	apt update || {
		printf "${red}${LANG_STRINGS[1]}!${nocol}\n"
		exit 1
	}
	apt install -y termux-tools coreutils less fontconfig-utils git zsh figlet toilet lf curl wget micro man || {
		printf "${red}${LANG_STRINGS[1]}!${nocol}\n"
		exit 1
	}
}

configure_termux() {
	printf "${green}${LANG_STRINGS[2]}...${nocol}\n"
	if [ -d "${HOME}/.termux" ]; then
		install_date_time="$(date +"%Y-%m-%d_%H-%M-%S")"
		printf "${green}${LANG_STRINGS[3]}${nocol}: ${HOME}/.termux_bak_${install_date_time}\n"
		mv "${HOME}/.termux" "${HOME}/.termux_bak_${install_date_time}"
	fi
	cp -r "${WORKING_DIR}/Termux" "${HOME}/.termux" || {
		printf "${red}${LANG_STRINGS[4]}!${nocol}\n"
		exit 1
	}
	chmod +x "${HOME}/.termux/fonts.sh" "${HOME}/.termux/colors.sh"
	printf "${green}${LANG_STRINGS[5]}...${nocol}\n"
	ln -fs "${HOME}/.termux/colors/dark/IrBlack" "${HOME}/.termux/colors.properties"
	# Replacing termuxs boring welcome message with something good looking
	if [[ -f "${PREFIX}/etc/motd" ]]; then
		mv "${PREFIX}/etc/motd" "${PREFIX}/etc/motd.bak"
	fi
	if [[ -f "${PREFIX}/etc/motd.sh" ]]; then
		mv "${PREFIX}/etc/motd.sh" "${PREFIX}/etc/motd.sh.bak"
	fi
	ln -sf "${HOME}/.termux/motd.sh" "${PREFIX}/etc/motd.sh"
}

install_ohmyzsh() {
	printf "${green}${LANG_STRINGS[6]}...${nocol}\n"
	git clone https://github.com/ohmyzsh/ohmyzsh.git "${HOME}/.oh-my-zsh"
	printf "${green}${LANG_STRINGS[7]}...${nocol}\n"
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/themes/powerlevel10k"
	printf "${green}${LANG_STRINGS[8]}...${nocol}\n"
	git clone https://github.com/zsh-users/zsh-autosuggestions.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
	printf "${green}${LANG_STRINGS[9]}...${nocol}\n"
	cp -f "${WORKING_DIR}/OhMyZsh/zshrc" "${HOME}/.zshrc"
	if [[ "$(dpkg --print-architecture)" == "arm" ]]; then
		printf "${green}${LANG_STRINGS[10]}!${nocol}\n"
		# There's no binaries of gitstatus for armv7 right now so disable it
		printf "\n# Disable gitstatus for now (Only for armv7 devices)\nPOWERLEVEL9K_DISABLE_GITSTATUS=true\n" >> "${HOME}/.zshrc"
	fi
	chmod +rwx "${HOME}/.zshrc"
	if [[ -f "${WORKING_DIR}/OhMyZsh/zsh_history" ]]; then
		printf "${green}${LANG_STRINGS[11]}...${nocol}\n"
		cp -f "${WORKING_DIR}/OhMyZsh/zsh_history" "${HOME}/.zsh_history"
		chmod +rw "${HOME}/.zsh_history"
	fi
	if [[ -f "${WORKING_DIR}/OhMyZsh/custom_aliases.zsh" ]]; then
		printf "${green}${LANG_STRINGS[12]}...${nocol}\n"
		cp -f "${WORKING_DIR}/OhMyZsh/custom_aliases.zsh" "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/custom_aliases.zsh"
	fi
	printf "${green}${LANG_STRINGS[13]}...${nocol}\n"
	cp -f "${WORKING_DIR}/OhMyZsh/p10k.zsh" "${HOME}/.p10k.zsh"
	printf "${green}${LANG_STRINGS[14]}!${nocol}\n"
}

finish_install() {
	# Create config directory if it doesn't exist
	if [ ! -d "${HOME}/.config" ]; then
		mkdir -p "${HOME}/.config"
	fi
	# Configure lf file manager
	cp -fr "${WORKING_DIR}/lf" "${HOME}/.config/lf"
	# Remove gitstatusd from cache if arm
	if [[ "$(dpkg --print-architecture)" == "arm" ]]; then
		rm -rf "${HOME}/.cache/gitstatus"
	fi
	printf "${green}${LANG_STRINGS[15]}...${nocol}\n"
	chsh -s zsh
	# Setup Complete
	termux-setup-storage
	termux-reload-settings
	printf "${green}${LANG_STRINGS[16]}!${nocol}\n"
	printf "${green}${LANG_STRINGS[17]}!${nocol}\n"
}

main() {
	# Start installation
	printf "${green}${LANG_STRINGS[18]} Termux-zsh?${nocol}\n"
	printf "  [${green}1${nocol}] ${COMMON_STRINGS[3]}\n"
	printf "  [${green}2${nocol}] ${COMMON_STRINGS[6]}\n"

	printf "\n"
	read -p "> " choice

	case "${choice}" in
		1)
			install_dependencies
			configure_termux
			install_ohmyzsh
			finish_install
			exit 0
			;;
		2)
			printf "${red}${LANG_STRINGS[19]}!${nocol}\n"
			exit 1
			;;
		*)
			printf "${red}${LANG_STRINGS[20]}!${nocol}\n"
			exit 1
			;;
	esac
}

main "${@}"
