FROM pypy:3.7-slim

ARG VERSION

ENV TZ=UTC

ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.9.0/wait /wait

COPY files/requirements.txt /requirements.txt
COPY files/run.sh /run.sh

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      build-essential \
      curl \
      gcc \
      libffi-dev \
      libmariadb3 \
      libmariadbclient-dev \
      libssl-dev \
      libyaml-dev \
    && pip3 install --no-cache-dir --upgrade pip \
    && pip3 install --no-cache-dir -r /requirements.txt \
    && if [ $VERSION != "latest" ]; then pip3 install --no-cache-dir "ara[server]==$VERSION"; else pip3 install --no-cache-dir "ara[server]"; fi \
    && useradd ara-server \
    && chmod +x /wait \
    && apt-get clean \
    && apt-get remove -y \
      build-essential \
      gcc \
      libffi-dev \
      libmariadbclient-dev \
      libssl-dev \
      libyaml-dev \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

USER ara-server
WORKDIR /home/ara-server

EXPOSE 8000

CMD ["sh", "-c", "/wait && /run.sh"]
HEALTHCHECK CMD curl --fail http://localhost:8000 || exit 1

LABEL "org.opencontainers.image.documentation"="https://docs.osism.de" \
      "org.opencontainers.image.licenses"="ASL 2.0" \
      "org.opencontainers.image.source"="https://github.com/osism/container-image-ara-server" \
      "org.opencontainers.image.url"="https://www.osism.de" \
      "org.opencontainers.image.vendor"="OSISM GmbH"
