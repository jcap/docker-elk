FROM alpine:latest
MAINTAINER John Cappiello <john@johncappiello.com>

ARG ELASTIC_VERSION
ARG KIBANA_DOWNLOAD_URL

ENV PATH /usr/share/kibana/bin:$PATH
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk

RUN adduser -D -u 1000 -h /usr/share/kibana kibana

EXPOSE 5601

WORKDIR /usr/share/kibana

# do all in one step
RUN set -ex && \
    apk update && \
    apk upgrade --update && \
    apk add --update libstdc++ curl ca-certificates bash curl openjdk8 openssl nodejs git && \
    update-ca-certificates && \
    wget ${KIBANA_DOWNLOAD_URL}/kibana-${ELASTIC_VERSION}-linux-x86_64.tar.gz && \
    EXPECTED_SHA=$(wget -O - ${KIBANA_DOWNLOAD_URL}/kibana-${ELASTIC_VERSION}-linux-x86_64.tar.gz.sha1) && \
    test $EXPECTED_SHA == $(sha1sum kibana-${ELASTIC_VERSION}-linux-x86_64.tar.gz | awk '{print $1}') && \
    tar zxf kibana-${ELASTIC_VERSION}-linux-x86_64.tar.gz && \
    chown -R kibana:kibana kibana-${ELASTIC_VERSION}-linux-x86_64 && \
    mv kibana-${ELASTIC_VERSION}-linux-x86_64/* . && \
    rmdir kibana-${ELASTIC_VERSION}-linux-x86_64 && \
    rm kibana-${ELASTIC_VERSION}-linux-x86_64.tar.gz && \
    rm -rf /var/cache/apk/*

# usr alpine nodejs and not bundled version
RUN bundled='NODE="${DIR}/node/bin/node"' && \
  apline_node='NODE="/usr/bin/node"' && \
  sed -i "s|$bundled|$apline_node|g" /usr/share/kibana/bin/kibana-plugin && \
  sed -i "s|$bundled|$apline_node|g" /usr/share/kibana/bin/kibana && \
  rm -rf /usr/share/kibana/node

# Add the launcher/wrapper script. It knows how to interpret environment
# variables and translate them to Kibana CLI options.
ADD bin/kibana-docker /usr/local/bin/
RUN chmod a+x /usr/local/bin/kibana-docker

# Add a self-signed SSL certificate for use in examples.
ADD ssl/kibana.example.org.* /usr/share/kibana/config/

# Set some Kibana configuration defaults.
ADD etc/kibana.yml /usr/share/kibana/config/

RUN set -ex && for esdirs in config ; do \
        mkdir -p "$esdirs"; \
        chown -R kibana:kibana "$esdirs"; \
    done

USER kibana

RUN kibana-plugin install x-pack

CMD /usr/local/bin/kibana-docker
