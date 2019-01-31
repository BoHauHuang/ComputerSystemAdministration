# Network FileSystem (in FreeBSD)
## Enable Service in /etc/rc.conf
```bash
vim /etc/rc.conf
```
## For NFS Server (NFSv4 Server)
**Add these lines in rc.conf**
```bash
nfs_server_enable="YES"
nfsv4_server_enable="YES"
nfs_server_flags="-u -t -n 4"
nfsuserd_enable="YES"
mountd_enable="YES"
mountd_flag="-r"
```

**Service Commands**
```bash
service nfsd start (or stop | restart | status)
service nfsuserd start (or stop | restart | status)
service mountd start (or stop | restart | status)
```
## For NFS Client
**Add this line in rc.conf**
```bash
nfs_client_enable="YES"
nfscbd_enable="YES"
```
**Service Commands**
```bash
service nfsclient start (or stop | restart | status)
```
