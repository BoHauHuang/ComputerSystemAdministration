# Export FileSystem
## Edit /etc/exports
**This file specifiy which directory will be shared**

**Command Format: [ directory-list  option-list  cliect-list ]**

Option-list:
```csh
-ro                                Exports read-only, default is read-write
-alldirs                           Allow any subdirectory to be mounted
-maproot=TEST                      Mapping root to the user named "TEST" (root become TEST when change file)
-mapall=TEST                       Mapping all UIDs to user named "TEST" (all users become TEST when change file)
```

Client-list:
```bash
hostname                             Specify host name (e.g. my hostname)
netgroup                             Specify NIS netgroups
-network A.B.C.D -mask E.F.G.H       network IP and mask
```

## Some Examples
**Example of /etc/exports**
```csh
/home  -ro -mapall=nobody testhost

/home:                          Sharing "/home" directory (but subdirectories are not to be mounted)
-ro:                            Read-only
-mapall=nobody:                 Mapping all users to nobody
testhost:                       host name is testhost
```
