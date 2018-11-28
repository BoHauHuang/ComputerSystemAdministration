# User Restriction

**Use "setfacl" command to set access control list** 

[setfacl -m u:USER:PERMISSION:FILE_or_DIR:STATUS  FILE]

(1) Not allow download files in directory

```bash
setfacl u:ftp:r:f:deny test_dir


Who?                    u           (user)
What is his name?       ftp
Which action?           r           (read: for file, it's download permission)
Which data?             f           (file)
Which permission?       deny        (can't do download to files in directory named test_dir)
Where?                  test_dir    
```

(2) Not allow delete files in directory

```bash
setfacl u:ftp:D:f:deny test_dir


Who?                    u           (user)
What is his name?       ftp
Which action?           D           (delete children, in other word, delete files in directory)
Which data?             f           (file)
Which permission?       deny        (can't do delete to files in directory named test_dir)
Where?                  test_dir    
```

