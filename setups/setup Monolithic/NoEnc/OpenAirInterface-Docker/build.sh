#!/bin/bash
setup="noenc"

docker rmi -f oaisoftwarealliance/oai-gnb-custom-${setup}:v2.3.0


docker pull oaisoftwarealliance/oai-gnb:v2.3.0
docker tag oaisoftwarealliance/oai-gnb:v2.3.0 oaisoftwarealliance/oai-gnb-custom-${setup}:v2.3.0
