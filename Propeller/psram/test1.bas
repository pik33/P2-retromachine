
const _clkfreq = 354_600_000

#include "retromachine.bi"
dim mem as class using "psram4.spin2"
let cog = mem.startx(0, 0,13, -1)

let totalres=0 : let totalblock=0
for i=0 to 8191
  for k=0 to 1023: let l=getrnd() and $FF : poke($50000+i,l) : next k
  mem.write($50000,i*1024,1024 )
  for k=0 to 1023 : poke ($70000+k,0) : next k
  let c=getct()
  mem.read1($70000,i*1024,1024 )
  c=getct()-c
  let res=0
  for k=0 to 1023: if peek($70000+k)<>peek($50000+k) then res+=1 
  next k
  totalres+=res
  if res>0 then totalblock+=1
  print "Block "; i;" tested with ";res;" errors ";c;" clocks"
next i  
print "Total errors ";totalres;" in ";totalblock;" blocks"
