#include "dir.bi"
mount "/sd", _vfs_open_sdcard()
chdir "/sd/" 
dim filename$,filename2$,currentdir$ as string
dim dirnum1,dirnum2,dirnum3,filenum1,filenum2,filenum3,position as integer

currentdir$="/sd/"
getlists(1)

sub getlists(mode)

dim e,i as integer

close #5										
open currentdir$+"dirlist.txt" for output as #5
  print #5,".."+space$(36)								
  print ".."
  filename$ = dir$("*", fbDirectory)							
  while filename$ <> "" andalso filename$ <> nil
    if len(filename$)<38 then filename$=filename$+space$(38-len(filename$))		
    filename$=right$(filename$,38)							
    print #5, filename$									
    print  filename$									
    filename$ = dir$()
  end while
  close #5										
 
  close #5
  open currentdir$+"filelist.txt" for output as #5
  filename$ = dir$("*", fbNormal)
  while filename$ <> "" andalso filename$ <> nil
    if len(filename$)<38 then filename$=filename$+space$(38-len(filename$))
    filename$=right$(filename$,38)
    print #5, filename$
    print filename$
    filename$ = dir$()
  end while
  close #5
 
    

end sub
