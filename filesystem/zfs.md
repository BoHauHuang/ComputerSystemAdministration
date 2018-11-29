# ZFS
## Zpool
**Manage ZFS pool (zpool)**

(1) Create a mirror storage

***If you are using VM***

***Please add two sata HDD in your device***

[ zpool create POOL_NAME TYPE DISK1 DISK2... ]

```bash
zpool create mypool mirror /dev/ada1 /dev/ada2

zpool:              zpool manage tool
create:             create a zpool
mypool:             pool name is "mypool"   
mirror:             raid type is mirror
/dev/ada1:          first disk for mirror
/dev/ada2:          second disk for mirror
```
