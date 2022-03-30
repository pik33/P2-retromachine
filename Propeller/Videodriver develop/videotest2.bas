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

v.spr1ptr=@balls
v.spr2ptr=@balls2
v.spr3ptr=@balls3
v.spr4ptr=@balls4
v.spr5ptr=@balls
v.spr6ptr=@balls2
v.spr7ptr=@balls3
v.spr8ptr=@balls4

var xpos1=10
var ypos1=10
var xpos2=61
var ypos2=60
var xpos3=112
var ypos3=110
var xpos4=163
var ypos4=160
var xpos5=214
var ypos5=210
var xpos6=265
var ypos6=260
var xpos7=316
var ypos7=310
var xpos8=367
var ypos8=360

var xdelta1=1
var ydelta1=1
var xdelta2=2
var ydelta2=2
var xdelta3=3
var ydelta3=3
var xdelta4=4
var ydelta4=4
var xdelta5=5
var ydelta5=5
var xdelta6=6
var ydelta6=6
var xdelta7=7
var ydelta7=7
var xdelta8=8
var ydelta8=8

do

do:loop until v.vblank=1
xpos1+=xdelta1
ypos1+=ydelta1
xpos2+=xdelta2
ypos2+=ydelta2
xpos3+=xdelta3
ypos3+=ydelta3
xpos4+=xdelta4
ypos4+=ydelta4
xpos5+=xdelta5
ypos5+=ydelta5
xpos6+=xdelta6
ypos6+=ydelta6
xpos7+=xdelta7
ypos7+=ydelta7
xpos8+=xdelta8
ypos8+=ydelta8


if xpos1>=1024-64 then xdelta1=-1
if ypos1>=576-64 then ydelta1=-1
if ypos1=0 then ydelta1=1
if xpos1=0 then xdelta1=1


if xpos2>=1024-64 then xdelta2=-2
if ypos2>=576-64 then ydelta2=-2
if ypos2<=0 then ydelta2=2
if xpos2<=0 then xdelta2=2


if xpos3>=1024-64 then xdelta3=-3
if ypos3>=576-64 then ydelta3=-3
if ypos3<=0 then ydelta3=3
if xpos3<=0 then xdelta3=3

if xpos4>=1024-64 then xdelta4=-4
if ypos4>=576-64 then ydelta4=-4
if ypos4<=0 then ydelta4=4
if xpos4<=0 then xdelta4=4

if xpos5>=1024-64 then xdelta5=-5
if ypos5>=576-64 then ydelta5=-5
if ypos5<=0 then ydelta5=5
if xpos5<=0 then xdelta5=5

if xpos6>=1024-64 then xdelta6=-6
if ypos6>=576-64 then ydelta6=-6
if ypos6<=0 then ydelta6=6
if xpos6<=0 then xdelta6=6

if xpos7>=1024-64 then xdelta7=-7
if ypos7>=576-64 then ydelta7=-7
if ypos7<=0 then ydelta7=7
if xpos7<=0 then xdelta7=7

if xpos8>=1024-64 then xdelta8=-8
if ypos8>=576-64 then ydelta8=-8
if ypos8<=0 then ydelta8=8
if xpos8<=0 then xdelta8=8




if xpos1>=0 then v.spr1x=xpos1
if xpos2>=0 then v.spr2x=xpos2
if xpos3>=0 then v.spr3x=xpos3
if xpos4>=0 then v.spr4x=xpos4
if xpos5>=0 then v.spr5x=xpos5
if xpos6>=0 then v.spr6x=xpos6
if xpos7>=0 then v.spr7x=xpos7
if xpos8>=0 then v.spr8x=xpos8




if ypos1>=0 then v.spr1y=ypos1
if ypos2>=0 then v.spr2y=ypos2
if ypos3>=0 then v.spr3y=ypos3
if ypos4>=0 then v.spr4y=ypos4
if ypos5>=0 then v.spr5y=ypos5
if ypos6>=0 then v.spr6y=ypos6
if ypos7>=0 then v.spr7y=ypos7
if ypos8>=0 then v.spr8y=ypos8





do:loop until v.vblank=0
loop
end sub

asm shared

balls file "balls.def"
balls2 file "balls3.def"
balls3 file "balls5.def"
balls4 file "balls7.def"
'balls5 file "balls5.def"
'balls6 file "balls6.def"
'balls7 file "balls7.def"
'balls8 file "balls8.def"

end asm
