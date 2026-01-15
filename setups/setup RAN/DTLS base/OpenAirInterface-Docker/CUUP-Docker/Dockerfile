FROM oaisoftwarealliance/oai-nr-cuup:v2.3.0

RUN apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y\
        build-essential \ 
        wget \ 
        libssl-dev \
        openssl \
        socat \
        netcat \
        tcpdump \
        iptables

COPY entrypoint.sh /opt/oai-gnb/bin/entrypoint.sh

RUN chmod +x /opt/oai-gnb/bin/entrypoint.sh


COPY certsECDSA /opt/oai-gnb/certsECDSA
COPY certsRSA /opt/oai-gnb/certsRSA


