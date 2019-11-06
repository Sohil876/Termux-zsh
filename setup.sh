#!/bin/bash
#DIR="$(pwd)"
# Install dependencies
echo "Installing dependencies."
apt update && apt install -y git zsh wget figlet

# Create termux home directory if not exists
#if [ ! -d $HOME/.termux ]; then
#mkdir $HOME/.termux
#fi

# Replacing termuxs boring welcome message with something good looking
mv $PREFIX/etc/motd $PREFIX/etc/motd.bak
#sed '/^export ZSH=$HOME*/a\figlet Termux\n(Setup by: Sohil876)' $HOME/.zshrc

# Download and setup oh-my-zsh
echo "Downloading and setting up oh-my-zsh."
git clone git://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh --depth 1
#cp $HOME/.oh-my-zsh/templates/zshrc.zsh-template $HOME/.zshrc

# Powerlevel9k theme and sorce code pro powerline font
echo "Installing powerlevel9k theme and source code pro powerline font."
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
#sed -i '/ZSH_THEME="robbyrussell"/c\ZSH_THEME="powerlevel9k/powerlevel9k"' $HOME/.zshrc
wget https://github.com/gabrielelana/awesome-terminal-fonts/raw/patching-strategy/patched/SourceCodePro+Powerline+Awesome+Regular.ttf -O $HOME/.termux/font.ttf
#sed '/^ZSH_THEME=.*/i POWERLEVEL9K_MODE="awesome-patched"' $HOME/.zshrc

# Copy .termux folder
cp .termux/ $HOME/.termux
chmod +x $HOME/.termux/fonts.sh $HOME/.termux/colors.sh

# Adding plugins
echo "Setting up plugins."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/plugins/zsh-autosuggestions
#sed -i '/plugins=(git)/c\plugins=(git zsh-syntax-highlighting zsh-autosuggestions)' $HOME/.zshrc
echo "Installed and enabled syntax highlighter and autosuggestion plugins."

# Remove the unnecessary userinfo on left prompt
#sed '/^# alias ohmyzsh=*/a\prompt_context() {}' $HOME/.zshrc

# Set zsh as default
echo "Setting up zsh as default."
chsh -s zsh
#mv $DIR/.files/colors.properties $HOME/.termux/colors.properties
cp my.zshrc $HOME/.zshrc

# Setup Complete
termux-setup-storage
termux-reload-settings
echo "Setup Completed!"
echo "Please restart Termux!"
