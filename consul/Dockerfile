FROM ubuntu:16.04

# Update repos and install curl and unzip
RUN apt-get -y update && apt-get install -y curl unzip

# Download and consul
RUN curl -SL -O https://releases.hashicorp.com/consul/0.7.0/consul_0.7.0_linux_amd64.zip && \
    unzip consul_0.7.0_linux_amd64.zip && \
    mv consul /usr/local/bin

CMD ["consul", "agent", "-server", "-bootstrap-expect", "1", "-data-dir", "/tmp/consul", "-node", "nautical", "-ui" ]

EXPOSE 8500 8600 8400 8301 8302 8300
