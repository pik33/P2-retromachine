#include "retromachine.bi"

dim newdl(4095) as ulong
dim random(1023) as ubyte

startmachine
startpsram
startvideo

v.setmode(512+64+48)
v.cls(154,147)
print("kwas") 
 
 
for i=0 to 8191 
for j=0 to 1023: random(j)=getrnd() and $7F: next j

psram.write(addr(random(0)),i*1024,1024)
next i
 
 
makedl


sub makedl


' Make colors 0 and 15 blue-green for the graphics part of the screen
let dltest=v.dl_ptr
let palettetest=v.palette_ptr
for i=0 to 4095 : newdl(i)=0: next i
for i=0 to 539 : newdl(i)=lpeek(dltest+4*i) : next i
newdl(1)=  %0101_0000_0000_0000_0000__1111_0111_0011

/'
' Prepare the title
var i=0
var address=addr(version$(0))
for i=0 to 27: lpoke title_ptr+4*i,$77710000 : next i
var start=(28-len(version$)) / 2
for i=start to start+len(version$)-1: lpoke title_ptr+4*i,$77710000+peek(address+i-start): next i

' clear the display list

for i=0 to 767: lpoke dlcopy_ptr+4*i,0 : next i

' First 4 lines = 0 for upper border over the title
' then a big title, 32 lines in 4x horizontal, 2x vertical zoom

for i=0 to 15
  for j=0 to 1
    lpoke dlcopy_ptr+4*(4+2*i+j),(title_ptr shl 12)+%10_0000_0000_00_01+(i shl 8)
  next j
next i  

' lines 36 to 42 empty, then 21 lines (= 21*16 screen lines and 21*32 DL entries) of 8x16 text with split screen - 84 chars from mainbuf, 28 from infobuf

address=mainbuf_ptr
var address2=infobuf_ptr

for i=0 to 20
  if i=20 then address2=infobuf_ptr+39*28*4 'display line 39 here
  for j=0 to 15
     lpoke dlcopy_ptr+4*(40+32*i+2*j+0),(address2 shl 14)+ %0000_0001_1100_1111+(0 shl 4) + j shl 12
     lpoke dlcopy_ptr+4*(40+32*i+2*j+1),(address shl 12)+ (j shl 8) + (i shl 2) + 1
  next j
  address=address+84*4
  address2=address2+28*4
next i
  
' Live change registers have to be cleared now

lpoke dlcopy_ptr+4*714, %0000_0000_0000_0000_0000_1111_1111_1111 

' Next 6 lines empty, over the graphic part
' We will use repeat command for this

lpoke dlcopy_ptr+4*721, %0000_1000_0000_0001_0001_1100_0000_0111   ' repeat 128, every second line add 448 (=2x vertical zoom)
'lpoke dlcopy_ptr+4*721, graphicbuf_ptr shl 12 +%00_0000_0000_1010  ' graphic line with 4bpp
lpoke dlcopy_ptr+4*722, graphicbuf_ptr shl 12 +%00_0000_0000_1010  ' graphic line with 4bpp

' 6 empty lines under the graphic lines. 2 lines before status/help line enable the horizontal fine scroll

lpoke dlcopy_ptr+4*728, %0000_0000_0000_0000_0001_0000_0101_0011

' scrolling help line, using repeat 

lpoke dlcopy_ptr+4*730, %0000_0001_0000_1111_0000_0000_0000_0111          ' repeat 16
lpoke dlcopy_ptr+4*731, (statusline_ptr+4) shl 12+ %00_0000_0000_0001     ' text line

lpoke dlcopy_ptr+4*732, %0000_0000_0000_0000_0001_0000_0101_0011          ' reset horizontal scroll to 0

' the rest of DL are zero
' Now tell the driver wheere is a new DL

'/

v.dl_ptr=addr(newdl(0))

end sub
