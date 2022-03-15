#include "retromachine.bi"
dim adc as class using "adccog.spin2"

dim x,y,dir as ulong
dim dirt$ as string

startmachine
startvideo

adc.start(16,17)
v.setmode(0)
v.cls(154,147)


do
x,y=adc.measure()
if x<3090 then dir=5 :dirt$="Up-left"
if x>=3090 andalso x<3350 then dir=9 :dirt$= "Up-right  "
if x>=3350 andalso x<4000 then dir=1:dirt$=  "Up        "
if x>=4000 andalso x<4900 then dir=6:dirt$=  "Down-left "
if x>=4900 andalso x<6000 then dir=10:dirt$= "Down-right"
if x>=6000 andalso x<8000 then dir=2:dirt$=  "Down      "
if x>=8000 andalso x<12000 then dir=4:dirt$= "Left      "
if x>=12000 andalso x<20000 then dir=8:dirt$="Right     "
if x>=20000 then dir=0 : dirt$=              "None      "

if y<16000 then pinhi(56)
if y>=16000 then pinlo(56) 

position 1,10: v.write(v.inttostr2(x,8)): position 20,10: v.write(dirt$): position 40,10: v.write(v.inttostr2(y,8))
loop
