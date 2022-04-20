const _clkfreq = 336956522
const DEBUG_COGS = %01
const leftpin = 8+6
const rightpin = leftpin+1

#include "retromachine.bi"

dim a1$ as string

dim xid6fields$(10) as string
'1:song name
'2 game title
'3 artist name
'4 dumper name
'5 dumped date
'6 emulator
'7 comments
'8 seconds to play
'9 fade

const XID6_FOURCC = $36646978

startpsram
startvideo
cls(154,147)
spc.start_spcfile(leftpin,rightpin,@spcfile)
position 0,0: printmeta
do:loop

'---- end of test 

function getxidfield(f,a) as integer

let id=peek(f+$10208+a)
let t=peek(f+$10208+a+1)
let l=dpeek(f+$10208+a+2)
 
if (t=0) and (id=6) then 
  xid6fields$(6)="Error"
  if l=0 then xid6fields$(6)="Unknown"
  if l=1 then xid6fields$(6)="ZSNES"
  if l=2 then xid6fields$(6)="Snes9x"
endif
if (t=1) and (((id>=1) and (id<=4)) or (id=7)) then
  xid6fields$(id)="" : for i=0 to l-1 : xid6fields$(id)= xid6fields$(id)+chr$(peek(f+$1020C+a+i)) : next i   
endif
if (t=4) and (id=5) then 
   xid6fields$(id)=decuns$(lpeek(f+$10208+a+4))
endif
if t=0 then return a+4
if t=1 then return a+l+4
if t=4 then return a+8
return -1
end function
  

function checkxid6(a) as integer
if lpeek(a+$10200)=XID6_FOURCC then 
  return 1
else
  return 0
end if
end function

function getxid6length(a) as integer
return lpeek(a+$10204) 
end function

sub printmeta

for i=1 to 10: xid6fields$(i)="" : next i
if checkxid6(addr(spcfile))=1 then 
  let ll=getxid6length(addr(spcfile)) 
'  print (" XID6 found, length ");ll
  let r=0: do: let r=getxidfield(addr(spcfile),r) :  loop until (r>=ll) or (r=-1)
else
  print(" XID6 not found")
endif


if xid6fields$(1)="" then 'song
  for i=0 to 31 : xid6fields$(1)=xid6fields$(1)+chr$(peek(addr(spcfile)+i+$2e)) : next i
endif
if xid6fields$(2)="" then 'game
  for i=0 to 31 : xid6fields$(2)=xid6fields$(2)+chr$(peek(addr(spcfile)+i+$4e)) : next i
endif
if xid6fields$(3)="" then 'artist
  for i=0 to 31 : xid6fields$(3)=xid6fields$(3)+chr$(peek(addr(spcfile)+i+$b1)) : next i
endif
if xid6fields$(4)="" then
  for i=0 to 31 : xid6fields$(4)=xid6fields$(4)+chr$(peek(addr(spcfile)+i+$6e)) : next i
endif
if xid6fields$(5)="" then
  for i=0 to 10 : xid6fields$(5)=xid6fields$(5)+chr$(peek(addr(spcfile)+i+$9e)) : next i
endif
if xid6fields$(6)="" then
  l=peek(addr(spcfile)+$D2) 
  xid6fields$(6)="Error"
  if l=$30 then xid6fields$(6)="Unknown"
  if l=$31 then xid6fields$(6)="ZSNES"
  if l=$32 then xid6fields$(6)="Snes9x" 
endif
if xid6fields$(7)="" then
  for i=0 to 31 : xid6fields$(7)=xid6fields$(7)+chr$(peek(addr(spcfile)+i+$7e)) : next i
endif
if xid6fields$(8)="" then
  for i=0 to 2 : xid6fields$(8)=xid6fields$(8)+chr$(peek(addr(spcfile)+i+$a9)) : next i
endif
if xid6fields$(9)="" then
  for i=0 to 4 : xid6fields$(9)=xid6fields$(9)+chr$(peek(addr(spcfile)+i+$ac)) : next i
endif
  

if xid6fields$(1)<>"" then print " Song title:", xid6fields$(1) 
if xid6fields$(2)<>"" then print " Game title:", xid6fields$(2) 
if xid6fields$(3)<>"" then print " Artist name:", xid6fields$(3) 
if xid6fields$(4)<>"" then print " Dumper name:", xid6fields$(4) 
if xid6fields$(5)<>"" then print " Dumped at:", xid6fields$(5) 
if xid6fields$(6)<>"" then print " Emulator:", xid6fields$(6) 
if xid6fields$(7)<>"" then print " Comments:", xid6fields$(7) 
if xid6fields$(8)<>"" then print " Time:    ", xid6fields$(8) 
if xid6fields$(9)<>"" then print " Fade:    ", xid6fields$(9) 

end sub
  


shared asm 

'' Note: copy the SPC files from the "tunes" directory
''       into the directory this file is in to make PropTool
''       find them. Or use that one command line option that
''       flexspin has. .... What, do I look like I remember how
''       that one goes? .... Ok, I have been informed I do
''       look like that. Well, I believe it'd be "-L ./tunes".
''       Yeah I think that'd do it.
spcfile  'file "sd2-01.spc"
        'file  sd2-18.spc"
        'file "sd2-34.spc"
        'file "sd2-41.spc"
        'file "sd3-207.spc"
        'file "sd3-208.spc"
        'file "sd3-301.spc"
        'file "sd3-312.spc"
        'file "mmx-04.spc"
        'file "mmx-16.spc"
        'file "scv4-06.spc"
        'file "scv4-28.spc"
        'file "iog-03.spc"
        'file "yi-07a.spc"
        'file "smr-128.spc"
        'file "sf-09.spc"
        'file "plok-01.spc"
        'file "plok-05.spc"
        'file "plok-12.spc"
        'file "plok-13.spc"
        'file "actr-04.spc"
        'file "Axel-F.spc"
        'file "sewer_surfin.spc"
        'file "fz-02.spc"
        'file "fz-07.spc"
        'file "fz-09.spc"
        'file "loz3-08.spc"
        'file "loz3-21.spc"
        file "loz3-31.spc"
end asm
