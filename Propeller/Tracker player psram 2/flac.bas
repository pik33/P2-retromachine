



sub position (x,y)
v.setcursorpos(x,y)
end sub

sub flacopen


dim samplerate as ulong
dim numchannels as ulong
dim sampledepth as ulong
dim numsamples as ulong
dim magic as ulong
dim r as ulong
dim metahead as ulong
dim metalength,metatype,lastmeta,long1,long2 as ulong

pos=1
get #8,pos,magic,1,r: pos+=4

position 184,4 : print hex$(magic,8)

if magic<>$43614C66 then goto 9999
lastmeta=0

do
get #8,pos,metahead,1,r: pos+=5


if metahead and $80 <>0 then lastmeta=1
metalength=metahead shr 8
metatype=metahead and $7F
if metatype<>0 then 
  pos+=metalength
else
  pos+=10
  get #8,pos,long1,1,r: pos+=4
  get #8,pos,long2,1,r: pos+=4

  
endif
  
   position 184,5: print hex$(magic,8)
   position 184,6: print hex$(metahead,8)
   position 184,7: print hex$(metalength,8)
   position 184,8: print hex$(long1,8)
   position 184,9: print hex$(long2,8)
   
lpoke $30,0: do: loop until lpeek($30)<>0
loop until lastmeta=1


 
'	

'			sampleRate = in.readUint(20);'
'				numChannels = in.readUint(3) + 1;
'				sampleDepth = in.readUint(5) + 1;
'				numSamples = (long)in.readUint(18) << 18 | in.readUint(18);




9999 end sub
