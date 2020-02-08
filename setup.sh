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
echo "Enter 1 to select Zinit (Zplugin), 2 for Oh-My-Zsh and 3 for Prezto"
vared -p "|=> " -c choice;
if [[ $choice == 1 ]] ; then
  echo "Zinit selected!"
  # Install plugin dependencies
  echo "Installing plugin dependencies:"
  apt update && apt install -y make file
  # Copy .termux folder
  cp -fr Termux/ ~/.termux
  chmod +x ~/.termux/fonts.sh ~/.termux/colors.sh
  # Download and setup Zinit
  echo "Downloading and setting up Zinit:"
  mkdir ~/.zinit
  git clone --depth=1 https://github.com/zdharma/zinit.git ~/.zinit/bin
  mkdir ~/my_completions
  # Copying over configured .zshrc file
  cp -f Zinit/zshrc ~/.zshrc
  touch ~/.zsh_history
  chmod +rwx ~/.zshrc
  chmod +rw ~/.zsh_history
  echo "Zinit downloaded and configured!, install will proceed on termux restart!"
elif [[ $choice == 2 ]] ; then
  echo "Oh-My-Zsh selected!"
  # Copy .termux folder
  cp -fr Termux/ ~/.termux
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
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/plugins/zsh-autosuggestions
  echo "Installed and enabled syntax highlighter and autosuggestion plugins."
  # Copying over configured .zshrc file
  #cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
  cp -f OhMyZsh/zshrc ~/.zshrc
  chmod +rwx ~/.zshrc
  chmod +rw ~/.zsh_history
  echo "Finished installing Oh-My-Zsh!"
elif [[ $choice == 3 ]]; then
  echo "Prezto selected!"
  # Copy .termux folder
  cp -fr Termux/ ~/.termux
  chmod +x ~/.termux/fonts.sh ~/.termux/colors.sh
  # Download and setup Prezto
  echo "Downloading and setting up Prezto."
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
  # Create rc files
  setopt EXTENDED_GLOB
  for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
    ln -fs "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
  done
  # Copying over configured files
  cp -f Prezto/zpreztorc ~/.zpreztorc
  cp -f Prezto/zshrc ~/.zshrc
  chmod +rwx ~/.zshrc
  chmod +rw ~/.zsh_history
  echo "Finished installing Prezto!"
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