#include "retromachine.bi"

dim newdl(7) as ulong
dim random(511) as ubyte
let c1=1: let c2=0
startmachine
startpsram
startvideo


waitms(5000)

do

'' text mode testing
  for mainmode=0 to 0+7
    for vzoom=0 to 3
      for hzoom= 0 to 2
        let mode=64*mainmode+4*vzoom+hzoom
        v.setmode(mode)
        v.cls(154,147)
        print "Mode: "; mode
  '    v.write("Mode: "): v.write(v.inttostr(mode))
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
          v.outtextxycg(0,0,"Mode: ",c1,c2) : v.outtextxycg(56,0,v.inttostr(mode),c1,c2)
          v.outtextxycg(0,16,"Fb : ",c1,c2) : v.outtextxycg(56,16,v.inttostr(v.s_buf_ptr),c1,c2)
          v.outtextxycg(0,32,"Lines: ",c1,c2) : v.outtextxycg(64,32,v.inttostr(v.s_lines),c1,c2)
          v.outtextxycg(0,48,"Cpl: ",c1,c2) : v.outtextxycg(56,48,v.inttostr(v.s_cpl),c1,c2)
          v.outtextxycg(0,64,"Buffer length: ",c1,c2) : v.outtextxycg(128,64,v.inttostr( v.s_buflen),c1,c2)
          v.outtextxycg(0,80,"1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890",c1,c2)
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
