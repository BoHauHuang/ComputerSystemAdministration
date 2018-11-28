# User Restriction

**Use "setfacl" command to set access control list** 

[setfacl -m u:USER:ACCESS_PERMISSION:FILE_or_DIR:TYPE  FILE]
[ACCESS_PERMISSION:    r/w/x/p/D/d...
FILE_or_DIR:          f/d
TYPE:                 allow/deny]

(1) Only not allow download files in directory
```bash
setfacl u:ftp:r:f:deny test_dir


Who?                    u           (user)
What is his name?       ftp         (anonymous username)
Which action?           r           (read: for file, it's download permission)
Which data?             f           (file)
Which permission?       deny        (can't do download to files in directory named test_dir)
Where?                  test_dir    
```

(2) Only not allow delete files in directory
```bash
setfacl u:ftp:D:f:deny test_dir


Who?                    u           (user)
What is his name?       ftp         (anonymous username)
Which action?           D           (delete children, in other word, delete files in directory)
Which data?             f           (file)
Which permission?       deny        (can't do delete to files in directory named test_dir)
Where?                  test_dir    
```
(3) Not allow both delete and download files in directory

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
