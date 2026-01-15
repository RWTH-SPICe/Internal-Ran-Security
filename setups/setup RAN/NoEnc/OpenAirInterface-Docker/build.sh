#!/bin/bash
setup="noenc"

docker rmi -f oaisoftwarealliance/oai-du-custom-${setup}:v2.3.0
docker rmi -f oaisoftwarealliance/oai-cucp-custom-${setup}:v2.3.0
docker rmi -f oaisoftwarealliance/oai-cuup-custom-${setup}:v2.3.0

docker pull oaisoftwarealliance/oai-gnb:v2.3.0
docker pull oaisoftwarealliance/oai-nr-cuup:v2.3.0
docker tag oaisoftwarealliance/oai-gnb:v2.3.0 oaisoftwarealliance/oai-du-custom-${setup}:v2.3.0
docker tag oaisoftwarealliance/oai-gnb:v2.3.0 oaisoftwarealliance/oai-cucp-custom-${setup}:v2.3.0
docker tag oaisoftwarealliance/oai-nr-cuup:v2.3.0 oaisoftwarealliance/oai-cuup-custom-${setup}:v2.3.0
