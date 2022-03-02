#include "dir.bi"
dim filename$ as string
declare filename2 alias filename$ as ulong

dim a$ as string
declare a alias a$ as ulong 

a=200000
for i=0 to 9: poke a+i,96+i:next i: poke a+i,0
print a$


mount "/sd", _vfs_open_sdcard()
chdir "/sd/mod"
filename$=dir$("*", fbDirectory or fbNormal)
do while filename$<>nil andalso filename$<>""
  print hex$(filename2,8), hex$(lpeek(filename2 and $7FFFF)),filename$
  filename$=dir$()
loop

'----------------------------------------------------


function peek(addr) as ubyte
dim r as ubyte
asm
rdbyte r,addr
end asm
return r
end function

function dpeek(addr) as ushort
dim r as ushort
asm
rdword r,addr
end asm
return r
end function

function lpeek(addr) as ulong
dim r as ulong
asm
rdlong r,addr
end asm
return r
end function

sub poke(addr as ulong,value as ubyte)
asm
wrbyte value, addr
end asm
end sub

sub dpoke(addr as ulong,value as ushort)
asm
wrword value, addr
end asm
end sub

sub lpoke(addr as ulong,value as ulong)
asm
wrlong value, addr
end asm
end sub

function addr(byref v as const any)

return(cast(ulong,@v))
end function
