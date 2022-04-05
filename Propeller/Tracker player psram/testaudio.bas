#include "retromachine.bi"


const hubset338=%1_111011__11_1111_0111__1111_1011 '338_666_667 =30*44100 
const hubset350=%1_000001__00_0010_0010__1111_1011 '350_000_000 =31*44100
const hubset340=%1_000000__00_0001_0000__1111_1011 '350_000_000 =31*44100
const hubset341=%1_010011__01_0101_0100__1111_1011 '350_000_000 =31*44100


dim testwave(16384) as ubyte

startmachine
startpsram
startvideo
startaudio


hubset(hubset341)

for i=0 to 16382 step 2: testwave(i)=i mod 255: testwave(i+1)=0: next i
for i=0 to 63: psram.write(addr(testwave(0)),i*16384,16384) : next i
lpoke base+28,$80000100 : waitms(2) : lpoke base+28,$40000000  				' init buffering variables
      										                ' now init the driver. Todo: exact synchronization of stereo channels !!!!!
    lpoke base+12,0               								' loop start   
    lpoke base+16,$100000                                      					' loop end, we will use $50000 bytes as $50 4k buffers
    dpoke base+20,16384                                                                       ' set volume 
    dpoke base+22,16384                                                              		' set pan
    dpoke base+24,30 					                			' set period
    dpoke base+26, 4    									' set skip, 1 stereo sample=4 bytes
    lpoke base+28,$0000_0000

    lpoke base+32+12,0                 								' loop start   
    lpoke base+32+16,$100000                                       				' loop end
    dpoke base+32+20,16384                                                                      ' volume
    dpoke base+32+22,0     	                                                                ' pan
    dpoke base+32+24, 30                                                                        ' period
    dpoke base+32+26, 4    									' skip
    lpoke base+32+28,$0000_0000
    
    lpoke base+8, $c0000000  								' sample ptr, 16 bit, restart from 0 
    lpoke base+32+8,  $e0000002
