dim speed, r as ulong
dim version, offset, load, startsong, flags, init, play, songs, song  as ushort
dim il,b as ubyte
dim ititle,iauthor,icopyright as ubyte(32)
dim atitle,author,copyright as string
dim i as integer

mount "/sd", _vfs_open_sdcard()
chdir "/sd/sid/selected"
let filename3$="/sd/sid/selected/bilinski.sid"

close #8: open filename3$ for input as #8

atitle=""'"                                "
author=""'"                                "
copyright=""'"                                "

get #8,5,version,2,r :    version=((version and 255) shl 8) or (version shr 8) : print version 
get #8,7,offset,2,r  :    offset=(offset shl 8) or (offset shr 8) 
get #8,9,load,2,r    :    load=(load shl 8) or (load shr 8)
get #8,11,init,2,r   :    init=(init shl 8) or (init shr 8) 
get #8,13,play,2,r   :    play=(play shl 8) or (play shr 8) 
get #8,15,songs,2,r  :    songs=(songs shl 8) or (songs shr 8)
get #8,17,startsong,2,r : startsong=(startsong shl 8) or (startsong shr 8) 
get #8,19,speed,4,r     
speed=speed shr 24+((speed shr 8) and $0000FF00) + ((speed shl 8) and $00FF0000) + (speed shl 24) 
get #8,23,ititle(0),32,r      
get #8,55,iauthor(0),32,r      
get #8,87,icopyright(0),32,r    

if version>1 then 
  get #8,119,flags,2,r : flags=(flags shl 8) or (flags shr 8)
  b=0 : if load=0 then b=1 : get #8,125,load,2,r  
endif

for i=0 to 31 : atitle=atitle+chr$(ititle(i)): next i  
for i=0 to 31 : author=author+chr$(iauthor(i)) : next i 
for i=0 to 31 : copyright=copyright+chr$(iauthor(i)) : next i  

print ("version:   "): print(hex$(version,4))
print ("offset:    "): print(hex$(offset,4))
print ("load:      "): print(hex$(load,4))  '178-144*b);
print ("init:      "): print(hex$(init,4))
print ("play:      "): print(hex$(play,4))
print ("songs:     "): print(hex$(songs))
print ("startsong: "): print(hex$(startsong))
print ("speed:     "): print(hex$(speed,8))
print ("title:     "): print(atitle)
print ("author:    "): print(author)
print ("copyright: "): print(copyright)
print ("flags:     "): print(hex$(flags,4))
