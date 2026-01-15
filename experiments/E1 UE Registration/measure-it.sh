#!/bin/bash

set -e

# Example usage:
#./measure-it.sh noenc 10 64
#./measure-it.sh ipsec 10 64 aes128gcm16-prfsha256-ecp256 null-sha1

SETUP=${SETUP:-"$1"} #noenc, dtls, ipsec
ITERATIONS=${ITERATIONS:-"$2"} # 250

IPSEC_AUTH_METHOD=${IPSEC_AUTH_METHOD:-"pubkey"} # pubkey
IPSEC_IKE_CIPHER_SUITE=${IPSEC_IKE_CIPHER_SUITE:-"$3"} #aes128gcm16-prfsha256-ecp256
IPSEC_ESP_CIPHER_SUITE=${IPSEC_ESP_CIPHER_SUITE:-"$4"} # aes128-sha2_256, aes256-sha2_256, aes256gcm16, aes256gcm16-
IPSEC_START_ACTION=${IPSEC_START_ACTION:-"start"} # start


DTLS_CIPHER=${DTLS_CIPHER:-"$3"} #ECDHE-RSA-AES128-GCM-SHA256
DTLS_VERSION=${DTLS_VERSION:-"$4"} #TLS1.2 #TLS1.3
DTLS_TYPE=${DTLS_TYPE:-"$5"} #RSA, ECDSA

DOCKER_COMPOSE_PATH=${DOCKER_COMPOSE_PATH:-$6} #Change this to desired path! e.g. ../../setups/setup N3/IPSec"


# do not change anything below here (unless you want to modify the code)

function docker_compose {
    local cmd="docker-compose"
    if ! command -v $cmd > /dev/null 2>&1;
    then
        cmd="docker compose"
    fi
    (export SETUP; \
    export IPSEC_AUTH_METHOD; \
    export IPSEC_IKE_CIPHER_SUITE; \
    export IPSEC_ESP_CIPHER_SUITE; \
    export IPSEC_START_ACTION; \
    export DTLS_CIPHER; \
    export DTLS_VERSION; \
    export DTLS_TYPE; \
    $cmd -f "$DOCKER_COMPOSE_PATH"/docker-compose.yaml "$@")
}

until sudo -v; do
    echo "Waiting for sudo authentication..."
    sleep 1
done

# make sure everything is clean
docker_compose kill || :
docker_compose down -v || :

# start docker networks

mkdir -p results
mkdir -p results/$ITERATIONS
pcap_file_base="results/$ITERATIONS/${SETUP}_$(date +"%Y-%m-%d-T%H-%M-%S")"
pcap_file_cucp="${pcap_file_base}.pcap"

touch ${pcap_file_cucp}
chmod a+w ${pcap_file_cucp}


# start pcap
docker_compose up -d webui mongodb nrf udr ausf pcf amf bsf upf udm smf oai-cucp oai-cuup oai-du
PID_CUCP=$(docker inspect -f '{{.State.Pid}}' rfsim5g-oai-cucp-${SETUP})
#PID_CUUP=$(docker inspect -f '{{.State.Pid}}' rfsim5g-oai-cuup-${SETUP})
sleep 5


sudo nsenter -t "$PID_CUCP" -n tshark -i any -f "src net 192.168.77.0/28 or src host 192.168.200.20" -w "$pcap_file_cucp" & #192.168.200.20: AMF PDUSessionRequest
tshark_pid_cucp=$!

sleep 5
reset
for (( i = 0; i < ITERATIONS; i++ ))
do
    echo "ITERATION: $i"

    docker_compose up -d oai-nr-ue

    until [ "$(docker inspect -f "{{.State.Health.Status}}" rfsim5g-oai-nr-ue-"$SETUP")" == "healthy" ]
    do
        sleep 0.1
    done

    #docker_compose kill oai-nr-ue
    docker_compose down -v oai-nr-ue
done

# stop pcap
sleep 5
kill -2 $tshark_pid_cucp # $tshark_pid_cuup
sleep 5
docker_compose down -v
python3 ./extract-measurements.py "$pcap_file_cucp"

#write_vars_to_file file varname1 varname2 ...
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
    write_vars_to_file "${pcap_file_base}.txt" SETUP ITERATIONS
elif [[ "${SETUP}" == "dtls" ]];
then
    write_vars_to_file "${pcap_file_base}.txt" SETUP ITERATIONS DTLS_CIPHER DTLS_VERSION DTLS_TYPE
elif [[ "${SETUP}" == "ipsec" ]];
then
    write_vars_to_file "${pcap_file_base}.txt" SETUP ITERATIONS IPSEC_AUTH_METHOD IPSEC_IKE_CIPHER_SUITE IPSEC_ESP_CIPHER_SUITE IPSEC_START_ACTION
fi