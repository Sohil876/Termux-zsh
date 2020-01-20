#!/bin/bash
#DIR="$(pwd)"

# Install dependencies
echo "Installing dependencies:"
apt update && apt install -y git zsh wget figlet

# Create termux home directory if not exists
#if [ ! -d $HOME/.termux ]; then
#mkdir $HOME/.termux
#fi

# Replacing termuxs boring welcome message with something good looking
mv $PREFIX/etc/motd $PREFIX/etc/motd.bak
# message included in *rc files

echo "Select installation:"
echo "Best use OhMyZsh unless you want a very complex setup with zplugin."
echo "Enter 1 to select Zplugin, 2 for Oh-My-Zsh and 3 for Prezto"
read -p "|=> " choice;
if [[ $choice == 1 ]] ; then
  echo "Zplugin selected!"
  # Install plugin dependencies
  echo "Installing plugin required dependencies:"
  apt update && apt install -y make file
  # Copy .termux folder
  cp -r .termux/ ~/.termux
  chmod +x ~/.termux/fonts.sh ~/.termux/colors.sh
  # Download and setup zplugin
  echo "Downloading and setting up Zplugin."
  mkdir ~/.zplugin
  git clone https://github.com/zdharma/zplugin.git ~/.zplugin/bin
  mkdir ~/my_completions
  # Copying over configured .zshrc file
  cp zp.zshrc $HOME/.zshrc
  touch ~/.zsh_history
  chmod +rwx ~/.zshrc
  chmod +rw ~/.zsh_history
  echo "Zplugin downloaded and configured!, install will proceed on termux restart!"
elif [[ $choice == 2 ]] ; then
  echo "Oh-My-Zsh selected!"
  # Copy .termux folder
  cp -r .termux/ ~/.termux
  chmod +x ~/.termux/fonts.sh ~/.termux/colors.sh
  # Download and setup oh-my-zsh
  echo "Downloading and setting up Oh-My-Zsh."
  git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh ~/.oh-my-zsh
  # Powerlevel10k theme and source code pro powerline font
  echo "Installing powerlevel10k theme with source code pro powerline font support."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
  #wget https://github.com/gabrielelana/awesome-terminal-fonts/raw/patching-strategy/patched/SourceCodePro+Powerline+Awesome+Regular.ttf -O $HOME/.termux/font.ttf
  # Adding plugins
  echo "Setting up plugins."
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/plugins/zsh-autosuggestions
  echo "Installed and enabled syntax highlighter and autosuggestion plugins."
  # Copying over configured .zshrc file
  #cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
  cp omz.zshrc ~/.zshrc
  chmod +rwx ~/.zshrc
  chmod +rw ~/.zsh_history
  echo "Finished installing Oh-My-Zsh!"
elif [[ $choice == 3 ]]; then
  echo "Prezto selected!"
  echo "Preztzo support to come in time, if i feel like using it :p"
  exit 1;
else
  echo "Invalid choice!"
  exit 1;
fi

# Remove the unnecessary userinfo on left prompt
#sed '/^# alias ohmyzsh=*/a\prompt_context() {}' $HOME/.zshrc

# Set zsh as default
echo "Setting up zsh as default shell."
chsh -s zsh
#mv $DIR/.files/colors.properties $HOME/.termux/colors.properties

# Setup Complete
termux-setup-storage
termux-reload-settings
echo "Setup Completed!"
echo "Please restart Termux!"
