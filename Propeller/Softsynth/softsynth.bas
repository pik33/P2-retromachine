'-----------------------------------------------------------------------
' Atari Softsynth samples based sound toy
' v. 0.02 - 20220426 
' pik33@o2.pl
'-----------------------------------------------------------------------


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

for i=0 to 7
lpoke 64*i+base+00,0
lpoke 64*i+base+04,0
lpoke 64*i+base+4+08,addr(geige)+16+$C000_0000
lpoke 64*i+base+4+12,0
lpoke 64*i+base+4+16,2048
dpoke 64*i+base+4+20,0
dpoke 64*i+base+4+22,8192
dpoke 64*i+base+4+24,74
dpoke 64*i+base+4+26,1203
lpoke 64*i+base+4+28,$4000_0000
lpoke 64*i+base+36, addr(percus)+16
lpoke 64*i+base+40,1000
dpoke 64*i+base+4+26,510
next i

dim channelassign(8)
for i=0 to 7: channelassign(i)=0 : next i
let kbdpressed=1
do

if lpeek($38)<>0 then
  if peek($3b)=$90 then
  ' find a channel
  let min=$7FFFFFFF: let minc=0
  for i=0 to 7
    if channelassign(i)<min then min=channelassign(i): minc=i
  next i
  
  let skip=round(notes(peek($39))*2*skipv):lpoke base+64*minc+4+08,addr(geige)+16+$C000_0000:  dpoke base+64*minc+4+26,skip :dpoke base+64*minc+4+20,peek($38)*64
  channelassign(minc)=kbdpressed: kbdpressed+=1
   print kbdpressed ,minc,channelassign(0)
  endif
 lpoke $38,0
endif

if lpeek($30)<>0 orelse lpeek($3c)<>0 then 
   
   if lpeek($30)<>0 then let a=peek($31)
   if lpeek($3c)<>0 then let a=peek($3d) 


  if a=$7A then let skip=round(notes(60)*skipv):lpoke base+4+08,addr(geige)+16+$C000_0000:  dpoke base+4+26,skip 
  if a=$78 then let skip=round(notes(62)*skipv):lpoke base+4+08,addr(geige)+16+$C000_0000:  dpoke base+4+26,skip 
  if a=$63 then let skip=round(notes(64)*skipv):lpoke base+4+08,addr(geige)+16+$C000_0000:  dpoke base+4+26,skip 
  if a=$76 then let skip=round(notes(65)*skipv):lpoke base+4+08,addr(geige)+16+$C000_0000:  dpoke base+4+26,skip 
  if a=$62 then let skip=round(notes(67)*skipv):lpoke base+4+08,addr(geige)+16+$C000_0000:  dpoke base+4+26,skip 
  if a=$6e then let skip=round(notes(69)*skipv):lpoke base+4+08,addr(geige)+16+$C000_0000:  dpoke base+4+26,skip 
  if a=$6d then let skip=round(notes(71)*skipv):lpoke base+4+08,addr(geige)+16+$C000_0000:  dpoke base+4+26,skip  
  if a=$2c then let skip=round(notes(72)*skipv):lpoke base+4+08,addr(geige)+16+$C000_0000:  dpoke base+4+26,skip 
  


position 2,27 : print hex$(lpeek($3c),8) : lpoke $30,0 : lpoke $3c,0: 
a=0

endif

'if lpeek($34)<>0 then position 2,2 : print hex$(lpeek($34),8) : lpoke $34,0
if lpeek($38)<>0 then position 2,13 : print hex$(lpeek($38),8) : lpoke $38,0
'if lpeek($3c)<>0 then position 2,4 : print hex$(lpeek($3c),8) : lpoke $3c,0
position 2,15: print hex$(lpeek(base+8),8)
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
abss		file "h/abs.h2"
default		file "h/default.h2"
dimx		file "h/dimx.h2"
echo		file "h/echo.h2"

bass1 		file "s/bass1.s2"
beben 		file "s/beben.s2"
booster		file "s/booster.s2"
charly	        file "s/charly.s2"
'd12
'dreieck
geige		file "s/geige.s2"
'geige2
'glocke
'groehl
'harmon
'hat2
lauta		file "s/lauta.s2"
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
