#include "dir.bi"
mount "/sd", _vfs_open_sdcard()

dim filename as string
chdir("/sd/mod")       ' set working directory
filename = dir$("*", 0)  ' start scan for all files and directories
while filename <> "" and filename <> nil
  print filename
  filename = dir$()      ' continue scan
end while
