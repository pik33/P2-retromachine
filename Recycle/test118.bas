
const _clkfreq = 354693878 
#include "dir.bi"
mount "/sd", _vfs_open_sdcard()
chdir "/sd/" 
dim filename$,filename2$,currentdir$ as string
dim dirnum1,dirnum2,dirnum3,filenum1,filenum2,filenum3,position as integer

currentdir$="/sd/"
getlists(1)

sub getlists(mode)

dim e,i as integer

if mode=1 then e=4: goto 360 								' if mode=1 then force error to rebuild fles

350 e=0
dirnum3=0
close #5 :open currentdir$+"dirlist.txt" for input as #5 				' try to open a directory list
e=geterr()
e=4                                        
360 if e=4 then										' error #4=file not found - create a new file
  close #5										' todo: react to other errors (message box?)
  open currentdir$+"dirlist.txt" for output as #5
  print #5,".."+space$(36)								' this file system has no .. - it needs to be manually added
  filename$ = dir$("*", fbDirectory)							' find all directories
  while filename$ <> "" andalso filename$ <> nil
    if len(filename$)<38 then filename$=filename$+space$(38-len(filename$))		' the string has to be exactly 38 characters 
    filename$=right$(filename$,38)							' which enables to use get when reading
    print #5, filename$									' write directory name to the file
    print  filename$									' write directory name to the file
    filename$ = dir$()
  end while
  close #5										
  goto 350
endif

if e=0 then 										' now the directory list exists
  i=1
' v.setwritecolors($c8,$c1)
 ' for  i=1 to 11: position 2,i : print space$(38) : next i  				' clear the directory panel
  i=2
  do
    input #5,filename$									' write first 10 entries to the panel
    filename2$=rtrim$(filename$)
    filename2$=space$((38-len(filename2$))/2)+filename2$
  '  if i<12 then position 2,i : print filename2$ ' v.write(filename2$) 
   if i<12 then   print filename2$ ' v.write(filename2$) 
    i+=1
  loop until filename$=nil orelse filename$="" 						' to do: write the number of entries to avoid reading all of them
  dirnum3=i-3	
  close #5
  endif
  

if mode=1 then e=4: goto 410								' file list read - mode=1 forces rebuild

400 e=0											' do the same thing as in directory panel
close #5
filenum3=0
open currentdir$+"filelist.txt" for input as #5
e=geterr()

410 if e=4 then
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
  goto 400
endif
    
if e=0 then ' file list exists
 ' v.setwritecolors($29,$22)
 ' for i=1 to 19: position 44,i : print space$(38) : next i  
  i=2
  do
    input #5,filename$
    filename2$=rtrim$(filename$)
    filename2$=space$((38-len(filename2$))/2)+filename2$
  '  if i<20 then position 44,i ': 'v.write(filename2$) 
  '  if i<20 then position 44,i ': 'v.write(filename2$) 
     print filename2$
    i+=1
  loop until filename$=nil orelse filename$=""
  filenum3=i-3
  close #5
endif

filenum1=0										' reset variables and highlight first directory position
filenum2=0
dirnum1=0
dirnum2=0
'highlight(0,0,1)
'panel=0

end sub
