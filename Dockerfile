FROM python:3.7
LABEL maintainer="Betacloud Solutions GmbH (https://www.betacloud-solutions.de)"

ARG VERSION
ENV VERSION ${VERSION:-1.1.0}

ENV DEBIAN_FRONTEND noninteractive

COPY files/run.sh /run.sh

RUN pip3 install PyMySQL mysqlclient \
    && if [ $VERSION != "latest" ]; then pip3 install "ara[server]==$VERSION"; else pip3 install "ara[server]"; fi \
    && useradd -m ara-server

USER ara-server
WORKDIR /home/ara-server

EXPOSE 8000

CMD ["/run.sh"]
HEALTHCHECK CMD curl --fail http://localhost:8000/ || exit 1
