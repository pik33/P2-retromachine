dim s as ulong
dim v1  as ushort
dim v2 as ushort
dim v3 as ushort
dim v4 as ushort
dim v5  as ushort
dim v6 as ushort
dim v7 as ushort
dim v8 as ushort

s=0 : v1=0 : v2=0 : v3=0 : v4=0
v5=0 : v6=0 : v7=0 : v8=0


mount "/sd", _vfs_open_sdcard()
chdir "/sd/sid/selected"
let filename3$="/sd/sid/selected/bilinski.sid"
close #7: open filename3$ for input as #7   

get #7,$37,s,1 
print hex$(s)  
print hex$(v1)
print hex$(v2)
print hex$(v3)
print hex$(v4)
print hex$(v5)
print hex$(v6)
print hex$(v7)
print hex$(v8)
