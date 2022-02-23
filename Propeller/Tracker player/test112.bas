mount "/sd", _vfs_open_sdcard()

dim r,test as ulong
chdir("/sd")       ' set working directory
open "/sd/testfile" for output as #3
put #3,test,1,r
close #3
