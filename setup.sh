#!/bin/bash
#DIR="$(pwd)"

# Install dependencies
echo "Installing dependencies:"
apt update && apt install -y git zsh figlet lf

# Replacing termuxs boring welcome message with something good looking
mv $PREFIX/etc/motd $PREFIX/etc/motd.bak
# message included in *rc files

# Start installation
echo "Select installation:"
echo "N.O.T.E:= Dropped Zinit (Zplugin)"
echo "Enter 1 for Oh-My-Zsh and 2 for Prezto"
vared -p "|=> " -c choice;
if [[ $choice == 1 ]] ; then
  echo "Oh-My-Zsh selected!"
  # Download and setup oh-my-zsh
  echo "Downloading and setting up Oh-My-Zsh."
  git clone --recursive https://github.com/robbyrussell/oh-my-zsh ~/.oh-my-zsh
  # Powerlevel10k theme and source code pro powerline font
  echo "Installing powerlevel10k theme with source code pro powerline font support."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  #wget https://github.com/gabrielelana/awesome-terminal-fonts/raw/patching-strategy/patched/SourceCodePro+Powerline+Awesome+Regular.ttf -O $HOME/.termux/font.ttf
  # Adding plugins
  echo "Setting up plugins."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/plugins/zsh-autosuggestions
  echo "Installed & enabled syntax highlighter, autosuggestion plugins."
  # Copying over configured .zshrc file
  #cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
  if [ $(dpkg --print-architecture) != 'arm' ] ; then
    cp -f OhMyZsh/zshrc ~/.zshrc
  else
    cp -f OhMyZsh/zshrc_armv7 ~/.zshrc
  fi
  chmod +rwx ~/.zshrc
  if [ -f OhMyZsh/zsh_history]; then
    cp -f OhMyZsh/zsh_history ~/.zsh_history
    chmod +rw ~/.zsh_history
  fi
  echo "Oh-My-Zsh installed!"
elif [[ $choice == 2 ]]; then
  echo "Prezto selected!"
  # Download and setup Prezto
  echo "Downloading and setting up Prezto."
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
  # Create rc files
  setopt EXTENDED_GLOB
  for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
    ln -fs "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
  done
  # Copying over configured files
  cp -f Prezto/zpreztorc ~/.zprezto/runcoms/zpreztorc
  cp -f Prezto/zshrc ~/.zprezto/runcoms/zshrc
  chmod +rwx ~/.zshrc
  chmod +rw ~/.zhistory
  chmod +rw ~/.zsh_history_root
  echo "Prezto installed!"
else
  echo "Invalid choice!"
  exit 1;
fi

# Copy .termux folder
cp -fr Termux/ ~/.termux
chmod +x ~/.termux/fonts.sh ~/.termux/colors.sh

# Remove the unnecessary userinfo on left prompt
#sed '/^# alias ohmyzsh=*/a\prompt_context() {}' $HOME/.zshrc

# Set zsh as default
echo "Setting up zsh as default shell."
chsh -s zsh

# Setup Complete
termux-setup-storage
termux-reload-settings
echo "Setup Completed!"
echo "Please restart Termux!"
