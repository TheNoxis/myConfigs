# vim: ft=bash
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
alias git-purge-branch="git fetch --prune --prune-tags && git branch --format='%(refname:short) %(upstream:track)'| awk '\$2 == \"[gone]\" {print \$1}'|xargs -r git branch -d"
alias git-purge-branch-unmerged="git fetch --prune --prune-tags && git branch --format='%(refname:short) %(upstream:track)'| awk '\$2 == \"[gone]\" {print \$1}'|xargs -r git branch -D"


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
alias k="kubecolor"
alias kns="kubens"
alias kctx="kubectx"
#
alias kil="kubecolor image list"
alias kapi="kubecolor api-resources --sort-by=name"
alias kcani="kubecolor auth can-i -list"
alias kwhoami="kubecolor auth can-i --list --namespace $(kubectl config view --minify -o 'jsonpath={..namespace}')"
alias kexec="kubecolor exec -it"
alias kport="kubecolor port-forward"
#
alias stern="kubectl stern --color always"
alias klogs="kubecolor logs -f"
alias klogsp="kubecolor logs -f -p"
alias kcurl="kubectl run curl-tmp -it --rm --image=nicolaka/netshoot --restart=Never -- curl -kv "
alias ktop="kubectl ktop"
alias ktp="kubecolor top pods"
alias ktn="kubecolor top nodes"
# LIST with GET -------------------
alias kgcm="kubecolor get configmap -o yaml"
alias kgcrb="kubecolor get ClusterRoleBinding -o yaml"
alias kgcrd="kubecolor get crd -o yaml"
alias kgcrt="kubecolor get certificate -o yaml"
alias kgcsr="kubecolor get csr -o yaml"
alias kgd="kubecolor get deployments -o yaml"
alias kgds="kubecolor get daemonset -o yaml"
alias kge="kubecolor get events  -o yaml"
alias kgi="kubecolor get ingress -o yaml"
alias kgir="kubecolor get ingressRoute -o yaml"
alias kgj="kubecolor get job -o yaml"
alias kgn="kubecolor get nodes -o yaml"
alias kgnp="kubecolor get networkpolicies -o yaml"
alias kgns="kubecolor get namespaces -o yaml"
alias kgp="kubecolor get pods -o yaml"
alias kgpv="kubecolor get pv -o yaml"
alias kgpvc="kubecolor get pvc -o yaml"
alias kgpr="kubecolor get policyreport -o yaml"
alias kgr="kubecolor get role -o yaml"
alias kgrb="kubecolor get rolebinding -o yaml"
alias kgs="kubecolor get services -o yaml -o yaml"
alias kgsec="kubecolor get secret -o yaml"
alias kgsm="kubecolor get servicemonitor -o yaml"
alias kgsa="kubecolor get serviceaccounts -o yaml"
alias kgsfs="kubecolor get statefulsets -o yaml"
alias kgvs="kubecolor get volumesnapshots -o yaml"
alias kgvsc="kubecolor get volumesnapshotcontents -o yaml"
alias kgrs="kubecolor get replicasets -o yaml"
alias kgrc="kubecolor get replicationcontrollers -o yaml"
alias kgcj="kubecolor get cronjob -o yaml"
alias kgb="kubecolor get bundle -o yaml"
alias kgc="kubecolor get cluster -o yaml"
# GET -------------------------------
alias klcm="kubecolor get configmap -o wide"
alias klcrb="kubecolor get ClusterRoleBinding -o wide"
alias klcrd="kubecolor get crd -o wide"
alias Klcrt="kubecolor get certificate -o wide"
alias klcsr="kubecolor get csr -o wide"
alias kld="kubecolor get deployments -o wide"
alias klds="kubecolor get daemonset -o wide"
alias kle="kubecolor get events --sort-by='.lastTimestamp'"
# alias kle="kubecolor get events --sort-by='.metadata.creationTimestamp'"
alias kli="kubecolor get ingress -o wide"
alias klir="kubecolor get ingressRoute -o wide"
alias klj="kubecolor get job"
alias kln="kubecolor get nodes -o wide"
alias klnp="kubecolor get networkpolicies"
alias klns="kubecolor get namespaces"
alias klp="kubecolor get pods -o wide"
alias klpv="kubecolor get pv -o wide"
alias klpvc="kubecolor get pvc -o wide"
alias klpr="kubecolor get policyreport --sort-by .metadata.creationTimestamp"
alias klr="kubecolor get role"
alias klrb="kubecolor get rolebinding -o wide"
alias kls="kubecolor get services -o wide"
alias klsec="kubecolor get secret"
alias klsm="kubecolor get servicemonitor"
alias klsa="kubecolor get serviceaccounts"
alias klsfs="kubecolor get statefulsets -o wide"
alias klvs="kubecolor get volumesnapshots"
alias klvsc="kubecolor get volumesnapshotcontents"
alias klrs="kubecolor get replicasets"
alias klrc="kubecolor get replicationcontrollers"
alias klgcj="kubecolor get cronjob -o wide"
alias klb="kubecolor get bundle -o wide"
alias klc="kubecolor get cluster -o wide"
## DESCRIBE -----------------------------
alias kdcm="kubecolor describe configmap"
alias kdcrb="kubecolor describe ClusterRoleBinding"
alias kdcrd="kubecolor describe crd"
alias kdcrt="kubecolor describe certificate"
alias kdcsr="kubecolor describe csr"
alias kdd="kubecolor describe deployments"
alias kdds="kubecolor describe daemonset"
alias kde="kubecolor describe events --sort-by='.lastTimestamp'"
alias kdi="kubecolor describe ingress"
alias kdir="kubecolor describe ingressRoute"
alias kdj="kubecolor describe job"
alias kdn="kubecolor describe nodes"
alias kdnp="kubecolor describe networkpolicies"
alias kdns="kubecolor describe namespaces"
alias kdp="kubecolor describe pods"
alias kdpv="kubecolor describe pv"
alias kdpvc="kubecolor describe pvc"
alias kdpr="kubecolor describe policyreport"
alias kdr="kubecolor describe role"
alias kdrb="kubecolor describe rolebinding"
alias kds="kubecolor describe services"
alias kdsec="kubecolor describe secret"
alias kdsm="kubecolor describe servicemonitor"
alias kdsa="kubecolor describe serviceaccounts"
alias kdsfs="kubecolor describe statefulsets"
alias kdvs="kubecolor describe volumesnapshots"
alias kdvsc="kubecolor describe volumesnapshotcontents"
alias kdrs="kubecolor describe replicasets"
alias kdrc="kubecolor describe replicationcontrollers"
alias kdcj="kubecolor describe cronjob"
alias kdb="kubecolor describe bundle"
alias kdc="kubecolor describe cluster"
## EDIT ------------------------------------
alias kecm="kubecolor edit configmap"
alias kecrb="kubecolor edit ClusterRoleBinding"
alias kecrd="kubecolor edit crd"
alias kecrt="kubecolor edit certificate"
alias kecsr="kubecolor edit csr"
alias ked="kubecolor edit deployments"
alias keds="kubecolor edit daemonset"
alias kee="kubecolor edit events --sort-by='.lastTimestamp'"
alias kei="kubecolor edit ingress"
alias keir="kubecolor edit ingressRoute"
alias kej="kubecolor edit job"
alias ken="kubecolor edit nodes"
alias kenp="kubecolor edit networkpolicies"
alias kens="kubecolor edit namespaces"
alias kep="kubecolor edit pods"
alias kepv="kubecolor edit pv"
alias kepvc="kubecolor edit pvc"
alias kepr="kubecolor edit policyreport"
alias ker="kubecolor edit role"
alias kerb="kubecolor edit rolebinding"
alias kes="kubecolor edit services"
alias kesec="kubecolor edit secret"
alias kesa="kubecolor edit serviceaccounts"
alias kesfs="kubecolor edit statefulsets"
alias kevs="kubecolor edit volumesnapshots"
alias kevsc="kubecolor edit volumesnapshotcontents"
alias kers="kubecolor edit replicasets"
alias kerc="kubecolor edit replicationcontrollers"
alias kecj="kubecolor edit cronjob"
alias keb="kubecolor edit bundle"
alias kec="kubecolor edit cluster"


## argocd
alias argocd-klogin='argocd login --grpc-web --name tpkube --username admin --insecure --password $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo) $(argocd context | awk "/^*/ {print \$3}")'
alias argocd-get-password='kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo'

## Vagrant
alias vssh="vagrant ssh"
alias v="vagrant"

## Vault
alias vault-oidc="vault login --method=oidc"

## Teraform
alias tfdebug='export TF_LOG=$([ "$TF_LOG" != "DEBUG" ] && echo "DEBUG" || echo ""); echo "> Terraform log: $TF_LOG"'
alias tfdebug_core='export TF_LOG_CORE=$([ "$TF_LOG_CORE" != "DEBUG" ] && echo "DEBUG" || echo ""); echo "> Terraform log: $TF_LOG_CORE"'
alias tfdebug_provider='export TF_LOG_PROVIDER=$([ "$TF_LOG_PROVIDER" != "DEBUG" ] && echo "DEBUG" || echo ""); echo "> Terraform log: $TF_LOG_PROVIDER"'
alias tf="terraform"
alias tfi="terraform init -upgrade"
alias tfd="terraform-docs markdown --output-file README.md"
alias tfp="clear; terraform plan -lock=false"
alias tfa="clear; terraform apply"
alias tff="terraform fmt"
alias tfv="terraform validate"
alias tfl="tflint"
alias tfs="trivy fs --scanners vuln,misconfig,secret,license ."

# OpenShift CLI
alias oc="kubecolor"
