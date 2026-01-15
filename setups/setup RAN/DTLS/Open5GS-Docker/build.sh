if [ ! -d $(dirname "$0")/open5gs ]
then
    git clone --depth 1 --branch v2.7.2 https://github.com/open5gs/open5gs $(dirname "$0")/open5gs;
fi
docker build --tag open5gs $(dirname "$0");

# webui image
if [ ! -f $(dirname "$0")/webui/wait ]
then
    wget -O $(dirname "$0")/webui/wait https://github.com/ufoscout/docker-compose-wait/releases/download/2.9.0/wait
fi
docker build --tag open5gs-webui -f $(dirname "$0")/webui/Dockerfile $(dirname "$0")
docker build --tag open5gs-mongodb -f $(dirname "$0")/mongodb/Dockerfile $(dirname "$0")