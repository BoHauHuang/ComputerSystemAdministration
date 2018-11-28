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

Such as
```bash
ChrootEveryone        yes                             (let user stay in their root directory, can't do more cd ..)
MinUID                10
PureDB                /usr/local/etc/pureftpd.pdb     (using pureDB to manage users)
TLS                   1                               (using TLS)
CertFile              /etc/ssl/private/pure-ftpd.pem  (TLS pem-file)
```

## Create Anonymous User for FTP
***for anonymous user, we need to create a system user called "ftp" for him.***

Use pw to manage system user (can add user, modify user, delete user, etc.)

[ pw groupadd GROUPNAME -g GID]

[ pw useradd NAME -u UID -g GID -d /HOME_DIR -s LOGIN_SHELL]

(1) For anonymous user, we need to create a system user named "ftp".
```bash
pw groupadd anonymous -g 21
pw useradd ftp -u 21 -g 21 -d /home/ftp -s /bin/bash
```
```
pw:               system user managing tool
groupadd:         add a group
anonymous:        group name is "anonymous"
-g 21:            group GID is 21

useradd:          add an user
ftp:              username is "ftp"
-u 21:            user's UID is 21 
-g 21:            user's GID is 21
-d /home/ftp:     user's home directory is /home/ftp
-s /bin/bash:     user's login shell is "bash" 
```
(2) Use pure-pw to manage FTP users of pure-ftpd

[ pure-pw useradd NAME -u UID -g GID -d /HOME_DIR]
```bash
pure-pw useradd ftp -u 21 -g 21 -d /home/ftp
pure-pw mkdb
```
```
pure-pw:          pure-ftpd user managing tool
useradd:          add an user
ftp:              username is "ftp"
-u 21:            user's UID is 21 (Because MinUID is 10, so 21 is okay)
-g 21:            user's GID is 21
-d /home/ftp:     user's home directory is /home/ftp

mkdb:             commit change of user data and update pureftpd.pdb file
```


## Create Virtual Users for FTP
Use pw to manage system user (can add user, modify user, delete user, etc.)

[ pw groupadd GROUPNAME -g GID]

[ pw useradd NAME -u UID -g GID -d /HOME_DIR -s LOGIN_SHELL]

(1) For virtual ftp users, we need to create at least one system user for them.
```bash
pw groupadd ftpgroup -g 666
pw useradd ftpuser -u 666 -g 666 -d /home/ftp -s /bin/bash
```
```
pw:               system user managing tool
groupadd:         add a group
ftpgroup:         group name is "ftpgroup"
-g 666:           group GID is 666

useradd:          add an user
ftpuser:          username is "ftpuser"
-u 666:           user's UID is 666
-g 666:           user's GID is 666
-d /home/ftp:     user's home directory is /home/ftp
-s /bin/bash:     user's login shell is "bash" 
```
(2) Use pure-pw to manage FTP users of pure-ftpd

[ pure-pw useradd NAME -u UID -g GID -d /HOME_DIR]
```bash
pure-pw useradd ftpuser -u 666 -g 666 -d /home/ftp
pure-pw mkdb
```
```
pure-pw:          pure-ftpd user managing tool
useradd:          add an user
ftpuser:          username is "ftpuser"
-u 666:           user's UID is 666
-g 666:           user's GID is 666
-d /home/ftp:     user's home directory is /home/ftp

mkdb:             commit change of user data and update pureftpd.pdb file
```

## If you set TLS=1, please see "TLS_support.md" for tutorial
