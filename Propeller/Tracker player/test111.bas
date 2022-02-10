#include "dir.bi"
const module$="aurora.mod"
mount "/sd", _vfs_open_sdcard()
chdir "/sd/mod"
'var j=0: if j=1 then print cd$()
open "/sd/mod/"+module$ for input as #4
print geterr()
close #4

function cd$() as string
return curdir$()
end function
