FROM alpine:latest
MAINTAINER John Cappiello <john@johncappiello.com>

ARG ELASTIC_VERSION
ARG METRICBEAT_DOWNLOAD_URL

ENV PATH /usr/share/metricbeat/bin:$PATH
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk

RUN adduser -D -u 1000 -h /usr/share/metricbeat metricbeat

EXPOSE 5601

WORKDIR /usr/share/metricbeat

# do all in one step
RUN set -ex && \
    apk update && \
    apk upgrade --update && \
    apk add --no-cache --update libstdc++ curl ca-certificates bash curl openjdk8 openssl git && \
    update-ca-certificates && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-2.25-r0.apk && \
    apk add glibc-2.25-r0.apk && \
    wget ${METRICBEAT_DOWNLOAD_URL}/metricbeat/metricbeat-${ELASTIC_VERSION}-linux-x86_64.tar.gz && \
    EXPECTED_SHA=$(wget -O - ${METRICBEAT_DOWNLOAD_URL}/metricbeat/metricbeat-${ELASTIC_VERSION}-linux-x86_64.tar.gz.sha1) && \
    test $EXPECTED_SHA == $(sha1sum metricbeat-${ELASTIC_VERSION}-linux-x86_64.tar.gz | awk '{print $1}') && \
    tar zvxf metricbeat-${ELASTIC_VERSION}-linux-x86_64.tar.gz && \
    chown -R metricbeat:metricbeat metricbeat-${ELASTIC_VERSION}-linux-x86_64 && \
    mv metricbeat-${ELASTIC_VERSION}-linux-x86_64/metricbeat . && \
    mv metricbeat-${ELASTIC_VERSION}-linux-x86_64/*.json . && \
    mv metricbeat-${ELASTIC_VERSION}-linux-x86_64/scripts . && \
    rm -rf metricbeat-${ELASTIC_VERSION}-linux-x86_64 && \
    rm metricbeat-${ELASTIC_VERSION}-linux-x86_64.tar.gz && \
    rm -rf /var/cache/apk/*

# Add the launcher/wrapper script. It knows how to interpret environment
# variables and translate them to Kibana CLI options.
ADD bin/metricbeat-docker /usr/local/bin/
RUN chmod a+x /usr/local/bin/metricbeat-docker

# Set some Metricbeat configuration defaults.
ADD etc/metricbeat.yml /usr/share/metricbeat/
RUN mkdir /usr/share/metricbeat/data
RUN mkdir /usr/share/metricbeat/logs

RUN chown -R metricbeat:metricbeat /usr/share/metricbeat

#USER metricbeat

CMD /usr/local/bin/metricbeat-docker
