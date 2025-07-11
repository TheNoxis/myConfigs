# vim: ft=bash

man() {
	env \
		LESS_TERMCAP_mb=$(printf "\e[1;31m") \
		LESS_TERMCAP_md=$(printf "\e[1;31m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[1;32m") \
		man "$@"
}


# ==================================================
## ALIASES -----------------------------------------
# ==================================================

alias d='~/bin/df.pl'
alias q='cd -'
alias s='cd ..'
alias tailf='tail -f -n 40'

## Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias    ls='ls --color=auto'
# 	alias   dir='dir --color=auto'
# 	alias  vdir='vdir --color=auto'
	alias  grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

## Linux version of OSX pbcopy and pbpaste.
#alias pbcopy='xsel --clipboard --input' ## voir script
#alias pbpaste='xsel --clipboard --output' ## voir scrip

## some more ls aliases:
alias ll='ls -l -hF --group-directories-first --time-style=posix-long-iso'
alias  l='ls -C -hF --group-directories-first --time-style=posix-long-iso'
alias lla='ll -a'
alias  la='l -a'

## Humman readable:
alias df='df -hT'
alias ddu='du --max-depth=1'
alias du='du -h'
alias free='free -m'

## Some more alias to avoid making mistakes:
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

## diff recursif sur un repertoire
alias rdiff='diff --color -qr'
alias diff='diff --color'
alias dmsg='dmesg --time-format iso'

## Autres
alias tree="tree -Fa"
alias gcc="gcc -ansi -Wall -o"
alias memleak="ps -o time,ppid,pid,nice,pcpu,pmem,user,comm -A | sort -n -k 6 | tail -15"

alias mp3tags='eyeD3'
alias fn='find -not -name "*lost+found*" -iname '
# alias ts='sudo /var/local/TeamSpeak/current/ts3server_startscript.sh'
# alias hh='~/bin/help.sh'
alias x='~/sbin/screen_attach.sh'
alias vi='vim'
alias fixrights="find . -type d -exec chmod 750 '{}' \; ; find . -type f -exec chmod 640 '{}' \;"
alias weather='curl -s http://wttr.in/paris | head -n -2'
alias meteo="weather"
alias b64="base64"


# ==================================================
## LES VCS (Version Control System) ----------------
# ==================================================

# alias svnci='svn ci -m "Update..."'
# alias svnst='svn status .'
# alias gitci='git commit -m "Update..." .'
# alias gitst='git status .'
# alias  hgci='hg  ci -m "Update..."'
# alias  hgst='hg status .'
alias cvs="$HOME/bin/cvs.py -r"
alias g="git"


# ==================================================
## WINDOWS/SESSION ---------------------------------
# ==================================================

if [ -n "$STY" ]; then
	alias mutt='screen -t Mail mutt'
	alias irssi='screen -t IRC irssi'
	alias suroot='screen -t Root sudo -s'
	alias ssh='screen -t Ssh ssh'
elif [ -n "$TMUX" ]; then
	alias mutt='tmux new-window   -n Mail mutt'
	alias irssi='tmux new-window  -n IRC  irssi'
	alias suroot='tmux new-window -n Root sudo -s'
	alias suroot='tmux new-window -n Ssh ssh'
fi


# ==================================================
## SHELL -------------------------------------------
# ==================================================

# Pour zsh
if [[ "$(readlink /proc/$$/exe)" == "/usr/bin/zsh" ]]; then
	alias .='source'
	alias yum='noglob yum'
	alias newbin='zstyle ":completion:*:commands" rehash 1'
	alias history='fc -liD'
fi


# ==================================================
## APPLICATIONS ------------------------------------
# ==================================================

## Libvirt
alias vml='virsh list --all --title'
alias vnl='virsh net-list --all'
alias vmn='virsh list --all --name | xargs -L1 virsh domifaddr --full'
alias vmb='virsh list --all --name | xargs -L1 virsh domblklist --details'
alias vpl='virsh pool-list --all --details'

## Docker
alias dps="docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Size}}\t{{.State}}\t{{.Networks}}\t{{.Ports}}'"
alias dvl="docker volume ls --format='table {{.Name}}\t{{.Driver}}\t{{.Scope}}\t{{.Size}}\t{{.Links}}'"
alias dvla="docker volume ls --format='table {{.Mountpoint}}\t{{.Size}}'"
alias dst="docker stats -a --no-stream --format='table {{.Container}}\t{{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.BlockIO}}\t{{.NetIO}}'"
alias dctx="docker context"

## Docker compose
alias dcp="docker compose pull"
alias dcu="docker compose up -d"
alias dcd="docker compose down"
alias dcs="docker compose stats"
alias dcps="docker compose ps"
# alias dcvl="docker compose volume ls"
alias dcl="docker compose logs -f -n 50"
alias dcst="docker compose stats -a --no-stream"

## Kubernetes
alias kns="kubens"
alias kctx="kubectx"
alias k="kubecolor"
# alias k="kubectl"
alias kapi="kubecolor api-resources --sort-by=name"
alias kcani="kubecolor auth can-i –list"
alias kgcm="kubecolor get configmap -o wide"
alias kgcsr="kubecolor get csr -o wide"
alias kgcrd="kubecolor get crd"
alias kgd="kubecolor get deployments -o wide"
alias kgds="kubecolor get daemonset -o wide"
alias kge="kubecolor get events --sort-by='.metadata.creationTimestamp'"
alias kgi="kubecolor get ingress -o wide"
alias kgj="kubecolor get job"
alias kgn="kubecolor get nodes -o wide"
alias kgnp="kubecolor get networkpolicies"
alias kgns="kubecolor get namespaces"
alias kgp="kubecolor get pods -o wide"
alias kgpv="kubecolor get pv -o wide"
alias kgpvc="kubecolor get pvc -o wide"
alias kgr="kubecolor get role"
alias kgrb="kubecolor get rolebinding -o wide"
alias kgcrb="kubecolor get ClusterRoleBinding -o wide"
alias kgs="kubecolor get rc,services -o wide"
alias kgsa="kubecolor get serviceaccounts"
alias kgsfs="kubecolor get statefulsets -o wide"
alias kil="kubecolor image list"
## argocd
alias argocd-klogin='argocd login --grpc-web --name tpkube --username admin --insecure --password $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo) $(argocd context | awk "/^*/ {print \$3}")'
alias argocd-get-password='kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo'

## Vagrant
alias vssh="vagrant ssh"
alias v="vagrant"

## Vault
alias vault-oidc="vault login --method=oidc"

## Teraform
alias tf="terraform"
alias tfi="terraform init -upgrade"
alias tfd="terraform-docs markdown --output-file README.md"
alias tfp="clear; terraform plan -lock=false"
alias tfa="clear; terraform apply"
alias tff="terraform fmt"
alias tfv="terraform validate"
alias tfl="tflint"
alias tfs="trivy fs --scanners vuln,misconfig,secret,license ."