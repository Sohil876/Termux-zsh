#!/bin/bash
#
## Termux-Zsh
#

install_dependencies() {
  echo "Installing dependencies:"
  apt update && apt install -y git zsh figlet lf wget micro man
}

install_ohmyzsh() {
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
  cp -f OhMyZsh/zshrc ~/.zshrc
  if [$(dpkg --print-architecture) == 'arm'] ; then
    # There's no binaries of gitstatus for armv7 right now so disable it
    echo -e "\n#Disable gitstatus for now (Only for armv7 devices)\nPOWERLEVEL9K_DISABLE_GITSTATUS=true" >> ~/.zshrc
  fi
  chmod +rwx ~/.zshrc
  # Copy over zsh_history file if its found in OhMyZsh directory
  if [-f OhMyZsh/zsh_history]; then
    cp -f OhMyZsh/zsh_history ~/.zsh_history
    chmod +rw ~/.zsh_history
  fi
  # Copy over custom_aliases.zsh file if its found in OhMyZsh directory
  if [-f OhMyZsh/custom_aliases.zsh]; then
    cp -f OhMyZsh/custom_aliases.zsh ~/.oh-my-zsh/custom/custom_aliases.zsh
  fi
  echo "Oh-My-Zsh installed!"
}

finish_install() {
  # Remove already existing .termux folder
  rm -rf ~/.termux
  # Copy .termux folder
  cp -r Termux ~/.termux
  chmod +x ~/.termux/fonts.sh ~/.termux/colors.sh
  # Replacing termuxs boring welcome message with something good looking
  mv $PREFIX/etc/motd $PREFIX/etc/motd.bak
  mv $PREFIX/etc/motd.sh $PREFIX/etc/motd.sh.bak
  # message included in *rc files
  # Remove the unnecessary userinfo on left prompt
  #sed '/^# alias ohmyzsh=*/a\prompt_context() {}' $HOME/.zshrc
  # Remove gitstatusd from cache if arm
  if [$(dpkg --print-architecture) == 'arm'] ; then
    rm -rf ~/.cache/gitstatus
  fi
  # Set zsh as default
  echo "Setting up zsh as default shell."
  chsh -s zsh
  # Setup Complete
  termux-setup-storage
  termux-reload-settings
  echo "Setup Completed!"
  echo "Please restart Termux!"
}

# Start installation
read -p "Install Oh-My-Zsh? [Y/n]" -n 1 -r yn
echo # For newline
case $yn in
    [Yy]* )
      install_dependencies
      install_ohmyzsh
      finish_install
      exit 0
    ;;
    [Nn]* )
      echo "Installation aborted!"
      exit 1
    ;;
esac

# Error msg for invalid choice
echo "Invalid choice!"
echo ""
exit 1

