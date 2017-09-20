FROM ubuntu:16.04
LABEL maintainer="Betacloud Solutions GmbH (https://www.betacloud-solutions.de)"

ENV DEBIAN_FRONTEND noninteractive
ARG VERSION
ENV VERSION ${VERSION:-0.14.3}

COPY files/run.sh /run.sh

RUN apt-get update \ 
    && apt-get install -y \ 
        libffi-dev \
        libssl-dev \
        python-dev \
        python-pip \ 
    && pip install --upgrade pip \
    && pip install pymysql \
    && pip install ara==$VERSION \
    && useradd -m -d /ara ara \
    && apt-get clean \
    && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/*

USER ara

VOLUME ["/ara"]
EXPOSE 9191

CMD ["/run.sh"]
