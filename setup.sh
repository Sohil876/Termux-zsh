#!/usr/bin/env bash

## Termux-Zsh

# Color Codes | 颜色代码
red="\e[0;31m"   # Red  | 红色
green="\e[0;32m" # Green | 绿色
nocol="\033[0m"  # Default | 默认

# Exit on error and trace commands
set -e
# set -x  # Uncomment for debugging

install_dependencies() {
	echo -e "${green}Installing dependencies...${nocol} | ${green}正在安装依赖项…${nocol}"
	apt update && apt install -y fontconfig-utils git zsh figlet toilet lf curl wget micro man || {
 		echo -e "${red}Failed to install dependencies!${nocol}"
 		exit 1
 	}
}

configure_mirrors() {
    echo -e "${green}Do you need to use mirrors?${nocol} | ${green}是否需要使用镜像？${nocol}[Y/n]"
    read -p "" choice
    case "${choice}" in
        [Yy]|"")
            USE_MIRROR=1
            ;;
        [Nn])
            USE_MIRROR=0
            ;;
        *)
            USE_MIRROR=0
            ;;
    esac
}

configure_termux() {
	echo -e "${green}Configuring termux...${nocol} | ${green}正在配置 Termux…${nocol}"
	if [ -d "${HOME}/.termux" ]; then
		echo "Found existing.termux folder, moving to different location ${HOME}/.termux_bak for clean install | 发现现有的 .termux 文件夹，为了全新安装，将其移动到 ${HOME}/.termux_bak"
		mv "${HOME}/.termux" "${HOME}/.termux_bak"
	fi
	cp -r Termux "${HOME}/.termux" || {
 		echo -e "${red}Failed to copy Termux folder! | 复制 Termux 文件夹失败！${nocol}"
 		exit 1
 	}
	chmod +x "${HOME}/.termux/fonts.sh" "${HOME}/.termux/colors.sh"
	echo -e "${green}Setting IrBlack as default color scheme...${nocol} | ${green}正在将 IrBlack 设置为默认颜色方案...${nocol}"
	ln -fs "${HOME}/.termux/colors/dark/IrBlack" "${HOME}/.termux/colors.properties"
	# Replacing termuxs boring welcome message with something good looking
	mv "${PREFIX}/etc/motd" "${PREFIX}/etc/motd.bak"
	mv "${PREFIX}/etc/motd.sh" "${PREFIX}/etc/motd.sh.bak"
	ln -sf "${HOME}/.termux/motd.sh" "${PREFIX}/etc/motd.sh"
}

install_ohmyzsh() {
	echo -e "${green}Installing Oh-My-Zsh...${nocol} | ${green}正在安装 Oh-My-Zsh…${nocol}"
	if [[ $USE_MIRROR -eq 1 ]]; then
	    git clone https://mirror.nju.edu.cn/git/ohmyzsh.git "${HOME}/.oh-my-zsh"
        else
	    git clone https://github.com/ohmyzsh/ohmyzsh.git "${HOME}/.oh-my-zsh"
	fi

	echo -e "${green}Installing powerlevel10k theme...${nocol} | ${green}正在安装 powerlevel10k 主题…${nocol}"
	if [[ $USE_MIRROR -eq 1 ]]; then
	    git clone --depth=1 https://mirror.nju.edu.cn/git/powerlevel10k.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}"/themes/powerlevel10k
	else
	    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}"/themes/powerlevel10k
	fi

	echo -e "${green}Installing custom plugins...${nocol} | ${green}正在安装自定义插件…${nocol}"
	if [[ $USE_MIRROR -eq 1 ]]; then
	    git clone https://mirror.nju.edu.cn/git/zsh-autosuggestions.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
	else
	    git clone https://github.com/zsh-users/zsh-autosuggestions.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
    fi

	if [[ $USE_MIRROR -eq 1 ]]; then
        git clone https://mirror.nju.edu.cn/git/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
	else
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
    fi

	echo -e "${green}Configuring Oh-My-Zsh...${nocol} | ${green}正在配置 Oh-My-Zsh…${nocol}"
	cp -f OhMyZsh/zshrc "${HOME}/.zshrc"
	if [[ "$(dpkg --print-architecture)" == "arm" ]]; then
		echo -e "Armv7 device detected${red}!${nocol} Gitstatus disabled${red}!${nocol} | 检测到 Armv7 设备${red}!${nocol} 已禁用 Gitstatus${red}!${nocol}"
		# There's no binaries of gitstatus for Armv7 right now so disable it | 目前没有为 Armv7 编译的 gitstatus 二进制文件，因此禁用它
		echo -e "\n# Disable gitstatus for now (Only for armv7 devices)\nPOWERLEVEL9K_DISABLE_GITSTATUS=true\n" >> "${HOME}/.zshrc"
	fi
	chmod +rwx "${HOME}/.zshrc"
	if [[ -f "OhMyZsh/zsh_history" ]]; then
		echo -e "${green}Installing zsh history file...${nocol} | ${green}正在安装 zsh 历史记录文件…${nocol}"
		cp -f OhMyZsh/zsh_history "${HOME}/.zsh_history"
		chmod +rw "${HOME}/.zsh_history"
	fi
	if [[ -f "OhMyZsh/custom_aliases.zsh" ]]; then
		echo -e "${green}Installing custom aliases...${nocol} | ${green}正在安装自定义别名…${nocol}"
		cp -f OhMyZsh/custom_aliases.zsh "${HOME}/.oh-my-zsh/custom/custom_aliases.zsh"
	fi
	echo -e "${green}Configuring powerlevel10k theme...${nocol} | ${green}正在配置 powerlevel10k 主题…${nocol}"
	cp -f OhMyZsh/p10k.zsh "${HOME}/.p10k.zsh"
	echo -e "${green}Oh-My-Zsh installed!${nocol} | ${green}Oh-My-Zsh 已安装！${nocol}"
}

finish_install() {
	# Create config directory if it doesn't exist | 创建配置目录（如果不存在）
	if [ ! -d "${HOME}/.config" ]; then
		mkdir -p "${HOME}/.config"
	fi
	# Configure lf file manager | 配置 lf 文件管理器
	cp -fr lf "${HOME}/.config/lf"
	# Remove gitstatusd from cache if arm | 如果是Armv7设备，将从缓存中移除 gitstatusd
	if [[ "$(dpkg --print-architecture)" == "arm" ]]; then
		rm -rf "${HOME}/.cache/gitstatus"
	fi
	echo -e "${green}Setting zsh as default shell...${nocol} | ${green}正在将 zsh 设置为默认 shell…${nocol}"
	chsh -s zsh
	# Setup Complete | 设置完成
	termux-setup-storage
	termux-reload-settings
	echo -e "${green}Setup Completed!${nocol} | ${green}安装完成！${nocol}"
	echo -e "${green}Please restart Termux!${nocol} | ${green}请重启 Termux！${nocol}"
}

# Start installation | 开始安装
main() {
    echo -e "${green}Install Oh-My-Zsh?${nocol} | ${green}是否安装 Oh-My-Zsh？[Y/n]${nocol}"
	read -p "" -n 1 -r yn
    echo "" # For newline | 为了添加新行
	case ${yn} in
        [Yy]*)
            install_dependencies
	        configure_mirrors
            configure_termux
            install_ohmyzsh
            finish_install
            exit 0
            ;;
        [Nn]*)
            echo -e "${red}Installation aborted!${nocol} | ${red}安装已被中止！${nocol}"
            exit 1
            ;;
        *)
		    echo -e "${red}Invalid choice!${nocol} | ${red}无效的选择！${nocol}"
            echo ""
            exit 1
            ;;
        esac
}

main "$@"
