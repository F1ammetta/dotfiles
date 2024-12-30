# check if Hyprland is running and start it if not
if ! pgrep -x "Hyprland" > /dev/null && [[ ""$(tty)"" == "/dev/tty1" ]];
then
  Hyprland
fi
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

pokeget dewott --hide-name | fastfetch --logo-type kitty -c ~/dotfiles/fastfetch.jsonc --file-raw -

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
#export VISUAL="${EDITOR}"
export EDITOR='nvim'
export editor='nvim'
export VISUAL='nvim'
export TERMINAL='kitty'
export BROWSER='firefox'
export SHELL='zsh'
export CHROME_EXECUTABLE='brave'
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

export MANPAGER="nvim +Man!"

unset QT_STYLE_OVERRIDE
export QT_QPA_PLATFORM="wayland;xcb"
export QT_QPA_PLATFORMTHEME="qt6ct"
export QT_QUICK_CONTROLS_STYLE="org.kde.desktop"

export GTK_IM_MODULE="fcitx"
export QT_IM_MODULE="fcitx"
export XMODIFIERS="@im=fcitx"

export XDG_MENU_PREFIX="arch-"

autoload -Uz compinit add-zsh-hook vcs_info
compinit -C -d ~/.config/zsh/zcompdump
precmd () { vcs_info }
_comp_options+=(globdots)

zstyle ':completion:*' verbose true
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} 'ma=48;5;197;1'
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:warnings' format "%B%F{red}No matches for:%f %F{magenta}%d%b"
zstyle ':completion:*:descriptions' format '%F{yellow}[-- %d --]%f'
zstyle ':vcs_info:*' formats ' %B%s-[%F{magenta}%f %F{yellow}%b%f]-'

dots_expand_or_complete() {
  echo -n "\e[31m…\e[0m" && zle expand-or-complete && zle redisplay
}

zle -N dots_expand_or_complete
bindkey "^I" dots_expand_or_complete

PS1='%B%F{blue}%f%b  %B%F{magenta}%n%f%b $(dir_icon)  %B%F{red}%~%f%b${vcs_info_msg_0_} %(?.%B%F{green}.%F{red})%f%b '


if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
  tmux source-file ~/.tmux.conf
fi
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/.local/bin:$PATH"
# export PATH="$HOME/node-v20.10.0-linux-x64/bin:$PATH"
export PATH="$PATH:$HOME/neovim"
export PATH="$PATH":"$HOME/.pub-cache/bin"
export PATH="$PATH":"$(go env GOPATH)/bin"
# . /home/fiammetta/export-esp.sh

# alias set_idf="nix-shell $HOME/nixpkgs-esp-dev/shells/esp32-idf.nix"
alias ls='ls -a'
alias set_idf=". /opt/esp-idf/export.sh"
alias teams='brave --app=https://teams.microsoft.com/go'
alias cp=pycp
alias mv=pymv
# set fzh to pip history into fzf

alias neofetch='neofetch --source ~/ascii.txt --colors 36 36 36 36 36'
alias get_idf='. $HOME/esp/esp-idf/export.sh'
# set ctrl-a to kill line
eval "$(zoxide init zsh)"
# set cd to zoxide
alias cd='z'
alias cdi='zi'
# set ctrl-o to clear output

alias fzh='history | fzf'
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="bigpath"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=~/dotfiles/zsh

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh
# source $ZSH/nix-shell.plugin.zsh
source $ZSH_CUSTOM/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSH_CUSTOM/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSH_CUSTOM/zsh-history-substring-search/zsh-history-substring-search.zsh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
export MODULAR_HOME="/home/fiammetta/.modular"
export PATH="/home/fiammetta/.modular/pkg/packages.modular.com_mojo/bin:$PATH"

bindkey '^A' kill-whole-line
bindkey '^O' clear-screen
# bind ^P to run  pokeget dewott --hide-name | fastfetch --logo-type kitty -c ~/dotfiles/fastfetch.jsonc --file-raw -
function run-pokeget() {
  pokeget dewott --hide-name | fastfetch --logo-type kitty -c ~/dotfiles/fastfetch.jsonc --file-raw -
  zle redisplay
}
zle -N run-pokeget
bindkey '^P' run-pokeget


# bindkey '^G' to run lazygit
function run-lazygit() {
  lazygit
  zle redisplay
}
zle -N run-lazygit
bindkey '^G' run-lazygit

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/.local/lib/mojo
export PATH=$PATH:~/.modular/pkg/packages.modular.com_mojo/bin/

export PATH=$PATH:/home/fiammetta/.spicetify

