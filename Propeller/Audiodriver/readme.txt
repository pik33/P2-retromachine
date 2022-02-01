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
long #7  reserved, unused. The planned usage is ADSR stuff.

 

