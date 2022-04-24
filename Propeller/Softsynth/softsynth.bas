#include "retromachine.bi"
startmachine
startpsram
startvideo
startaudio

dim test as ushort(15)
for i=0 to 7  : test(i)=$7FFF : next i
for i=8 to 15 : test(i)=$8001 : next i

position 2,10: print hex$(addr(sinus)), dpeek(addr(sinus)+16), dpeek(addr(sinus)+18), dpeek(addr(sinus)+20)

lpoke base+00,0
lpoke base+04,0
lpoke base+08,addr(sinus)+16+$C000_0000
lpoke base+12,0
lpoke base+16,2048
dpoke base+20,16384
dpoke base+22,8192
dpoke base+24,11
dpoke base+26,1111
lpoke base+28,$4000_0000



do

if lpeek($30)<>0 then position 2,1 : print hex$(lpeek($30),8) : lpoke $30,0
if lpeek($34)<>0 then position 2,2 : print hex$(lpeek($34),8) : lpoke $34,0
if lpeek($38)<>0 then position 2,3 : print hex$(lpeek($38),8) : lpoke $38,0
if lpeek($3c)<>0 then position 2,4 : print hex$(lpeek($3c),8) : lpoke $3c,0
position 2,6: print hex$(lpeek(base),8)
loop

'channel+0  long current spl pointer
'channel+4  long sample
'channel+8  long sample start 
'channel+12 long loop start
'channel+16 long loop end
'channel+20 word volume
'channel+22 word pan
'channel+24 word synthfreq
'channel+26 word skip
'channel+28 long reserved




asm shared
sinus file "sinus.s2"
end asm
