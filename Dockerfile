FROM ubuntu:focal
LABEL maintainer="Alberto Lazaro<alazarolop at posteo.me>"
ENV REFRESHED_AT 2020-05-06

ENV DEBIAN_FRONTEND="noninteractive"

ARG TZ=Europe/Madrid
# Version of Saga-GIS in Git repository (i.e., 'git branch')
ARG SAGA_VERSION="release-7.6.3"
ARG NCORES=10

RUN apt-get update \
    && apt-get install -qy --no-install-recommends \
        libwxgtk3.0-gtk3-dev libtiff5-dev libgdal-dev libproj-dev \
        libexpat-dev wx-common libogdi-dev unixodbc-dev libgomp1 \
    && apt-get install -qy --no-install-recommends g++ make automake libtool git

# Building tools                        
RUN _TMPDIR=$(mktemp -d) \
    && cd $_TMPDIR \
    && git clone git://git.code.sf.net/p/saga-gis/code saga-gis-code \
    && cd saga-gis-code/saga-gis/ \
    && git checkout $SAGA_VERSION \
    # Building
    && autoreconf -fi \
    && ./configure \
    && make -j $NCORES \
    && make install \
    && ldconfig \
    && cd \
    && rm -rf $_TMPDIR

CMD ["/bin/bash"]