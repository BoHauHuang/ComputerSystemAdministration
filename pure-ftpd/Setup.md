# Setup pure-ftpd
## Port Forwarding for VM (if you are using VM)
(1) Open port 20, 21 in your firewall

(2) Open port 30000~50000 in firewall for FTP passive-mode

***If you can't open so many ports in one time***

***open few ports, such as port 30000~30004 is also okay***

## Port Install
```bash
cd /usr/ports/ftp/pure-ftpd/
make config (if you want to modify the config of pure-ftpd installation)
make install clean
```

## RC Service Setting
```bash
vim /etc/rc.conf
```
Add the following command:
```bash
pureftpd_enable="YES"
```
## Edit Configure File of Pure-ftpd
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

## Create Anonymous User for FTP
***for anonymous user, we need to create a system user called "ftp" for him.***

Use pw to manage system user (can add user, modify user, delete user, etc.)

[ pw useradd NAME -u UID -g GID -d /HOME_DIR -s LOGIN_SHELL]
```bash
pw useradd ftp -u 21 -g 21 -d /home/ftp -s /bin/sh
```
```
pw: system user managing tool
useradd: add an user
ftp: user name is "ftp"
-u: user UID is 21
-g: user GID is 21
-d: user home directory is /home/ftp
-s: user login shell is "sh" 
```
## Create Virtual Users for FTP
(1) For ftp users, we need to create at least one system user for them.

## Use Pure-pw to Manage Ftpusers
