#!/bin/bash
#
## Termux-zsh
## Font changer
#

# Color Codes
red="\e[0;31m"             # Red
green="\e[0;32m"           # Green
nocol="\033[0m"            # Default

# Variables
WORKING_DIR="${HOME}/.termux"

echo -e "
$(toilet -t -f smslant -F crop Font Changer)

Default font is ${green}JetBrains Mono Regular${nocol}
All fonts except MesloLGS are taken from: ${green}https://github.com/ryanoasis/nerd-fonts${nocol}"

echo -e "
[${green}1${nocol}] JetBrains Mono Light
[${green}2${nocol}] JetBrains Mono Regular
[${green}3${nocol}] Hack Regular
[${green}4${nocol}] Fira Code Regular
[${green}5${nocol}] MesloLGS NF Regular
[${green}6${nocol}] Source Code Pro Regular
[${green}q${nocol}] Quit
"

while true; do
	read -p "Enter a number to select font: " input;

    if (( input == 1 )); then
        URL="https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/JetBrainsMono/Ligatures/Light/complete/JetBrains%20Mono%20Nerd%20Font%20Complete%20Light.ttf?raw=true";
        break;
    elif (( input == 2 )); then
        URL="https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/JetBrainsMono/Ligatures/Regular/complete/JetBrains%20Mono%20Nerd%20Font%20Complete%20Regular.ttf?raw=true";
        break;
	elif (( input == 3 )); then
		URL="https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete.ttf?raw=true";
        break;
	elif (( input == 4 )); then
		URL="https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete.ttf?raw=true";
        break;
	elif (( input == 5 )); then
		URL="https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf";
        break;
	elif (( input == 6 )); then
		URL="https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete.ttf?raw=true";
        break;
	elif [[ "${input}" == "q" || "${input}" == "Q" ]]; then
        break;
	else
		echo -e "${red}Please enter the right number to select font!${nocol}"
	fi
done;

if [[ ! -z ${URL} ]]; then
    echo -e "${green}Downloading selected font...${nocol}"
    wget "${URL}" -O "${WORKING_DIR}"/font.ttf.temp
    mv "${WORKING_DIR}"/font.ttf.temp "${WORKING_DIR}"/font.ttf
    echo -e "${green}Font set sucessfully!${nocol}"
    termux-reload-settings
fi
