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
        bytefill(aa,qq,1024)
    psram.write(addr(random(0)),j*1024,1024) 

  next j
k=(k+1) 
v.waitvbl(1)
loop


 



sub makedl


' Make colors 0 and 15 blue-green for the graphics part of the screen
let dltest=v.dl_ptr
let palettetest=v.palette_ptr
for i=0 to 4095 : newdl(i)=0: next i
for i=0 to 575 : newdl(i+1)=lpeek(dltest+4*i) :next i
newdl(0)=  %0111_0000_0000_0000_0000__1111_0111_0011
 for i=1 to 576
   let q=lpeek(dltest+4*i)
   let q2=(q and $0000000)+((i-1)*8) shl 14+12+2

   newdl(i)=q2   
 
next i
'v.timings(5)=8 : v.timings(11)=128 
v.setpalette(256)


v.dl_ptr=addr(newdl(0))

end sub
