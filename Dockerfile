FROM python:3.7-alpine

ARG VERSION

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

LABEL "org.opencontainers.image.documentation"="https://docs.osism.io" \
      "org.opencontainers.image.licenses"="ASL 2.0" \
      "org.opencontainers.image.source"="https://github.com/osism/docker-kolla-ansible" \
      "org.opencontainers.image.url"="https://www.osism.de" \
      "org.opencontainers.image.vendor"="Betacloud Solutions GmbH"
