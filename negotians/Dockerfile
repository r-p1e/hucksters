FROM ubuntu:16.04

# Update system and install curl and git
RUN apt-get -y update && apt-get install -y curl

# Download negotians-exe and do executable
RUN curl -SL -O https://github.com/r-p1e/negotians/releases/download/untagged-afe252d1dda3576af714/negotians-exe \
    && mv negotians-exe /usr/local/bin/negotians && chmod +x /usr/local/bin/negotians


# Update repos and install curl and unzip
RUN apt-get -y update && apt-get install -y curl unzip

# Download and consul
RUN curl -SL -O https://releases.hashicorp.com/consul/0.7.0/consul_0.7.0_linux_amd64.zip && \
    unzip consul_0.7.0_linux_amd64.zip && \
    mv consul /usr/local/bin

EXPOSE 8500 8600 8400 8301 8302 8300

# Define service for consul
RUN mkdir -p /etc/consul.d && \
    echo '{"service": {"name": "negotians", "tags": ["web"], "port": 3000}}' > /etc/consul.d/negotians.json

# Install dnsmasq and configure dns
RUN apt-get install -y dnsmasq
RUN echo 'server=/consul/127.0.0.1#8600' > /etc/dnsmasq.d/10-consul
RUN echo "user=root" >> /etc/dnsmasq.conf
RUN echo "listen-address=127.0.0.1" >> /etc/dnsmasq.conf
RUN echo "prepend domain-name-servers 127.0.0.1;" >> /etc/dhcp/dhclient.conf
RUN echo "request subnet-mask, broadcast-address, time-offset, routers," >> /etc/dhcp/dhclient.conf
RUN echo "domain-name, domain-name-servers, host-name," >> /etc/dhcp/dhclient.conf
RUN echo "netbios-name-servers, netbios-scope;" >> /etc/dhcp/dhclient.conf

COPY run_negotians.sh run_negotians.sh
RUN chmod +x run_negotians.sh

CMD ["./run_negotians.sh"]
