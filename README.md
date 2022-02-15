# Termux-ZSH
My personal termux setup, a bit modernized terminal **:)**

![Termux-zsh-SS](Termux-zsh-SS.png)

**Installation**
- Install zsh and git `pkg install zsh git` (because of usage of `vared` its incompatible with bash atm)
- Clone this repo and cd into it `git clone https://github.com/Sohil876/Termux-zsh`
- Run setup.sh with zsh `zsh setup.sh`
- Restart termux (If you have weird font rendering issue just run `rm -rf ~/.termux` in termux and rerun setup.sh again for now.

**What it does?:** 
- Installs zsh and sets it as default shell.
- Installs user selectable zsh framework from available options (1) oh-my-zsh (2) Prezto for plugins and themes. (Dropped zinit)
- Installs Powerlevel10k theme and prepatched SourceCodePro font as default.
- Added fonts and colors in ~/.termux/ directory with scripts to change them easily.
- Installs syntax highlighter and autosuggestion plugins.
- Disable unnecessary infos on right and left prompts.
- Enable double line left prompt with diffrent icons for dir, git and vcs, beautified left command prompt a bit, enabled new line after prompt.
- Replace termux's default welcome message with a better looking one.
- Installs lf (Terminal file manager), press CTRL+O to execute lf in current directory.
- Inbuilt transfer function (file.io) to transfer files easily, do `transfer whateverfile.ext` to upload the file and get the download link.
- Added command edit function, press CTRL+E to edit any command in text editor.

