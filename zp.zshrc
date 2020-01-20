source ~/.zplugin/bin/zplugin.zsh
#source ~/home/.zplugin/plugins/tj---git-extras/etc/git-extras-completion.zsh

#SAVEHIST=100
#HISTFILE=~/.zsh_history
export HISTFILE=~/.zsh_history
export SAVEHIST=$HISTSIZE

# Welcome message
figlet -f slant Termux
echo "(Setup by: Sohil876)"
echo ""
echo "Working with packages:
 * Search packages:   pkg search <query>
 * Install a package: pkg install <package>
 * Upgrade packages:  pkg upgrade
Subscribing to additional repositories:
 * Root:     pkg install root-repo
 * Unstable: pkg install unstable-repo
 * X11:      pkg install x11-repo"
echo ""

# Needed to make gpg(2) work
#export GPG_TTY=$(tty)
GPG_TTY=$(tty)
export GPG_TTY

# (optional) If you place the source below compinit, then add those two lines after the source:
#autoload -Uz _zplugin
#(( ${+_comps} )) && _comps[zplugin]=_zplugin
# Two regular plugins loaded without tracking.
zplugin light zsh-users/zsh-autosuggestions
zplugin light zdharma/fast-syntax-highlighting

# Plugin history-search-multi-word loaded with tracking.
zplugin load zdharma/history-search-multi-word

# Load the pure theme, with zsh-async library that's bundled with it.
#zplugin ice pick"async.zsh" src"pure.zsh"
#zplugin light sindresorhus/pure

# Powerlevel10k theme
#zplugin ice depth=1; zplugin light romkatv/powerlevel10k

# Powerlevel9k theme
POWERLEVEL9K_MODE="awesome-patched"
zplugin ice depth=1; zplugin light Powerlevel9k/powerlevel9k
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
# Add a space in the first prompt
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%f"
# Visual customisation of the second prompt line
local user_symbol="$"
if [[ $(print -P "%#") =~ "#" ]]; then
    user_symbol = "#"
fi
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%{%B%F{black}%K{yellow}%} $user_symbol%{%b%f%k%F{yellow}%} %{%f%}"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir newline vcs)
#POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)
POWERLEVEL9K_DISABLE_RPROMPT=true
#POWERLEVEL9K_COLOR_SCHEME="light"

# Binary release in archive, from GitHub-releases page. 
# After automatic unpacking it provides program "fzf".
zplugin ice from"gh-r" as"program"
zplugin load junegunn/fzf-bin

# One other binary release, it needs renaming from `docker-compose-Linux-x86_64`.
# This is done by ice-mod `mv'{from} -> {to}'. There are multiple packages per
# single version, for OS X, Linux and Windows – so ice-mod `bpick' is used to
# select Linux package – in this case this is actually not needed, Zplugin will
# grep operating system name and architecture automatically when there's no `bpick'.
#zplugin ice from"gh-r" as"program" mv"docker* -> docker-compose" bpick"*linux*"
#zplugin load docker/compose

# Vim repository on GitHub – a typical source code that needs compilation – Zplugin
# can manage it for you if you like, run `./configure` and other `make`, etc. stuff.
# Ice-mod `pick` selects a binary program to add to $PATH. You could also install the
# package under the path $ZPFX, see: http://zdharma.org/zplugin/wiki/Compiling-programs
#zplugin ice as"program" atclone"rm -f src/auto/config.cache; ./configure" \
#    atpull"%atclone" make pick"src/vim"
#zplugin light vim/vim

# Scripts that are built at install (there's single default make target, "install",
# and it constructs scripts by `cat'ing a few files). The make'' ice could also be:
# `make"install PREFIX=$ZPFX"`, if "install" wouldn't be the only, default target.
zplugin ice as"program" pick"$ZPFX/bin/git-*" make"PREFIX=$ZPFX"
zplugin light tj/git-extras

# Handle completions without loading any plugin, see "clist" command.
# This one is to be ran just once, in interactive session.
zplugin creinstall %HOME/my_completions  
# For GNU ls (the binaries can be gls, gdircolors, e.g. on OS X when installing the
# coreutils package from Homebrew; you can also use https://github.com/ogham/exa)
zplugin ice atclone"dircolors -b LS_COLORS > c.zsh" atpull'%atclone' pick"c.zsh" nocompile'!'
zplugin light trapd00r/LS_COLORS

autoload -U +X compinit && compinit
#autoload -U +X bashcompinit && bashcompinit
zplugin cdreplay
