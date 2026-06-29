# vim: ft=make
# =====================================
## INFORMATIONS -----------------------
# =====================================
# Author: [:VIM_EVAL:]$FULLNAME[:END_EVAL:]
# Create date: [:VIM_EVAL:]strftime('%Y/%m/%d - %H:%M')[:END_EVAL:]
# Copyright: (C) [:VIM_EVAL:]strftime('%Y')[:END_EVAL:] [:VIM_EVAL:]$COPYRIGHT[:END_EVAL:]
# Describle:
#
#

# =====================================
## VARIABLES --------------------------
# =====================================
# PHONY: Désactive la vérification de l'existence d'un fichier portant le même nom qu'une règle.
.PHONY: *

NAME = 'exemple'
# Date au format YYYY-MM-DD
DATE = $(shell date +"%Y-%m-%d")
# le ?= permet de définir une variable seulement si elle n'est pas déjà définie.
WITH_DEBUG      ?= yes
# Le := permet d'évaluer la variable immédiatement, contrairement à = qui l'évalue au moment de l'utilisation.
VAR := value

# SHELL: permet de définir le shell à utiliser pour exécuter les commandes du Makefile.
SHELL := /bin/bash


# =====================================
## MAIN -------------------------------
# =====================================

all: clean

install:
	touch /tmp/$(NAME)

# .ONESHELL: permet d'exécuter toutes les commandes d'une règle dans le même shell.
.ONESHELL:
clean:
	@find ./ -type f -name "*.DELETEME"

## Le format d'un .env est le suivant :
# VARIABLE=valeur
# -include .env

test:
	@test -n "$$TEST_ZSH_BIN" && echo "Testing zsh binary: $(TEST_ZSH_BIN)" || true

test2:
ifeq (${USE_CONTAINER}, docker)
	@docker run --rm --privileged=true -it -v ${PROJECT}:/antigen ${CONTAINER_IMAGE}${ZSH_VERSION} $(shell echo "${COMMAND}" | sed "s|${PROJECT}|${CONTAINER_ROOT}|g")
else ifeq (${USE_CONTAINER}, no)
	${COMMAND}
endif

test3: export VERSION_FILE=./VERSION
test3:
	@$(call ised,"s/{{ANTIGEN_VERSION}}/$$(cat ${VERSION_FILE})/",${TARGET})
	@for src in ${GLOB}; do echo "----> $$src"; cat "$$src" >> ${TARGET}; done

# le % est un joker qui permet de faire correspondre n'importe quel nom de fichier.
# le $@ représente le nom de la cible.
# le $^ représente tous les fichiers sources.
SOURCES = $(wildcard *.txt)
%.zip: $(SOURCES)
	zip $@ $^


# ====================================
## MAIN DOCKER -----------------------
# ====================================

DOCKER_NAME=$(NAME)
DOCKER_IMG=$(NAME)
DOCKER_VOL=$(NAME)_data

all: build stop rm run logs

clean:
	docker images | grep -q ${DOCKER_IMG} && docker rmi ${DOCKER_IMG} || true

stop:
	docker stop ${DOCKER_NAME} ||:

start:
	docker start ${DOCKER_NAME}

rm:
	docker rm ${DOCKER_NAME} ||:

sh:
	docker exec -it ${DOCKER_NAME} /bin/sh

build:
	docker build -t ${DOCKER_IMG} .

run:
	#docker run -it --name ${DOCKER_NAME} -p 8080:80 -v ${DOCKER_VOL}:/srv -d --env-file ./docker.env ${DOCKER_IMG}
	docker run -it --name ${DOCKER_NAME} -v ${DOCKER_VOL}:/srv -d --env-file ./docker.env ${DOCKER_IMG}

ps:
	docker ps | grep -P '(CONTAINER|${DOCKER_NAME})'

logs:
	docker logs ${DOCKER_NAME}

ip:
	docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${DOCKER_NAME}

