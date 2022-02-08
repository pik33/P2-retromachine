#include "retromachine.bi"

const HEAPSIZE = 3072
const version$="Prop2play v.0.10"
const statusline$=" Propeler2 wav/sid/mod player v. 0.10 --- 2022.02.06 --- pik33@o2.pl --- use serial terminal or RPi KBM interface to control --- arrows up,down move - pgup,pgdn move 10 positions - enter selects - tab switches panels - +,- controls volume - R rescans current directory ------"

<<<<<<< Updated upstream
const module$="enha.mod"
=======
const module$="cos.mod"
>>>>>>> Stashed changes


' Place graphics buffers at the top of memory so they will not move while editing the program

const infobuf_ptr=$7EE80
const graphicbuf_ptr=$77E80
const mainbuf_ptr=$73A70
const statusline_ptr=$738A8
const title_ptr=$73838
const dlcopy_ptr=$72C38

' global vars

dim oldtrigs(4) as ulong
dim pan(4)
dim sn$(32)
dim sl as ulong
dim filebuf(127) as ubyte
dim r as ulong
dim ansibuf(3) as ubyte
dim mainstack(64) as ulong
' ----------------------------Main program start ------------------------------------

    
mainvolume=127 : mainpan=8192  ' vol: 1..128..(255)  pan 0 (mono)..8192 (full)
startmachine
startvideo
startaudio
v.cursoroff
makedl
lpoke addr(sl),len(statusline$)  ' cannot assign to sl, but still can lpoke :) 
framenum=0
for i=0 to 3 : oldtrigs(i)=0 : next i
pan(0)=8192-mainpan : pan(1)=8192+mainpan : pan(2)=8192+mainpan : pan(3)=8192-mainpan
preparepanels

mount "/sd", _vfs_open_sdcard()

chdir "/sd/"
getlists






close #5
close #6

chdir "/sd/mod"
ma=lomem()+1024 : mb=ma
pos=1
open "/sd/mod/"+module$ for input as #4
do
  get #4,pos,filebuf(0),128,r
  pos+=r
  for i=0 to r-1 : poke mb+i,filebuf(i) : next i
  mb+=r

loop until r<>128 orelse mb>= dlcopy_ptr-4
close #4
  position 3,16: v.write(v.inttostr2(pos-1,8)) 
tracker.initmodule(ma,0)

samples=15: if peek(ma+1080)=asc("M") and peek(ma+1082)=asc("K") then samples=31
getinfo(ma,samples)


'if lpeek($3c)<>0 then position 30,15: v.write(v.inttostr2(q2,8)) :position 30,16: v.write(v.inttostr2(q,8)): position 30,17 : v.write(v.inttostr2(peek($3d),8)): q2=q: q=peek($3d): lpoke $3c,0

'mainloop

cog=cpu (mainloop, @mainstack(0))

panel=0

do
  if lpeek($3c)<>0 then ansibuf(0)=ansibuf(1): ansibuf(1)=ansibuf(2) : ansibuf(2)=ansibuf(3) : ansibuf(3)=peek($3D): lpoke($3C,0)
  if ansibuf(3)=9 then 
    if panel=0 then highlight(panel,dirnum1,0)
    if panel=1 then highlight(panel,filenum1,0)
    panel=1-panel
    if panel=1 then highlight(panel,filenum1,1)
    if panel=0 then highlight(panel,dirnum1,1)
    ansibuf(3)=0
  endif
loop					    




' ------------------ main loop ------------------------  rev 20220205 ---------------------------------

sub mainloop

do
  tracker.tick
  waitvbl
  for mi=0 to 3 : setchannel(mi,oldtrigs(mi)) : next mi          ' this line has to be vblk syynchronized as much as possible
  framenum+=1
  movedl
  scrollstatus((framenum) mod (8*sl))
  displaysamples
loop
end sub

' ---------------- end of the main program -----------------------------------------------------------------------


sub getlists

diragain:
close #5

e=0
dirnum3=0
try
  open "dirlist.txt" for input as #5 
catch e
close #5                                          
end try

if e=4 then
  close #5
  open "dirlist.txt" for output as #5
  print #5,".."
  filename$ = dir$("*", fbDirectory)
  while filename$ <> "" andalso filename$ <> nil
    print #5, filename$
    filename$ = dir$()
  end while
  close #5
  goto diragain
endif
    
  
    
if e=0 then ' dir list exists
  i=2
  v.setwritecolors($c8,$c1)
  do
    input #5,filename$
    if filename$<> nil andalso filename$<>"" then
      filename$=right$(filename$,38)
      filename$=insert$(space$(38),filename$,19-len(filename$)/2)
      filename$=left$(filename$,38)
      if i<12 then position 2,i : print filename$ 
      i+=1
    endif  
<<<<<<< Updated upstream
  loop until filename$=nil orelse filename$="" 
  dirnum3=i-2
  position 3,18: print dirnum3
  endif
  
=======
  loop until i>12 orelse filename$=""
close #5
endif

>>>>>>> Stashed changes

close #6
fileagain:

e=0
folenum3=0
try
  open "filelist.txt" for input as #6 
catch e
close #6                                                
end try

if e=4 then
  close #6
  open "filelist.txt" for output as #6
  filename$ = dir$("*", fbNormal)
  while filename$ <> "" andalso filename$ <> nil
    print #6, filename$
    filename$ = dir$()
  end while
  close #6
  goto fileagain
endif
    
if e=0 then ' file list exists
  i=2
    v.setwritecolors($29,$22)
  do
    input #6,filename$
    if filename$<>"" then
      filename$=right$(filename$,38)
      filename$=insert$(space$(38),filename$,19-len(filename$)/2)
      filename$=left$(filename$,38)
      if i<19 then position 44,i : print filename$ 
      i+=1
    endif
 '   position 42+21-len(filename$)/2,i : print filename$ :i+=1
  loop until filename$=nil orelse filename$=""
  filenum3=i-2
endif

filenum1=0
filenum2=0
dirnum1=0
dirnum2=0
'max dir pos=10
'max file pos=17
highlight(0,0,1)
panel=0

'for i=2 to 39 : lpoke mainbuf_ptr+2*84*4+i*4, (lpeek(mainbuf_ptr+2*84*4+i*4) and $FFFF) or $c1c80000 :next i
'for i=44 to 81 : lpoke mainbuf_ptr+2*84*4+i*4, (lpeek(mainbuf_ptr+2*84*4+i*4) and $FFFF) or $22290000 :next i

end sub

sub highlight(hpanel,hpos,hhigh)

hq1=8+42*4*hpanel
hq2=mainbuf_ptr+(2+hpos)*84*4
if hpanel=0 andalso hhigh=1 then hq3=$c1c80000
if hpanel=0 andalso hhigh=0 then hq3=$c8c10000
if hpanel=1 andalso hhigh=1 then hq3=$22290000
if hpanel=1 andalso hhigh=0 then hq3=$29220000
for hi=0 to 37: lpoke hq1+hq2+hi*4,((lpeek(hq1+hq2+hi*4) and $FFFF) or hq3 ): next hi
end sub





' ---------------- Prepare the user interface --- rev 20220206 ---------------------------------------------------

sub preparepanels

' 1. Channel and oscilloscope panel at graphic canvas

v.s_buf_ptr=graphicbuf_ptr
v.s_cpl=112
v.s_lines=64
v.putpixel=v.p4
v.font_family=2
v.box(0,0,895,63,0)
v.frame(675,3,892,60,15)
v.frame(676,3,891,60,15)
outtext48(86,0," Channels ",15)
v.buf_ptr=mainbuf_ptr
v.frame(3,3,668,60,15)
v.frame(4,3,667,60,15)
outtext48(2,0," Oscilloscope ",15)
v.line1(16,32,655,32,14) 'cannot use "line"

' 2 File info scrolling panel

v.s_buf_ptr=infobuf_ptr                                                                                                       'set display variables to info buffer
v.s_lines=40
v.s_cpl=28
v.s_buflen=40*28
cls($9a,$93) 
poke infobuf_ptr, 10: poke infobuf_ptr+4,3 : for i=13 to 26:poke infobuf_ptr+4*i,3 : next i : poke infobuf_ptr+4*i,9           'Upper line with semigraphic frame
poke infobuf_ptr+39*28*4, 12: for i=1 to 26 : poke infobuf_ptr+39*28*4+i*4,3 :  next i : poke infobuf_ptr+39*28*4+4*i,11       'Lower (#39, but displayed at #20 via DL) semigraphic frame
for i=1 to 38: poke infobuf_ptr+112*i,4:  poke infobuf_ptr+112*i+108,4: next i                                                 'Left and right semigraphic
position 3,0 : print "File info"                                                                                               'Header

' 3 Directories, files and now playing on the main panel

v.s_buf_ptr=mainbuf_ptr
v.s_lines=21
v.s_cpl=84
v.s_buflen=21*84
cls($c8,$c1)                                                                                                                    'clear the buffer and make it green
for i=0 to 20: for j=42 to 83:  lpoke mainbuf_ptr+4*(84*i+j), $29220020 :next j : next i					'red for files
for i=14 to 20: for j=0 to 41:  lpoke mainbuf_ptr+4*(84*i+j), $EAE40020 :next j : next i                                        'yellow for playing timer
poke mainbuf_ptr, 10: for i=1 to 40:poke mainbuf_ptr+4*i,3 : next i : poke mainbuf_ptr+4*i,9                                    'Upper line with semigraphic frame
poke mainbuf_ptr+13*84*4, 12: for i=1 to 40 : poke mainbuf_ptr+13*84*4+i*4,3 :  next i : poke mainbuf_ptr+13*84*4+4*i,11        'Lower semigraphic frame
for i=1 to 12: poke mainbuf_ptr+84*4*i,4:  poke mainbuf_ptr+(84*4)*i+41*4,4: next i                                             'Left and right semigraphic
position 2,0 : print " Directories "                                                                                            'Header

poke mainbuf_ptr+42*4, 10: for i=1 to 40:poke mainbuf_ptr+42*4+4*i,3 : next i : poke mainbuf_ptr+42*4+4*i,9                   
poke mainbuf_ptr+42*4+20*84*4, 12: for i=1 to 40 : poke mainbuf_ptr+42*4+20*84*4+i*4,3 :  next i : poke mainbuf_ptr+42*4+20*84*4+4*i,11       
for i=1 to 19: poke mainbuf_ptr+42*4+84*4*i,4:  poke mainbuf_ptr+42*4+(84*4)*i+41*4,4: next i                                                  
v.setwritecolors($29,$22): position 44,0 : print " Files "                                                                     

poke mainbuf_ptr+14*84*4, 10: for i=1 to 40 : poke mainbuf_ptr+14*84*4+i*4,3 : next i : poke mainbuf_ptr+14*84*4+4*i,9            
poke mainbuf_ptr+20*84*4, 12: for i=1 to 40 : poke mainbuf_ptr+20*84*4+i*4,3 : next i : poke mainbuf_ptr+20*84*4+4*i,11       
for i=15 to 19: poke mainbuf_ptr+84*4*i,4:  poke mainbuf_ptr+(84*4)*i+41*4,4: next i                                                 
v.setwritecolors($ea,$e4) : position 2,14 : print " Now playing "                                                                    
                                 
v.setbordercolor2(v.getpalettecolor(113))											' dark blue border
end sub

' ---------------- Find an adress of the current top of the stack --- rev 20220206 -------------------------------

function lomem() as ulong
dim as integer ptr x = __builtin_alloca(4)    
return (cast(ulong,x))
end function

' ---------------- Set channel registers with tracker data --- rev 20220205 ---------------------------------------

sub setchannel(channel,byref trigger as ulong)

if tracker.trigger(channel)<>trigger then                                                           ' tracker wants to trigger a note
  trigger=tracker.trigger(channel)                                                                  ' remember trigger count
  lpoke base+8+32*channel,tracker.currSamplePtr(channel) or $40000000                               ' set new sample ptr and request sample restart 
  lpoke base+12+32*channel,tracker.currsamplelength(channel)-tracker.currrepeatLength(channel)      ' set new loop start   
  lpoke base+16+32*channel,tracker.currsamplelength(channel)                                        ' set new loop and
endif
dpoke base+20+32*channel, (tracker.currVolume(channel)+tracker.deltavolume(channel))*mainvolume     ' set volume - this and the rest doesn't depend on trigger
dpoke base+22+32*channel, pan(channel)                                                              ' set pan
dpoke base+24+32*channel, tracker.currPeriod(channel)+tracker.deltaperiod(channel)                  ' set period
dpoke base+26+32*channel, 1                                                                         ' set skip, always 1 here
end sub


'---------------- Get and display module information --------------------------

sub getinfo(ma,num)

v.s_buf_ptr=infobuf_ptr           'set display variables to info buffer
v.s_lines=40
v.s_cpl=28
v.s_buflen=40*28
 
 
v.setwritecolors($93,$9a): position 2,2 : print "                        " : position 2,2: print module$ :v.setwritecolors($9a,$93)     ' test: module file name will be here
position 2,3 : print "Amiga module: "; samples;" samples"
position 2,5 : for i=ma to ma+19 : print chr$(peek(i) mod 128); : next i      ' first 20 bytes of module=title
  
for i=0 to 31: sn$(i)=space$(22) :next i
c=0
for i=1 to num
  for j=0 to 21
    a=lpeek(addr(sn$(i)))
    b=(peek(ma+20+30*(i-1)+j))
    if b>=32 then poke a+j,b : c=i ' c will be the last named sample
  next j
next i
for i=1 to c: position 2,i+5 :print sn$(i) :next i
v.s_buf_ptr=mainbuf_ptr
v.s_lines=21
v.s_cpl=84
v.s_buflen=21*84'print

end sub


'------------ Fast character output on 4bpp graphic canvas - reduce time 19x comparing to high level spin code --- rev 20220205 ---------

sub outtext48(x,y, s$ as string ,c)

for i=0 to len(s$)-1

putchar48(v.s_buf_ptr,v.s_cpl,x+i,y,peek(addr(s$(0))+i),v.font_ptr+2048,15)
next i
end sub


sub putchar48(buf,cpl,x,y,char,font,c)

dim q,i,b,r  as ulong


asm
          mov i,#7
       
p101      mov b,char
          shl b,#3
          add b,font
          add b,i
          rdbyte b,b
          mergeb b
          getword q,b,#1
          mul b,c
          mul q,c
          setword b,q,#1
          mov q,y
          add q,i
          mul q,cpl
          shl q,#2
          add q,buf
          mov r,x
          shl r,#2
          add q,r
          wrlong b,q
          djnf i,#p101
   
end asm

end sub

'---------------- Display current samples and periods  using fast char output --- rev 20220205 ----------------------

sub displaysamples 

v.s_buf_ptr=graphicbuf_ptr
v.s_cpl=112
v.s_lines=64

outtext48(108,20,v.inttostr2(tracker.currperiod(0)+tracker.deltaperiod(0),3),15)
outtext48(108,28,v.inttostr2(tracker.currperiod(1)+tracker.deltaperiod(1),3),15)
outtext48(108,36,v.inttostr2(tracker.currperiod(2)+tracker.deltaperiod(2),3),15)
outtext48(108,44,v.inttostr2(tracker.currperiod(3)+tracker.deltaperiod(3),3),15)

outtext48(86,20,sn$(tracker.currsamplenr(0)),15) 
outtext48(86,28,sn$(tracker.currsamplenr(1)),15)
outtext48(86,36,sn$(tracker.currsamplenr(2)),15)
outtext48(86,44,sn$(tracker.currsamplenr(3)),15)

v.s_buf_ptr=mainbuf_ptr
v.s_cpl=84
v_s_lines=21

end sub

'------------------ A status/help line fine horizontal scrolling --- rev 20220205 -------------------------------------------------------

sub scrollstatus(amount)

lpoke statusline_ptr, peek(addr(statusline$(0))+(0+amount/8) mod sl)+$71710000
lpoke statusline_ptr+4,peek(addr(statusline$(0))+(1+amount/8) mod sl)+$71710000
lpoke statusline_ptr+4*112, peek(addr(statusline$(112))+(112+amount/8) mod (0))+$71710000
lpoke dlcopy_ptr+4*729, %0000_0000_0000_0000_0000_0000_0101_0011 + (((amount mod 8)+8) shl 8) 
for i=2 to 111 : lpoke statusline_ptr+4*i, peek(addr(statusline$(0))+(i+(amount/8)) mod sl)+$77710000: next i
end sub

'------------------ A display list vertical scrolling of file info screen  --- rev 20220205 --------------------------------------------

sub movedl

for i=0 to 14 
  for j=0 to 15  
     lpoke dlcopy_ptr+4*(200+32*i+2*j+0), ((infobuf_ptr+560+112*((i+((framenum+j) /16)) mod (c+2)))  shl 14)+ %0000_0001_1100_1111+(0 shl 4) + ((j+framenum) mod 16) shl 12
   next j
next i

end sub  

'----------------- Prepare a custom displaylist for the player --- rev 20220205 ---------------------------------------------------------

sub makedl

' Make colors 0 and 15 blue-green for the graphics part of the screen

dltest=v.dl_ptr
palettetest=v.palette_ptr
lpoke palettetest,lpeek(palettetest+161*4)
lpoke palettetest+15*4,lpeek(palettetest+168*4)

' Prepare the title

address=addr(version$(0))
for i=0 to 27: lpoke title_ptr+4*i,$77710000 : next i
start=(28-len(version$)) / 2
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
address2=infobuf_ptr

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
lpoke dlcopy_ptr+4*722, graphicbuf_ptr shl 12 +%00_0000_0000_1010  ' graphic line with 4bpp

' 6 empty lines under the graphic lines. 2 lines before status/help line enable the horizontal fine scroll

lpoke dlcopy_ptr+4*728, %0000_0000_0000_0000_0001_0000_0101_0011

' scrolling help line, using repeat 

lpoke dlcopy_ptr+4*730, %0000_0001_0000_1111_0000_0000_0000_0111          ' repeat 16
lpoke dlcopy_ptr+4*731, (statusline_ptr+4) shl 12+ %00_0000_0000_0001     ' text line

lpoke dlcopy_ptr+4*732, %0000_0000_0000_0000_0001_0000_0101_0011          ' reset horizontal scroll to 0

' the rest of DL are zero
' Now tell the driver wheere is a new DL

v.dl_ptr=dlcopy_ptr 
end sub

'---------------------------------- THE END OF THE CODE ----------------------------------------------------------------

' Semigraphic characters codes
' 3 hline 4 vline 5 T 6 up T 7 -| 8 |- 9rup 10 lup 11 rdown 12 ldown 13 cross
