FROM python:3.7-alpine AS build

ARG VERSION="latest"
ENV PATH="/opt/ara-server/bin:$PATH"

RUN apk add --no-cache \
      mariadb-connector-c-dev \
      curl
RUN apk add --no-cache --virtual \
      .build-deps \
      build-base \
      mariadb-dev
RUN python -m venv /opt/ara-server
RUN pip3 install --no-cache-dir PyMySQL mysqlclient
RUN if [ $VERSION != "latest" ]; then pip3 install "ara[server]==$VERSION"; else pip3 install "ara[server]"; fi

FROM python:3.7-alpine
LABEL maintainer="Betacloud Solutions GmbH (https://www.betacloud-solutions.de)"

COPY files/run.sh /run.sh
RUN adduser -D ara-server

USER ara-server
WORKDIR /home/ara-server
COPY --from=build /opt/ara-server /opt/ara-server

EXPOSE 8000

CMD ["/run.sh"]
HEALTHCHECK CMD curl --fail http://localhost:8000 || exit 1
