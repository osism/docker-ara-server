FROM python:3.7
LABEL maintainer="Betacloud Solutions GmbH (https://www.betacloud-solutions.de)"

ENV DEBIAN_FRONTEND noninteractive
ARG VERSION
ENV VERSION ${VERSION:-0.16.1}

COPY files/run.sh /run.sh

RUN pip3 install pymysql \
    && pip3 install ara==$VERSION \
    && useradd -m -d /ara ara

USER ara

VOLUME ["/ara"]
EXPOSE 9191

CMD ["/run.sh"]
HEALTHCHECK CMD curl --fail http://localhost:9191/ || exit 1
