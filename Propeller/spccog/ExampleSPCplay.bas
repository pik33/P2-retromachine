const _CLKFREQ = 32*256*32_000
const DEBUG_COGS = %01
const leftpin = 8+6
const rightpin = leftpin+1

dim a1$ as string


dim spc as class using "SPCcog"
spc.start_spcfile(leftpin,rightpin,@spcfile)


print("SPC metadata:")
lpoke(addr(a1$),addr(spcfile)+$2e)
print "Song title:",left$(a1$,32)
lpoke(addr(a1$),addr(spcfile)+$4e)
print "Game title:",left$(a1$,32)
lpoke(addr(a1$),addr(spcfile)+$6e)
print "Dumper name:",left$(a1$,16)
lpoke(addr(a1$),addr(spcfile)+$7e)
print "Comments:",left$(a1$,32)
lpoke(addr(a1$),addr(spcfile)+$9e)
print "Dumped at:",left$(a1$,11)
lpoke(addr(a1$),addr(spcfile)+$a9)
print "Play time:",left$(a1$,3);" s."
lpoke(addr(a1$),addr(spcfile)+$ac)
print "Fade time:",left$(a1$,5);" ms."
lpoke(addr(a1$),addr(spcfile)+$b1)
print "Artist:"," ",a1$;" ms."

do:loop

sub lpoke(addr as ulong,value as ulong)
asm
wrlong value, addr
end asm
end sub


function addr(byref v as const any) as ulong
return(cast(ulong,@v))
end function

shared asm 

'' Note: copy the SPC files from the "tunes" directory
''       into the directory this file is in to make PropTool
''       find them. Or use that one command line option that
''       flexspin has. .... What, do I look like I remember how
''       that one goes? .... Ok, I have been informed I do
''       look like that. Well, I believe it'd be "-L ./tunes".
''       Yeah I think that'd do it.
spcfile  'file "sd2-01.spc"
        'file  sd2-18.spc"
        'file "sd2-34.spc"
        'file "sd2-41.spc"
        'file "sd3-207.spc"
        'file "sd3-208.spc"
        'file "sd3-301.spc"
        'file "sd3-312.spc"
        'file "mmx-04.spc"
        'file "mmx-16.spc"
        'file "scv4-06.spc"
        'file "scv4-28.spc"
        'file "iog-03.spc"
        'file "yi-07a.spc"
        'file "smr-128.spc"
        'file "sf-09.spc"
        'file "plok-01.spc"
        'file "plok-05.spc"
        'file "plok-12.spc"
        'file "plok-13.spc"
        'file "actr-04.spc"
        'file "Axel-F.spc"
        'file "sewer_surfin.spc"
        'file "fz-02.spc"
        'file "fz-07.spc"
        'file "fz-09.spc"
        'file "loz3-08.spc"
        'file "loz3-21.spc"
        file "loz3-31.spc"
end asm
