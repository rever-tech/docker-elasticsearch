FROM openjdk:8-jre

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.7
RUN set -x \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true

ARG ES_VERSION=2.4.1
ARG ES_BASE_LINK=https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch

RUN set -x && apt-get update && apt-get install wget

RUN wget $ES_BASE_LINK/$ES_VERSION/elasticsearch-${ES_VERSION}.tar.gz

RUN mkdir -p /usr/share
RUN tar xvf elasticsearch-${ES_VERSION}.tar.gz -C /usr/share
RUN rm -rf elasticsearch-${ES_VERSION}.tar.gz
RUN ln -s /usr/share/elasticsearch-${ES_VERSION} /usr/share/elasticsearch
RUN mkdir -p /usr/share/elasticsearch/plugins

ENV PATH /usr/share/elasticsearch/bin:$PATH

WORKDIR /usr/share/elasticsearch
RUN rm -rf config
COPY config ./config
RUN mkdir -p /usr/share/elasticsearch/config/scripts

VOLUME ["/usr/share/elasticsearch/data", "/usr/share/elasticsearch/logs"]

RUN useradd -ms /bin/bash elasticsearch

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

EXPOSE 9200 9300
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["elasticsearch"]