# vim: ft=dockerfile
##
# Create date: [:VIM_EVAL:]strftime('%Y/%m/%d - %H:%M')[:END_EVAL:]
# Copyright: (C) [:VIM_EVAL:]strftime('%Y')[:END_EVAL:] Stéphane Henry
##
MAINTAINER Henry Stéphane
LABEL com.example.version="0.01"
LABEL vendor="ACME Incorporated"
LABEL com.example.release-date="[:VIM_EVAL:]strftime('%Y/%m/%d - %H:%M')[:END_EVAL:]"
LABEL com.example.version.is-production="false"
##
FROM debian:jessie
##
WORKDIR "/opt"
RUN apt-get update && apt-get install --yes git-core python-dev bison libasound2-dev libportaudio-dev python-pyaudio tree
#RUN easy_install pip
RUN git clone https://github.com/jasperproject/jasper-client.git jasper
WORKDIR "jasper"
RUN sudo pip install --upgrade setuptools
RUN pip install -r jasper/client/requirements.txt

RUN tree /opt
