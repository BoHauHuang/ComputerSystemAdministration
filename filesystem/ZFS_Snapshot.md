# Z-FileSystem (ZFS) Snapshot

## List Snapshot

[ zfs list -t snapshot ]


## Create Snapshot

[ zfs snapshot DATASET ]

```bash
zfs snapshot mypool/test

zfs:                         z-filesystem
snapshot:                    take snapshot of dataset
mypool/test:                 target dataset is "mypool/test"
```
