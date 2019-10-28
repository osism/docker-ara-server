FROM python:3.7-alpine
LABEL maintainer="Betacloud Solutions GmbH (https://www.betacloud-solutions.de)"

ARG VERSION
ENV VERSION ${VERSION:-latest}

COPY files/run.sh /run.sh

RUN apk add --no-cache \
      mariadb-connector-c-dev \
      curl \
    && apk add --no-cache --virtual .build-deps \
      build-base \
      mariadb-dev \
    && pip3 install --no-cache-dir PyMySQL mysqlclient \
    && if [ $VERSION != "latest" ]; then pip3 install "ara[server]==$VERSION"; else pip3 install "ara[server]"; fi \
    && adduser -D ara-server \
    && apk del .build-deps

USER ara-server
WORKDIR /home/ara-server

EXPOSE 8000

CMD ["/run.sh"]
HEALTHCHECK CMD curl --fail http://localhost:8000 || exit 1
