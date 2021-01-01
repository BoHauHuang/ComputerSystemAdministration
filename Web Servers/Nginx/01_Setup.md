# Nginx Setup (in FreeBSD)

### install (PKG)
```sh
sudo pkg install nginx
```
### install (PORT)
```sh
cd /usr/ports/www/nginx/
sudo make install
```

### Enable 
```sh
vim /etc/rc.conf
``` 
```sh
(in /etc/rc.conf)
nginx_enable="YES"
```