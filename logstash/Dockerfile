FROM alpine:latest
MAINTAINER John Cappiello <john@johncappiello.com>

ARG ELASTIC_VERSION
ARG LOGSTASH_DOWNLOAD_URL
ARG LOGSTASH_PACK_URL

ENV PATH /usr/share/logstash/bin:$PATH
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk

RUN adduser -D -u 1000 -h /usr/share/logstash logstash
WORKDIR /usr/share/logstash

# do all in one step
RUN set -ex && \
    apk update && \
    apk upgrade --update && \
    apk add --update libstdc++ curl ca-certificates bash curl openjdk8 openssl && \
    update-ca-certificates && \
    wget ${LOGSTASH_DOWNLOAD_URL}/logstash-${ELASTIC_VERSION}.tar.gz && \
    EXPECTED_SHA=$(wget -O - ${LOGSTASH_DOWNLOAD_URL}/logstash-${ELASTIC_VERSION}.tar.gz.sha1) && \
    test $EXPECTED_SHA == $(sha1sum logstash-${ELASTIC_VERSION}.tar.gz | awk '{print $1}') && \
    tar zxf logstash-${ELASTIC_VERSION}.tar.gz && \
    chown -R logstash:logstash logstash-${ELASTIC_VERSION} && \
    mv logstash-${ELASTIC_VERSION}/* . && \
    rmdir logstash-${ELASTIC_VERSION} && \
    rm logstash-${ELASTIC_VERSION}.tar.gz && \
    rm -rf /var/cache/apk/*

ADD bin/logstash-docker /usr/local/bin/
RUN chmod a+x /usr/local/bin/logstash-docker

# Provide a minimal configuration, so that simple invocations will provide a good experience.
ADD etc/log4j2.properties /usr/share/logstash/config/
ADD etc/logstash.yml /usr/share/logstash/config/
ADD pipeline/default.conf /usr/share/logstash/pipeline/logstash.conf

RUN set -ex && for esdirs in config pipeline; do \
        mkdir -p "$esdirs"; \
        chown -R logstash:logstash "$esdirs"; \
    done

USER logstash

# Install xpack
RUN cd /usr/share/logstash && LOGSTASH_PACK_URL=${LOGSTASH_PACK_URL} logstash-plugin install x-pack

EXPOSE 5044

CMD /usr/local/bin/logstash-docker
