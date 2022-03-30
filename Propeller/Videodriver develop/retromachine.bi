const _clkfreq = 336956522

dim v as class using "hg004.spin2"
dim psram as class using "psram4.spin2"

dim videocog as integer
dim mbox as ulong

sub startpsram
psram.startx(0, 0, 12, -1)
mbox=psram.getMailbox(0)
end sub

sub cls(fg=154,bg=147)
v.cls(fg,bg)
end sub

function startvideo(mode=64, pin=0, mb=0) 'todo return a cog#
dim videocog as ulong
videocog=v.start(pin,mbox)
v.setbordercolor(0,0,0)
for thecog=0 to 7:psram.setQos(thecog, 112 << 16) :next thecog
psram.setQoS(videocog, $7FFFf400) 
open SendRecvDevice(@v.putchar, nil, nil) as #0
return videocog
end function

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

function addr(byref v as const any) as ulong

return(cast(ulong,@v))
end function

sub position(x,y)
v.setcursorpos(x,y)
end sub

sub waitvbl
  v.waitvbl(1)
end sub
