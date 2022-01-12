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
dim paula as class using "audio016.spin2"

dim sn$(32)

emptystr$="                      "

ma=addr(module)
tracker.initmodule(ma,0)

position 1,1 :for i=ma to ma+19 : print chr$(peek(i)); : next i
samples=15: if peek(ma+1080)=asc("M") and peek(ma+1082)=asc("K") then samples=31
position 1,2 : print samples;" ";"samples module"
getinfo(ma,samples)

paula.start

old1=0 : old2=0 :old3=0 : old4=0

do

    waitvbl
    tracker.tick
    
	paula.channel1(0)=tracker.currSamplePtr(0)
	paula.channel1(1)=1
	paula.channel1(2)=tracker.currsamplelength(0)-tracker.currrepeatLength(0)
	paula.channel1(3)=tracker.currsamplelength(0)
	paula.channel1(4)=(tracker.currVolume(0)+tracker.deltavolume(0))*mainvolume
	paula.channel1(5)=8192-2048
	paula.channel1(6)=tracker.currPeriod(0)+tracker.deltaperiod(0)
	paula.channel1(7)=1


    old12=paula.channel2(0)
	paula.channel2(0)=tracker.currSamplePtr(1)
	paula.channel2(1)=1
	paula.channel2(2)=tracker.currSampleLength(1)-tracker.currrepeatLength(1)
	paula.channel2(3)=tracker.currSampleLength(1)
	paula.channel2(4)=(tracker.currVolume(1)+tracker.deltavolume(1))*mainvolume
	paula.channel2(5)=8192+2048
	paula.channel2(6)=tracker.currPeriod(1)+tracker.deltaperiod(1)
	paula.channel2(7)=1


    old13=paula.channel3(0)
	paula.channel3(0)=tracker.currSamplePtr(2)
	paula.channel3(1)=1
	paula.channel3(2)=tracker.currSampleLength(2)-tracker.currrepeatLength(2)
	paula.channel3(3)=tracker.currSampleLength(2)
	paula.channel3(4)=(tracker.currVolume(2)+tracker.deltavolume(2))*mainvolume
	paula.channel3(5)=8192+2048
	paula.channel3(6)=tracker.currPeriod(2)+tracker.deltaperiod(2)
	paula.channel3(7)=1


    old14=paula.channel4(0)    
	paula.channel4(0)=tracker.currSamplePtr(3)
	paula.channel4(1)=1
	paula.channel4(2)=tracker.currSampleLength(3)-tracker.currrepeatLength(3)
	paula.channel4(3)=tracker.currSampleLength(3)
	paula.channel4(4)=(tracker.currVolume(3)+tracker.deltavolume(3))*mainvolume
	paula.channel4(5)=8192-2048
	paula.channel4(6)=tracker.currPeriod(3)+tracker.deltaperiod(3)
	paula.channel4(7)=1

 
    if tracker.trigger(0) <> old1 then paula.channel1(8)=0 : old1=tracker.trigger(0)
    if tracker.trigger(1) <> old2 then paula.channel2(8)=0 : old2=tracker.trigger(1)  
    if tracker.trigger(2) <> old3 then paula.channel3(8)=0 : old3=tracker.trigger(2)  
    if tracker.trigger(3) <> old4 then paula.channel4(8)=0 : old4=tracker.trigger(3) 
    
    waitus 300 
       
    paula.channel1(8)=$FFFFFFFF 
    paula.channel2(8)=$FFFFFFFF 
    paula.channel3(8)=$FFFFFFFF 
    paula.channel4(8)=$FFFFFFFF 
 
    
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
module file "../../../mod/atlantis.mod"

end asm
