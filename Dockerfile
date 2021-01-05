FROM python:3.9-alpine

ARG VERSION

ENV TZ=UTC

ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.7.3/wait /wait

COPY files/requirements.txt /requirements.txt
COPY files/run.sh /run.sh

RUN apk add --no-cache \
      mariadb-connector-c-dev \
      curl \
    && apk add --no-cache --virtual .build-deps \
      build-base \
      mariadb-dev \
    && pip3 install --no-cache-dir --upgrade pip \
    && pip3 install --no-cache-dir -r /requirements.txt \
    && if [ $VERSION != "latest" ]; then pip3 install --no-cache-dir "ara[server]==$VERSION"; else pip3 install --no-cache-dir "ara[server]"; fi \
    && adduser -D ara-server \
    && apk del .build-deps \
    && chmod +x /wait

USER ara-server
WORKDIR /home/ara-server

EXPOSE 8000

CMD ["sh", "-c", "/wait && /run.sh"]
HEALTHCHECK CMD curl --fail http://localhost:8000 || exit 1

LABEL "org.opencontainers.image.documentation"="https://docs.osism.de" \
      "org.opencontainers.image.licenses"="ASL 2.0" \
      "org.opencontainers.image.source"="https://github.com/osism/docker-image-ara-server" \
      "org.opencontainers.image.url"="https://www.osism.de" \
      "org.opencontainers.image.vendor"="Betacloud Solutions GmbH"
