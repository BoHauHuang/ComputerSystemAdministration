# Network FileSystem (in FreeBSD)
## Enable Service in /etc/rc.conf
```bash
vim /etc/rc.conf
```
## For NFS Server
**Add these lines in rc.conf**
```bash
nfs_server_enable="YES"
nfs_server_flags="-u -t -n 4"
```
## For NFS Client
**Add this line in rc.conf**
```bash
nfs_client_enable="YES"
```
