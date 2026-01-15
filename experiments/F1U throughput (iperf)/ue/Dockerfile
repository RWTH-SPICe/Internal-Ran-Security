FROM oaisoftwarealliance/oai-nr-ue:v2.3.0
RUN apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
        curl \
        wget

COPY measure.sh /opt/oai-nr-ue/measure.sh
RUN chmod +x /opt/oai-nr-ue/measure.sh
