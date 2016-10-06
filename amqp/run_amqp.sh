#!/bin/bash

genstring(){
    < /dev/urandom tr -dc _A-Z-a-z-0-9 | \
        head -c${1:-16}; \
        echo;
}

register_value_to_consul(){
    local key=$1
    local value=$2

    curl -S -X PUT -d "$value" -i "http://localhost:8500/v1/kv/web/$key"
}

create_amqp_user() {
    local username=$(genstring )
    local pwd=$(genstring)

    # Install rabbitmq management plugin
    rabbitmq-plugins enable rabbitmq_management
    service rabbitmq-server restart

    # Download and make executable rabbitmqadmin
    curl -SL -O localhost:15672/cli/rabbitmqadmin && \
        chmod +x rabbitmqadmin && \
        mv rabbitmqadmin /usr/local/bin

    rabbitmqctl add_user $username $pwd
    rabbitmqctl set_user_tags $username administrator
    rabbitmqctl set_permissions -p / $username ".*" ".*" ".*"

    service rabbitmq-server restart

    register_value_to_consul "amqp_user" $username
    register_value_to_consul "amqp_pwd" $pwd
}

main() {
    service rabbitmq-server start
    consul agent -data-dir /tmp/consul -node rabbitmq-first -config-dir /etc/consul.d -join "172.17.0.2" &
    create_amqp_user

    # Make container live forever
    trap : TERM INT; sleep infinity & wait
}

main
