#include "retromachine.bi"

dim random(511) as ubyte
let c1=1: let c2=0
'startmachine
startpsram
startvideo

dim ccc,x1,x2,y1,y2,r as ulong

goto 999
for j=1 to 2
  v.setmode(1024+512+192+48)
  v.cls(200,0)
  'v.outtextxycg(0,0,"Testing PSRAM 8bpp 1024x576 HDMI mode",200,0)
  print "Testing PSRAM 8bpp 1024x576 HDMI mode"
  waitms(5000)
 
  for i = 0 to 500
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

  for i = 0 to 500
    ccc=getrnd() and 255
    x1=getrnd() mod 1024
    x2=getrnd() mod 1024
    y1=getrnd() mod 576
    y2=getrnd() mod 576
    v.frame(x1,y1,x2,y2,ccc)
  next i  
  
  for i = 0 to 1000
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
  
/'  
  v.setmode(0+512+64+48)
  v.cls(40,0)
  print "Testing HUB 8bpp 896x496 HDMI mode "

  waitms(5000)
 
  for i = 0 to 5000
    ccc=getrnd() and 255
    x1=getrnd() mod 896
    x2=getrnd() mod 896
    y1=getrnd() mod 496
    y2=getrnd() mod 496
    v.draw(x1,y1,x2,y2,ccc)
  next i 

  for i = 0 to 50000
    x1=getrnd() mod 896
    y1=getrnd() mod 496
    r=getrnd() mod 100
    ccc=getrnd() and 255
    v.fcircle(x1,y1,r,ccc)   
  next i  

  for i = 0 to 5000
    ccc=getrnd() and 255
    x1=getrnd() mod 896
    x2=getrnd() mod 896
    y1=getrnd() mod 496
    y2=getrnd() mod 496
    v.frame(x1,y1,x2,y2,ccc)
  next i  
  
  for i = 0 to 10000
    x1=getrnd() mod 896
    y1=getrnd() mod 496
    r=getrnd() mod 100
    ccc=getrnd() and 255
    v.circle(x1,y1,r,ccc) 
  next i  
  
  for i = 0 to 100000
    ccc=getrnd() and 255
    x1=getrnd() mod 896
    x2=getrnd() mod 200
    y1=getrnd() mod 496
    y2=getrnd() mod 200
    v.box(x1,y1,x1+x2,y1+y2,ccc)  
  next i      
'/
next j 

v.setmode(2047)
print "kwas"
waitms(4000)
999 v.setmode(0)
v.cls(200,0)
for i=1 to 28:print("koperwas"):next i

print("koperwas");
'v.setcursorpos(2,29)
do:loop
waitms(5000)
v.setfontfamily(4)
do
'goto 100
'' text mode testing
  for mainmode=0 to 0+7
    for vzoom=0 to 3
      for hzoom= 0 to 2
        let mode=64*mainmode+4*vzoom+hzoom
        v.setmode(mode)
        v.cls(154,147)
        print "Mode: "; mode
        print "Fb start: ";v.s_buf_ptr
        print "Lines: ";v.s_lines
        print "Cpl: "; v.s_cpl
        print "Buffer length: ";v.s_buflen
        for i=1 to 13:v.write("1234567890"):next i
        if mode mod 64 = 0 then waitms(5000)
        waitms(600)

      next hzoom
    next vzoom
  next mainmode    

 for mainmode=8 to 8+7
    for depth=0 to 3
      for vzoom=0 to 3
        for hzoom= 0 to 3
          let mode=64*mainmode+16*depth+4*vzoom+hzoom
          v.setmode(mode)
          if depth=3 then let c1=154: let c2=147
          if depth=2 then let c1=2 : let c2=0
          if depth=1 then let c1=2 : let c2=0
          if depth=0 then let c1=1 : let c2=0
          v.cls(c1,c2)
          print "Mode: "; mode
          print "Fb start: ";v.s_buf_ptr
          print "Lines: ";v.s_lines
          print "Cpl: "; v.s_cpl
          print "Buffer length: ";v.s_buflen
          v.outtextxycg(0,80,"1234567890123456789012345678901234567890",c1,c2)
          if mode mod 64 = 0 then waitms(5000)
          waitms(600)
 
        next hzoom
      next vzoom
    next depth
  next mainmode    
 
 for mainmode=16 to 16+7
    for vzoom=0 to 3
      for hzoom= 0 to 2
        let mode=64*mainmode+4*vzoom+hzoom
        v.setmode(mode)
        v.cls(154,147)
        print "Mode: "; mode
  '    v.write("Mode: "): v.write(v.inttostr(mode))
        print "Fb start: ";v.s_buf_ptr
        print "Lines: "; v.s_lines
        print "Cpl: "; v.s_cpl
        print "Buffer length: ";4*v.s_buflen
        for i=1 to 13:v.write("1234567890"):next i
        if mode mod 64 = 0 then waitms(5000)
        waitms(600)

      next hzoom
    next vzoom
  next mainmode    

 
    for mainmode=24 to 24+7
    for depth=0 to 3
      for vzoom=0 to 3
        for hzoom= 0 to 3
          let mode=64*mainmode+16*depth+4*vzoom+hzoom
          v.setmode(mode)
          if depth=3 then let c1=154: let c2=147
          if depth=2 then let c1=2 : let c2=0
          if depth=1 then let c1=2 : let c2=0
          if depth=0 then let c1=1 : let c2=0
          v.cls(c1,c2)
          print "Mode: "; mode
          print "Fb start: ";v.s_buf_ptr
          print "Lines: ";v.s_lines
          print "Cpl: "; v.s_cpl
          print "Buffer length: ";v.s_buflen

          v.outtextxycg(0,80,"1234567890123456789012345678901234567890",c1,c2)
          if mode mod 64 = 0 then waitms(5000)
          waitms(600)
 
        next hzoom
      next vzoom
    next depth
  next mainmode    
 
mainmode=0
loop


sub test2
 
v.setmode(512+0+192+32)
waitms(5000)
 
makedl
v.setcursorpos(3,3)
let aa=addr(random(0))
for j=0 to 35
  let qq=$88800000 + (j+65) 
  longfill(aa,qq,128)
  psram.write(addr(random(0)),j*512,512) 
next j
end sub

sub makedl

for i=0 to 7 : newdl(i)=0: next i
newdl(0)= %0111_0000_0000_0000_0000_0111_0111_0011        ' switch to PSRAM
newdl(1)= %0010_0100_0000_1111_0000_0001_0000_0111        ' repeat 576 lines, after every line add 32 (will be SHLed by 5) to the address
newdl(2)= %0000_0000_0000_0000_0000_0000_0000_0001        ' display a text line starting from 0, 
v.setpalette(256)
v.dl_ptr=addr(newdl(0))
end sub
