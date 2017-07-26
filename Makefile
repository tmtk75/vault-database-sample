.DEFAULT_GOAL := help

### MySQL
mysql:
	docker run $(run_opts) \
		--link mysqld:mysql \
		--rm \
		mysql \
		bash -c 'mysql -s -u foo -pabc123 -h $$MYSQL_PORT_3306_TCP_ADDR mydb'

mysql-it:
	@make mysql run_opts=-it

### PostgreSQL
psql:
	docker run $(run_opts) --rm \
		-e PGPASSWORD=abc123 \
		--link postgres:postgres \
		postgres \
		psql -h postgres -U postgres

psql-it:
	@make psql run_opts=-it

### vault
vault-start:
	vault server -config ./vault.hcl

env_path := .vault-env
vault-init: .vault-env
.vault-env:
	vault init -key-threshold 2 2>&1 | tee vault-keys
	vault unseal `cat vault-keys | grep 'Key 1' | sed 's/.*: //'`
	vault unseal `cat vault-keys | grep 'Key 2' | sed 's/.*: //'`
	printf "export VAULT_ADDR=http://127.0.0.1:8200\n" > $(env_path)
	printf "export VAULT_TOKEN=" >> $(env_path)
	cat vault-keys | grep "Root Token" | sed 's/.*: //' >> $(env_path)

clean:
	rm -rf .vault-env vault-data

###
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'
