### Termux-ZSH

Termux with zsh, a bit modernized terminal **:)**\
\
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/3a469a271f6b4a37b73288cc9929d0e1)](https://www.codacy.com/gh/Sohil876/Termux-zsh/dashboard?utm_source=github.com&utm_medium=referral&utm_content=Sohil876/Termux-zsh&utm_campaign=Badge_Grade)

#

![Termux-zsh-SS](Termux-zsh-SS.png)

### Notes:

-   Termux from playstore [is no longer updated](https://wiki.termux.com/wiki/Termux_Google_Play), install termux from [f-droid](https://f-droid.org/en/packages/com.termux) instead.
-   To run commands in termux from other apps or open it in a directory with a filemanager ([Mixplorer](https://forum.xda-developers.com/t/app-2-2-mixplorer-v6-x-released-fully-featured-file-manager.1523691/) for example) give it App on top or draw over other apps permission and set `allow-external-apps` to true in `~/.termux/termux.properties`, However keep in mind that any app that supports this functionality can then automatically execute commands in termux so its very unsafe and should be only set to true when necessary.
-   You can set custom aliases or override any alias you want by setting them in `OhMyZsh/custom_aliases.zsh` before installing termux-zsh, or in `~/.oh-my-zsh/custom/custom_aliases.zsh` after installing it.
-   By default all `commit` aliases of git plugin now use verbose flags for some reason, that ends up inserting huge verbose diff in commit message, if you don't want that behaviour for any git commit aliases you can re set them as specified in above note in the `custom_aliases.zsh` file, im overriding `gc` alias in there by default to remove the verbose flag, you can use that as example and set yours in that file, you need to reload termux after setting them.
-   You can use `omz update` command in termux to update OhMyZsh framework/plugins/themes to latest versions.

### Installation:

-   Clone this repo `git clone https://github.com/Sohil876/Termux-zsh`
-   Run setup.sh file `bash setup.sh`
-   Restart termux

### What it does?:

-   Installs zsh and sets it as default shell.
-   Installs user customizable zsh framework [OhMyZsh](https://github.com/ohmyzsh/ohmyzsh) for plugins and themes. (Dropped prezto, zinit)
-   Installs Powerlevel10k theme and prepatched SourceCodePro font as default.
-   Added fonts and colors in ~/.termux/ directory with scripts to change them easily.
-   Installs syntax highlighter and autosuggestion plugins (from zsh users).
-   Enabled plugins by default `alias-finder command-not-found git node npm zsh-autosuggestions zsh-syntax-highlighting`, to check their usage and more available plugins [Go Here](https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins)
-   Disable unnecessary infos on right and left prompts.
-   Enable double line left prompt with diffrent icons for dir, git and vcs, beautified left command prompt a bit, enabled new line after prompt.
-   Replace termux's default welcome message with a better looking one.
-   Installs lf (Terminal file manager), press CTRL+O to execute lf in current directory.
-   Added command edit function, press CTRL+E to edit any command in micro text editor (you can change it to whatever text editor you prefer in `~/.zshrc` file here `export VISUAL=micro`.

Checkout [OhMyZsh Cheatsheet](https://github.com/ohmyzsh/ohmyzsh/wiki/Cheatsheet) for some quick usefull tricks.\
Checkout [OhMyZsh Wiki](https://github.com/ohmyzsh/ohmyzsh/wiki/Home) to see how to customize it, add plugins and themes.
