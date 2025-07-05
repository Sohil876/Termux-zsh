#!/usr/bin/env bash
#
## Termux-zsh
## Font changer
#

# Color Codes
red="\e[0;31m"   # Red
green="\e[0;32m" # Green
nocol="\033[0m"  # Default

# Variables
WORKING_DIR="${HOME}/.termux"
LANG_CODE="en"
MLGSNF_VERSION="v2.3.3" # Meslo font release version from powerlevel-media (https://github.com/romkatv/powerlevel10k-media)
NF_VERSION="v3.2.1"     # Nerd font release version (https://github.com/ryanoasis/nerd-fonts)
MLGSNF_R="https://github.com/romkatv/powerlevel10k-media/raw/${MLGSNF_VERSION}/MesloLGS%20NF%20Regular.ttf"
URL_NF="https://github.com/ryanoasis/nerd-fonts/raw/${NF_VERSION}/patched-fonts"
NF_JBM_L="${URL_NF}/JetBrainsMono/Ligatures/Light/JetBrainsMonoNerdFont-Light.ttf"
NF_JBM_R="${URL_NF}/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf"
NF_H_R="${URL_NF}/Hack/Regular/HackNerdFont-Regular.ttf"
NF_FC_R="${URL_NF}/FiraCode/Regular/FiraCodeNerdFont-Regular.ttf"
NF_SCP_R="${URL_NF}/SourceCodePro/SauceCodeProNerdFont-Regular.ttf"
NF_IT_R="${URL_NF}/IosevkaTerm/IosevkaTermNerdFont-Regular.ttf"
NF_M_R="${URL_NF}/Mononoki/Regular/MononokiNerdFont-Regular.ttf"
NF_T_R="${URL_NF}/Terminus/TerminessNerdFont-Regular.ttf"
NF_CC_R="${URL_NF}/CascadiaCode/Regular/CaskaydiaCoveNerdFont-Regular.ttf"
NF_BM_R="${URL_NF}/IBMPlexMono/Mono/BlexMonoNerdFontMono-Regular.ttf"
NF_AP_R="${URL_NF}/AnonymousPro/Regular/AnonymiceProNerdFont-Regular.ttf"

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
mapfile -t LANG_STRINGS < "${WORKING_DIR}/lang/${LANG_CODE}/fonts.lang"
mapfile -t COMMON_STRINGS < "${WORKING_DIR}/lang/${LANG_CODE}/common.lang"

while [[ ${#} -gt 0 ]]; do
	case "${1}" in
		-ls)
			printf "${green}${COMMON_STRINGS[9]}${nocol}:\n"
			find "${WORKING_DIR}/lang" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;
			exit 0
			;;
		-h)
			printf "${green}${COMMON_STRINGS[10]}${nocol}: font-changer [-l <${COMMON_STRINGS[12]}>]\n"
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

printf "\n${green}$(toilet -t -f mini -F crop Font Changer)${nocol}\n"
printf "\nNerd Fonts: ${green}${NF_VERSION}${nocol}\n"
printf "Meslo LGS fonts: ${green}${MLGSNF_VERSION}${nocol}\n"
printf "${LANG_STRINGS[0]}: ${green}JetBrains Mono Regular${nocol}\n"

printf "
[${green}1${nocol}] JetBrains Mono (Light)
[${green}2${nocol}] JetBrains Mono (Regular)
[${green}3${nocol}] Hack (Regular)
[${green}4${nocol}] Fira Code (Regular)
[${green}5${nocol}] MesloLGS NF (Regular)
[${green}6${nocol}] Source Code Pro (Regular)
[${green}7${nocol}] Iosevka Term (Regular)
[${green}8${nocol}] Monokai (Regular)
[${green}9${nocol}] Terminus (Regular)
[${green}10${nocol}] Cascadia Code (Regular)
[${green}11${nocol}] IBM Plex Mono (Regular)
[${green}12${nocol}] Anonymous Pro (Regular)

[${green}${COMMON_STRINGS[1]}${nocol}] ${COMMON_STRINGS[2]}
"

while true; do
	printf "\n"
	read -p "${LANG_STRINGS[1]}: " input

	if [[ ${input} == "q" || ${input} == "Q" ]]; then
		echo ""
		exit 0
	elif ((input == 1)); then
		URL="${NF_JBM_L}"
		break
	elif ((input == 2)); then
		URL="${NF_JBM_R}"
		break
	elif ((input == 3)); then
		URL="${NF_H_R}"
		break
	elif ((input == 4)); then
		URL="${NF_FC_R}"
		break
	elif ((input == 5)); then
		URL="${MLGSNF_R}"
		break
	elif ((input == 6)); then
		URL="${NF_SCP_R}"
		break
	elif ((input == 7)); then
		URL="${NF_IT_R}"
		break
	elif ((input == 8)); then
		URL="${NF_M_R}"
		break
	elif ((input == 9)); then
		URL="${NF_T_R}"
		break
	elif ((input == 10)); then
		URL="${NF_CC_R}"
		break
	elif ((input == 11)); then
		URL="${NF_BM_R}"
		break
	elif ((input == 12)); then
		URL="${NF_AP_R}"
		break
	else
		printf "${red}${LANG_STRINGS[2]}!${nocol}\n"
	fi
done

if [[ -n ${URL} ]]; then
	printf "${green}${LANG_STRINGS[3]}...${nocol}\n"
	wget "${URL}" -O "${WORKING_DIR}/font.ttf.temp" > /dev/null 2>&1
	fc-validate "${WORKING_DIR}/font.ttf.temp" > /dev/null 2>&1
	if [ ${?} -ne 0 ]; then
		printf "${red}${LANG_STRINGS[4]}${nocol}\n"
		rm "${WORKING_DIR}/font.ttf.temp"
		exit 1
	fi
	mv "${WORKING_DIR}/font.ttf.temp" "${WORKING_DIR}/font.ttf"
	printf "${green}${LANG_STRINGS[5]}!${nocol}\n"
	termux-reload-settings
fi
