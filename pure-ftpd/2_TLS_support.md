# TLS Support
## Create pure-ftpd.pem file
```bash
su   (become root)

mkdir -p /etc/ssl/private

openssl dhparam -out /etc/ssl/private/pure-ftpd-dhparams.pem 2048

openssl req -x509 -nodes -newkey rsa:2048 -sha256 -keyout \
  /etc/ssl/private/pure-ftpd.pem \
  -out /etc/ssl/private/pure-ftpd.pem

chmod 600 /etc/ssl/private/*.pem
```
