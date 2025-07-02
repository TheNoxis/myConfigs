# vim: ft=dockerfile

## --
FROM ubuntu:24.04

# Doc: https://specs.opencontainers.org/image-spec/annotations/
LABEL org.opencontainers.image.authors="[:VIM_EVAL:]$FULLNAME[:END_EVAL:]"
LABEL org.opencontainers.image.created="[:VIM_EVAL:]strftime('%Y/%m/%d - %H:%M')[:END_EVAL:]"
LABEL org.opencontainers.image.description="FIXME Human-readable description of the software packaged in the image (string)"
LABEL org.opencontainers.image.licenses="Copyright: (C) [:VIM_EVAL:]strftime('%Y')[:END_EVAL:] [:VIM_EVAL:]$COPYRIGHT[:END_EVAL:]"
LABEL org.opencontainers.image.revision="FIXME revision cvs"
LABEL org.opencontainers.image.title="FIXME Human-readable title of the image (string)"
LABEL org.opencontainers.image.vendor="FIXME ACME Incorporated"
LABEL org.opencontainers.image.version="FIXME"

ARG TOTO="toto"

ENV TATA="tata"

## --
RUN apt update && apt-get install --yes \
    bison \
    git-core \
    libasound2-dev \
    libportaudio-dev \
    python-dev \
    python-pyaudio \
    tree

WORKDIR "/opt"
RUN git clone https://xxx.git jasper

WORKDIR "/opt/jasper"
RUN pip install -r -nocache jasper/client/requirements.txt

ENTRYPOINT ["/opt/jasper/bin/jasper"]
