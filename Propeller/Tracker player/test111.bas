option implicit
dim sl(0) as ulong
statusline$="something"
sl(0)=len(statusline$)


' blink a pin at a given frequency
sub blink(pin, freq)
  direction(pin) = output
  do
    output(pin) = not output(pin)
    waitcnt(getcnt() + freq)
  loop
end sub
 
dim stack(8) ' small stack, blink does not call many other functions

' start the blinking up on another CPU
var a = cpu(blink(56, 80_000_000), @stack(1))
