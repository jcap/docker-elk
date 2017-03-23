

export ELASTIC_VERSION=5.2.2
export ES_DOWNLOAD_URL=https://artifacts.elastic.co/downloads/elasticsearch
export LOGSTASH_PACK_URL=https://artifacts.elastic.co/downloads/logstash-plugins
export LOGSTASH_DOWNLOAD_URL=https://artifacts.elastic.co/downloads/logstash
export KIBANA_DOWNLOAD_URL=https://artifacts.elastic.co/downloads/kibana
export METRICBEAT_DOWNLOAD_URL=https://artifacts.elastic.co/downloads/beats

all: build up

up:
	docker-compose up -d

build:
	docker-compose build

down:
	docker-compose down


init:
	docker exec -t dockerelk_elasticsearch_1 /bin/bash -c 'curl -XPUT "http://$$ELASTICSEARCH_USERNAME:$$ELASTICSEARCH_PASSWORD@localhost:9200/_xpack/security/user/logstash_system/_password?pretty" -H "Content-Type: application/json" -d " { \"password\": \"$$LOGSTASH_MONITORING_PASSWORD\" } "'


#backup:
#	docker run -v dockerelk_elasticsearch-data:/data --rm jcap/elasticsearch tar -cvf - -C / data | xz > esbackup.tar.xz
