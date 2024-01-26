FROM centos:7

ENV VER elasticsearch-7.17.17

RUN yum update -y && yum install wget perl-Digest-SHA java-1.8.0-openjdk.x86_64 -y

RUN wget https://artifacts.elastic.co/downloads/elasticsearch/${VER}-linux-x86_64.tar.gz && \
    wget https://artifacts.elastic.co/downloads/elasticsearch/${VER}-linux-x86_64.tar.gz.sha512 && \
    shasum -a 512 -c ${VER}-linux-x86_64.tar.gz.sha512

RUN tar -zxf ${VER}-linux-x86_64.tar.gz && \
    rm ${VER}-linux-x86_64*

RUN adduser elasticsearch && \
    chown -R elasticsearch:elasticsearch /${VER} && \
    chown -R elasticsearch:elasticsearch /var/lib

USER elasticsearch

WORKDIR /${VER}

RUN sed -i 's|#cluster.name: my-application|cluster.name: netology_cluster|g' ./config/elasticsearch.yml &&\
    sed -i 's|#node.name: node-1|node.name: netology_test|g' ./config/elasticsearch.yml && \
    sed -i 's|#path.data: /path/to/data|path.data: /var/lib|g' ./config/elasticsearch.yml && \
    sed -i 's|#network.host: 192.168.0.1|network.host: 0.0.0.0|g' ./config/elasticsearch.yml && \
    echo "discovery.type: single-node" >> ./config/elasticsearch.yml

EXPOSE 9200
EXPOSE 9300

CMD ["./bin/elasticsearch"]
