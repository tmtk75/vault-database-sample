storage "file" {
  path = "./vault-data"
}

listener "tcp" {
  tls_disable = 1
}

