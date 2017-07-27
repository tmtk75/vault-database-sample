# README
A playground for database secret backend of vault.
https://www.vaultproject.io/docs/secrets/databases/index.html

Required commands
* vault
* mysql (client)
* psql
* jq
* docker, docker-compose


## Getting Started
```
[1]$ make vault-start
...

[2]$ source .env
[2]$ make vault-init
...
[2]$ source .vault-env

[2]$ vault write cubbyhole/foo bar=1234
Success! Data written to: cubbyhole/foo

[2]$ vault read -format yaml cubbyhole/foo
data:
  bar: 1234
...
```

## MySQL backend
```
[0]$ docker-compose up mysql
...

[2]$ make -f db.mk vault-mount
[2]$ make -f db.mk mysql-init
...

[2]$ make -f db.mk mysql-config
...

[2]$ make -f db.mk mysql-login
...
mysql>
```

## PostgreSQL backend
```
[0]$ docker-compose up postgres
...

[2]$ make -f db.mk vault-mount
[2]$ make -f db.mk pg-init
...

[2]$ make -f db.mk pg-config
...

[2]$ make -f db.mk pg-login
...
pg>
```

## Retry
```
[1]$ Stop the vault process by CTRL+C

[1]$ make clean vault-start
```
