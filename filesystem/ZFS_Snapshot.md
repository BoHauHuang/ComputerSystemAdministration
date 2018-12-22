# Z-FileSystem (ZFS) Snapshot

## List Snapshots

[ zfs list -t snapshot ]

```bash
zfs list -t snapshot

zfs:                        z-filesystem
list:                       list things in zfs
-t:                         type of things
snapshot:                   type is "snapshot"
```

## Create Snapshot

[ zfs snapshot DATASET ]

```bash
zfs snapshot mypool/test

zfs:                         z-filesystem
snapshot:                    take snapshot of dataset
mypool/test:                 target dataset is "mypool/test"
```
