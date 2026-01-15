#!/bin/bash
setup="ipsec"

docker rmi -f oaisoftwarealliance/oai-gnb-custom-${setup}:v2.3.0


docker pull oaisoftwarealliance/oai-gnb:v2.3.0
docker build --tag oaisoftwarealliance/oai-gnb-custom-${setup}:v2.3.0 -f $(dirname "$0")/GNB-Docker/Dockerfile $(dirname "$0")/GNB-Docker
