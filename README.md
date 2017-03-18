## [Elastic Stack](https://www.elastic.co/products) in Docker Containers

This is a relatively self contained Elastic Stack, each component running in its
own Docker container. All Docker images are based off
[alpine:latest](https://hub.docker.com/_/alpine/) to keep image sizes as small
as possible.

Configuration is managed almost entirely through a single environment variable
file.

Based heavily off the Dockerfiles distribrubted by
[elastic](https://github.com/elastic) themselves.
[logstash](https://github.com/elastic/logstash-docker),
[elasticsearch](https://github.com/elastic/elasticsearch-docker), and
[kibana](https://github.com/elastic/kibana-docker) were all adapted.
[beats-docker](https://github.com/elastic/beats-docker) was later found and used
to help refine a few pieces.

### Build

```shell
make build
```

### Run

```shell
make up
```
