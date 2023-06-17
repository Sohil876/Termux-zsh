#!/bin/bash
#
## Termux-Zsh
#

# Color Codes
red="\e[0;31m"             # Red
green="\e[0;32m"           # Green
nocol="\033[0m"            # Default

install_dependencies() {
    echo -e "${green}Installing dependencies ...${nocol}"
    apt update && apt install -y git zsh figlet toilet lf curl wget micro man
}

configure_termux() {
    echo -e "${green}Configuring termux ...${nocol}"
    # Remove already existing .termux folder
    rm -rf "${HOME}/.termux"
    cp -r Termux "${HOME}/.termux"
    chmod +x "${HOME}/.termux/fonts.sh" "${HOME}/.termux/colors.sh"
    echo -e "${green}Setting IrBlack as default color scheme ...${nocol}"
    ln -fs "${HOME}/.termux/colors/dark/IrBlack" "${HOME}/.termux/colors.properties"
    # Replacing termuxs boring welcome message with something good looking
    mv "${PREFIX}/etc/motd" "${PREFIX}/etc/motd.bak"
    mv "${PREFIX}/etc/motd.sh" "${PREFIX}/etc/motd.sh.bak"
    mv "${HOME}/.termux/motd.sh" "${PREFIX}/etc/motd.sh"
    ln -sf "${PREFIX}/etc/motd.sh" "${HOME}/.termux/motd.sh"
}

install_ohmyzsh() {
    echo -e "${green}Installing Oh-My-Zsh ...${nocol}"
    git clone https://github.com/ohmyzsh/ohmyzsh.git "${HOME}/.oh-my-zsh"
    echo -e "${green}Installing powerlevel10k theme ...${nocol}"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}"/themes/powerlevel10k
    echo -e "${green}Installing custom plugins ...${nocol}"
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
    echo -e "${green}Configuring Oh-My-Zsh ...${nocol}"
    cp -f OhMyZsh/zshrc "${HOME}/.zshrc"
    if [[ "$(dpkg --print-architecture)" == "arm" ]]; then
        echo -e "Armv7 device detected${red}!${nocol} Gitstatus disabled${red}!${nocol}"
        # There's no binaries of gitstatus for armv7 right now so disable it
        echo -e "\n# Disable gitstatus for now (Only for armv7 devices)\nPOWERLEVEL9K_DISABLE_GITSTATUS=true\n" >> "${HOME}/.zshrc"
    fi
    chmod +rwx "${HOME}/.zshrc"
    if [[ -f "OhMyZsh/zsh_history" ]]; then
        echo -e "${green}Installing zsh history file ...${nocol}"
        cp -f OhMyZsh/zsh_history "${HOME}/.zsh_history"
        chmod +rw "${HOME}/.zsh_history"
    fi
    if [[ -f "OhMyZsh/custom_aliases.zsh" ]]; then
        echo -e "${green}Installing custom aliases ...${nocol}"
        cp -f OhMyZsh/custom_aliases.zsh "${HOME}/.oh-my-zsh/custom/custom_aliases.zsh"
    fi
    echo -e "${green}Configuring powerlevel10k theme ...${nocol}"
    cp -f OhMyZsh/p10k.zsh "${HOME}/.p10k.zsh"
    echo -e "${green}Oh-My-Zsh installed!${nocol}"
}

finish_install() {
    # Create config directory if it doesn't exist
    mkdir -p "${HOME}/.config"
    # Configure lf file manager
    cp -fr lf "${HOME}/.config/lf"
    # Remove gitstatusd from cache if arm
    if [[ "$(dpkg --print-architecture)" == "arm" ]]; then
        rm -rf "${HOME}/.cache/gitstatus"
    fi
    echo -e "${green}Setting zsh as default shell ...${nocol}"
    chsh -s zsh
    # Setup Complete
    termux-setup-storage
    termux-reload-settings
    echo -e "${green}Setup Completed!${nocol}"
    echo -e "${green}Please restart Termux!${nocol}"
}

# Start installation
echo -e "${green}Install Oh-My-Zsh? [Y/n]${nocol}"
read -p "" -n 1 -r yn;
echo "" # For newline
case ${yn} in
    [Yy]* )
        install_dependencies
        configure_termux
        install_ohmyzsh
        finish_install
        exit 0
    ;;
    [Nn]* )
        echo -e "${red}Installation aborted!${nocol}"
        exit 1
    ;;
esac

# Error msg for invalid choice
echo -e "${red}Invalid choice!${nocol}"
echo ""
exit 1

