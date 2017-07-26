#!/usr/bin/env bash
#
# Mhh... too complex... --link is easy, but legacy...
#
prefix=$(basename `pwd` | sed 's/-//g')_
network_name=${1-${prefix}my_network}
mysqld_ipaddr=$(docker inspect mysqld \
	| jq -r '.[].NetworkSettings.Networks.'${network_name}'.IPAddress')

docker run $2 \
	--rm \
	--net ${network_name} \
	mysql \
	bash -c 'mysql -s -u foo -pabc123 -h '${mysqld_ipaddr}' mydb'

