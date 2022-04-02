20220401: 0.92a
Oscilloscope can be switched off and its buffer can be set at the start
PSRAM uses 256-byte cache for every channel, the cache address has to be set at the start 
Getting samples from HUB or PSRAM is settable using command bit #30 individually for each channel

20220314: the new version 0.91 added
8 channel only this time, PSRAM and oscilloscope support

long #7 is now command. Used at the channel #0
 - bit 31 - set sample rate (new sample rate divider for DACs at word #0)
 - bit 30 - 0 - use PSRAM, 1- use HUB

There are several TODOs. The oscilloscope data pointer is hardcoded at scope_ptr=$72238 (640 longs) and this should be (1) switchable (2) configurable via a command
A HUB/PSRAM selector should be set at individual channel level and not global.

---------------
This is a first beta version of Amiga inspired audio driver.
There are 4 files now, maybe this will reduce to one file and a preprocessor definitions
These are 8, 16 and 32 channel versions which work at standard Paula speed (PAL version,3.54 MHz)
There is also fast, 8 channels at 7.09 MHz version

To use:
- start the driver using start()
- for normal Paula operation the clkfreq has to be 354693878 - Paula x 100
- you can manually change "100" constant in the the DACs initialization code to anything not less than 50 for different CPU clocks
- every channel register banks has 8 longs/16 worsd in it:

long #0: the sample phase accumulator: use it as read only although you -can- change this while playing
long #1: the current sample generated, 2 words, right:left
long #2: the sample pointer. Set bit#31 to 1 if the sample is 8 bit, 0 for 16 bit. 
         Set bit #30 to 1 to start playing the sample from the beginning
long #3: sample loop start point
long #4: sample loop end point. 
         If the sample has to no loop and stop at the end, set loop start=end of sample, loop end=loop start +1 or 2 (for 16 bit)
long #5: volume and pan
         word #10: volume, 0..16384(=1). Values more than 16384 could cause clipping if sample is normalized
         word #11: pan. 16384: full left, 8192: center, 0: full right
long #6  period and skip
         word #11: period. This is the number of Paula cycles between two samples. 
         word #12: skip. Set to 1 for 8 bit, 2 for 16-bit samples. 
         Setting higher skip value skips the samples while playing, allows for higher frequencies for the same period
long #7  was: (reserved, unused. The planned usage is ADSR stuff.)
         Command, bit 31=set sample rate, bit 30 - set sample source

 

