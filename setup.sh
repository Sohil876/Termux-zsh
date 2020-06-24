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
echo "N.O.T.E:= Dropped other plugin managers in favour of Prezto"
echo "Enter 1 to install and set Prezto as default."
vared -p "|=> " -c choice;
if [[ $choice == 1 ]]; then
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
  cp -f Prezto/zpreztorc ~/.zprezto/runcoms/zpreztorc
  cp -f Prezto/zshrc ~/.zprezto/runcoms/zshrc
  chmod +rwx ~/.zshrc
  chmod +rw ~/.zhistory
  chmod +rw ~/.zsh_history_root
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