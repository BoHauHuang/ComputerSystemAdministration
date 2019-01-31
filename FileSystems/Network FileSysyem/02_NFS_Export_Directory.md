# Export FileSystem

## Step 0: Choose which Directory you want to export
**I want to export these directories:**
```
/nfs/test_dirA
/nfs/test_dirB
```

## Step 1: Create ZFS filesystem
**Only when the directories has own mountpoints, clients can mount all directories successfully.**

**Command format: [ zfs create ZPOOL_NAME/DIR_NAME ]
```csh
zfs create zroot/test_dirA
zfs create zroot/test_dirB
```

## Step 2: Set Mountpoints
**Command format: [ zfs set mountpoint=/PATH_TO_DIR  ZPOOL_NAME/DIR_NAME ]
```csh
zfs set mountpoint=/nfs/test_dirA zroot/test_dirA
zfs set mountpoint=/nfs/test_dirB zroot/test_dirB
```


## Step 3: Edit /etc/exports
**This file specifiy which directory will be shared**

**Command format: [ directory-list  option-list  cliect-list ]**

Option-list:
```csh
-ro                                Exports read-only, default is read-write
-alldirs                           Allow any subdirectory to be mounted
-maproot=TEST                      Mapping root to the user named "TEST" (root become TEST when change file)
-mapall=TEST                       Mapping all UIDs to user named "TEST" (all users become TEST when change file)
```

Client-list:
```csh
hostname                             Specify host name (e.g. my hostname)
netgroup                             Specify NIS netgroups
-network A.B.C.D -mask E.F.G.H       network IP and mask
```

**Example of /etc/exports**
```csh
/net/test_dirA  -ro -mapall=testuser
/net/test_dirB
```

## Step 4: Reload Mountd
**After edit /etc/exports, we must reload mountd**
```csh
service mountd reload
```
