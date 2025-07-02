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

NAME='exemple'

# =====================================
## MAIN -------------------------------
# =====================================

all: clean

install:
	touch /tmp/$(NAME)

clean:
	@find ./ -type f -name "*.DELETEME"




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

