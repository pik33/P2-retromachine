'' 6502 emu based on macca's compukit emulator

const _clkfreq=336956522

' 6502 constants

const REGP_N = 7
const REGP_V = 6
const REGP_B = 4
const REGP_D = 3
const REGP_I = 2
const REGP_Z = 1
const REGP_C = 0

' TODO: call 6502: set PC, return with .ret or set the int. Regset has to be in hub. 


dim ramptr as ulong
dim lutptr as ulong

dim ram_6502(65535) as ubyte
dim a  as class using "6502asm.spin2"

init
start()
test
do:loop

sub test

50 ram_6502($500)=0
waitus(100)
if ram_6502($501)=0 then pinlo(56) 
if ram_6502($501)=1 then pinhi(56) 
waitms(200)
ram_6502($500)=1
waitus(100)
if ram_6502($501)=0 then pinlo(56) 
if ram_6502($501)=1 then pinhi(56) 
waitms(200)
goto 50
end sub



sub init
ram_6502($fffc)=0     ' set reset vector to $600
ram_6502($fffd)=$6
ram_6502($600)=$AD    ' LDA $0500
ram_6502($601)=$00
ram_6502($602)=$05
ram_6502($603)=$8D    ' STA $0501
ram_6502($604)=$01
ram_6502($605)=$05
ram_6502($606)=$4C    ' JMP $0600
ram_6502($607)=$00
ram_6502($608)=$06
end sub


function start() as integer
let ramptr=addr(ram_6502)
'let lutptr=addr(lut_6502)
return cpu(a.cog_6502,@ramptr)
end function


sub poke(addr as ulong,value as ubyte)
asm
wrbyte value, addr
end asm
end sub

function addr(byref v as const any) as ulong
return(cast(ulong,@v))
end function
