# Setup pure-ftpd
## Port forwarding for VM (if you are using VM)
(1) Open port 20, 21 in your firewall
(2) Open port 30000~50000 in firewall for FTP passive-mode
***If you can't open so many ports in one time***
***open 5 port is also okay***

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
## Edit configure file of Pure-ftpd
(1) Copy the sample file
```bash
cd /usr/local/etc/
cp pure-ftpd.conf.sample pure-ftpd.conf
chmod u+w pure-ftpd.conf
```
(2) Edit .conf (open the pure-ftpd.conf by your editor, I use "vim" here)
```bash
vim pure-ftpd.conf
```
And do what you want to change for the pure-ftpd
