# If you come from bash you might have to change your $PATH.
export PATH=$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
#ZSH=/usr/share/oh-my-zsh/

# Path to powerlevel10k theme
# source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

#if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
#  eval "$(oh-my-posh init zsh)"
#fi

# Add wisely, as too many plugins slow down shell startup.
plugins=(git sudo)

# Aliases
# alias vim='nvim' # neovim
alias ls='eza -l --icons=auto' # long list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias tree='eza --tree --icons=auto' # tree view
alias ld='eza -lhD --icons=auto' # long list directories
alias cat='bat'
alias pcat='bat -p'
alias btop='btop --utf-force'
alias yeet='sudo pacman -Rncs' # uninstall package
alias update='sudo pacman -Syu' # update system/package
alias aurupdate='paru -Syu' # update aur
alias plist='pacman -Qs' # list installed package
alias s='sudo pacman -Ss' # list availabe pacman package
alias ps='paru -Ss' # list availabe aur package
alias pc='sudo pacman -Sc' # remove unused cache
alias ro='paru -Qtdq | paru -Rncs -' # remove unused packages, also try > $aurhelper -Qqd | $aurhelper -Rsu --print -
alias code='code --ozone-platform=wayland' # gui code editor
alias fsf='fastfetch'

# Useful Aliases
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# Always mkdir a path (this doesn't inhibit functionality to make a singl>
alias mkdir='mkdir -p'

# Fixes "Error opening terminal: xterm-kitty" when using the default kitty term to open some programs through ssh
alias ssh='kitten ssh'
alias deepseek='ollama run deepseek-r1:1.5b' # Deepseek R1 LLM local 8b parameter install

# Keybinds
bindkey "^[[1;5C" forward-word # ctrl+right-arrow
bindkey "^[[1;5D" backward-word # ctrl+left-arrow
bindkey "^[[A" history-substring-search-up # history up
bindkey "^[[B" history-substring-search-down # history down
bindkey "^[[3;5~" kill-word # ctrl+del
bindkey "^[[3~" delete-char # del

# Source antidote
source $HOME/.antidote/antidote.zsh
antidote load $HOME/.zsh_plugins.txt
#source $HOME/.config/starship.toml
# Starship eval
eval "$(starship init zsh)"
#eval "$(zoxide init --cmd cd zsh)"
#eval "$(oh-my-posh init zsh)"

# >>> Added by Spyder >>>
alias spyder=/home/goutam01/.local/spyder-6/envs/spyder-runtime/bin/spyder
alias uninstall-spyder=/home/goutam01/.local/spyder-6/uninstall-spyder.sh
# <<< Added by Spyder <<<
