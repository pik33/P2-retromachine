#include "retromachine.bi"
startmachine
startpsram
startvideo
startaudio

dim test as ushort(15)
for i=0 to 7  : test(i)=$7FFF : next i
for i=8 to 15 : test(i)=$8001 : next i
dim notes(127) as single 
dim oct(7)
const c212=1.05946309435929526456
const skipv=2.73458481397043367867

const c_1=8.17579891564370733371
print c212
let q#=13.75
let f#=c_1: for i=0 to 127: notes(i)=f# : f#=f#*c212: next i
for j=0 to 9: for i=0 to 11: print notes(12*j+i), : next i : print : next j
oct(0)=60: oct(1)=62 : oct(2)=64: oct(3)=65 : oct(4)=67 : oct(5)=69: oct(6)=71: oct(7)=72


'position 2,10: print hex$(addr(sinus)), dpeek(addr(sinus)+16), dpeek(addr(sinus)+18), dpeek(addr(sinus)+20)

lpoke base+00,0
lpoke base+04,0
lpoke base+08,addr(charly)+16+$C000_0000
lpoke base+12,0
lpoke base+16,2048
dpoke base+20,16384
dpoke base+22,8192
dpoke base+24,37
dpoke base+26,1203
lpoke base+28,$4000_0000

waitms(500)
dpoke base+26,1000

do
for i=0 to 7: let skip=round(notes(oct(i))*skipv): dpoke base+26,skip: waitms(500) : next i


'if lpeek($30)<>0 then position 2,1 : print hex$(lpeek($30),8) : lpoke $30,0
'if lpeek($34)<>0 then position 2,2 : print hex$(lpeek($34),8) : lpoke $34,0
'if lpeek($38)<>0 then position 2,3 : print hex$(lpeek($38),8) : lpoke $38,0
'if lpeek($3c)<>0 then position 2,4 : print hex$(lpeek($3c),8) : lpoke $3c,0
'position 2,6: print hex$(lpeek(base),8)
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


sub play(note,wave,adsr)
end sub



asm shared
percus 		file "h/percus.h2"
bass1 		file "s/bass1.s2"
beben 		file "s/beben.s2"
booster		file "s/booster.s2"
charly	        file "s/charly.s2"
'd12
'dreieck
'geige
'geige2
'glocke
'groehl
'harmon
'hat2
'lauta
'laute
'lauti
'lauto
'lautu
'mm
'np01
'np02
'odd
'orgel
'otto1
'pila
'pila1
'prim
'ra
'random
'rechteck
'rect1
'rect5
'rect10
'rect25
'rect50
'rehi
'saege
'saw0
'saw10
'saw25
'saw50
'sinran2
'sinran3
sinus		file "s/sinus.s2"
'ssub
'violin
'zacke
'zacke2
'sinus file "s/sinus.s2"
end asm
