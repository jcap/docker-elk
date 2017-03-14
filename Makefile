

export ELASTIC_VERSION=5.2.2
export ES_DOWNLOAD_URL=https://artifacts.elastic.co/downloads/elasticsearch
export LOGSTASH_PACK_URL=https://artifacts.elastic.co/downloads/logstash-plugins
export LOGSTASH_DOWNLOAD_URL=https://artifacts.elastic.co/downloads/logstash
export KIBANA_DOWNLOAD_URL=https://artifacts.elastic.co/downloads/kibana

up:
	docker-compose up -d

build:
	docker-compose build

down:
	docker-compose down
