#!/bin/bash
set -e

# build base images
$(dirname "$0")/Open5GS-Docker/build.sh

$(dirname "$0")/OpenAirInterface-Docker/build.sh