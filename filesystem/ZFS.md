# Z FileSystem (ZFS)
## List Datasets
[ zfs list ]
```bash
zfs list
```
## Create Dataset
[ zfs create DATASET ]
```bash
zfs create mypool/test

zfs:                            z-filesystem
create:                         create dataset
mypool/test:                    new dataset name is "mypool/test"
```
## Rename Dataset
[ zfs rename ORIGIN_NAME NEW_NAME ]
 ```bash
 zfs rename mypool/testt mypool/test
 
 zfs:                           z-filesystem
 rename:                        rename dataset
 mypool/testt:                  dataset with wrong name is "mypool/testt"
 mypool/test:                   rename dataset to new name "mypool/test"
 ```
## Destroy Dataset
[ zfs destroy DATASET ]
```bash
zfs destroy mypool/test

zfs:                            z-filesystem
destroy:                        destroy (delete) dataset
mypool/test:                    target dataset is "mypool/test"
```
## Set Mountpoint of Dataset
[ zfs set mountpoint=/PATH/TO/DIR DATASET ]
```bash
zfs set mountpoint=/home/ftp/test mypool/test

zfs:                            z-filesystem
set:                            setting dataset
mountpoint=/home/ftp/test:      mountpoint is /home/ftp/test
mypool/test:                    target dataset is mypool/test
```

## Change Compression type
[ zfs set compression=TYPE DATASET ]
```bash
zfs set compression=gzip mypool/test

zfs:                            z-filesystem  
set:                            setting dataset
compression=gzip:               set compression to "gzip"
mypool/test:                    the target dataset is "mypool/test"
```
