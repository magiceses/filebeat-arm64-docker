# Reverse engineered dockerfile since the beats repo is doing something way too complicated to do a docker build 
## https://stackoverflow.com/questions/19104847/how-to-generate-a-dockerfile-from-an-image
## alias dfimage="docker run -v /var/run/docker.sock:/var/run/docker.sock --rm alpine/dfimage"
## dfimage -sV=1.36 docker.elastic.co/beats/filebeat:7.11.0
# Follow tini directions for alpine https://github.com/krallin/tini
FROM --platform=linux/arm64 alpine:3.13.1
LABEL maintainer=spahrj@gmail.com
LABEL org.opencontainers.image.source https://github.com/jeffspahr/filebeat-arm64-docker

ENV ELASTIC_CONTAINER=true
ENV PATH=/usr/share/filebeat:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV GODEBUG=madvdontneed=1

COPY docker-entrypoint /usr/local/bin/docker-entrypoint
RUN chmod 755 /usr/local/bin/docker-entrypoint

RUN apk update \                                                                                                                                                                                                                        
 && apk --no-cache add ca-certificates wget openssl tini\                                                                                                                                                                                                      
 && update-ca-certificates    

RUN wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.11.0-linux-arm64.tar.gz
RUN tar -xzvf filebeat-7.11.0-linux-arm64.tar.gz
RUN mv filebeat-7.11.0-linux-arm64 /usr/share/filebeat

RUN ls -l /usr/share/filebeat
RUN ls -l /sbin/
RUN echo $PATH

#RUN groupadd --gid 1000 filebeat
#RUN useradd -M --uid 1000 --gid 1000 --groups 0 --home /usr/share/filebeat filebeat
#USER filebeat
ENV LIBBEAT_MONITORING_CGROUPS_HIERARCHY_OVERRIDE=/
WORKDIR /usr/share/filebeat
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/docker-entrypoint"]
CMD ["-environment" "container"]
