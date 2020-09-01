#!/bin/bash

docker-compose up -d &&\
docker cp "$(docker-compose ps -q phoenix):/opt/phoenix-server/phoenix-5.0.0-HBase-2.0-client.jar" $PWD/phoenix-5.0.0-HBase-2.0-client.jar &&\
docker cp $PWD/phoenix-5.0.0-HBase-2.0-client.jar "$(docker-compose ps -q spark)":/usr/local/spark/jars/phoenix-5.0.0-HBase-2.0-client.jar &&\
rm $PWD/phoenix-5.0.0-HBase-2.0-client.jar
