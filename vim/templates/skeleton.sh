#!/usr/bin/env bash
# vim: ft=sh ts=4 syntax=sh
#
# Mode debug
# set -x
# Exit if error found
set -e
# Exit si une variable est référencée avant d'etre définie:
set -u
# Retourne $?=2 si une commmande avant un pipe est en erreur:
set -o pipefail


# =====================================
## INFORMATIONS -----------------------
# =====================================
# Author: Henry Stéphane
# Create date: [:VIM_EVAL:]strftime('%Y/%m/%d - %H:%M')[:END_EVAL:]
# Copyright: (C) [:VIM_EVAL:]strftime('%Y')[:END_EVAL:] Stéphane Henry
# Describle:
#
#


# =====================================
## VARIABLES GLOBALES -----------------
# =====================================
RETURN_CODE=0
DATETIME=$(date +'%Y%m%d-%H%M%S')
SCRIPT_PATH=$(readlink -f "$0")
#SCRIPT_NAME=$(basename $0)
SCRIPT_NAME=${SCRIPT_PATH##*/}
#SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
SCRIPT_DIR=${SCRIPT_PATH%/*}
LOG=false
LOG_FILE=${SCRIPT_NAME%.sh}.log
CP_OPT=''
RM_OPT=''
CHMOD_OPT=''
CHOWN_OPT=''
## Couleurs:
NC='\e[0m'
NC=$(tput sgr0 )
black=$(tput setaf 0)
BLACK=$(tput setab 0)
red=$(tput setaf 1)
RED=$(tput setab 1)
green=$(tput setaf 2)
GREEN=$(tput setab 2)
yellow=$(tput setaf 3)
YELLOW=$(tput setab 3)
blue=$(tput setaf 4)
BLUE=$(tput setab 4)
magenta=$(tput setaf 5)
MAGENTA=$(tput setab 5)
cyan=$(tput setaf 6)
CYAN=$(tput setab 6)
white=$(tput setaf 7)
WHITE=$(tput setab 7)


# =====================================
## FUNCTIONS --------------------------
# =====================================

function _help {
	cat <<EOF
  Usage: $SCRIPT_NAME <options>
Options:
          -h : Affiche cette aide
          -v : Verbose mode.
          -d : Debug mode.
    -a <arg> : Exemple.
EOF
	exit 0
}

# =====================================
## MAIN -------------------------------
# =====================================

## Loggin:
if $LOG ; then
	exec 1> >(tee -a "$LOG_FILE" )
	exec 2> >(tee -a "$LOG_FILE" >&2 )
fi

## Traitement des arguments:
while getopts ":a:hvd" opt; do
	case $opt in
		a)
			echo "-a was triggered, Parameter: $OPTARG" >&2
			;;
		h)
			_help
			exit 0
			;;
		d)
			set -x
			;;
		v)
			CP_OPT="$CP_OPT -v"
			CHMOD_OPT="$CHMOD_OPT -v"
			RM_OPT="$RM_OPT -v"
			CHOWN_OPT="$CHOWN_OPT -v"
			;;
		\?)
			echo "Invalid option: -$OPTARG" >&2
			exit 1
			;;
		:)
			echo "Option -$OPTARG requires an argument." >&2
			exit 1
			;;
	esac
done

test -e /toto
ret=$?
RETURN_CODE=$(( RETURN_CODE + ret ))

exit $RETURN_CODE
