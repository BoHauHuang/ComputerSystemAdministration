# Client Mount NFS Server
## Step 1: Edit /etc/rc.conf for NFS Client in Another Computer
```csh
vim /etc/rc.conf
```
**add these in rc.conf**
```csh
nfs_client_enable="YES"
nfscbd_enable="YES"
```

## Step 2: Check export list
**Command format: [ showmount -e SERVER_IP ]**
```csh
showmount -e XXX.XXX.XXX.XXX
```
***If you can see directories that you export, you made it !***

***Otherwise, check if you got something wrong with previous steps*** 

## Step 3: Mount NFS Server
**Command format: [ mount SERVER_IP:/DIR_YOU_WANT  /CLIENT_DIR]**

```csh
sudo mount XXX.XXX.XXX.XXX:/nfs/test_dirA /nfs_client/test_dirA
sudo mount XXX.XXX.XXX.XXX:/nfs/test_dirB /nfs_client/test_dirB
```
