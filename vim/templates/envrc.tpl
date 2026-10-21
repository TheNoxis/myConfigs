# =====================================
## INFORMATIONS -----------------------
# =====================================
# Author: [:VIM_EVAL:]$FULLNAME[:END_EVAL:]
# Create date: [:VIM_EVAL:]strftime('%Y/%m/%d - %H:%M')[:END_EVAL:]
# Copyright: (C) [:VIM_EVAL:]strftime('%Y')[:END_EVAL:] [:VIM_EVAL:]$COPYRIGHT[:END_EVAL:]
# Describle: Fichier de configuration pour l'environnement de développement.
#    Il est utilisé par l'outil direnv pour charger automatiquement 
#    les variables d'environnement lorsque vous entrez dans le répertoire du projet.
#

## Chargement d'environnement de langage de programmation
# layout python3
# layout node
# use goenv 1.24.2

##
# use novops

## Variable d'environnement pour kubernetes
# export KUBECONFIG=$PWD/.kube-config.yml

# export_alias zz "ls -la"
# export_alias <alias_name> <command>

## Pour une varaible export DIUN_NOTIF_TELEGRAM_CHATIDS=xxxxxxxxxx
# export_vault kv_IDH/diun/DIUN_NOTIF_TELEGRAM_CHATIDS
