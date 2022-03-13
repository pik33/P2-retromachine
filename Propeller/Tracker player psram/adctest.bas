#include "retromachine.bi"

dim newdl(4095) as ulong
dim random(1023) as ubyte

dim adc as class using "adccog.spin2"

dim x,y as ulong

startmachine
startvideo

adc.start(16,17)
v.setmode(0)
v.cls(154,147)
print "kwas"


do
x,y=adc.measure()
position 1,10: v.write(v.inttostr2(x,8)): position 20,10: v.write(v.inttostr2(y,8))
loop
