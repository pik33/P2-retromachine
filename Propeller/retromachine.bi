const _clkfreq = 319_215_686  'PAL*90
option implicit
dim v030 as class using "hng030rm"
dim rm as class using "retrocog"
 

sub cls(fg=154,bg=147)
v030.cls(fg,bg)
end sub

function startvideo(mode=64, pin=0) 'todo return a cog#
v030.start(mode,pin)
v030.setbordercolor(0,0,0)
open SendRecvDevice(@v030.putchar, nil, nil) as #0
end function

sub putpixel(x,y,c)
v030.putpixel8(x,y,c)
end sub

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
