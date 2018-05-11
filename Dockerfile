FROM debian:stretch

MAINTAINER 0815chr1s

ENV FHEM_VERSION 5.8
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
ENV TZ=Europe/Paris

# Install dependencies
RUN apt-get update && apt-get upgrade -y --force-yes && apt-get install -y --force-yes --no-install-recommends apt-utils
RUN apt-get -y --force-yes install \
curl \
gnupg

RUN apt-get --purge remove node
RUN apt-get --purge remove nodejs
RUN apt-get autoremove 

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y build-essential libavahi-compat-libdnssd-dev libudev-dev libpam0g-dev nodejs
RUN npm i -g "npm@>=5.7.1"

RUN mkdir /opt/iobroker
RUN chmod 777 /opt/iobroker
RUN cd /opt/iobroker
RUN npm install iobroker --unsafe-perm

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /opt/iobroker/
ADD scripts/run.sh run.sh
RUN chmod +x run.sh

EXPOSE 8081 8082 8083 8084

CMD /opt/iobroker/run.sh