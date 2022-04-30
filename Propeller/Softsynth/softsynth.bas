'-----------------------------------------------------------------------
' Atari Softsynth samples based sound toy
' v. 0.02 - 20220426 
' pik33@o2.pl
'-----------------------------------------------------------------------

'sample rate=82264.77587890625

#include "retromachine.bi"
startmachine
startpsram
startvideo
startaudio

dim midi as ulong
declare midibytes alias midi as ubyte(3)


dim notes(127) as single 
dim oct(7)
const c212=1.05946309435929526456
'const skipv=2.73458481397043367867
const skipv=815.7667
const adsrv=52209 ' for 1 s
const c_1=8.17579891564370733371
print c212
let q#=13.75
let f#=c_1: for i=0 to 127: notes(i)=f# : f#=f#*c212: next i
for j=0 to 9: for i=0 to 11: print notes(12*j+i), : next i : print : next j
oct(0)=60: oct(1)=62 : oct(2)=64: oct(3)=65 : oct(4)=67 : oct(5)=69: oct(6)=71: oct(7)=72


'position 2,10: print hex$(addr(sinus)), dpeek(addr(sinus)+16), dpeek(addr(sinus)+18), dpeek(addr(sinus)+20)

for i=0 to 31



lpoke 64*i+base+00,0
lpoke 64*i+base+04,0
lpoke 64*i+base+08,0
lpoke 64*i+base+12,0
lpoke 64*i+base+16,addr(geige)+16+$4000_0000
lpoke 64*i+base+20,2048
lpoke 64*i+base+24,0
lpoke 64*i+base+28,8192
lpoke 64*i+base+32,$100000
lpoke 64*i+base+36, addr(percus)+16
lpoke 64*i+base+40,522090
lpoke 64*i+base+44,$FFFFFFFF
next i



dim channelassign(31)
dim channelnotes(31)
for i=0 to 31: channelassign(i)=0 : next i
let kbdpressed=1
do

' waitms(300): let midi=$90003A10
let midi=rm.readmidi(): position 2,17: if midi<>0 then print " ", hex$(midi,8),
let b3=midibytes(3): let b0=midibytes(0): let b1=midibytes(1) : let b2=midibytes(2)
if b3=$90 then
  let min=$7FFFFFFF: let minc=0
  for i=0 to 31
    if channelassign(i)<min then min=channelassign(i): minc=i 
  next i
  channelnotes(minc)=b1
  let skip=round(notes(b1)*skipv) : lpoke base+64*minc+32,skip :lpoke base+64*minc+24,b0*64 : lpoke base+64*minc+44,$e0000000 : lpoke 64*minc+base+40,52209
  lpoke base+64*minc+16,addr(geige)+16+$4000_0000
  waitms(1)
  channelassign(minc)=kbdpressed: kbdpressed+=1
  b3=0
endif
if b3=$80 orelse (b3=$90 andalso b0=0) then
  for i=0 to 31
    if channelnotes(i)=b1 then lpoke base+64*i+44,$FFFFFFFF
  next i  
  b3=0
 
  
endif
print hex$(lpeek(base+64*minc+12),8)
loop





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
