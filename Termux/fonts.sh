#!/bin/bash
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
URL_JBM_L="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Light/JetBrainsMonoNerdFont-Light.ttf"
URL_JBM_R="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf"
URL_H_R="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/HackNerdFont-Regular.ttf"
URL_FC_R="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/FiraCodeNerdFont-Regular.ttf"
URL_SCP_R="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Regular/SauceCodeProNerdFont-Regular.ttf"
URL_MLGSNF_R="https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
URL_IT_R="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/IosevkaTerm/Regular/IosevkaTermNerdFont-Regular.ttf"

echo -e "
${green}$(toilet -t -f mini -F crop Font Changer)${nocol}

Default font is ${green}JetBrains Mono Regular${nocol}
All fonts except MesloLGS are taken from: ${green}https://github.com/ryanoasis/nerd-fonts${nocol}"

echo -e "
[${green}1${nocol}] JetBrains Mono Light
[${green}2${nocol}] JetBrains Mono Regular
[${green}3${nocol}] Hack Regular
[${green}4${nocol}] Fira Code Regular
[${green}5${nocol}] MesloLGS NF Regular
[${green}6${nocol}] Source Code Pro Regular
[${green}7${nocol}] Iosevka Term Regular

[${green}q${nocol}] Quit
"

while true; do
	read -p "Enter a number to select font: " input

	if ((input == 1)); then
		URL="${URL_JBM_L}"
		break
	elif ((input == 2)); then
		URL="${URL_JBM_R}"
		break
	elif ((input == 3)); then
		URL="${URL_H_R}"
		break
	elif ((input == 4)); then
		URL="${URL_FC_R}"
		break
	elif ((input == 5)); then
		URL="${URL_MLGSNF_R}"
		break
	elif ((input == 6)); then
		URL="${URL_SCP_R}"
		break
	elif ((input == 7)); then
		URL="${URL_IT_R}"
		break
	elif [[ "${input}" == "q" || "${input}" == "Q" ]]; then
		break
	else
		echo -e "${red}Please enter the right number to select font!${nocol}"
	fi
done

if [[ ! -z ${URL} ]]; then
	echo -e "${green}Downloading selected font...${nocol}"
	wget "${URL}" -O "${WORKING_DIR}"/font.ttf.temp
	mv "${WORKING_DIR}"/font.ttf.temp "${WORKING_DIR}"/font.ttf
	echo -e "${green}Font set sucessfully!${nocol}"
	termux-reload-settings
fi
