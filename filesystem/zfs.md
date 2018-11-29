# ZFS and Zpool
## Zpool
**Manage ZFS pool (zpool)**

***Please add sufficient disks in your device***

**(1) Create a mirror storage**

[ zpool create POOL_NAME TYPE DISK1 DISK2... ]

```bash
zpool create mypool mirror /dev/ada1 /dev/ada2

zpool:                 zpool manage tool
create:                create a zpool
mypool:                pool name is "mypool"   
mirror:                raid type is mirror
/dev/ada1:             first disk for mirror
/dev/ada2:             second disk for mirror
```

**(2) Status of zpools**

[ zpool status ]

```bash
zpool status

zpool:                 zpool manage tool
status:                status of all zpools
```

**(3) In "mypool" add another mirror storage**

[ zpool add TARGET_ZPOOL TYPE DISK1 DISK2... ]

```bash
zpool add mypool mirror /dev/ada3 /dev/ada4

zpool:                 zpool manage tool
add:                   add a storage in pool
mypool:                target pool name is "mypool"   
mirror:                raid type is mirror
/dev/ada3:             first disk for mirror
/dev/ada4:             second disk for mirror
```

Now you will have two mirror storage in a zpool

```
zpool status 

and you will see:

 pool: mypool
 state: ONLINE
 scan: scrub repaired 0 in 0h0m with 0 errors on Fri May 30 08:29:51 2014
 config:
 
        NAME           STATE     READ WRITE CKSUM
        mypool         ONLINE       0     0     0
          mirror-0     ONLINE       0     0     0
            /dev/ada1  ONLINE       0     0     0
            /dev/ada2  ONLINE       0     0     0
          mirror-1     ONLINE       0     0     0
            /dev/ada3  ONLINE       0     0     0
            /dev/ada4  ONLINE       0     0     0
```

**(4) Remove disk "/dev/ada2" from "mypool"**

[ zpool detach TARGET_ZPOOL TARGET_DISK]

```bash
zpool detach mypool /dev/ada2

zpool:                 zpool manage tool
detach:                remove a disk from pool
mypool:                target pool name is "mypool"
/dev/ada2:             target disk to be removed
```
