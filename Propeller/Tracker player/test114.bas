#include "dir.bi"
dim filename$ as string
declare filename2 alias filename$ as ulong

dim a$ as string
declare a alias a$ as ulong 



mount "/sd", _vfs_open_sdcard()
chdir "/sd/mod"
filename$=dir$("*", fbDirectory or fbNormal)
do while filename$<>nil andalso filename$<>""
  print hex$(filename2,8), hex$(lpeek(filename2 and $7FFFF)),filename$
  filename$=dir$()
loop

'----------------------------------------------------




function lpeek(addr) as ulong
dim r as ulong
asm
rdlong r,addr
end asm
return r
end function
