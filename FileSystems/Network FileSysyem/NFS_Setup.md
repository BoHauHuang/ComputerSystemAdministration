# Network FileSystem (in FreeBSD)
## Enable Service in /etc/rc.conf
```bash
vim /etc/rc.conf
```
## For NFS Server
**Add these lines in rc.conf**
```bash
nfs_server_enable="YES"
nfsv4_server_enable="YES"
mountd_enable="YES"
nfsuserd_enable="YES"
nfs_server_flags="-u -t -n 4"
```

**Service Commands**
```bash
service nfsd start (or stop | restart | status)
```
## For NFS Client
**Add this line in rc.conf**
```bash
nfs_client_enable="YES"
nfscbd_enable="YES"
```
**Service Commands**
```bash
service nfsuserd start (or stop | restart | status)
```
