# Network FileSystem (in FreeBSD)
## Enable Service in /etc/rc.conf
```csh
vim /etc/rc.conf
```
## For NFS Server (NFSv4 Server)
**Add these lines in rc.conf**
```csh
nfs_server_enable="YES"
nfsv4_server_enable="YES"
nfs_server_flags="-u -t -n 4"
nfsuserd_enable="YES"
mountd_enable="YES"
mountd_flag="-r"
```

**Service Commands**
```csh
service nfsd start (or stop | restart | status)
service nfsuserd start (or stop | restart | status)
service mountd start (or stop | restart | status)
```
## For NFS Client
**Add this line in rc.conf**
```csh
nfs_client_enable="YES"
nfscbd_enable="YES"
```
**Service Commands**
```csh
service nfsclient start (or stop | restart | status)
```
