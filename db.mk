###
vault-mount:
	vault mount database

### vault mysql
mysql-init:
	vault write database/config/mysql \
		plugin_name=mysql-database-plugin \
		connection_url="root:verysecret@tcp(127.0.0.1:3306)/" \
		allowed_roles="mysql-readonly"

mysql-config:
	vault write database/roles/mysql-readonly \
		db_name=mysql \
		creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT SELECT ON *.* TO '{{name}}'@'%';" \
		default_ttl="1h" \
		max_ttl="24h"

mysql-login:
	vault read -format json database/creds/mysql-readonly | tee vault-mysql-lease.json
	mysql -s -h 127.0.0.1 -P 3306 \
		-u "`jq -r .data.username vault-mysql-lease.json`" \
		--password="`jq -r .data.password vault-mysql-lease.json`"

### vault postgres
pg-init:
	vault write database/config/postgresql \
		plugin_name=postgresql-database-plugin \
		allowed_roles="pg-readonly" \
		connection_url="postgresql://postgres:abc123@localhost:5432/?sslmode=disable"

pg-config:
	vault write database/roles/pg-readonly \
		db_name=postgresql \
		creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; \
		    GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";" \
		default_ttl="1h" \
		max_ttl="24h"

pg-login:
	vault read -format json database/creds/pg-readonly | tee vault-pg-lease.json
	psql "sslmode=disable host=localhost dbname=postgres password=`jq -r .data.password vault-pg-lease.json`" \
		--username="`jq -r .data.username vault-pg-lease.json`"


