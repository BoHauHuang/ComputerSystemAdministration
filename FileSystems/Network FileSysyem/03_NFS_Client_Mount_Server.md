# Client Mount NFS Server
## Step 1: Edit /etc/rc.conf for NFS Client in Another Computer
```csh
vim /etc/rc.conf
```
*add these in rc.conf*
```csh
nfs_client_enable="YES"
nfscbd_enable="YES"
```

## Step 2: Check export list
**Command format: [ showmount -e SERVER_IP ]
```csh
showmount -e XXX.XXX.XXX.XXX
```
***If you can see directories you export, you made it !***
***Otherwise, check if you got something wrong with previous steps*** 
