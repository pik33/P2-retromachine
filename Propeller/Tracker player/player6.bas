#include "retromachine.bi"

dim dlcopy(1200) as ulong
dim title(28) as ulong
dim statusline(114) as ulong  '112 visible chars + 2 chars for scrolling
dim oldtrigs(4) as ulong
dim pan(4)
dim sn$(32)
dim infobuf(26*34) as ulong       ' scrollable file info, 34 lines of text
dim graphicbuf(448*64) as ulong   ' 64 lines of 4bpp graphics
dim mainbuf(86*21) as ulong       ' main text field, 86 charx21 lines
startmachine
startvideo
startaudio

statusline$=" Propeler2 wav/sid/mod player v. 0.06 --- 2022.02.01 --- pik33@o2.pl --- use serial terminal or RPi KBM interface to control --- arrows up,down move - pgup,pgdn move 10 positions - enter selects - tab switches panels --- "
emptystr$="                      "
framenum=0
for i=0 to 3 : oldtrigs(i)=0 : next i
pan(0)=8192+1024 : pan(1)=8192-1024 : pan(2)=8192-2048 : pan(3)=8192+2048
mainvolume=127 '1..128..(255)

makedl
cls
c113=v030.getpalettecolor(113)
v030.setbordercolor2(c113)

ma=addr(module)
tracker.initmodule(ma,0)

position 1,1 :for i=ma to ma+19 : print chr$(peek(i)); : next i
samples=15: if peek(ma+1080)=asc("M") and peek(ma+1082)=asc("K") then samples=31
position 1,2 : print samples;" ";"samples module"
getinfo(ma,samples)

' ------------------ main loop ------------------------

do
  waitvbl
  tracker.tick
  framenum+=1
  for i=0 to 3 :setchannel(i,oldtrigs(i)) : next i
  displaysamples
  scrollstatus((framenum) mod (8*220))
loop

' ---------------- end of program -------------------------------------------

sub scrollstatus(amount)

statusline(0)=peek(addr(statusline$(0))+(0+amount/8) mod 220)+$71710000
statusline(1)=peek(addr(statusline$(0))+(1+amount/8) mod 220)+$71710000
statusline(112)=peek(addr(statusline$(112))+(112+amount/8) mod 220)+$71710000

dlcopy(727)=%0000_0000_0000_0000_0000_0000_0101_0011 + (((amount mod 8)+8) shl 8) 

for i=2 to 111 : statusline(i)=peek(addr(statusline$(0))+(i+(amount/8)) mod 220)+$77710000: next i
end sub


' ---------------- Set channel registers with tracker data -------------------

sub setchannel(channel,byref trigger as ulong)

if tracker.trigger(channel)<>trigger then 
  trigger=tracker.trigger(channel)
  lpoke base+8+32*channel,tracker.currSamplePtr(channel) or $40000000                                
  lpoke base+12+32*channel,tracker.currsamplelength(channel)-tracker.currrepeatLength(channel)
  lpoke base+16+32*channel,tracker.currsamplelength(channel)
endif
dpoke base+20+32*channel, (tracker.currVolume(channel)+tracker.deltavolume(channel))*mainvolume
dpoke base+22+32*channel, pan(channel)
dpoke base+24+32*channel, tracker.currPeriod(channel)+tracker.deltaperiod(channel)
dpoke base+26+32*channel, 1
end sub

'---------------- Display current samples and periods ----------------------------

sub displaysamples 

position 5,19:   v030.write(sn$(tracker.currsamplenr(0))) : v030.write(emptystr$)
position 1,19 :  v030.write(v030.inttostr2(tracker.currperiod(0)+tracker.deltaperiod(0),3))
position 32,19:  v030.write(sn$(tracker.currsamplenr(1))) : v030.write(emptystr$)
position 28,19 : v030.write(v030.inttostr2(tracker.currperiod(1)+tracker.deltaperiod(1),3))
position 60,19:  v030.write(sn$(tracker.currsamplenr(2))) : v030.write(emptystr$)
position 56,19 : v030.write(v030.inttostr2(tracker.currperiod(2)+tracker.deltaperiod(2),3))
position 84,19 : v030.write(v030.inttostr2(tracker.currperiod(3)+tracker.deltaperiod(3),3))
position 88,19:  v030.write(emptystr$) : position 88,23: v030.write(sn$(tracker.currsamplenr(3)))
end sub

'---------------- Get and display module information --------------------------

sub getinfo(ma,num)

'position 1,4: print "Name                   len   ft vol rep   r.len         Name                   len   ft vol rep   r.len "
for i=0 to 31: sn$(i)="S"+decuns$(i,2)+space$(19) :next i
for i=1 to num
  for j=0 to 21
    a=lpeek(addr(sn$(i)))
    b=(peek(ma+20+30*(i-1)+j))
    if b>=32 then poke a+j,b
  next j
'  sl=2*(256*peek(ma+20+30*(i-1)+22)+ peek(ma+20+30*(i-1)+23))  
'  rp=2*(256*peek(ma+20+30*(i-1)+26)+ peek(ma+20+30*(i-1)+27))  
'  rl=2*(256*peek(ma+20+30*(i-1)+28)+ peek(ma+20+30*(i-1)+29))  
'  ft=peek(ma+20+30*(i-1)+24)
'  vl=peek(ma+20+30*(i-1)+25)
'  if i<16 then position 1,5+i :print sn$(i) : position 24,5+i : print sl :position 31,5+i : print ft :position 34,5+i : print vl : position 37,5+i :print rp : position 43,5+i :print rl
'  if i>=16 then position 57,i-11 :print sn$(i) : position 80,i-11 : print sl : position 87,i-11 : print ft: position 90,i-11 : print vl :position 93,i-11 : print rp : position 99,i-11 : print rl
next i
'print
end sub

'------------------ A playground for displaylist effects -------------------------

sub movedl

olddl=dlcopy(61) ' and %1111_1111_1111_1111_1111_0000_0000_1111) +  (((framenum / 2) mod 56) shl 4)
for i=0 to 476 step 2
  dlcopy(61+i)=dlcopy(61+i+2)' and %1111_1111_1111_1111_1111_0000_0000_1111) + (((framenum / 2) mod 56) shl 4)
next i
dlcopy(61+478)=olddl
end sub  

'----------------- Prepare a custom displaylist for the player

sub makedl

dltest=v030.dl_ptr
palettetest=v030.palette_ptr

' Prepare the title

for i=0 to 28: title(i)=$77710000 : next i
title(6)=title(6)+asc("P")
title(7)=title(7)+asc("r")
title(8)=title(8)+asc("o")
title(9)=title(9)+asc("p")
title(10)=title(10)+asc("2")
title(11)=title(11)+asc("p")
title(12)=title(12)+asc("l")
title(13)=title(13)+asc("a")
title(14)=title(14)+asc("y")
title(16)=title(16)+asc("v")
title(17)=title(17)+asc(".")
title(18)=title(18)+asc("0")
title(19)=title(19)+asc(".")
title(20)=title(20)+asc("0")
title(21)=title(21)+asc("6")

for i=0 to 111 : statusline(i)=peek(addr(statusline$(0))+i-2)+$710000+ i shl 24: next i
statusline(2)=(statusline(2) and $FFFF) + $71710000

'4
'32     36
'6      42
'336   378  714
'6     384  720
'128   512  722 'rep
'6     518  728
'16    534  744
'6     540  750



' 4 lines of upper border

for i=0 to 3 : dlcopy(i)=0: next i

' 32 lines of big text title logo. Tell the driver via DL that it should display the text from "title" table

for i=0 to 15
  for j=0 to 1
    dlcopy(4+2*i+j)=((addr(title(0))) shl 12)+%10_0000_0000_00_01+(i shl 8)
  next j
next i  

' 6 empty lines under the logo

for i=36 to 42: dlcopy(i)=0 : next i

' 21 text lines with split screen 

address=$76600
for i=0 to 20
  for j=0 to 15
     dlcopy(40+32*i+2*j+0)=(address shl 14)+ %0000_0000_0000_1111+(0 shl 4) + j shl 12
     dlcopy(40+32*i+2*j+1)=(address shl 12)+ (j shl 8) + (i shl 2) + 1
  next j
  address=address+448
next i
for i=714 to 719 : dlcopy(i)=0 : next i
dlcopy(720)=%0000_1000_0000_0001_0001_1100_0000_0111  ' repeat 128, every second line add 448
address=addr(graphicbuf)
dlcopy(721)=address shl 12 +%00_0000_0000_1010

for i=722 to 726 : dlcopy(i)=0 : next i
dlcopy(727)=%0000_0000_0000_0000_0001_0000_0101_0011
dlcopy(728)=0
address=addr(statusline)+4
dlcopy(729)=%0000_0001_0000_1111_0000_0000_0000_0111  ' repeat 16
dlcopy(730)=address shl 12+ %00_0000_0000_0001         ' text line
for i=731 to 734: dlcopy(i)=0 : next i
dlcopy(0)=%0000_0000_0000_0000_0001_0000_0101_0011
dlcopy(736)=0 : dlcopy(737)=0
v030.dl_ptr=addr(dlcopy) 
v030.buf_ptr=$76600
v030.s_buf_ptr=$76600
end sub

'--- module

asm shared
module file "/home/pik33/mod/ballada.mod"
end asm


/'
mount "/sd", _vfs_open_sdcard()

chdir ("/sd/mod")
filename$=dir$("*",0)
while filename$ <> "" and filename$ <> nil
  print filename$
  waitms(10)
  filename$ = dir$()      ' continue scan
end while
'/

'3 hline 4 vline 5 T 6 up T 7 -| 8 |- 9rup 10 lup 11 rdown 12 ldown 13 cross
' dl:
' A standard display list entry:

' - display the character mode line: %aaaa_aaaa_aaaa_aaaa_aazz_nnnn_llll_ll_01 
'    aaaa_aaaa_aaaa_aaaa_aa00 - address of the display data, aligned to long
'    zz - zoom (horizontal, vertical zoom is done by repeating the same line) 00-1x, 01 - 2x, 10 - 4x, 11 - blank line 
'    nnnn - font line # 
'    llllll - character line #. This is used to place a "hardware" blinking text cursor.
 
' - display the graphics line: aaaa_aaaa_aaaa_aaaa_aazz_rrrr_rrrr_cc_10
'    aaaa_aaaa_aaaa_aaaa_aa00 - address of the display data, aligned to long
'    zz - zoom (horizontal, vertical zoom is done by repeating the same line)
'    r - reserved, now unused bits
'    cc - color depth, 1/2/4/8 bpp

' - extended entry:

'' - repeat                 %nnnn_nnnn_nnnn_qqqq_mmmm_mmmm_mmmm_0111    repeat the next dl line n times, after q lines add offset m (works)
'' TODO, planned:
'' - reload palette         %mmmm_mmmm_nnnn_nnnn_qqqq_qqqq_qqqq_1011    reload n palette entries from m color from palette_ptr+q
'' - set border color       %rrrr_rrrr_gggg_gggg_bbbb_bbbb_0001_0011    set border to rgb
'' - set border color       %0000_0000_0000_0000_pppp_pppp_0001_1011    set border color to palette entry #p
'' - set fine hscroll       %0000_0000_0000_0000_000s_pppp_0001_1111    set the horizontal fine scroll, +- 15 px, I don't know if doable at all 

' Only repeat implemented now (as in v0.31)
