# ============================================
## SOURCES -----------------------------------
# ============================================
# http://doc.ubuntu-fr.org/zsh


# ============================================
## VARIABLES ENVIRONMENT ---------------------
# ============================================
test -f ~/.environment && source ~/.environment
test -f ~/.local/environment && source ~/.local/environment


# ============================================
## BACKWORD like BASH ------------------------
# ============================================
# Ctrl+w supprimera un mot jusqu'au / pour un path:
autoload -U select-word-style
select-word-style bash


# ============================================
## HISTORIQUE  -------------------------------
# ============================================
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
# Affiche la commande sans l executer quand on tape "!"
setopt hist_verify
# Ne pas ecrire les doublon dans l'historique:
setopt hist_ignore_dups
# Ajoute le temps le temps d'exécution dans l'historique:
setopt inc_append_history_time
# Synchronise entre les shells
#setopt share_history

# ============================================
## COULEURS ----------------------------------
# ============================================
autoload -U colors && colors


# ============================================
## AUTRES OPTIONS ----------------------------
# ============================================

# Pour faire: ^*.zip
setopt extendedglob

# Correction orthographique des commande:
# Uniquement pour les commandes:
setopt correct
# Pour les commandes et les arguments:
#setopt correctall

# Changement de repertoire sans faire 'cd':
#setopt autocd

# Pointeur toujours en fin de commande apres une autocompletion:
setopt always_to_end

# For autocompletion of command line switches for aliases, add the following to:
setopt completealiases

# Pas de notification d'un process en tache de fond
unsetopt notify

# ============================================
## BINDKEY -----------------------------------
# ============================================
## Lookup in /etc/termcap or /etc/terminfo else, you can get the right keycode
## by typing ^v and then type the key or key combination you want to use.
## "man zshzle" for the list of available actions
bindkey -e           # emacs keybindings
## Historique:
#bindkey '\e[5~'   history-search-backward # PgUp
#bindkey '\e[6~'   history-search-forward  # PgDn
#bindkey '^R'      history-incremental-pattern-search-backward

## Redefini Home et End
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line

## Redefini Del & Ins
bindkey '^[[3~' delete-char
bindkey '^[[2~' overwrite-mode

## ctrl+left Error: fonctionne avec alt+left
# Ubuntu + Putty - Sans tmux
test -n "$TMUX" || bindkey '^[[D' backward-word
# Konsole:
bindkey '[1;5D' backward-word
# Centos 6.4 + Putty - Sans tmux
#test -z "$TMUX" || bindkey '^[OD' backward-word

## ctrl+right Error: fonctionne avec alt+right
# Ubuntu + Putty - Sans tmux
test -n "$TMUX" || bindkey '^[[C' forward-word
# konsole
bindkey '[1;5C' forward-word
# Centos 6.4 + Putty - Sans tmux
#test -z "$TMUX" || bindkey '^[OC' forward-word

# Putty only: ALT+Arrow (NOT WORKING)
#bindkey '^[^[[C' forward-word
#bindkey '^[^[[D' backward-word
#bindkey "\e\e[[D" backward-word

# Putty + TMUX: ALT+Arrow
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

## Revenir en arriere dans le menu des propositions (shift+tab):
## /home/noxis/.zshrc:bindkey:122: no such keymap `menuselect'`
#bindkey -M menuselect '^[[Z' reverse-menu-complete


# ============================================
## COMPLETION --------------------------------
# ============================================

# Affiche un message quand il ne trouve pas:
setopt nomatch


zstyle ':completion:*' verbose yes
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

# La complétion est très modifiable. Pour améliorer l'apparence de l'auto complétion :
# zstyle ':completion:*:descriptions' format "$fg[yellow]%B--- %d%b"
zstyle ':completion:*:descriptions' format '%F{red}▶ %U%k%B%d%b%u%f'
# zstyle ':completion:*:warnings' format '%BDésolé, pas de résultats pour : %d%b'
# zstyle ':completion:*:warnings' format "$fg[red]No matches for:$reset_color %d"
zstyle ':completion:*:warnings' format '%F{red}%BSorry, no matches for:%f %d%b'
# menu if nb items > 2
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt '%F{red}%SScrolling active: current selection at%f %p%s'
# ignore case
#zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
# Permet la couleur dans la liste des propositions:
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
## Crée un cache des complétion possibles
# très utile pour les complétion qui demandent beaucoup de temps
# comme la recherche d'un paquet aptitude install moz<tab>
zstyle ':completion:*' use-ip true
zstyle ':completion:*' use-cache true
zstyle ':completion:*' cache-path ~/.zsh_cache
zstyle ':completion::complete:*' use-cache true
zstyle ':completion::complete:*' cache-path ~/.zsh_cache
#
zstyle ':completion:*' show-completer true
# The following lines were added by compinstall:
zstyle :compinstall filename '~/.zshrc'



## -- Complétion pour la commande killall:
zstyle ':completion:*:processes' command 'ps -ax'
zstyle ':completion:*:processes-names' command 'ps -aeo comm='
# zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##${~strip}}})'
# zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${(s: :)${(ps:\t:)${${(f)~~"$(<~/.local/hosts)"}%%\#*}##${~strip}}})'
# zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.local_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
##
# zstyle -e ':completion:*:*:hosts' hosts 'reply=(${(s: :)${(ps:\t:)${${(f)~~"$(<~/.local_hosts)"}%%\#*}##${~strip}}})'
zstyle -e ':completion:*:*:hosts' hosts 'reply=(${(s: :)${(ps:\t:)${${(f)~~"$(<~/.local/hosts)"}%%\#*}##${~strip}}})'
#zstyle -e ':completion:*:*:hosts' hosts 'reply=(${(s: :)${(ps:\t:)${${(f)~~"$( grep -vhE "^(#|:|127.0.0.1)" /etc/hosts ~/.local_hosts)"}%%\#*}##${~strip}}} \
#												${=${${(f)"$(cat {/etc/,/etc/ssh_,~/.local_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
# strip='[:blank:]#[^[:blank:]]#'
# zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${(s: :)${(ps:\t:)${${(f)~~"$(<~/.local/hosts)"}%%\#*}##${~strip}}})'

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:killall:*:processes-names' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:killall:*' menu yes select
# -- SUDO
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
## -- SHELL + RSYNC + SCP
# Pour éviter de proposer un élément déjà présent lors d'un cp, mv ou rm :
zstyle ':completion:*:(rm|mv|cp|scp|rsync|vi):*' ignore-line yes
## -- VIM*
zstyle ':completion:*:*:vi(mdiff|m|):*:*files' ignored-patterns '*.o' '*.pyc' '*.gz' '*.tar'
zstyle ':completion:*:*:vi(mdiff|m|):*' file-sort modification
## -- SSH

zstyle ':completion:*:*:docker:*' option-stacking yes


## -- MES SCRIPTS -------------------------------------
# compdef _gnu_generic cvs.py

## Utilisation de la completion ZSH:
fpath=(~/.zsh.d/completion $fpath)
# fpath=(~/.zsh.d/zsh-ansible.git $fpath)
#fpath=($fpath)

# autoload -Uz compinit
# autoload -U compinit
# compinit

compdef _kubectl k
#
autoload -Uz compinit
compinit -i

## Utilisation de la completion bash:
autoload -U +X bashcompinit && bashcompinit
test -d /etc/bash_completion.d && source /etc/bash_completion.d/*
## Complete customs:
complete -o nospace -C /home/noxis/.local/bin/mc mc
complete -o nospace -C /usr/bin/nomad nomad


# ============================================
## PLUGINS -----------------------------------
# ============================================

## Predictable SSH authentication socket location.
SOCK="$HOME/.ssh/${SSH_CLIENT/ */}_${HOSTNAME}_ssh_auth_sock"
if [[ -n ${SSH_AUTH_SOCK} && $SSH_AUTH_SOCK != $SOCK ]]; then
	ln -sf $SSH_AUTH_SOCK $SOCK
elif [[ -n ${WSL_DISTRO_NAME} && -x "$HOME/.local/bin/wsl-ssh-agent-relay" ]]; then
	## Forward agent Agent Windows vers WSL
	$HOME/.local/bin/wsl-ssh-agent-relay start
	SOCK=${HOME}/.ssh/wsl-ssh-agent.sock
fi
export SSH_AUTH_SOCK=$SOCK

## Coloration syntaxique des commandes:
source ~/.zsh.d/zsh-syntax-highlighting.git/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_STYLES[path]=fg=256
ZSH_HIGHLIGHT_STYLES[globbing]=fg=063
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=060
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=061
ZSH_HIGHLIGHT_STYLES[alias]=fg=green,bold
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=011
ZSH_HIGHLIGHT_STYLES[path_pathseparator]=fg=011
ZSH_HIGHLIGHT_STYLES[redirection]=fg=001
ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=001

## Navigation dans l'history avec flesh Haut/bas (A placer apres /zsh-syntax-highlighting.zsh)
source ~/.zsh.d/zsh-history-substring-search.git/zsh-history-substring-search.zsh
setopt HIST_IGNORE_ALL_DUPS
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# source ~/.zsh.d/antigen.git/antigen.zsh
## Plugins: zsh-256color
# antigen bundle chrissicool/zsh-256color
## Plugins: zsh-syntax-highlighting
# antigen bundle zsh-users/zsh-syntax-highlighting
## Plugins: oh-my-zsh
# ZSH="$HOME/.antigen/repos/https-COLON--SLASH--SLASH-github.com-SLASH-robbyrussell-SLASH-oh-my-zsh.git/"
# ZSH_CUSTOM="$HOME/.zsh.d/oh-my-zsh"
# ZSH_THEME="agnoster"
# ZSH_THEME="noxis"
# antigen bundle robbyrussell/oh-my-zsh
# By default, you will be prompted to check for upgrades every few weeks.
# If you would like oh-my-zsh to automatically upgrade itself without prompting you:
# DISABLE_UPDATE_PROMPT=true
# To disable automatic upgrades, set the following in your ~/.zshrc:
# DISABLE_AUTO_UPDATE=true
## Plugins: git
# antigen bundle git

# Load the theme.
# antigen theme clint

# Tell antigen that you're done.
# antigen apply


# ============================================
## PROMPTS -----------------------------------
# ============================================
# autoload -U promptinit && promptinit
# prompt clint
source ~/.zsh.d/themes/noxis.zsh-theme


## Get notified when someone logs in:
# watch=all                       # watch all logins
# logcheck=30                     # every 30 seconds
# WATCHFMT="%n from %M has %a tty%l at %T %W"

# ============================================
## PROMPTS: autosuggestion -------------------
# ============================================
# https://github.com/zsh-users/zsh-autosuggestions
source ~/.zsh.d/zsh-autosuggestions.git/zsh-autosuggestions.zsh
# export ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmd
bindkey '^[[Z' autosuggest-accept


# ============================================
## ALIASES -----------------------------------
# ============================================
unalias -m '*'
test -e ~/.bash_aliases && source ~/.bash_aliases || true

##
# Pour remapé ctrl+q ou s, il faut supprimer l’ mappage des touche
# fait par le terminal dans .bashrc ou .zshrc
# src: https://stackoverflow.com/questions/21806168/vim-use-ctrl-q-for-visual-block-mode-in-vim-gnome
stty start undef

##
test -e ~/.local/zshrc && source ~/.local/zshrc || true

## Loading direnv
if [ -x /usr/bin/direnv ]; then
	eval "$(/usr/bin/direnv hook zsh)"
elif [ -x ~/.local/bin/direnv ]; then
	eval "$(~/.local/bin/direnv hook zsh)"
fi


autoload -Uz vcs_info
#precmd_vcs_info() { vcs_info }
precmd() { vcs_info  }
#precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
#RPROMPT=\$vcs_info_msg_0_
#PROMPT=\$vcs_info_msg_0_'%# '
# zstyle ':vcs_info:*:*' formats ' %s%b %a'
zstyle ':vcs_info:*+*:*' debug false
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' enable git svn
#zstyle ':vcs_info:git*' formats "%{$fg[grey]%}%s %{$reset_color%}%r/%S%{$fg[grey]%} %{$fg[blue]%}%b%{$reset_color%}%m%u%c%{$reset_color%} "
zstyle ':vcs_info:git*' formats "%F{011}  %F{015}%b %F{red}%m%u%c%f"

#zstyle ':vcs_info:*:*' formats '  %b %a'
zstyle ':vcs_info:git*' actionformats "%F{011}  %F{015}%b %F{red}%m%u%c%f"
#zstyle ':vcs_info:(svn|bzr|git):*' branchformat '%b%{'${fg[yellow]}'%}:%r'


#autoload -Uz vcs_info
#zstyle ':vcs_info:*' enable git

# () {
    # local formats="${PRCH[branch]} %b%c%u"
    # local actionformats="${formats}%{${fg[default]}%} ${PRCH[sep]} %{${fg[green]}%}%a"
    # zstyle ':vcs_info:*:*' formats           $formats
    # zstyle ':vcs_info:*:*' actionformats     $actionformats
    # zstyle ':vcs_info:*:*' stagedstr         "%{${fg[green]}%}${PRCH[circle]}"
    # zstyle ':vcs_info:*:*' unstagedstr       "%{${fg[yellow]}%}${PRCH[circle]}"
    # zstyle ':vcs_info:*:*' check-for-changes true
# }

#add-zsh-hook precmd vcs_info


compdef _vagrant v
compdef _kubectl k

complete -o nospace -C /usr/bin/terraform terraform
complete -o nospace -C /usr/bin/terraform tf
