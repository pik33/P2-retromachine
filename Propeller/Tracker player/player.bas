#include "retromachine.bi"

startvideo
rm.start
cls

dim tracker as class using "trackerplayer.spin2"
dim paula as class using "audio010.spin2"

'tracker.init(clkfreq,44000,1,256,256)
tracker.initmodule(@module,0)
waitms(500)

paula.start

old1=0 : old2=0 :old3=0 : old4=0
do

    waitvbl
    tracker.tick
    
	paula.channel1(0)=tracker.currSamplePtr(0)
	paula.channel1(1)=1
	paula.channel1(2)=tracker.currsamplelength(0)-tracker.currrepeatLength(0)
	paula.channel1(3)=tracker.currsamplelength(0)
	paula.channel1(4)=(tracker.currVolume(0)+tracker.deltavolume(0))*128
	paula.channel1(5)=0
	paula.channel1(6)=tracker.currPeriod(0)+tracker.deltaperiod(0)
	paula.channel1(7)=1
    if tracker.trigger(0) <> old1 then paula.channel1(8)=0 :waitus(10) : paula.channel1(8)=1 :old1=tracker.trigger(0)

    old12=paula.channel2(0)
	paula.channel2(0)=tracker.currSamplePtr(1)
	paula.channel2(1)=1
	paula.channel2(2)=tracker.currSampleLength(1)-tracker.currrepeatLength(1)
	paula.channel2(3)=tracker.currSampleLength(1)
	paula.channel2(4)=(tracker.currVolume(1)+tracker.deltavolume(1))*128
	paula.channel2(5)=16384
	paula.channel2(6)=tracker.currPeriod(1)+tracker.deltaperiod(1)
	paula.channel2(7)=1
    if tracker.trigger(1) <> old2 then paula.channel2(8)=0 :waitus(10) : paula.channel2(8)=1 :old2=tracker.trigger(1)

    old13=paula.channel3(0)
	paula.channel3(0)=tracker.currSamplePtr(2)
	paula.channel3(1)=1
	paula.channel3(2)=tracker.currSampleLength(2)-tracker.currrepeatLength(2)
	paula.channel3(3)=tracker.currSampleLength(2)
	paula.channel3(4)=(tracker.currVolume(2)+tracker.deltavolume(2))*128
	paula.channel3(5)=16384
	paula.channel3(6)=tracker.currPeriod(2)+tracker.deltaperiod(2)
	paula.channel3(7)=1
    if tracker.trigger(2) <> old3 then paula.channel3(8)=0 :waitus(10) : paula.channel3(8)=1 :old3=tracker.trigger(02)

    old14=paula.channel4(0)    
	paula.channel4(0)=tracker.currSamplePtr(3)
	paula.channel4(1)=1
	paula.channel4(2)=tracker.currSampleLength(3)-tracker.currrepeatLength(3)
	paula.channel4(3)=tracker.currSampleLength(3)
	paula.channel4(4)=(tracker.currVolume(3)+tracker.deltavolume(3))*128
	paula.channel4(5)=0
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

'    kk=getcnt()
    v030.setcursorpos(1,1)
    v030.write(v030.inttostr2(tracker.currsamplenr(0),2))
    
    v030.setcursorpos(4,1)
    v030.write(v030.inttostr2(tracker.currperiod(0)+tracker.deltaperiod(0),3))
    v030.setcursorpos(11,1)
    v030.write(v030.inttostr2(tracker.currsamplenr(1),2))
    
    v030.setcursorpos(14,1)
    v030.write(v030.inttostr2(tracker.currperiod(1)+tracker.deltaperiod(1),3))
    
    v030.setcursorpos(21,1)
    v030.write(v030.inttostr2(tracker.currsamplenr(2),2))
    
   
    v030.setcursorpos(24,1)
    min=tracker.currperiod(2)+tracker.deltaperiod(2)
    v030.write(v030.inttostr2(min,3))
    
    v030.setcursorpos(31,1)
    v030.write(v030.inttostr2(tracker.currsamplenr(3),2))
    
    v030.setcursorpos(34,1)
    v030.write(v030.inttostr2(tracker.currperiod(3)+tracker.deltaperiod(3),3))
    v030.setcursorpos(41,1)
    v030.write(v030.inttohex(lpeek($80),8))
'    kk=getcnt()-kk
    
'    v030.setcursorpos(41,1)
      
'    v030.write(v030.inttostr(kk/320))
end sub

asm shared
module file "../../../mod/aniasong.mod"
end asm
