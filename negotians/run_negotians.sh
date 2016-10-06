#!/bin/bash

get_value_from_consul() {
    local key=$1

    curl -i "http://localhost:8500/v1/kv/web/$key" | grep -Po '"Value":.*?[^\\]",' | awk -F':' '{print $2}' | awk -F'"' '{print $2}'
}

run_server() {
    local amqp_user=$(get_value_from_consul "amqp_user")
    local amqp_pwd=$(get_value_from_consul "amqp_pwd")

    negotians $amqp_user $amqp_pwd
}

main() {
    consul agent -data-dir /tmp/consul -node negotians-first -config-dir /etc/consul.d -join "172.17.0.2" &
    service dnsmasq start
    echo "nameserver 127.0.0.1" > /etc/resolv.conf

    run_server
}

main
