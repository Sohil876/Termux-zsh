# You can set your custom aliases here

# Git
alias gc='git commit'
# Termux-zsh
alias color-changer='bash "${HOME}"/.termux/colors.sh'
alias font-changer='bash "${HOME}"/.termux/fonts.sh'
alias p10k-update='git -C "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}"/themes/powerlevel10k pull'
alias custom-plugins-update='echo "Checking custom plugins for updates ..."; echo ""; for i in $(ls "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}"/plugins); do if [[ -d "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/${i}" && -d "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/${i}/.git" && "${i}" != "example" ]]; then echo "Checking ${i} ..."; git -C "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/${i}" pull; echo ""; fi; done'
