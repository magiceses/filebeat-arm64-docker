FROM alpine:3.13.1

RUN   apk update \                                                                                                                                                                                                                        
 &&   apk --no-cache add ca-certificates wget openssl\                                                                                                                                                                                                      
 &&   update-ca-certificates    

RUN wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.11.0-linux-arm64.tar.gz
RUN tar -xzvf filebeat-7.11.0-linux-arm64.tar.gz

CMD filebeat
 
