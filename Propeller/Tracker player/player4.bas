#include "retromachine.bi"

startmachine
startvideo

dim dlcopy(1200) as ulong
dim title(28) as ulong
framenum=0

makedl


'' new displaylist
' 4 lines border, 32 lines title, 4 lines border = 40
' 43 lines of fnt8 =344 ' 384
' down: 4 lines border, 16 lines status/help, 4 border, 128 lines scope, 4 border = 156






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
cls
c113=v030.getpalettecolor(113)
v030.setbordercolor2(c113)

mainvolume=127 '1..128..(255)

  SF_CS  = 61  '{ O }                                            ' serial flash
  SF_SCK = 60  '{ O }
  SF_SDO = 59  '{ O }
  SF_SDI = 58  '{ I }
  RD_DATA      = $03


dim sn$(32)
dim cog,base as ulong

emptystr$="                      "
ss$=""
for i=1 to 31 : ss$=ss$+chr$(i) :next i


ma=addr(module)
tracker.initmodule(ma,0)

position 1,1 :for i=ma to ma+19 : print chr$(peek(i)); : next i
samples=15: if peek(ma+1080)=asc("M") and peek(ma+1082)=asc("K") then samples=31
position 1,2 : print samples;" ";"samples module"
getinfo(ma,samples)

cog,base=paula.start()

old1=0 : old2=0 :old3=0 : old4=0

max=0

'position 0,26 : v030.writeln(ss$)
'print"123456789012345678901234567890"
do
'channel+0  long current spl pointer 
'channel+4  long sample
'channel+8  long sample start - bit31=1 when 16 bit spl
'channel+12 long loop start
'channel+16 long loop end
'channel+20 word volume
'channel+22 word pan
'channel+24 word synthfreq
'channel+26 word skip
'channel+28 long reserved

    waitvbl
    tracker.tick
    framenum+=1

    if tracker.trigger(0)<>old1 then 
      old1=tracker.trigger(0)
      lpoke base+8,tracker.currSamplePtr(0) or $40000000
      lpoke base+12,tracker.currsamplelength(0)-tracker.currrepeatLength(0)
      lpoke base+16,tracker.currsamplelength(0)
    endif
    dpoke base+20, (tracker.currVolume(0)+tracker.deltavolume(0))*mainvolume
    dpoke base+22, 8192-2048
    dpoke base+24, tracker.currPeriod(0)+tracker.deltaperiod(0)
    dpoke base+26, 1

 
    if tracker.trigger(1) <> old2  then
 '         lpoke base+32,0
      old2=tracker.trigger(1)
      lpoke base+8+32,tracker.currSamplePtr(1) or $40000000
      lpoke 32+base+12,tracker.currsamplelength(1)-tracker.currrepeatLength(1)
      lpoke 32+base+16,tracker.currsamplelength(1)

 
      endif
      
    dpoke 32+base+20, (tracker.currVolume(1)+tracker.deltavolume(1))*mainvolume
    dpoke 32+base+22, 8192+1024
                                                                                          dpoke 32+base+24, tracker.currPeriod(1)+tracker.deltaperiod(1)
    dpoke 32+base+26, 1

   if tracker.trigger(2) <> old3  then
 '   lpoke base+64,0 
     old3=tracker.trigger(2)
   
    lpoke base+8+64,tracker.currSamplePtr(2) or $40000000
    lpoke 64+base+12,tracker.currsamplelength(2)-tracker.currrepeatLength(2)
    lpoke 64+base+16,tracker.currsamplelength(2)
    endif
    
    dpoke 64+base+20, (tracker.currVolume(2)+tracker.deltavolume(2))*mainvolume
    dpoke 64+base+22, 8192+2048
                                                                                      dpoke 64+base+24, tracker.currPeriod(2)+tracker.deltaperiod(2)
    dpoke 64+base+26, 1

    if tracker.trigger(3) <> old4 then
  '   lpoke base+96,0
    old4=tracker.trigger(3)
    lpoke base+8+96,tracker.currSamplePtr(3) or $40000000
   
    lpoke 96+base+12,tracker.currsamplelength(3)-tracker.currrepeatLength(3)
    lpoke 96+base+16,tracker.currsamplelength(3)
    endif
    dpoke 96+base+20, (tracker.currVolume(3)+tracker.deltavolume(3))*mainvolume
    dpoke 96+base+22, 8192-1024
                                                                                         dpoke 96+base+24, tracker.currPeriod(3)+tracker.deltaperiod(3)
    dpoke 96+base+26, 1

 '   if tracker.trigger(3) <> old4 then lpoke base+8+96,  tracker.currSamplePtr(3) or $40000000 :old4=tracker.trigger(3)
 '   if tracker.trigger(0) <> old1 then lpoke base+8,  tracker.currSamplePtr(0)or $40000000 :  old1=tracker.trigger(0)
 '  if tracker.trigger(1) <> old2 then lpoke base+8+32, tracker.currSamplePtr(1) or $40000000 :  old2=tracker.trigger(1)
 '  if tracker.trigger(2) <> old3 then lpoke base+8+64,  tracker.currSamplePtr(2) or $40000000 :  old3=tracker.trigger(2)

  '  e=0
   
    test

loop

'0 - samplestart   - a pointer to the sample start
'1 - sampletype    - 0: 16 bit, 1 8 bit, both signed
'2 - loopstart     - loop start
'3 - loopend       - loop end, has to be >=loopstart+2
'4 - volume        - sample volume, 16384=1
'5 - pan           - 0..16384
'6 - synthfreq     - the frequency divider for the channel. The channel sample rate will be 3546895 or 3579545 Hz divided by this
'7 - skip          - value to add to the phase accumulator for the next sample, 1 for 8 bit, 2 for 16 bit, more for special purposes
'8 - cmd 


sub test 
'movedl

    position 5,23:   v030.write(sn$(tracker.currsamplenr(0))) : v030.write(emptystr$)
    position 1,23 :  v030.write(v030.inttostr2(tracker.currperiod(0)+tracker.deltaperiod(0),3))
    position 32,23:  v030.write(sn$(tracker.currsamplenr(1))) : v030.write(emptystr$)
    position 28,23 : v030.write(v030.inttostr2(tracker.currperiod(1)+tracker.deltaperiod(1),3))
    position 60,23:  v030.write(sn$(tracker.currsamplenr(2))) : v030.write(emptystr$)
    position 56,23 : v030.write(v030.inttostr2(tracker.currperiod(2)+tracker.deltaperiod(2),3))
    position 84,23 : v030.write(v030.inttostr2(tracker.currperiod(3)+tracker.deltaperiod(3),3))
    position 88,23:  v030.write(emptystr$) : position 88,23: v030.write(sn$(tracker.currsamplenr(3)))

    

 
end sub


sub getinfo(ma,num)
'v030. setwritecolors(170,147):
position 1,4: print "Name                   len   ft vol rep   r.len         Name                   len   ft vol rep   r.len "
': v030. setwritecolors(154,147)
for i=0 to 31: sn$(i)="S"+decuns$(i,2)+space$(19) :next i
for i=1 to num
  for j=0 to 21
    a=lpeek(addr(sn$(i)))
    b=(peek(ma+20+30*(i-1)+j))
    if b>=32 then poke a+j,b

  next j
sl=2*(256*peek(ma+20+30*(i-1)+22)+ peek(ma+20+30*(i-1)+23))  
rp=2*(256*peek(ma+20+30*(i-1)+26)+ peek(ma+20+30*(i-1)+27))  
rl=2*(256*peek(ma+20+30*(i-1)+28)+ peek(ma+20+30*(i-1)+29))  
ft=peek(ma+20+30*(i-1)+24)
vl=peek(ma+20+30*(i-1)+25)
if i<16 then position 1,5+i :print sn$(i) : position 24,5+i : print sl :position 31,5+i : print ft :position 34,5+i : print vl : position 37,5+i :print rp : position 43,5+i :print rl
if i>=16 then position 57,i-11 :print sn$(i) : position 80,i-11 : print sl : position 87,i-11 : print ft: position 90,i-11 : print vl :position 93,i-11 : print rp : position 99,i-11 : print rl
next i
print
 

'  if sampleNumber == 0 or sampleNumber > LAST_SAMPLE_NUMBER ' Can't go beyond sample 31
'    long[samplePtr] := 0
'    return

'  sampleNumber--
'  sampleInfoPtr      := samplesInfoLut + (sampleNumber * 30)
'  long[sampleLength] := ((byte[sampleInfoPtr + 22] << 8) | byte[sampleInfoPtr + 23]) << 1
'  long[fTune]        :=   byte[sampleInfoPtr + 24]
'  long[volume]       :=   byte[sampleInfoPtr + 25]
'  long[repeatPoint]  := ((byte[sampleInfoPtr + 26] << 8) | byte[sampleInfoPtr + 27]) << 1
'  long[repeatLength] := ((byte[sampleInfoPtr + 28] << 8) | byte[sampleInfoPtr + 29]) << 1
'  long[samplePtr]    := samplesPtrLut[sampleNumber]

 ' if long[repeatLength] == 2 && long[repeatPoint] == 0
 '   long[repeatLength] := 1

end sub

sub movedl


olddl=dlcopy(61) ' and %1111_1111_1111_1111_1111_0000_0000_1111) +  (((framenum / 2) mod 56) shl 4)

for i=0 to 476 step 2
  dlcopy(61+i)=dlcopy(61+i+2)' and %1111_1111_1111_1111_1111_0000_0000_1111) + (((framenum / 2) mod 56) shl 4)
next i
dlcopy(61+478)=olddl
end sub  





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
title(21)=title(21)+asc("1")
' 22 lines of upper border

for i=0 to 21 : dlcopy(i)=0: next i

dlcopy(21)=%1111_1111_1111_1111

dlcopy(22)= %0000_0000_0000_0000_0000_0100_0011_0011   ' set font height to 16, default font (=ST mono)

' 32 lines of big text titlle logo. Tell the driver via DL that it should display the text from "title" table

'%nnnn_nnnn_nnnn_qqqq_mmmm_mmmm_mmmm_0111 

for i=0 to 15
  for j=0 to 1
    dlcopy(23+2*i+j)=((addr(title(0))) shl 12)+%10_0000_0000_00_01+(i shl 8)
  next j
next i  

'dlcopy(55)=  %0000_0000_0000_0000_0000_0011_0011_0011      'set font height to 8
'dlcopy(56)= v030.getfontaddr(3) shl 12+%0000_0100_0011     'set font pointer to atari8 8x8 font

' 4 empty lines under the logo
'' dlcopy(57)=((addr(title(0))) shl 14) +%0000_0000_1100_1111
for i=55 to 58 : dlcopy(i)= dlcopy(0) : next i 

' Now make 22 text lines starting at 79e00

address=$76600
for i=0 to 24
  for j=0 to 15
     dlcopy(59+32*i+2*j+0)=(address shl 14)+ %0000_0000_0000_1111+(0 shl 4) + j shl 12
     dlcopy(59+32*i+2*j+1)=(address shl 12)+ (j shl 8) + (i shl 2) + 1
  next j
  address=address+448
next i

for i=827 to 1199 : dlcopy(i)=0 : next i
v030.dl_ptr=addr(dlcopy) 
v030.buf_ptr=$76600

end sub

asm shared
module file "/home/pik33/mod/cdtv2.mod"

end asm



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
