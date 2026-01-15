#!/bin/sh

if [ "$NF" = "none" ]
then
    echo "Please choose which network function to start."
    echo "For that, use the environment variable \"NF\"."
    exit 1
fi

if [ "$NF" = "upf" ]
then
    echo "This container is a UPF. Setting up routes."
    if ! grep "ogstun" /proc/net/dev > /dev/null; then
        ip tuntap add name ogstun mode tun
    fi
    ip addr del 10.45.0.1/16 dev ogstun 2> /dev/null
    ip addr add 10.45.0.1/16 dev ogstun
    # ip addr del 2001:db8:cafe::1/48 dev ogstun 2> /dev/null
    # ip addr add 2001:db8:cafe::1/48 dev ogstun
    ip link set ogstun up

    # UE WAN access likely doubly NAT'd - by UPF and by Docker
    iptables -t nat -A POSTROUTING -s 10.45.0.0/16 ! -o ogstun -j MASQUERADE
    echo "Iptables set up correctly"
fi

if [ -z "$O5GS_BUILD" ]
then
    echo "Starting $NF" | tee -a /open5gs/$NF.log
    exec /open5gs/default/bin/open5gs-${NF}d -c /open5gs/default/etc/open5gs/$NF.yaml 2>&1 | tee -a /open5gs/$NF.log
else
    exec /open5gs/$O5GS_BUILD/bin/open5gs-${NF}d -c /open5gs/default/etc/open5gs/$NF.yaml 2>&1 | tee -a /open5gs/$NF.log
fi