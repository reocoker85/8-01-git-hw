FROM centos:7

LABEL maintainer="reocoker1985@yndex.ru"

ARG BUILD_DATE

LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.docker.cmd="docker run -p 9200:9200 -p 9300:9300 reocoker/centoselastic"


ENV VER elasticsearch-7.17.17

RUN <<EOT
yum -y update 
yum install -y wget perl-Digest-SHA java-1.8.0-openjdk.x86_64
yum -y clean all 
rm -rf /var/cache
EOT

RUN <<EOT
wget https://artifacts.elastic.co/downloads/elasticsearch/${VER}-linux-x86_64.tar.gz
wget https://artifacts.elastic.co/downloads/elasticsearch/${VER}-linux-x86_64.tar.gz.sha512
shasum -a 512 -c ${VER}-linux-x86_64.tar.gz.sha512
tar -zxf ${VER}-linux-x86_64.tar.gz
rm ${VER}-linux-x86_64*
EOT

RUN <<EOT
adduser elasticsearch
chown -R elasticsearch:elasticsearch /${VER}
chown -R elasticsearch:elasticsearch /var/lib
EOT

USER elasticsearch

WORKDIR /${VER}

RUN cat <<EOT >> ./config/elasticsearch.yml
cluster.name: netology_cluster
node.name: netology_test 
path.data: /var/lib
network.host: 0.0.0.0
discovery.type: single-node
EOT

EXPOSE 9200
EXPOSE 9300

CMD ["./bin/elasticsearch"]
#CMD ["/bin/bash"]
