# This file is subject to the terms and conditions defined in file 'LICENSE',
# which is part of this repository.

FROM ubuntu:16.04
MAINTAINER Betacloud Solutions GmbH (https://www.betacloud-solutions.de)

ENV DEBIAN_FRONTEND noninteractive
ARG VERSION
ENV VERSION ${VERSION:-0.13.3}

COPY files/extend_start.sh /extend_start.sh

RUN apt-get update \ 
    && apt-get install -y \ 
        libffi-dev \
        libssl-dev \
        python-dev \
        python-pip \ 
    && echo "[global]\nindex-url = https://devpi-0.betacloud.io/root/pypi/+simple/\ntrusted-host = devpi-0.betacloud.io" > /etc/pip.conf \
    && pip install --upgrade pip \
    && pip install pymysql \
    && pip install ara==$VERSION \
    && groupadd kolla \
    && useradd -m -d /var/lib/ara-server ara-server \
    && usermod -a -G kolla ara-server \
    && mkdir /ara \
    && chown ara-server: /ara \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER ara-server

ENTRYPOINT ["/extend_start.sh"]
EXPOSE 9191
