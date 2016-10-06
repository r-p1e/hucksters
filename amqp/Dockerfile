FROM ubuntu:16.04

# Update repositories and install wget
RUN apt-get -y update && apt-get -y install wget

# Install rabbitmq
RUN echo 'deb http://www.rabbitmq.com/debian/ testing main' | \
    tee /etc/apt/sources.list.d/rabbitmq.list && \
    wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | \
    apt-key add - && \
    apt-get -y update && \
    apt-get -y install rabbitmq-server

EXPOSE 5672


# Update repos and install curl and unzip
RUN apt-get -y update && apt-get install -y curl unzip

# Download and consul
RUN curl -SL -O https://releases.hashicorp.com/consul/0.7.0/consul_0.7.0_linux_amd64.zip && \
    unzip consul_0.7.0_linux_amd64.zip && \
    mv consul /usr/local/bin

EXPOSE 8500 8600 8400 8301 8302 8300

# Define service for consul
RUN mkdir -p /etc/consul.d && \
    echo '{"service": {"name": "rabbitmq", "tags": ["amqp"], "port": 5672, "check": {"script": "rabbitmqctl node_health_check", "interval": "60s"}}}' > /etc/consul.d/rabbitmq.json

COPY run_amqp.sh run_amqp.sh
RUN chmod +x run_amqp.sh

CMD ["./run_amqp.sh"]


