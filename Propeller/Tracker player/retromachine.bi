'const _clkfreq = 319_215_686  'PAL*90
const _clkfreq = 354693878 
'349977600=31*256*44100=350000000=2/35=44102,8225806
'356352000=29*256*48000=356363636=11/196=48001,5673491

'option implicit
dim v as class using "hng037rm.spin2"
dim rm as class using "retrocog.spin2"
dim tracker as class using "trackerplayer.spin2"
dim paula as class using "audio090-8-sc.spin2"
#include "dir.bi"

dim audiocog,videocog,base as ulong

sub startaudio
audiocog,base=paula.start()
end sub 

sub cls(fg=154,bg=147)
v.cls(fg,bg)
end sub

function startvideo(mode=64, pin=0) 'todo return a cog#
v.start(mode,pin)
v.setbordercolor(0,0,0)
open SendRecvDevice(@v.putchar, nil, nil) as #0
end function

'function startmachine()' todo return a cog
'c=rm.start()
'return c
'end function

#define startmachine rm.start
#define plot v.plot1

'sub putpixel(x,y,c)
'v030.putpixel8(x,y,c)
'end sub

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

sub position(x,y)
v.setcursorpos(x,y)
end sub

sub waitvbl
  v.waitvbl(1)
end sub
