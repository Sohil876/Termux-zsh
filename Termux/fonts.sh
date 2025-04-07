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

echo -e "
${green}$(toilet -t -f mini -F crop Font Changer)${nocol}

Nerd Fonts: ${green}${NF_VERSION}${nocol}
Meslo LGS fonts: ${green}${MLGSNF_VERSION}${nocol}
Default font: ${green}JetBrains Mono Regular${nocol}"

echo -e "
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

[${green}q${nocol}] Quit
"

while true; do
	read -p "Enter a number to select font: " input

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
		echo -e "${red}Please enter the right number to select font!${nocol}"
	fi
done

if [[ -n ${URL} ]]; then
	echo -e "${green}Downloading selected font...${nocol}"
	wget "${URL}" -O "${WORKING_DIR}"/font.ttf.temp > /dev/null 2>&1
	fc-validate "${WORKING_DIR}"/font.ttf.temp > /dev/null 2>&1
	if [ ${?} -ne 0 ]; then
		echo -e "Font file is corrupted, please download again.\n"
		rm "${WORKING_DIR}"/font.ttf.temp
		exit 1
	fi
	mv "${WORKING_DIR}"/font.ttf.temp "${WORKING_DIR}"/font.ttf
	echo -e "${green}Font set sucessfully!${nocol}\n"
	termux-reload-settings
fi
