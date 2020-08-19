#!/bin/bash

cd shopfront
# mvn clean install
docker build -t shopfront:1.0 .

cd ../productcatalogue
# mvn clean install
docker build -t productcatalogue:1.0 .

cd ../stockmanager
# mvn clean install
docker build -t stockmanager:1.0 .

cd ..
