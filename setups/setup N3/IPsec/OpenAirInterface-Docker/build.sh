#!/bin/bash
setup="ipsec"

docker rmi -f oaisoftwarealliance/oai-du-custom-${setup}:v2.3.0
docker rmi -f oaisoftwarealliance/oai-cucp-custom-${setup}:v2.3.0
docker rmi -f oaisoftwarealliance/oai-cuup-custom-${setup}:v2.3.0


docker build --tag oaisoftwarealliance/oai-du-custom-${setup}:v2.3.0 -f $(dirname "$0")/DU-Docker/Dockerfile $(dirname "$0")/DU-Docker
docker build --tag oaisoftwarealliance/oai-cucp-custom-${setup}:v2.3.0 -f $(dirname "$0")/CUCP-Docker/Dockerfile $(dirname "$0")/CUCP-Docker
docker build --tag oaisoftwarealliance/oai-cuup-custom-${setup}:v2.3.0 -f $(dirname "$0")/CUUP-Docker/Dockerfile $(dirname "$0")/CUUP-Docker
