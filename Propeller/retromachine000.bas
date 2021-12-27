#include "retromachine.bi"
e=0
const _clkfreq = 320_000_000
startvideo 512+48
cls
print "Basic test"
print

print"kwas2"
print hex$(1234)

mount "/sd", _vfs_open_sdcard()
open "/sd/testbas.txt" for input as #3
input #3,s
print s
input #3,s
print s
input #3,s
print s
close #3
open "/sd/testbas.txt" for input as #3
input #3,s
print s
input #3,s
print s
input #3,s
print s
close #3
