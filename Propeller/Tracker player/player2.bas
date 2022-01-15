#include "retromachine.bi"

startmachine
startvideo

cls
mainvolume=128 '1..128..(255)

  SF_CS  = 61  '{ O }                                            ' serial flash
  SF_SCK = 60  '{ O }
  SF_SDO = 59  '{ O }
  SF_SDI = 58  '{ I }
  RD_DATA      = $03

dim tracker as class using "trackerplayer.spin2"
dim paula as class using "audio018.spin2"

dim sn$(32)
dim cog,base as ulong

emptystr$="                      "

ma=addr(module)
tracker.initmodule(ma,0)

position 1,1 :for i=ma to ma+19 : print chr$(peek(i)); : next i
samples=15: if peek(ma+1080)=asc("M") and peek(ma+1082)=asc("K") then samples=31
position 1,2 : print samples;" ";"samples module"
getinfo(ma,samples)

cog,base=paula.start()

old1=0 : old2=0 :old3=0 : old4=0

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
     
    if tracker.trigger(0)<>old1 then 
 '        lpoke base,0
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
    dpoke 32+base+22, 8192+2048
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
    dpoke 96+base+22, 8192-2048
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

 '   kk=getcnt()
    position 5,29:   v030.write(sn$(tracker.currsamplenr(0))) : v030.write(emptystr$)
    position 1,29 :  v030.write(v030.inttostr2(tracker.currperiod(0)+tracker.deltaperiod(0),3))
    position 32,29:  v030.write(sn$(tracker.currsamplenr(1))) : v030.write(emptystr$)
    position 28,29 : v030.write(v030.inttostr2(tracker.currperiod(1)+tracker.deltaperiod(1),3))
    position 60,29:  v030.write(sn$(tracker.currsamplenr(2))) : v030.write(emptystr$)
    position 56,29 : v030.write(v030.inttostr2(tracker.currperiod(2)+tracker.deltaperiod(2),3))
    position 84,29 : v030.write(v030.inttostr2(tracker.currperiod(3)+tracker.deltaperiod(3),3))
    position 88,29:  v030.write(sn$(tracker.currsamplenr(3))) : v030.write(emptystr$)
'    position 90,1: v030.write("Counter: ") : v030.write(v030.inttohex(lpeek($80),8))
'    kk=getcnt()-kk
    
 '   position 51,30: v030.write(v030.inttostr(kk/320))  
      
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


asm shared
module file "../../../mod/amegas.mod"

end asm
