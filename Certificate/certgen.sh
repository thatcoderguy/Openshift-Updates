openssl genrsa -out <name>.key 2048
openssl req -new -key <name>.key -out <name>.csr  -subj "/C=GB/ST=London/L=London/O=IT/OU=IT/CN=<DOMAIN>"
openssl x509 -req -days 366 -in <name>.csr      -signkey <name>.key -out <name>.crt
