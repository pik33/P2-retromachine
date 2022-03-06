#include "retromachine.bi"
option implicit
startmachine
startvideo
const _clkfreq = 320000000 
cls

dim tracker as class using "trackerplayer.spin2"
dim paula as class using "audio010.spin2"

dim psram as class using "psram4.spin2"

ma=addr(module)
tracker.initmodule(ma,0)
waitms 500
samples=32: if peek(ma+1080)=asc("M") and peek(ma+1082)=asc("K") then samples=16
position 1,1 : print samples;" ";"samples module"

psram.startx(0, 0, 10, -1)
  
psram.write(0, 0, 512*1024) ' fill PSRAM with copy of hub RAM
mbox=psram.getMailbox(0)

paula.start(mbox)


old1=0 : old2=0 :old3=0 : old4=0
do

    waitvbl
    tracker.tick
    
	paula.channel1(0)=tracker.currSamplePtr(0)
	paula.channel1(1)=1
	paula.channel1(2)=tracker.currsamplelength(0)-tracker.currrepeatLength(0)
	paula.channel1(3)=tracker.currsamplelength(0)
	paula.channel1(4)=(tracker.currVolume(0)+tracker.deltavolume(0))*128
	paula.channel1(5)=8192-2048
	paula.channel1(6)=tracker.currPeriod(0)+tracker.deltaperiod(0)
	paula.channel1(7)=1
    if tracker.trigger(0) <> old1 then paula.channel1(8)=0 :waitus(10) : paula.channel1(8)=1 :old1=tracker.trigger(0)

    old12=paula.channel2(0)
	paula.channel2(0)=tracker.currSamplePtr(1)
	paula.channel2(1)=1
	paula.channel2(2)=tracker.currSampleLength(1)-tracker.currrepeatLength(1)
	paula.channel2(3)=tracker.currSampleLength(1)
	paula.channel2(4)=(tracker.currVolume(1)+tracker.deltavolume(1))*128
	paula.channel2(5)=8192+2048
	paula.channel2(6)=tracker.currPeriod(1)+tracker.deltaperiod(1)
	paula.channel2(7)=1
    if tracker.trigger(1) <> old2 then paula.channel2(8)=0 :waitus(10) : paula.channel2(8)=1 :old2=tracker.trigger(1)

    old13=paula.channel3(0)
	paula.channel3(0)=tracker.currSamplePtr(2)
	paula.channel3(1)=1
	paula.channel3(2)=tracker.currSampleLength(2)-tracker.currrepeatLength(2)
	paula.channel3(3)=tracker.currSampleLength(2)
	paula.channel3(4)=(tracker.currVolume(2)+tracker.deltavolume(2))*128
	paula.channel3(5)=8192+2048
	paula.channel3(6)=tracker.currPeriod(2)+tracker.deltaperiod(2)
	paula.channel3(7)=1
    if tracker.trigger(2) <> old3 then paula.channel3(8)=0 :waitus(10) : paula.channel3(8)=1 :old3=tracker.trigger(02)

    old14=paula.channel4(0)    
	paula.channel4(0)=tracker.currSamplePtr(3)
	paula.channel4(1)=1
	paula.channel4(2)=tracker.currSampleLength(3)-tracker.currrepeatLength(3)
	paula.channel4(3)=tracker.currSampleLength(3)
	paula.channel4(4)=(tracker.currVolume(3)+tracker.deltavolume(3))*128
	paula.channel4(5)=8192-2048
	paula.channel4(6)=tracker.currPeriod(3)+tracker.deltaperiod(3)
	paula.channel4(7)=1
    if tracker.trigger(3) <> old4 then paula.channel4(8)=0 :waitus(10) : paula.channel4(8)=1 :old4=tracker.trigger(03)
    
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

    kk=getcnt()
    position 1,3:  v.write(v.inttostr2(tracker.currsamplenr(0),2))
    position 4,3 : v.write(v.inttostr2(tracker.currperiod(0)+tracker.deltaperiod(0),3))
    position 11,3: v.write(v.inttostr2(tracker.currsamplenr(1),2))
    position 14,3: v.write(v.inttostr2(tracker.currperiod(1)+tracker.deltaperiod(1),3))
    position 21,3: v.write(v.inttostr2(tracker.currsamplenr(2),2))
    position 24,3: v.write(v.inttostr2(tracker.currperiod(2)+tracker.deltaperiod(2),3))
    position 31,3: v.write(v.inttostr2(tracker.currsamplenr(3),2))
    position 34,3: v.write(v.inttostr2(tracker.currperiod(3)+tracker.deltaperiod(3),3))
    position 41,3: v.write(v.inttohex(lpeek($80),8))

    kk=getcnt()-kk
    
    position 51,3: v.write(v.inttostr(kk/320))  
      
end sub

asm shared
module file "/home/pik33/mod/jungle.mod"
end asm
