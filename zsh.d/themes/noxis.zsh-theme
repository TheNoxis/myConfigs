# vim: ft=zsh


# =====================================
## VRAIBLES ---------------------------
# =====================================

CURRENT_BG='234'
export PTIMER=''
# Disables prompt mangling in virtual_env/bin/activate
export VIRTUAL_ENV_DISABLE_PROMPT=1


# =====================================
## FUNCTIONS --------------------------
# =====================================

function virtualenv_info {
	[[ -n "${VIRTUAL_ENV}" ]] || return
#	echo "🐍 ${ZSH_THEME_VIRTUALENV_PREFIX=[}${VIRTUAL_ENV:t:gs/%/%%}${ZSH_THEME_VIRTUALENV_SUFFIX=]}"
	echo "%F{011}  %F{015}${VIRTUAL_ENV:t:gs/%/%%}"
}

function conda_info {
	[[ -n ${CONDA_DEFAULT_ENV} ]] || return
	[[ -n "${VIRTUAL_ENV}" ]] || echo ""
	#echo " ☭ Conda:${ZSH_THEME_VIRTUALENV_PREFIX=[}${CONDA_PREFIX:t:gs/%/%%}${ZSH_THEME_VIRTUALENV_SUFFIX=]}"
	# echo "%F{011}  %F{015}${CONDA_PREFIX:t:gs/%/%%}"
	echo "%F{011}  %F{015}${CONDA_DEFAULT_ENV}"
}

function docker_context {
	if [[ -n ${DOCKER_HOST} ]]; then
		local docker=$( echo ${DOCKER_HOST} | grep -Po '.*://(.*@)\K([a-zA-Z@0-9]+)' )
	elif [[ -n ${DOCKER_CONTEXT} ]]; then
		local docker=${DOCKER_CONTEXT}
	elif [[ -e  ~/.docker/config.json  ]] \
		&& $(which jq &>/dev/null) \
		&& jq -r '.currentContext' ~/.docker/config.json | grep -v "default" &>/dev/null; then
		# && [[ $(jq -r '.currentContext' ~/.docker/config.json | grep -v "default")  ]]; then
		local docker=$(jq -r '.currentContext' ~/.docker/config.json)
	else
		return 0
	fi
	[[ -n "${docker}" ]] || return
	[[ "${docker}" == "null" ]] && return 0
	echo "%F{011}  %F{015}${docker}"
}

function kubernetes_context {
	[[ -n ${KUBECTL_CONTEXT} ]] || local KUBECTL_CONTEXT=$(kubectx -c 2>/dev/null)
	[[ -n ${KUBECTL_CONTEXT} ]] || return
	echo "%F{011} ⎈ %F{015}${KUBECTL_CONTEXT}[$(kubens -c 2>/dev/null)]"
}

function libvirt_context {
	[[ -n ${LIBVIRT_DEFAULT_URI} ]] || return
	[[ ${LIBVIRT_DEFAULT_URI} == "qemu:///system" ]] && return
	echo "%F{011} ⮺ %F{015}$( echo ${LIBVIRT_DEFAULT_URI} |grep -Po '.*://(.*@)\K([a-zA-Z@0-9]+)' )"
}

function sep {
	local f=$1
	local b=$2
	echo "%K{$b}%F{$f}%f%K{$b}"
}

function rsep {
	local f=$1
	local b=$2
	echo "%K{$b}%F{$f}%f%K{$f}"
}

function _timer_preexec() {
	export NX_START_TIMER=${NX_START_TIMER:-$SECONDS}
}

function _timer_precmd() {
	if [ ${NX_START_TIMER:-0} -gt 0 ]; then
		export NX_TIMER=$(($SECONDS - $NX_START_TIMER))
		# export RPROMPT="%F{cyan}${timer_show}s %{$reset_color%}"
		# export RPROMPT="$(rsep 024 NONE)$(show_time ${timer_show})$_RPROMPT"
		# export PTIME="$(rsep 024 NONE)$(show_time ${timer_show})$_RPROMPT"
		unset NX_START_TIMER
	fi
}

function show_time() {
	local valueColor=007
	local unitColor=133
	# local totalSeconds=$1
	local totalSeconds=$NX_TIMER
	# echo -n "[$NX_TIMER]"
	# echo -n "[$NX_START_TIMER]"
	local seconds=$((totalSeconds%60))
	local minutes=$((totalSeconds/60%60))
	local hours=$((totalSeconds/60/60%24))
	local days=$((totalSeconds/60/60/24))
	# (( $days > 0 ))    && echo -n "%F{${valueColor}}${day}%f%F{${unitColor}}d%f"
	# (( $hours > 0 ))   && echo -n "%F{${valueColor}}${hours}%f%F{${unitColor}}h%f"
	# (( $minutes > 0 )) && echo -n "%F{${valueColor}}${minutes}%f%F{${unitColor}}m%f"
	# echo -n "%F{${valueColor}}${seconds}%f%F{${unitColor}}s%f"
	## --
	# export PTIMER="%F{${valueColor}}${seconds}%f%F{${unitColor}}s%f"
	# (( $days > 0 ))    && PTIMER+="%F{${valueColor}}${day}%f%F{${unitColor}}d%f"
	# (( $hours > 0 ))   && PTIMER+="%F{${valueColor}}${hours}%f%F{${unitColor}}h%f"
	# (( $minutes > 0 )) && PTIMER+="%F{${valueColor}}${minutes}%f%F{${unitColor}}m%f"
	# (( $seconds > 0 )) && PTIMER+="%F{${valueColor}}${seconds}%f%F{${unitColor}}s%f"
	# PTIMER+="%F{${valueColor}}${seconds}%f%F{${unitColor}}s%f"
	## --
	(( $days > 0 ))    && PTIMER+="${day}d"
	(( $hours > 0 ))   && PTIMER+="${hours}h"
	(( $minutes > 0 )) && PTIMER+="${minutes}m"
	PTIMER+="${seconds}%F{054}s%f"
	## --
	export PTIMER
}

function check_mail() {
	local nb=$( mail 2>/dev/null | grep -c '^.[NU]' )
	if [ "$nb" != "0" ]; then
		local c='red'
		echo -n "%F{${c}} $nb"
	else
		local c='015'
		echo -n "%F{${c}}%F{008}"
	fi
}


# =====================================
## MAIN -------------------------------
# =====================================


preexec_functions+=(_timer_preexec)
precmd_functions+=(_timer_precmd)


# typeset -a precmd_functions
# precmd_functions+=(set_red_prompt_background)

setopt prompt_subst


## --
P_CODE='%(?.%{%F{green}%}.%{%F{red}%}✘ %?)%f'
P_HOST='%F{243}%m%f'
P_USER='%(!.%F{red}.%F{green})%n%f'

## -----------------------------------
## Container context ..
#P_CHARPROMPT+='$(docker_context)'
#P_CHARPROMPT+='$(kubernetes_context)'
#P_CHARPROMPT+='%{%F{blue}%k%}%f%b%k'


P_DIR='%~% '
P_SU='%(!.%{%k%F{blue}%K{black}%}%{%F{yellow}%} ⚡ %{%k%F{black}%}.%{%k%F{blue}%})'
P_DATETIME='%D{%Y/%m/%d %R.%S %Z}'
P_JOBS='%(1j.%F{red}.%F{015})%f'
P_MAIL="$( check_mail )"
## -- Date et Heure --
# P_DATE='%D{%F}'
# P_DATE='%D{%Y/%m/%d}'
P_DATE='%F{243}%D{%Y}%F{054}-%f'
P_DATE+='%F{243}%D{%m}%F{054}-%f'
P_DATE+='%F{243}%D{%d}%F{054}%f'
## --
# P_TIME='%D{%Hh%Mm%Ss}'
P_TIME='%F{243}%D{%H}%F{054}:%f'
P_TIME+='%F{243}%D{%M}%F{054}.%f'
P_TIME+='%F{243}%D{%S}%F{054}%f'
# P_TIME+='%D{%z}'
#virtualenv_info $P_ENV
# PROMPT="%K{234} $P_CODE $(sep 234 008) $P_HOST $(sep 008 234) $(virtualenv_info) $(sep 234 008) $(_git_info) $(sep 008 blue ) $P_DIR $(sep blue black)
# PROMPT="%K{234} $P_CODE $(sep 234 008) $P_HOST $(sep 008 blue) $(virtualenv_info)$(_git_info) $P_DIR $(sep blue black)
#PROMPT="%K{234} $P_CODE $P_JOBS $(sep 234 008) $P_USER $(sep 008 blue) $P_DIR $(sep blue black)
#\$(virtualenv_info)%f%k[%F{yello}%h%f]❯ "


# =====================================================
# PROMPT="%K{234} $P_CODE $P_TIME $PTIME $P_DATE %k%f
show_time
# PTIMER=$(show_time)

## Fin prompt:
P_CHARPROMPT='%k%(!.%F{red}.%F{green})❯%f%b%k '

PROMPT="%F{243}-($P_USER%F{33}@$P_HOST $P_CODE %F{243}on $PTIMER%F{243} at $P_DATE $P_TIME%F{243})-%f
%K{018}\
\$(virtualenv_info)\$(conda_info)\
$(sep 018 024)\
\$(libvirt_context)\$(docker_context)\$(kubernetes_context)\
$(sep 024 238)\
%F{015} $P_DIR\
$(sep 238 234)\
\$vcs_info_msg_0_\
$(sep 234 NONE)\
$P_CHARPROMPT"

PROMPT2="$P_CHARPROMPT"


# =====================================================
_RPROMPT=""
# _RPROMPT+="$(rsep 242 024)%F{220}"
_RPROMPT+="$(rsep 024 NONE)"
#_RPROMPT+="$(rsep 024 087)"
# _RPROMPT+="$(rsep 238 242)"
_RPROMPT+="$(rsep 242 024)"
_RPROMPT+="$(rsep 238 242) "
_RPROMPT+="$P_MAIL"
_RPROMPT+=" "
# _RPROMPT+="$(rsep 242 024)"
_RPROMPT+="$P_JOBS"
# _RPROMPT+="$P_DATE"
_RPROMPT+=" "
RPROMPT="$_RPROMPT"


# =====================================================
SPROMPT="%F{red}▶ %UCorrect%f %R %F{red}to%f %r%u%F{red}? (%F{white}Y%F{red}es, %F{white}N%F{red}o, %F{white}A%F{red}bort, %F{white}E%F{red}dit)%f "
# SPROMPT=${SPROMPT}
