const _clkfreq = 320_000_000
option implicit
dim v030 as class using "hng030rm"

function cls(fg=154,bg=147)
v030.cls(fg,bg)
end function

function startvideo(mode=64, pin=0)
v030.start(mode,pin)
v030.setbordercolor(0,0,0)
open SendRecvDevice(@v030.putchar, nil, nil) as #2
end function

function putpixel(x,y,c)
v030.putpixel8(x,y,c)
end function
