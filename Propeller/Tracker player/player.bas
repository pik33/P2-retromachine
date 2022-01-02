#include "retromachine.bi"

startvideo
rm.start
'cls

dim tracker as class using "trackerplayer.spin2"
dim paula as class using "audio008.spin2"

tracker.init(clkfreq,44000,1,256,256)
tracker.initmodule(@module,0)
waitms(500)

paula.start
old1=0 : old2=0 :old3=0 : old4=0
old11=0 : old12=0 :old13=0 : old14=0
do
  v030.waitvbl(1)
  tracker.tick
   

 '   print tracker.currSamplePtr(0);" ";tracker.currSampleLength(0);" ";tracker.currRepeatPoint(0);" ";tracker.currrepeatLength(0); " - ";
 '   print tracker.currSamplePtr(1);" ";tracker.currSampleLength(1);" ";tracker.currRepeatPoint(1);" ";tracker.currrepeatLength(1); " - ";
  '  print tracker.currSamplePtr(2);" ";tracker.currSampleLength(2);" ";tracker.currRepeatPoint(2);" ";tracker.currrepeatLength(2); " - ";
 '   print tracker.currSamplePtr(3);" ";tracker.currSampleLength(3);" ";tracker.currRepeatPoint(3);" ";tracker.currrepeatLength(3)

    
    old11=paula.channel1(0)
	paula.channel1(0)=tracker.currSamplePtr(0)
	paula.channel1(1)=1
	paula.channel1(2)=tracker.currsamplelength(0)-tracker.currrepeatLength(0)
	paula.channel1(3)=tracker.currsamplelength(0)
	paula.channel1(4)=tracker.currVolume(0)*128
	paula.channel1(5)=4096+2048
	paula.channel1(6)=tracker.currPeriod(0)
	paula.channel1(7)=1
'     if paula.channel1(0) <> old11 then paula.channel1(8)=0 :waitus(100) : paula.channel1(8)=1
      if tracker.trigger(0) <> old1 then paula.channel1(8)=0 :waitus(100) : paula.channel1(8)=1 :old1=tracker.trigger(0)

    old12=paula.channel2(0)
	paula.channel2(0)=tracker.currSamplePtr(1)
	paula.channel2(1)=1
	paula.channel2(2)=tracker.currSampleLength(1)-tracker.currrepeatLength(1)
	paula.channel2(3)=tracker.currSampleLength(1)
	paula.channel2(4)=tracker.currVolume(1)*128
	paula.channel2(5)=8192+2048
	paula.channel2(6)=tracker.currPeriod(1)
	paula.channel2(7)=1
 '    if paula.channel2(0) <> old12 then paula.channel2(8)=0 :waitus(100) : paula.channel2(8)=1
     if tracker.trigger(1) <> old2 then paula.channel2(8)=0 :waitus(100) : paula.channel2(8)=1 :old2=tracker.trigger(1)

    old13=paula.channel3(0)
	paula.channel3(0)=tracker.currSamplePtr(2)
	paula.channel3(1)=1
	paula.channel3(2)=tracker.currSampleLength(2)-tracker.currrepeatLength(2)
	paula.channel3(3)=tracker.currSampleLength(2)
	paula.channel3(4)=tracker.currVolume(2)*128
	paula.channel3(5)=8192+2048
	paula.channel3(6)=tracker.currPeriod(2)
	paula.channel3(7)=1
 '    if paula.channel3(0) <> old13 then paula.channel3(8)=0 :waitus(100) : paula.channel3	(8)=1
    if tracker.trigger(2) <> old3 then paula.channel3(8)=0 :waitus(100) : paula.channel3(8)=1 :old3=tracker.trigger(02)

    old14=paula.channel4(0)    
	paula.channel4(0)=tracker.currSamplePtr(3)
	paula.channel4(1)=1
	paula.channel4(2)=tracker.currSampleLength(3)-tracker.currrepeatLength(3)
	paula.channel4(3)=tracker.currSampleLength(3)
	paula.channel4(4)=tracker.currVolume(3)*128
	paula.channel4(5)=4096+2048
	paula.channel4(6)=tracker.currPeriod(3)
	paula.channel4(7)=1
 '   if paula.channel4(0) <> old14 then paula.channel4(8)=0 :waitus(100) : paula.channel4	(8)=1
    if tracker.trigger(3) <> old4 then paula.channel4(8)=0 :waitus(100) : paula.channel4(8)=1 :old4=tracker.trigger(03)

 

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

asm shared
module file "jamaja.mod"
end asm
