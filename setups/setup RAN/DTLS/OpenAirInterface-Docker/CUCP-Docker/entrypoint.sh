#!/bin/bash
#72.2

set -uo pipefail


PREFIX=/opt/oai-gnb
CONFIGFILE=$PREFIX/etc/gnb.conf

TYPE_PREFIX=$PREFIX/certs$DTLS_TYPE


###Time to attach to Wireshark
echo "Sleep started"
sleep 5

###########DTLS

socat -v -dd OPENSSL-DTLS-SERVER:2155,reuseaddr,fork,cipher=$DTLS_CIPHER,openssl-min-proto-version=$DTLS_VERSION,cert=${TYPE_PREFIX}/cucpAltCert.pem,key=${TYPE_PREFIX}/cucpAltKey.pem,cafile=${TYPE_PREFIX}/root-cert.pem SCTP:192.168.72.2:38472,sourceport=2155 &
socat -v -dd OPENSSL-DTLS-SERVER:2156,reuseaddr,fork,cipher=$DTLS_CIPHER,openssl-min-proto-version=$DTLS_VERSION,cert=${TYPE_PREFIX}/cucpCert.pem,key=${TYPE_PREFIX}/cucpKey.pem,cafile=${TYPE_PREFIX}/root-cert.pem SCTP:192.168.77.2:38462,sourceport=2156 &



###############


###Actual OAI
echo "=================================="
echo "/proc/sys/kernel/core_pattern=$(cat /proc/sys/kernel/core_pattern)"

if [ ! -f $CONFIGFILE ]; then
  echo "No configuration file $CONFIGFILE found: attempting to find YAML config"
  YAML_CONFIGFILE=$PREFIX/etc/gnb.yaml
  if [ ! -f $YAML_CONFIGFILE ]; then
    echo "No configuration file $YAML_CONFIGFILE found. Please mount either at $CONFIGFILE or $YAML_CONFIGFILE"
    exit 255
  fi
  CONFIGFILE=$YAML_CONFIGFILE
fi

echo "=================================="
echo "== Configuration file:"
cat $CONFIGFILE

new_args=()

while [[ $# -gt 0 ]]; do
  new_args+=("$1")
  shift
done

new_args+=("-O")
new_args+=("$CONFIGFILE")

# Load the USRP binaries
echo "=================================="
echo "== Load USRP binaries"
if [[ -v USE_B2XX ]]; then
    $PREFIX/bin/uhd_images_downloader.py -t b2xx
elif [[ -v USE_X3XX ]]; then
    $PREFIX/bin/uhd_images_downloader.py -t x3xx
elif [[ -v USE_N3XX ]]; then
    $PREFIX/bin/uhd_images_downloader.py -t n3xx
fi

# enable printing of stack traces on assert
export OAI_GDBSTACKS=1

echo "=================================="
echo "== Starting gNB soft modem"
if [[ -v USE_ADDITIONAL_OPTIONS ]]; then
    echo "Additional option(s): ${USE_ADDITIONAL_OPTIONS}"
    while [[ $# -gt 0 ]]; do
        new_args+=("$1")
        shift
    done
    for word in ${USE_ADDITIONAL_OPTIONS}; do
        new_args+=("$word")
    done
    echo "${new_args[@]}"
    exec "${new_args[@]}"
else
    echo "${new_args[@]}"
    exec "${new_args[@]}"
fi

