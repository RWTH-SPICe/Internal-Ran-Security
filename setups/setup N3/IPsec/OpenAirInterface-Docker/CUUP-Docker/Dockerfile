FROM oaisoftwarealliance/oai-nr-cuup:v2.3.0

RUN apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y\
        strongswan \
        charon-systemd \
        strongswan-swanctl \
        strongswan-charon \
        libstrongswan-standard-plugins \
        libstrongswan \
        libcharon-extra-plugins \
        libstrongswan-extra-plugins \
        libgmp10 \
        netcat-openbsd

RUN sed -i "s/load = yes/load = no/" /etc/strongswan.d/charon/bypass-lan.conf


COPY ipsec-config /etc/swanctl

# "pubkey" (ECDSA), "psk"
ENV IPSEC_AUTH_METHOD="pubkey"
# "aes128gcm16-prfsha256-ecp256"
ENV IPSEC_IKE_CIPHER_SUITE="aes256-sha256-modp2048"
# "null", "null-sha2_256" (NULL-HMAC), "aes128-sha2_256" (AES128-CBC-HMAC), "aes128gcm16" (AES128-GCM), "aes128gmac" (NULL-GMAC), "aes256-sha2_256" (AES256-CBC-HMAC), "aes256gcm16" (AES256-GMAC)
ENV IPSEC_ESP_CIPHER_SUITE="aes256-sha256"
# "start", "trap"
ENV IPSEC_START_ACTION="start"


#Add for 30 sec delay
COPY ../entrypoint.sh /opt/oai-gnb/bin/entrypoint.sh

RUN chmod +x /opt/oai-gnb/bin/entrypoint.sh

#CMD [ "/ipsec-start.sh" ]
