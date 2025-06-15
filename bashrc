# =======================
## -- Noxis -------------
# =======================

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)

# If not running interactively, don't do anything
[ -z "$PS1" ] && return


# ============================================
## VARIABLES ENVIRONMENT ---------------------
# ============================================
test -f ~/.environment && source ~/.environment
test -f ~/.local/environment && source ~/.local/environment


# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend
# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000
HISTTIMEFORMAT='%Y/%m/%d %T '

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ]    && eval "$(/usr/bin/lesspipe)"
# centos:
[ -x /usr/bin/lesspipe.sh ] && eval "$(/usr/bin/lesspipe.sh)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

test -e __git_ps1 || function __git_ps1(){ return 0; }


## PROMPT -------------------------------
function conda_info {
	# local BLUE='\001\033[0;34m\002'
	local YELLOW='\001\033[1;33m\002'
	local WHITE='\001\033[1;37m\002'
	[[ -n "$CONDA_DEFAULT_ENV" ]] || return
	echo -en "${YELLOW}  ${WHITE}${CONDA_DEFAULT_ENV}"
}

function pprom2 {
	local        EXIT="$?"
	## --
	local        BLUE="\[\033[0;34m\]"
	local        GRAY="\[\033[0;90m\]"
	local  LIGHT_GRAY="\[\033[0;37m\]"
	local LIGHT_GREEN="\[\033[1;32m\]"
	local  LIGHT_BLUE="\[\033[1;34m\]"
	local  LIGHT_CYAN="\[\033[1;36m\]"
	local      YELLOW="\[\033[1;33m\]"
	local       WHITE="\[\033[1;37m\]"
	local         RED="\[\033[0;31m\]"
	local       RESET="\[\033[0;00m\]"
	## --
	case ${EXIT} in
		0) EXIT=$LIGHT_GREEN${EXIT};;
		*) EXIT=$RED${EXIT};;
	esac
	## --
	local SU="$LIGHT_GREEN"
	if [ $(id -u) == "0" ]; then
		SU="$RED❯"
	fi
	## --
	local R_HOST=$GRAY
	if [ -n "${SSHRCCLEANUP}" ]; then
		R_HOST=$LIGHT_BLUE
	fi
	## --
	local _ENV=''
	shopt -s nocasematch
	if [ -n "${ENV}" ] && [[ "${ENV}" =~ "prod" ]]; then
		_ENV="${RED}(${ENV})${RESET}"
	elif [ -n "${ENV}" ]; then
		_ENV="${LIGHT_CYAN}(${ENV})${RESET}"
	fi
	shopt -u nocasematch
	## --
	PS1="$GRAY-(\
${EXIT}${GRAY} \
$GRAY\$(date +%H:%M.%S)$GRAY \
$SU\u${LIGHT_BLUE}@$R_HOST\h$GRAY \
$GRAY\j${LIGHT_BLUE}j\
$GRAY)-\
\n\
\[\e[48;5;025m\]\
\[\e[38;5;015m\]\
\$(conda_info)\
\[\e[48;5;234m\]\
\[\e[38;5;025m\]\
\
\$(__git_ps1 ' ${YELLOW} ${WHITE}%s${BLUE}')\
\[\e[48;5;238m\]\
\[\e[38;5;234m\]\
\
$WHITE \w\
$RESET\
\[\e[38;5;238m\]\
\
${_ENV}$SU❯ $RESET"
#$YELLOW❯\$ $RESET\[\e[0m\]"

	PS2="$SU"
	PS4='+ '
}


# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
	screen-256color) color_prompt=yes;;
	xterm-256color) color_prompt=yes;;
	term-color) color_prompt=yes;;
	xterm*|rxvt*) prompt_biz=yes;;
esac

if [ "$color_prompt" = yes ]; then
	PROMPT_COMMAND=pprom2
elif [ $prompt_biz = yes ]; then
	PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
	export PS1
else
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
	export PS1
fi
unset color_prompt force_color_prompt


# use ctl+Left & ctl+right keys to move forward and back in words
bind '"\eOC":forward-word'
bind '"\eOD":backward-word'


# Pour remapé ctrl+q ou s, il faut supprimer l’ mappage des touche
# fait par le terminal dans .bashrc ou .zshrc
# src: https://stackoverflow.com/questions/21806168/vim-use-ctrl-q-for-visual-block-mode-in-vim-gnome
stty start undef


## FORWARD AGENT ---------------------
SOCK="$HOME/.ssh/${SSH_CLIENT/ */}_${HOSTNAME}_ssh_auth_sock"
if [[ -n ${SSH_AUTH_SOCK} && $SSH_AUTH_SOCK != $SOCK ]]; then
	## Predictable SSH authentication socket location.
	ln -sf $SSH_AUTH_SOCK $SOCK
elif [[ -n ${WSL_DISTRO_NAME} && -x "$HOME/.local/bin/wsl-ssh-agent-relay" ]]; then
	## Forward agent Agent Windows vers WSL
	$HOME/.local/bin/wsl-ssh-agent-relay start
	SOCK=${HOME}/.ssh/wsl-ssh-agent.sock
fi
export SSH_AUTH_SOCK=$SOCK


## Commande direnv
which direnv &>/dev/null && eval "$(direnv hook bash)"


## COMPLETIONS COMANDES --------------
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
	. /etc/bash_completion
fi

BASH_COMPLETION_DIR_CUST="${HOME}/.bash_completion.d/"
if [ -d "$BASH_COMPLETION_DIR_CUST" ]; then
	for i in  $BASH_COMPLETION_DIR_CUST/*; do
		[[ ${i##*/} != @(*~|*.bak|*.swp|\#*\#|*.dpkg*|.rpm*) ]] &&
		[ \( -f $i -o -h $i \) -a -r $i ] && . $i
	done
fi


# Complete customs:
complete -C mc mc
complete -C nomad nomad
complete -F __start_kubectl k
complete -F __start_kubectl kubecolor
complete -C terraform terraform
complete -C terraform tf
complete -C vault vault


## Alias definitions:
if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi
which sshrc  &>/dev/null && alias ssh="sshrc"


## LOCAL BASHRC -------------------
test -r ~/.local/bashrc && source ~/.local/bashrc

