#!/bin/bash

set -e

# Example usage:
#./measure-it.sh noenc 10 64
#./measure-it.sh ipsec 10 64 aes128gcm16-prfsha256-ecp256 null-sha1

# change parameters here
SETUP=${SETUP:-"$1"} #noenc, ipsec
ITERATIONS=${ITERATIONS:-"$2"} # 10
NUMBER_OF_PINGS=${NUMBER_OF_PINGS:-2000} # 2000
PING_PAYLOAD_SIZE=${PING_PAYLOAD_SIZE:-"$3"} # 64 or 1024
PING_DEST=${PING_DEST:-192.168.200.1}

IPSEC_AUTH_METHOD=${IPSEC_AUTH_METHOD:-"pubkey"}
IPSEC_IKE_CIPHER_SUITE=${IPSEC_IKE_CIPHER_SUITE:-"$4"} #aes128gcm16-prfsha256-ecp256
IPSEC_ESP_CIPHER_SUITE=${IPSEC_ESP_CIPHER_SUITE:-"$5"} # aes128-sha2_256, aes256-sha2_256, aes256gcm16, aes256gcm16-
IPSEC_START_ACTION=${IPSEC_START_ACTION:-"start"}

DOCKER_COMPOSE_PATH=${DOCKER_COMPOSE_PATH:-$6} #Set this to desired path of the docker compose file! e.g. ../../setups/setup N3/IPsec"


# do not change anything below here (unless you want to modify the code)

function docker_compose {
    local cmd="docker-compose"
    if ! command -v $cmd > /dev/null 2>&1;
    then
        cmd="docker compose"
    fi
    (export SETUP; \
    export NUMBER_OF_PINGS; \
    export PING_PAYLOAD_SIZE; \
    export PING_DEST; \
    export IPSEC_AUTH_METHOD; \
    export IPSEC_IKE_CIPHER_SUITE; \
    export IPSEC_ESP_CIPHER_SUITE; \
    export IPSEC_START_ACTION; \
    $cmd -f "$DOCKER_COMPOSE_PATH"/docker-compose.yaml "$@")
}


# make sure everything is clean
docker_compose kill || :
docker_compose down -v || :

mkdir -p ./experiment-data
mkdir -p results
mkdir -p results/$PING_PAYLOAD_SIZE
rm -f ./experiment-data/data.txt
results_file="results/$PING_PAYLOAD_SIZE/${SETUP}_$(date +"%Y-%m-%d-T%H-%M-%S").txt"

docker build --tag oaisoftwarealliance/oai-nr-ue:v2.3.0 "$(dirname "$0")"/ue

# start pcap
touch ./experiment-data/data.txt
chmod a+w ./experiment-data/data.txt

for (( i = 0; i < ITERATIONS; i++ ))
do
    echo "ITERATION: $i"

    docker_compose up -d

    until [ "$(docker inspect -f "{{.State.Health.Status}}" open5gs-upf-${SETUP})" == "healthy" ]
    do
        sleep 0.1
    done

    docker exec -d open5gs-upf-${SETUP} /bin/bash -c "iperf3 -s"

    until [ "$(docker inspect -f "{{.State.Health.Status}}" rfsim5g-oai-nr-ue-${SETUP})" == "healthy" ]
    do
        sleep 0.1
    done

    docker exec -d rfsim5g-oai-nr-ue-${SETUP} ./measure.sh
    until [ "$(docker inspect -f "{{.State.Status}}" rfsim5g-oai-nr-ue-${SETUP})" == "exited" ]
    do
        sleep 0.1
    done

    cat ./experiment-data/data.txt >> "$results_file"

    docker_compose kill
    docker_compose down -v
done


# stop pcap
sleep 5

rm -f ./experiment-data/data.txt

python3 "$(dirname "$0")"/extract-measurements.py "$results_file"

# write_vars_to_file file varname1 varname2 ...
function write_vars_to_file {
    if [ $# -ge 2 ]; then
        sed -i "1s/^/\n/" "$1"
        # write down in reversed order, resulting in the expected order
        for (( i=$#; i>1; i-- ))
        do
            local var_name=${!i}
            sed -i "1i$var_name = ${!var_name}" "$1"
        done
    fi
}

if [[ "${SETUP}" == "noenc" ]];
then
    write_vars_to_file "${results_file}" SETUP ITERATIONS PING_PAYLOAD_SIZE NUMBER_OF_PINGS
elif [[ "${SETUP}" == "dtls" ]];
then
    write_vars_to_file "${results_file}" SETUP ITERATIONS DTLS_CIPHER DTLS_VERSION
elif [[ "${SETUP}" == "ipsec" ]];
then
    write_vars_to_file "${results_file}" SETUP ITERATIONS PING_PAYLOAD_SIZE NUMBER_OF_PINGS IPSEC_AUTH_METHOD IPSEC_IKE_CIPHER_SUITE IPSEC_ESP_CIPHER_SUITE IPSEC_START_ACTION
fi