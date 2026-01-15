#!/bin/bash

set -uo pipefail

PREFIX=/opt/oai-gnb
CONFIGFILE=$PREFIX/etc/gnb.conf


###Time to attach to Wireshark
echo "Sleep started"
sleep 5


###Ipsec Start only working from here for now
if [ "${IPSEC_AUTH_METHOD,,}" = "pubkey" ]
then
     sed -i "s/#pubkey //g" /etc/swanctl/swanctl.conf
else
     sed -i "s/#psk //g" /etc/swanctl/swanctl.conf
fi
sed -i "s/IKE_CIPHER_SUITE/$IPSEC_IKE_CIPHER_SUITE/g" /etc/swanctl/swanctl.conf
sed -i "s/ESP_CIPHER_SUITE/$IPSEC_ESP_CIPHER_SUITE/g" /etc/swanctl/swanctl.conf
if [ "${IPSEC_START_ACTION,,}" = "start" ]
then
     sed -i "s/START_ACTION/start/g" /etc/swanctl/swanctl.conf
else
     sed -i "s/START_ACTION/$IPSEC_START_ACTION/g" /etc/swanctl/swanctl.conf
fi

ipsec start;
# # wait for ipsec daemon to start
 until echo "" | nc -q 0 -U /var/run/charon.vici
 do
      sleep 0.1
 done
 swanctl --load-all --file /etc/swanctl/swanctl.conf

#exec "/ipsec-start.sh"


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

