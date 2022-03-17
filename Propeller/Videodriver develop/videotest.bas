#include "retromachine.bi"

dim newdl(7) as ulong
dim random(511) as ubyte

startmachine
startpsram
startvideo




'for i=1 to 13:v.write("1234567890"):next i
'waitms(5000)

'makedl
/'
let aa=addr(random(0))
for j=0 to 35
  let qq=$88800000 + (j+65) 
  longfill(aa,qq,128)
  psram.write(addr(random(0)),j*256,256) 
next j
'/
 

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
        print "Lines: "; v.s_lines
        print "Cpl: "; v.s_cpl
        print "Buffer length: ";4*v.s_buflen
        for i=1 to 13:v.write("1234567890"):next i
        if mode mod 64 = 0 then waitms(5000)
        waitms(2000)

      next hzoom
    next vzoom
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
        waitms(2000)

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
