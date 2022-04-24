const _clkfreq = 336956522

dim v as class using "hg007e.spin2"
dim rm as class using "retrocog.spin2"
'dim tracker as class using "trackerplayer.spin2"
dim paula as class using "audio093a-8-sc.spin2"
'dim sid as class using "sidcog8.spin2"
dim psram as class using "psram4.spin2"
'dim spc as class using "spccog.spin2"
'dim a6502 as class using "a6502-1.spin2"
#include "dir.bi"

dim audiocog,videocog as integer
dim base as ulong
dim mbox as ulong

sub startpsram
psram.startx(0, 0, 11, -1)
mbox=psram.getMailbox(0)
end sub

sub startaudio
audiocog,base=paula.start(mbox,$75A00,$7A400)
end sub 

sub stopaudio
cpustop(audiocog)
audiocog=-1
end sub

sub cls(fg=154,bg=147)
v.cls(fg,bg)
end sub

function startvideo(mode=64, pin=0, mb=0) 'todo return a cog#
dim videocog as ulong
videocog=v.start(pin,mbox)
v.setbordercolor(0,0,0)
v.cls(154,147)
'for thecog=0 to 7:psram.setQos(thecog, 112 << 16) :next thecog
psram.setQoS(videocog, $7FFFf400) 
open SendRecvDevice(@v.putchar, nil, nil) as #0
return videocog
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

sub pslpoke(addr as ulong,value as ulong)
psram.filllongs(addr,value,1,0)
end sub

sub pspoke(addr as ulong,value as ulong)
psram.fillbytes(addr,value,1,0)
end sub

function pspeek(adr as ulong) as ubyte
dim res as ubyte
psram.read1(addr(res),adr,1)
return res
end function

function pslpeek(adr as ulong) as ulong
dim res as ulong
psram.read1(addr(res),adr,4)
return res
end function

function addr(byref v as const any) as ulong

return(cast(ulong,@v))
end function

sub position(x,y)
v.setcursorpos(x,y)
end sub

sub waitvbl
  v.waitvbl(1)
end sub
