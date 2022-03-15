#include "retromachine.bi"

dim newdl(4095) as ulong
dim random(1023) as ubyte

startmachine
startpsram
startvideo

v.setmode(512+0+192+32)
v.cls(154,147)

waitms(5000)
 
makedl
let aa=addr(random(0))
let k=0
do
  for j=0 to 575
    let qq=(j+k) mod 256 
    let qq=$88800000 + (j+65) mod 128
        longfill(aa,qq,256)
    psram.write(addr(random(0)),j*1024,1024) 
  next j
k=(k+1) 
v.waitvbl(1)
loop
'v.setcursorpos(3,3)
sub makedl
for i=0 to 1023 : newdl(i)=0: next i
newdl(0)= %0111_0000_0000_0000_0000__1111_0111_0011        ' switch to PSRAM
'newdl(1)= %0000_0001_0000__0000__0000_0010_0000_0111       ' repeat 576 lines, after every line add 32 (will be SHLed by 5) to the address
'newdl(2)= 0
newdl(1)= %0010_0100_0000__1111__0000_0010_0000_0111       ' repeat 576 lines, after every line add 32 (will be SHLed by 5) to the address
'newdl(2)= %0000_0000_0000_0000_00_00_0000_0000_11_10       ' display a graphics line starting from 0, 
newdl(2)= %0000_0000_0000_0000_0000_0000_0000_00_01       ' display a graphics line starting from 0, 

v.setpalette(256)
v.dl_ptr=addr(newdl(0))

end sub
