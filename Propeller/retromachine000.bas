#include "retromachine.bi"

'e=0 ' this strange thing makes the program run in full optimization

startvideo 
rm.start

cls
print "Basic test"
print

do
  dim b11,b12 as ubyte
  if lpeek($30)<>0 then
    cmd=peek($33)
    if cmd<>0 then

      b11=peek($32)
      b12=peek($31)
    endif 
    lpoke $30,0 
    if cmd=$87 then print "Keyboard key released, scancode "; b11 
    if cmd=$88 then print "Keyboard key pressed,  scancode "; b11   ; ", charcode "; b12
    if cmd=$89 then 
      if b11=0 then 
        print "Keyboard modifiers released"
      else 
        print "Keyboard modifiers pressed: ";hex$(b11)
      endif 
    endif   
  endif  
  
  if lpeek($34)<>0 then
    cmd=peek($37)
    if cmd<>0 then
      b11=peek($36)
      b12=peek($35)
    endif  
    lpoke $34,0
    if cmd=$81 then mousex=b11+b12 shl 7 : print "Mouse moved, x= ";mousex; " y= "; mousey
    if cmd=$82 then mousey=b11+b12 shl 7 : print "Mouse moved, x= ";mousex; " y= "; mousey
    if cmd=$83 then mousewheel=b11+b12 shl 7 : print "Mousewheel: ";mousewheel
    if cmd=$84 then print "Mouse key: ";b11
    if cmd=$85 then print "Mouse clicked"
    if cmd=$86 then print "Mouse double clicked"
     
  endif  

  if lpeek($38)<>0 then 
    cmd=peek($3b) shr 4
    channel=peek($3B) and $0F
    b11=peek($39)
    b12=peek($38)
    lpoke $38,0
    if cmd=8 then print "Midi note off, channel ";channel;", note ";b11
    if cmd=9 then print "Midi note on,  channel ";channel;", note ";b11;", velocity ";b12
    if cmd=10 then print "Midi poly aftertouch, channel ";channel;" note ";b11;", velocity ";b12
    if cmd=11 then print "Midi control change, channel ";channel;" controller ";b11;", value ";b12
    if cmd=12 then print "Midi program change, channel ";channel;" program ";b12
    if cmd=13 then print "Midi mono aftertouch, channel ";channel;" value ";b12
    if cmd=14 then print "Midi pitch bend, channel ";channel;" value ";b11+b12 shl 7
    if cmd=15 then print "Novation control key "; b12 ' TODO Sysex has to be properly processed 
  endif
      
loop
