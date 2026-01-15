#!/bin/bash

echo "Starting iperf"
iperf3 -c 10.45.0.1 -t 600 -b 10M | grep receiver | tail -n1 | awk '{print $(NF-2)}' > /data/data.txt

kill 1