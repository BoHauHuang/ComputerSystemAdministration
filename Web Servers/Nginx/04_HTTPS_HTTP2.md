# HTTPS && HTTP2 (nginx)

### Generate key and certification (Self Signed)
```sh
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout <path_to_key> -out <path_to_certification>
```

### in /usr/local/etc/nginx/nginx.conf
```sh
server {
	listen 443 ssl http2;
	server_name <host_name>;
	ssl_protocols TLSv1.2 TLSv1.3;
	ssl_certificate <path_to_certification>;
	ssl_certificate_key <path_to_key>;
	...
	...
}
```