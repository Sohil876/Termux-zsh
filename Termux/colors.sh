#!/bin/bash
#
## Termux-zsh
## Color scheme changer
#

# Color Codes
red="\e[0;31m"             # Red
green="\e[0;32m"           # Green
nocol="\033[0m"            # Default

# Variables
WORKING_DIR=${HOME}/.termux
COLORS_DIR=${WORKING_DIR}/colors
THEME_TYPE=""
count=1

echo -e "
$(toilet -t -f smslant -F crop Color Changer)

Default color scheme is ${green}IrBlack${nocol}
All color schemes are taken from: ${green}https://github.com/mbadolato/iTerm2-Color-Schemes${nocol}"

echo -e "
[${green}1${nocol}] Light themes
[${green}2${nocol}] Dark themes
[${green}q${nocol}] Quit
"

while true; do
    read -p "Select the type of color scheme: " input;

    if [[ ${input} == 1 ]]; then
        THEME_TYPE="light";
        break;
    elif [[ ${input} == 2 ]]; then
        THEME_TYPE="dark";
        break;
    elif [[ "${input}" == "q" || "${input}" == "Q" ]]; then
        exit 0;
    else
        echo -e "${red}Please enter the right number to select the type of color scheme!${nocol}";
    fi
done;

for colors in "${COLORS_DIR}/${THEME_TYPE}"/*; do
    colors_name[count]=$( echo "${colors}" | awk -F"/" '{print $NF}' )
    echo -e "[${green}${count}${nocol}] ${colors_name[count]}";
    count=$(( count + 1 ));
done;
count=$(( count - 1 ));
echo -e "[${green}q${nocol}] Quit"

while true; do
    read -p "Enter a number, leave blank to not to change: " input;

    if [[ "${input}" == "q" || "${input}" == "Q" ]]; then
        exit 0;
    elif ! [[ ${input} =~ ^[0-9]+$ ]]; then
        echo -e "${red}Please enter the right number to select color scheme!${nocol}";
    elif (( input >= 0 && input <= count )); then
        eval choice="${colors_name[input]}";
        ln -fs "${COLORS_DIR}/${THEME_TYPE}/${choice}" "${WORKING_DIR}"/colors.properties;
        echo -e "${green}Theme set sucessfully!${nocol}"
        break;
    else
        echo -e "${red}Please enter the right number to select color scheme!${nocol}";
    fi
done;

termux-reload-settings
