#!/bin/env bash

if [[ -z "$ping_hosts" ]];then
	ping_hosts="nils.lol"
fi
if [[ -z "$http_hosts" ]];then
	http_hosts="https://nils.lol"
fi

function get_code {
	http_results="$(curl -s -I $http_hosts | grep HTTP)"
}
