#include "retromachine.bi"

dim s(64) as ulong

let c1=1: let c2=0
'startmachine
startpsram
startvideo
dim ccc,x1,x2,y1,y2,r as ulong
v.cls(200,0)
let cog=cpu(movesprite,@s)

v.setfontfamily(0)
do
  for i=1 to 100: print i: next i

  for i=0 to 1000
    ccc=getrnd() and 255
    x1=getrnd() mod 128
    y1=getrnd() mod 36
    position x1,y1: v.setwritecolors(ccc,0): print "Testing PSRAM 8bpp 1024x576 HDMI mode";
  next i

  for i=0 to 1000
    ccc=getrnd() and 255
    x1=getrnd() mod 1024
    y1=getrnd() mod 576
    v.outtextxycg(x1,y1,"Testing PSRAM 8bpp 1024x576 HDMI mode",ccc,0)
  next i
  
  for i = 0 to 5000
    ccc=getrnd() and 255
    x1=getrnd() mod 1024
    x2=getrnd() mod 1024
    y1=getrnd() mod 576
    y2=getrnd() mod 576
    v.draw(x1,y1,x2,y2,ccc)
  next i 

  for i = 0 to 5000
    x1=getrnd() mod 1024
    y1=getrnd() mod 576
    r=getrnd() mod 100
    ccc=getrnd() and 255
    v.fcircle(x1,y1,r,ccc)   
  next i  

  for i = 0 to 5000
    ccc=getrnd() and 255
    x1=getrnd() mod 1024
    x2=getrnd() mod 1024
    y1=getrnd() mod 576
    y2=getrnd() mod 576
    v.frame(x1,y1,x2,y2,ccc)
  next i  
  
  for i = 0 to 5000
    x1=getrnd() mod 1024
    y1=getrnd() mod 576
    r=getrnd() mod 100
    ccc=getrnd() and 255
    v.circle(x1,y1,r,ccc) 
  next i  
  
  for i = 0 to 10000
    ccc=getrnd() and 255
    x1=getrnd() mod 1024
    x2=getrnd() mod 200
    y1=getrnd() mod 576
    y2=getrnd() mod 200
    v.box(x1,y1,x1+x2,y1+y2,ccc)  
  next i      
  
loop

sub movesprite
var xdelta=1
var ydelta=1

do

do:loop until v.vblank=1
v.spr1x+=xdelta
v.spr1y+=ydelta
if v.spr1x>=1024-64 then xdelta=-1
if v.spr1y>=576-64 then ydelta=-1
if v.spr1y=0 then ydelta=1
if v.spr1x=0 then xdelta=1
do:loop until v.vblank=0
loop
end sub

asm shared

balls file "balls.def"

end asm
