# Docker Image for Elasticsearch
This repository contains Dockerfile to build an image that dock [Elasticsearch]() service.

## Usage

### Build this image

The pre-built image is publish in Docker Hub with name r3v3r/elasticsearch

To build it yourself, run this command on project directory:
```sh
$ docker build -t <your_image_name_here>[:<tag name>] .
```
Example: Build an image from this Dockerfile with name rever/elasticsearch and tag latest
```sh
$ docker build -t rever/elasticsearch:latest .
```

### Run service

Run with default configuration:
```sh
$ docker run -d -p 9200:9200 -p 9300:9300 r3v3r/elasticsearch 
```
NOTE: Replace `-p 9200:9200` with `-p <your_external_http_port>:9200`; and, `-p 9300:9300` with `-p <your_external_tcp_port>:9300`

Run with custom configuration
```sh
$ docker run -d -p <your_external_http_port>:9200 -p <your_external_tcp_port>:9300 \
    -v <folder_contains_config_file_on_host>:/usr/share/elasticsearch/config \
    -v <data_folder_on_host>:<data_folder_on_container>:rw \
    [-v <log_folder_on_host>:<log_folder_on_container>:rw] \
    [--name <your_container_name>] \
    r3v3r/elasticsearch [<your_custom_config>]
```
NOTE: <data_folder_on_container> must be the same with `path.data` in config file; and, <log_folder_on_container> must be the same with `path.logs` in config file.

Example:
```sh
$ docker run -d -p 9200:9200 -p 9300:9300 \
    -v /root/docker-elasticsearch/config:/usr/share/elasticsearch/config \
    -v /root/docker-elasticsearch/data:/usr/share/elasticsearch/data:rw \
    -v /root/docker-elasticsearch/log:/usr/share/elasticsearch/logs:rw \
    --name test_elasticsearch \
    r3v3r/elasticsearch -Dcluster.name=sample_cluster
```
This command will spawn a docker container that run elasticsearch service with these configurations:

 * Configuration file in `/root/docker-elasticsearch/config` of host machine
 * Data of ssdb will be storaged in `/root/docker-elasticsearch/data` of host machine
 * Log files will be storaged in `/root/docker-elasticsearch/log` of host machine`
 * Cluster name is `sample_cluster`