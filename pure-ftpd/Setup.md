# Setup pure-ftpd
## Port install
```bash
cd /usr/ports/ftp/pure-ftpd/
make config (if you want to modify the config of pure-ftpd installation)
make install clean
```

## RC service setting
```bash
vim /etc/rc.conf
```
Add the following command:
```bash
pureftpd_enable="YES"
```
