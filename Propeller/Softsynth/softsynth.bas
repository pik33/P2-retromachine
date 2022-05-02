'-----------------------------------------------------------------------
' Atari Softsynth samples based sound toy
' v. 0.02 - 20220426 
' pik33@o2.pl
'-----------------------------------------------------------------------

'sample rate=82264.77587890625

#include "retromachine.bi"

const version$="Prop2Softsynth v.0.03"


const c212=1.05946309435929526456
const c_1=8.17579891564370733371
const skipv=815.7667
const adsrv=52209 ' for 1 s





dim envnames$(31)
dim wavenames$(63)

dim notes(127) as single 
dim oct(7)


dim channelassign(31)
dim channelnotes(31)
dim midi as ulong
declare midibytes alias midi as ubyte(3)

startmachine
startpsram
startvideo
startaudio

preparepanels
kbddraw

const envcount=19
const wavecount=47
let envtime=52209
let envsuspos=$80

envnames$(00)="abs     " 
envnames$(01)="default "
envnames$(02)="dimx    "
envnames$(03)="echo    "
envnames$(04)="gm000   "
envnames$(05)="gm040   "
envnames$(06)="gm100   "
envnames$(07)="harry   "
envnames$(08)="logo    "
envnames$(09)="mix     "
envnames$(10)="orgel   "
envnames$(11)="percus  "
envnames$(12)="percus2 "
envnames$(13)="rainbow "
envnames$(14)="saxt    "
envnames$(15)="sinush  "
envnames$(16)="soft    "
envnames$(17)="violin  "
envnames$(18)="custom  "
let envno=12
envdraw(envno,envtime,envsuspos)

wavenames$(00)="bass1    "	 	'0
wavenames$(01)="beben    "	 	'1
wavenames$(02)="booster  "	 	'2
wavenames$(03)="charly   "        	'3
wavenames$(04)="d12      "		'4
wavenames$(05)="dreieck  "       	'5
wavenames$(06)="geige    "	 	'6
wavenames$(07)="geige2   "	 	'7
wavenames$(08)="glocke   "	 	'8
wavenames$(09)="groehl   "		'9
wavenames$(10)="harmon   "	        '10
wavenames$(11)="hat2     "	 	'11
wavenames$(12)="lauta    "	 	'12
wavenames$(13)="laute    "	 	'13
wavenames$(14)="lauti    "	 	'14
wavenames$(15)="lauto    "	 	'15
wavenames$(16)="lautu    "	 	'16
wavenames$(17)="mm       "	 	'17
wavenames$(18)="np01     "	 	'18
wavenames$(19)="np02     "	 	'19
wavenames$(20)="odd      "	 	'20
wavenames$(21)="orgel    "	 	'21
wavenames$(22)="otto1    "	 	'22
wavenames$(23)="pila     "	 	'23
wavenames$(24)="pila1    "	 	'24
wavenames$(25)="prim     "	 	'25
wavenames$(26)="ra       "	 	'26
wavenames$(27)="random   "	 	'27
wavenames$(28)="rechteck "	 	'28
wavenames$(29)="rect1    "	 	'29
wavenames$(30)="rect5    "	 	'30
wavenames$(31)="rect10   "	 	'31
wavenames$(32)="rect25   "	 	'32
wavenames$(33)="rect50   "	 	'33
wavenames$(34)="rehi     "	 	'34
wavenames$(35)="saege    "	 	'35
wavenames$(36)="saw0     "	 	'36
wavenames$(37)="saw10    "	 	'37
wavenames$(38)="saw25    "	 	'38
wavenames$(39)="saw50    "	        '39
wavenames$(40)="sinran2  "	 	'40
wavenames$(41)="sinran3  "	 	'41
wavenames$(42)="sinus    "	 	'42
wavenames$(43)="sub      "	 	'43
wavenames$(44)="violin   "	 	'44
wavenames$(45)="zacke	 "	 	'45
wavenames$(46)="zacke2	 "	 	'46
let waveno=6
wavedraw(waveno)


let f#=c_1: for i=0 to 127: notes(i)=f# : f#=f#*c212: next i


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
lpoke 64*i+base+36,addr(abss)+272*envno+16
lpoke 64*i+base+40,envtime*10
lpoke 64*i+base+44,$FFFFFFFF
next i




for i=0 to 31: channelassign(i)=0 : next i
let kbdpressed=1
'do
'position 10,25: print decuns$(lpeek($40),8)
' waitms(300): let midi=$90003A10
90 midi=rm.readmidi(): position 2,17: if midi<>0 then print " ", hex$(midi,8),
if midi=0 then goto 90
let b3=midibytes(3): let b0=midibytes(0): let b1=midibytes(1) : let b2=midibytes(2)

if b3=$B0 andalso b1=$15 then  ' Novation Impulse knob #1, controller #$15: set envelope
  if b0/6<envcount then let envno=b0/6
  envdraw(envno, envtime, envsuspos)
  goto 90
endif

if b3=$B0 andalso b1=$16 then  ' Novation Impulse knob #2, controller #$16: set envelope time
  let envtime=(12*52209)/(b0+1)
  envdraw(envno, envtime, envsuspos)
  goto 90
endif

if b3=$B0 andalso b1=$17 then  ' Novation Impulse knob #3, controller #$17: set envelope time
  let envsuspos = 1+2*b0
  envdraw(envno, envtime, envsuspos)
  goto 90
endif

if b3=$B0 andalso b1=$19 then  ' Novation Impulse knob #3, controller #$17: set envelope time
  if b0/2<wavecount then let waveno=b0/2
  wavedraw(waveno)
  goto 90
endif

if b3=$90 andalso b0<>0 then
  let min=$7FFFFFFF: let minc=0
  for i=0 to 31
    if channelassign(i)<min then min=channelassign(i): minc=i 
  next i
  channelnotes(minc)=b1
  let skip=round(notes(b1)*skipv) : lpoke base+64*minc+32,skip :lpoke base+64*minc+24,b0*64 : lpoke base+64*minc+44,envsuspos shl 24 : lpoke 64*minc+base+40,52209
  lpoke base+64*minc+16,addr(bass1)+2064*waveno+16+$4000_0000: lpoke 64*minc+base+36,addr(abss)+272*envno+16: lpoke 64*minc+base+40,envtime
  waitms(1)
  channelassign(minc)=kbdpressed: kbdpressed+=1
  b3=0
  goto 90
endif

if b3=$80 orelse (b3=$90 andalso b0=0) then
  for i=0 to 31
    if channelnotes(i)=b1 then lpoke base+64*i+44,0
  next i  
  b3=0
  goto 90
  
endif

goto 90

sub preparepanels

' 1. Channel and oscilloscope panel at graphic canvas

cls(0,15)	
v.setfontfamily(4)						'
v.outtextxycz((1024-32*len(version$))/2,4,version$,0,15,4,2)
						'

'v.frame(4,408,524,555,15)							' clear the panel
'v.box(5,409,523,427,188)							' clear the panel
'v.box(5,428,523,554,177)							' clear the panel
'v.outtextxycf(12,410,"Osciloscope",0)'

'v.frame(528,408,720,555,15)							' clear the panel
'v.box(529,409,719,427,26)							' clear the panel
'v.box(529,428,719,554,16)							' clear the panel
'v.outtextxycf(536,410,"Visualization",0)

'v.frame(724,408,1019,555,15)							' clear the panel
'v.box(725,409,1018,427,170)							' clear the panel
'v.box(725,428,1018,554,162)
'v.outtextxycf(732,410,"Channels",0)

v.frame(743,50,1000,200,0)							' clear the panel
v.box(744,51,999,69,153)
v.box(744,70,999,199,159)


v.frame(199,50,712,200,0)							' clear the panel
v.box(200,51,711,69,153)
v.box(200,70,711,199,159)



'v.frame(362,40,720,404,15)							' clear the panel
'v.box(363,41,719,59,40)							' clear the panel
'v.box(363,60,719,403,34)							' clear the panel
'v.outtextxycf(370,43,"Files",0)

'v.frame(4,40,358,236,15)							' clear the panel
'v.box(5,41,357,59,200)							' clear the panel
'v.box(5,60,357,235,193)							' clear the panel
'v.outtextxycf(12,43,"Directories",0)

'v.frame(4,240,358,324,15)							' clear the panel
'v.box(5,241,357,259,232)							' clear the panel
'v.box(5,260,357,323,225)							' clear the panel
'v.outtextxycf(12,243,"Now playing",0)

'v.frame(4,328,358,404,15)							' clear the panel
'v.box(5,329,357,347,122)							' clear the panel
'v.box(5,348,357,403,114)							' clear the panel
'v.outtextxycf(12,331,"Status",0)

'let oldcpl=v.s_cpl: let oldcpl1=v.s_cpl1: let oldbufptr=v.s_buf_ptr: v.setfontfamily(4)
'v.s_cpl=2048:v.s_cpl1=2048: v.s_buf_ptr=$700000: :position 0,0 : v.outtextxycg(0,0,statusline$+statusline$,120,113)
'v.s_cpl=oldcpl:v.s_cpl1=oldcpl1:v.s_buf_ptr=oldbufptr: v.setfontfamily(0)


end sub

sub envdraw(no,tm,sp)
v.box(744,70,999,199,159)
for i=0 to 255
  let q=peek(addr(abss)+272*no+16+i)
  v.putpixel(744+i,198-q/2,40)
next i
v.draw(744+sp,71,744+sp,198,192)
v.box(744,51,999,69,153)
v.outtextxycf(752,53,"Envelope: "+envnames$(no)+" "+str$(52209.0/tm)+" s.  ",15)
end sub

sub wavedraw(no)

v.frame(199,50,712,200,0)							' clear the panel
v.box(200,51,711,69,153)
v.box(200,70,711,199,159)
for i=0 to 511
  let q=dpeek(addr(bass1)+2064*no+16+4*i)
  if q>32767 then q-=32768 else q+=32768
  v.putpixel(200+i,198-q/512,40)
next i
v.outtextxycf(208,53,"Waveform: "+wavenames$(no),15)
end sub

sub kbddraw

for o=0 to 10
  for n=0 to 7
    if o=10 andalso n>3 then continue
    v.frame(8+12*(8*7+n),400,20+12*(7*o+n),500,0)
  next n
  v.box(16+12*(7*o),400,24+12*(7*o),460,0)
  v.box(28+12*(7*o),400,36+12*(7*o),460,0)
  v.box(52+12*(7*o),400,60+12*(7*o),460,0)
  v.box(64+12*(7*o),400,72+12*(7*o),460,0)
  v.box(76+12*(7*o),400,84+12*(7*o),460,0)

next o 


end sub

asm shared
abss		file "h/abs.h2"		'0	
default		file "h/default.h2"	'1
dimx		file "h/dimx.h2"	'2
echo		file "h/echo.h2"	'3
gm000		file "h/gm000.h2"	'4
gm040		file "h/gm040.h2"	'5
gm100		file "h/gm100.h2"	'6
harry		file "h/harry.h2"	'7
logo		file "h/logo.h2"	'8
mix		file "h/mix.h2"		'9
orgelh		file "h/orgel1.h2"	'10
percus		file "h/percus.h2"	'11
percus2		file "h/percus2.h2"	'12
rainbow		file "h/rainbow.h2"	'13
saxt		file "h/saxt.h2"	'14
sinush 		file "h/sinus.h2"	'15
soft		file "h/soft.h2"	'16
violinh		file "h/violin.h2"	'17
custom		file "h/default.h2"     '18

bass1 		file "s/bass1.s2"	'0
beben 		file "s/beben.s2"	'1
booster		file "s/booster.s2"	'2
charly	        file "s/charly.s2"	'3
d12		file "s/d12.s2"		'4
dreieck	        file "s/dreieck.s2"	'5
geige		file "s/geige.s2"	'6
geige2		file "s/geige2.s2"	'7
glocke		file "s/glocke.s2"	'8
groehl		file "s/groehl.s2"	'9
harmon		file "s/harmon.s2"	'10
hat2		file "s/hat2.s2"	'11
lauta		file "s/lauta.s2"	'12
laute		file "s/laute.s2"	'13
lauti		file "s/lauti.s2"	'14
lauto		file "s/lauto.s2"	'15
lautu		file "s/lautu.s2"	'16
mm		file "s/mm.s2"		'17
np01		file "s/np01.s2"	'18
np02		file "s/np02.s2"	'19
odd		file "s/odd.s2"		'20
orgel		file "s/orgel.s2"	'21
otto1		file "s/otto1.s2"	'22
pila		file "s/pila.s2"	'23
pila1		file "s/pila1.s2"	'24
prim		file "s/prim.s2"	'25
ra		file "s/ra.s2"		'26
random		file "s/random.s2"	'27
rechteck	file "s/rechteck.s2"	'28
rect1		file "s/rect1.s2"	'29
rect5		file "s/rect5.s2"	'30
rect10		file "s/rect10.s2"	'31
rect25		file "s/rect25.s2"	'32
rect50		file "s/rect50.s2"	'33
rehi		file "s/rehi.s2"	'34
saege		file "s/saege.s2"	'35
saw0		file "s/saw0.s2"	'36
saw10		file "s/saw10.s2"	'37
saw25		file "s/saw25.s2"	'38
saw50		file "s/saw50.s2"	'39
sinran2		file "s/sinran2.s2"	'40
sinran3		file "s/sinran3.s2"	'41
sinus		file "s/sinus.s2"	'42
ssub		file "s/sub.s2"		'43
violin		file "s/violin.s2"	'44
zacke		file "s/zacke.s2"	'45
zacke2		file "s/zacke2.s2"	'46

'sinus file "s/sinus.s2"
end asm
