#!/usr/bin/env bash
#
## Termux-zsh
## Color scheme changer
#

# Color Codes
red="\e[0;31m"   # Red
green="\e[0;32m" # Green
nocol="\033[0m"  # Default

# Variables
WORKING_DIR="${HOME}/.termux"
COLORS_DIR="${WORKING_DIR}/colors"
THEME_TYPE=""
count=1
LANG_CODE="en"

# Pre-scan all arguments for -l <lang_code> before loading lang files
for ((i = 1; i <= $#; i++)); do
	arg="${!i}"
	next_index=$((i + 1))
	next_arg="${!next_index}"

	if [[ $arg == "-l" ]]; then
		if [[ -z $next_arg || $next_arg == -* ]]; then
			printf "${red}Missing language code after -l|--lang\n"
			printf "Use -ls to list available languages or -h for help${nocol}\n"
			exit 1
		fi
		lang_input="${next_arg,,}"
		if [[ -d "$WORKING_DIR/lang/$lang_input" ]]; then
			LANG_CODE="$lang_input"
		else
			printf "${red}No localization found for language code${nocol} ${lang_input}\n"
			printf "${red}Check available languages with -ls or use -h for help${nocol}\n"
			exit 1
		fi
		break
	fi
done

# Load lang files
mapfile -t LANG_STRINGS < "${WORKING_DIR}/lang/${LANG_CODE}/colors.lang"
mapfile -t COMMON_STRINGS < "${WORKING_DIR}/lang/${LANG_CODE}/common.lang"

while [[ ${#} -gt 0 ]]; do
	case "${1}" in
		-ls)
			printf "${green}${COMMON_STRINGS[9]}${nocol}:\n"
			find "${WORKING_DIR}/lang" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;
			exit 0
			;;
		-h)
			printf "${green}${COMMON_STRINGS[10]}${nocol}: color-changer [-l <${COMMON_STRINGS[12]}>]\n"
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

if [ ! -d "${COLORS_DIR}" ]; then
	printf "${red}${LANG_STRINGS[0]}${nocol}"
	exit 1
elif [ ! -d "${COLORS_DIR}/light" ]; then
	printf "${red}${LANG_STRINGS[1]}${nocol}"
	exit 1
elif [ ! -d "${COLORS_DIR}/dark" ]; then
	printf "${red}${LANG_STRINGS[2]}${nocol}"
	exit 1
fi

printf "\n${green}$(toilet -t -f mini -F crop Color Changer)${nocol}\n"
printf "\n${LANG_STRINGS[3]} ${green}IrBlack${nocol}"
printf "\n${LANG_STRINGS[4]} ${green}https://github.com/mbadolato/iTerm2-Color-Schemes${nocol}\n"

printf "
[${green}1${nocol}] ${LANG_STRINGS[5]}
[${green}2${nocol}] ${LANG_STRINGS[6]}

[${green}${COMMON_STRINGS[1]}${nocol}] ${COMMON_STRINGS[2]}
"

while true; do
	printf "\n"
	read -p "${LANG_STRINGS[7]} " input
	input="$(xargs <<< "${input}")"

	if [[ ${input} == 1 ]]; then
		THEME_TYPE="light"
		break
	elif [[ ${input} == 2 ]]; then
		THEME_TYPE="dark"
		break
	elif [[ ${input} == "q" || ${input} == "Q" ]]; then
		exit 0
	else
		printf "${red}${LANG_STRINGS[8]}${nocol}\n"
	fi
done

for colors in "${COLORS_DIR}/${THEME_TYPE}"/*; do
	colors_name[count]=$(basename "${colors%.*}")
	printf "[${green}${count}${nocol}] ${colors_name[count]}\n"
	count=$((count + 1))
done
count=$((count - 1))
printf "\n[${green}${COMMON_STRINGS[1]}${nocol}] ${COMMON_STRINGS[2]}\n"

while true; do
	printf "\n"
	read -p "${LANG_STRINGS[9]} " input
	input="$(xargs <<< "${input}")"

	if [[ ${input} == "q" || ${input} == "Q" ]]; then
		exit 0
	elif ((input >= 1 && input <= count)); then
		choice="${colors_name[input]}"
		ln -fs "${COLORS_DIR}/${THEME_TYPE}/${choice}.properties" "${WORKING_DIR}/colors.properties"
		printf "${green}${LANG_STRINGS[11]}${nocol}\n"
		termux-reload-settings
		exit 0
	else
		printf "${red}${LANG_STRINGS[10]}${nocol}\n"
	fi
done
