FROM ubuntu:22.04

RUN apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
        python3-pip \
        python3-setuptools \
        python3-wheel \
        ninja-build \
        build-essential \
        flex \
        bison \
        git \
        cmake \
        meson \
        libsctp-dev \
        libgnutls28-dev \
        libgcrypt-dev \
        libssl-dev \
        libmongoc-dev \
        libbson-dev \
        libyaml-dev \
        libmicrohttpd-dev \
        libcurl4-gnutls-dev \
        libnghttp2-dev \
        libtins-dev \
        libtalloc-dev \
        iproute2 \
        iptables \
        iputils-ping \
        ca-certificates \
        curl \
        wget \
        netbase \
        iperf3 \
        pkg-config && \
    if apt-cache show libidn-dev > /dev/null 2>&1; then \
        apt-get install -y --no-install-recommends libidn-dev; \
    else \
        apt-get install -y --no-install-recommends libidn11-dev; \
    fi && \
    apt-get clean && rm -rf /var/lib/apt/lists/*takk

COPY open5gs /open5gs

WORKDIR /open5gs

RUN meson setup build --prefix=/open5gs/default && ninja -C build install

COPY configs /open5gs/default/etc/open5gs
COPY hnet /open5gs/default/etc/open5gs/hnet

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD [ "/start.sh" ]

HEALTHCHECK --start-period=11s --interval=1s CMD grep -c "initialize...done" /open5gs/$NF.log
