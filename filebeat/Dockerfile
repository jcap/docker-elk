FROM alpine:latest
MAINTAINER John Cappiello <john@johncappiello.com>

ARG ELASTIC_VERSION
ARG BEAT_DOWNLOAD_URL

ENV PATH /usr/share/filebeat/bin:$PATH

WORKDIR /usr/share/filebeat

# do all in one step
RUN set -ex && \
    apk update && \
    apk upgrade --update && \
    apk add --no-cache --update libstdc++ curl ca-certificates bash curl openssl git && \
    update-ca-certificates && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-2.25-r0.apk && \
    apk add glibc-2.25-r0.apk && \
    wget ${BEAT_DOWNLOAD_URL}/filebeat/filebeat-${ELASTIC_VERSION}-linux-x86_64.tar.gz && \
    EXPECTED_SHA=$(wget -O - ${BEAT_DOWNLOAD_URL}/filebeat/filebeat-${ELASTIC_VERSION}-linux-x86_64.tar.gz.sha1) && \
    test $EXPECTED_SHA == $(sha1sum filebeat-${ELASTIC_VERSION}-linux-x86_64.tar.gz | awk '{print $1}') && \
    tar zvxf filebeat-${ELASTIC_VERSION}-linux-x86_64.tar.gz && \
    mv filebeat-${ELASTIC_VERSION}-linux-x86_64/filebeat . && \
    mv filebeat-${ELASTIC_VERSION}-linux-x86_64/*.json . && \
    mv filebeat-${ELASTIC_VERSION}-linux-x86_64/scripts . && \
    rm -rf filebeat-${ELASTIC_VERSION}-linux-x86_64 && \
    rm filebeat-${ELASTIC_VERSION}-linux-x86_64.tar.gz && \
    rm -rf /var/cache/apk/*

# Add the launcher/wrapper script. It knows how to interpret environment
# variables and translate them to Kibana CLI options.
ADD bin/filebeat-docker /usr/local/bin/
RUN chmod a+x /usr/local/bin/filebeat-docker

# Set some Metricbeat configuration defaults.
ADD etc/filebeat.yml /usr/share/filebeat/
RUN mkdir /usr/share/filebeat/data
RUN mkdir /usr/share/filebeat/logs


CMD /usr/local/bin/filebeat-docker
