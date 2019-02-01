# User Restriction

**Use "setfacl" command to set access control list** 

[setfacl -m u:USER:ACCESS_PERMISSION:FILE_or_DIR:TYPE  FILE]

***-m:                   modify*** 

***ACCESS_PERMISSION:    r/w/x/p/D/d...***

***FILE_or_DIR:          f/d***

***TYPE:                 allow/deny***

**(1)  Only not allow download files in directory**
```bash
setfacl u:ftp:r:f:deny test_dir


Who?                    u           (user)
What is his name?       ftp         (anonymous username)
Which action?           r           (read: for file, it's download permission)
Which data?             f           (file)
Which permission?       deny        (can't do download to files in directory named test_dir)
Where?                  test_dir    
```

**(2)  Only not allow delete files in directory**
```bash
setfacl u:ftp:D:f:deny test_dir


Who?                    u           (user)
What is his name?       ftp         (anonymous username)
Which action?           D           (delete children, in other word, delete files in directory)
Which data?             f           (file)
Which permission?       deny        (can't do delete to files in directory named test_dir)
Where?                  test_dir    
```
**(3)  Not allow both delete and download files in directory**

***Once setting new deny permission, it will overwrite the former setting***

***In other word, if you want more than one restrict, you have to set them in one time***
```bash
setfacl u:ftp:rD:deny test_dir


Who?                    u           (user)
What is his name?       ftp         (anonymous username)
Which action?           r and D     (read and delete children)
Which data?             f           (file)
Which permission?       deny        (can't do delete to files in directory named test_dir)
Where?                  test_dir
```
**(4)  Not allow list directory and files, but can enter the directories under test_dir**

**Not allow list directory and files: can't do "ls"**

**Can enter the directories under test_dir: can do "cd /HIDDEN_DIR"**

```bash
setfacl -m u:ftp:r:d:deny test_dir
setfacl -m u:ftp:x:d:allow test_dir

Who?                    u           (user)
What is his name?       ftp         (anonymous username)
Which action?           r           (read: for directory, it equals to "ls")
Which data?             d           (directory)
Which permission?       deny        (can't see to files in directory named test_dir)
Where?                  test_dir

Who?                    u           (user)
What is his name?       ftp         (anonymous username)
Which action?           x           (execute: for directory, it equals to "cd")
Which data?             d           (directory)
Which permission?       allow       (can enter directories in directory named test_dir)
Where?                  test_dir
```
## Access Permissions (Often used)
**For Files**
```
r:  read
w:  edit
x:  execute
d:  delete
o:  change owner (chown or chgrpc
c:  read ACL     (getfacl)
C:  change ACL   (setfacl, chmod)
```
**For Directories**
```
r:  list directory    (ls)
w:  create directory  (mkdir or touch a new file in directory)
x:  change directory  (cd)
D:  delete child      (delete data in directoy)
o:  change owner      (chown or chgrp)
c:  read ACL          (getfacl)
C:  change ACL        (setfacl, chmod)
```
