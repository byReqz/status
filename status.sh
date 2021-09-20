#!/bin/env bash

if [[ -z "$ping_hosts" ]];then
	ping_hosts="nils.lol"
fi
if [[ -z "$http_hosts" ]];then
	http_hosts="https://nils.lol"
fi

function get_code {
	http_results="$(curl -s -I $http_hosts | grep HTTP | cut -d " " -f 2)"
}

function get_ping {
	ping_raw="$(fping -e "$ping_hosts")"
	ping_reach="$(echo "$ping_raw" | grep -o -e "alive" -e "unreachable")"
	ping_ms="$(echo "$ping_raw" | cut -d "(" -f 2 | cut -d ")" -f 1)"
	ping_results="$ping_reach / $ping_ms"
}

get_code
get_ping
echo "$http_results $ping_results"
