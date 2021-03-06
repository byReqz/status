#!/bin/env bash

if [[ -z "$ping_hosts" ]];then
	ping_hosts=("nils.lol")
else
	ping_hosts=($ping_hosts)
fi
if [[ -z "$http_hosts" ]];then
	http_hosts=("https://nils.lol")
else
	http_hosts=($http_hosts)
fi

function get_code {
	http_raw="$(curl -s -I $h | tr -d '\r')"
	http_code="$(echo "$http_raw" | grep HTTP | cut -d " " -f 2)"
	if [[ "$http_code" < 299 && "$http_code" > 199 ]];then
		http_code="[\e[32m"$http_code"\e[0m"
	elif [[ "$http_code" < 199 && "$http_code" > 099 ]];then
		http_code="[\e[36m"$http_code"\e[0m"
        elif [[ "$http_code" < 399 && "$http_code" > 299 ]];then
                http_code="[\e[1;33m"$http_code"\e[0m"
        elif [[ "$http_code" < 499 && "$http_code" > 399 ]];then
                http_code="[\e[1;31m"$http_code"\e[0m"
        elif [[ "$http_code" < 599 && "$http_code" > 499 ]];then
                http_code="[\e[31m"$http_code"\e[0m"
	fi
	if [[ -z "$http_code" ]];then
		http_code="[\e[1;31merror\e[0m]"
		http_server=""
	else
		http_server=" | \e[1;34m$(echo "$http_raw" | grep -i "server" | sort -u | cut -d " " -f 2 | tr -s '\n' ' '| xargs | sed 's/ / + /g')\e[0m]"
	fi
	http_results=""$http_results"
 $(printf "%-63s%s\n" ["\e[1;35m"$h"\e[0m"] "$http_code""$http_server")"
}

function get_ping {
	ping_raw="$(fping -e "$p" 2> /dev/null)"
	ping_reach="$(echo "$ping_raw" | grep -o -e "alive" -e "unreachable")"
	if [[ "$ping_reach" == "unreachable" ]];then
		ping_reach="[\e[32munreachable\e[0m]"
	elif [[ "$ping_reach" == "alive" ]];then
		ping_reach="[\e[32malive\e[0m"
		ping_ms=" | \e[1;34m$(echo "$ping_raw" | cut -d "(" -f 2 | cut -d ")" -f 1)\e[0m]"
	else
		ping_reach="[\e[1;31merror\e[0m]"
		ping_ms=""
	fi
	ping_results=""$ping_results"
 $(printf "%-63s%s\n" ["\e[1;35m"$p"\e[0m"] "$ping_reach""$ping_ms")"
}

function main {
	printf [--------------------------------------------------------------------]
	if [[ "$ping_hosts" != "none" ]];then
		echo  ""
		printf "\e[1;4mPing Hosts:\e[0m"
		for p in "${ping_hosts[@]}";do
			get_ping
		done
		echo -e "$ping_results"
	fi
	if [[ "$http_hosts" != "none" ]];then
        	echo  ""
        	printf "\e[1;4mHTTP Hosts:\e[0m"
		for h in "${http_hosts[@]}";do
			get_code
		done
		echo -e "$http_results"
	fi
	echo [--------------------------------------------------------------------]
}

while true;do
	main
	http_results=""
	ping_results=""
	sleep 2m
	clear
done
