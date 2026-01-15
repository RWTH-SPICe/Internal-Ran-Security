#!/bin/bash

# warmup
ping -c 20 -I oaitun_ue1 -i 0.2 $PING_DEST

echo "Starting ping"
ping -s $PING_PAYLOAD_SIZE -c $NUMBER_OF_PINGS -I oaitun_ue1 -i 0.2 $PING_DEST | grep 'time=' | awk -F'=' '{print $4}' | awk '{print $1}' > /data/data.txt

kill 1