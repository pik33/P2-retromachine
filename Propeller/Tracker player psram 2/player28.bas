'-------------------------------------------------------------------------------------------------------------
'
' Prop2play - a multiformat player for the P2
' v. 0.28 - 20220421
' pik33@o2.pl
' with a lot of code and help from the P2 community
' MIT license
'
'-------------------------------------------------------------------------------------------------------------

'memory map:

' 7C000 - 7FFFF - reserved for debugger
' 7B000 - 7BFFF - 4k   HUB buffers for the video driver
' 7AC00 - 7AFFF - 1k   HUB buffers for the video blitting
' 7A400 - 7ABFF - 2k   HUB buffers for the audio driver
' 76400 - 7A3FF - 16k  HUB buffer for audio and other files loading
' 75A00 - 763FF - 2560 bytes oscilloscope buffer
' 75000 - 759FF - 2560 bytes stack space for cogs
' 64000 - 74FFF - 68k  HUB buffer for .spc and 6502
' 64000 - top of the program RAM available - 409600 bytes 

'cogs needed

' - main cog, always
' - video cog, always
' - psram cog, always
' - keyboard and mouse cog, always
' - module playing cog, switchable 
' - audio driver cog, switchable, plays wav and mod files
' - SIDCog based SID chip emulator cog, switchable, for .sid and .dmp
' - 6502 cog, switchable, for .sid
' - SPCcog, Super Nintendo sound chip emulator, for .spc

'cogs usage:

' - wav: main, video, kbm, audio, psram	   		= 5 cogs
' - mod: main, video, kbm, audio, psram, module       	= 6 cogs
' - spc: main, video, kbm, psram, spc                 	= 5 cogs
' - sid: main, video, kbm, psram, sid, sid-loop, 6502 	= 7 cogs
' - dmp: main, video, kbm, psram, sid, sid-loop       	= 6 cogs

'--------------------------------------------------------------------------------------------------------------

#include "retromachine.bi"                     ' initialization, classes and auxilliary stuff

' ------------------------ Constant and addresses -------------------------------------------------------------

const HEAPSIZE = 8192
const version$="Prop2play v.0.28"
const statusline$=" Propeller2 multiformat player v. 0.28 --- 2022.04.21 --- pik33@o2.pl --- use a serial terminal or a RPi KBM interface to control --- arrows up,down move - pgup/pgdn or w/s move 10 positions - enter selects - tab switches panels - +,- controls volume - 1..4 switch channels on/off - 5,6 stereo separation - 7,8,9 sample rate - a,d SID speed - x,z SID subtune - R rescans current directory ------"
const hubset338=%1_111011__11_1111_0111__1111_1011 '338_666_667 =30*44100 
const hubset336=%1_101101__11_0000_0110__1111_1011 '336_956_522 =paula*95
const scope_ptr=$75A00
declare a6502buf alias $64000 as ubyte($10FFF) '64000 doesnt work, why?
declare mainstack alias $75000 as ubyte(2559)
declare filebuf alias $76400 as ubyte(16383)

' ----------------------- Global vars -------------------------------------------------------------------------

dim displayname(39) as ubyte
dim displayname_ptr as ulong
dim oldtrigs(4) as ulong
dim pan(4)
dim sn$(32)
dim sl as ulong
dim r as ulong
dim i,j,k,l,m,qqq as integer
dim ansibuf(3) as ubyte

dim filename$,filename2$,filename3$ as string
dim s1a,s1b,s21a,s21b,s31a,s31b,s41a,s41b as integer
dim cc,qq1,qq2,framenum,e as ulong
dim dirnum1,dirnum2,dirnum3,filenum1,filenum2,filenum3,olddirnum1,oldfilenum1,filemove,modtime,time2 as integer
dim samples,panel,c,ma,mb,pos as ulong
dim currentdir$ as string
dim channelvol(4), channelpan(4) as integer
dim mainvolume, mainpan as integer
dim samplerate,wavepos,currentbuf as ulong
dim newdl(32)

dim modplaying,waveplaying,dmpplaying, spcplaying, sidplaying, needbuf,playnext as ubyte
dim modcog,scog,a6502cog,scog2 as integer
dim dmppos as ulong
dim newcnt,bufptr,siddelay,sidfreq,sidtime as integer
dim sidpos,sidlen as ulong
dim stop as ulong
dim sidregs(34) as ulong
dim sidnames(8) as string


dim speed, r as ulong
dim version,offset,load,startsong,flags, init, play, songs, song  as ushort
dim dump as ushort
dim b as ubyte
dim ititle,iauthor,icopyright as ubyte(32)
dim atitle,author,copyright as string

'' ----------------------------Main program start ------------------------------------

channelvol(0)=1 : channelvol(1)=1 : channelvol(2)=1 : channelvol(3)=1    
mainvolume=127 : mainpan=2048  ' vol: 1..128..(255)  pan 0 (mono)..8192 (full)
startmachine
startpsram
startvideo
startaudio

'v.cursoroff
makedl
lpoke addr(sl),len(statusline$)  ' cannot assign to sl, but still can lpoke :) 
framenum=0
for i=0 to 3 : oldtrigs(i)=0 : next i
pan(0)=8192-mainpan : pan(1)=8192+mainpan : pan(2)=8192+mainpan : pan(3)=8192-mainpan
preparepanels
waveplaying=0: modplaying=0 : dmpplaying=0 : spcplaying=0 : sidplaying=0

sidnames(0)="               "
sidnames(1)="Triangle       "
sidnames(2)="Saw            "
sidnames(3)="Combined wave 3"
sidnames(4)="Square         "
sidnames(5)="Combined wave 5"
sidnames(6)="Combined wave 6"
sidnames(7)="Combined wave 7"
sidnames(8)="Noise          "

stop=0

mount "/sd", _vfs_open_sdcard()
chdir "/sd"
currentdir$="/sd/"
filemove=0

getlists(0)
ma=lomem()+1024 :  mb=ma 
pos=1

modcog=-1 : a6502cog=-1 : scog=-1 : scog2=-1
panel=0
s1a=0
samplerate=100   

v.spr1ptr=@balls1
v.spr2ptr=@balls2
v.spr3ptr=@balls3
v.spr4ptr=@balls4

v.spr1h=31
v.spr1w=31
v.spr2h=31
v.spr2w=31
v.spr3h=31
v.spr3w=31
v.spr4h=31
v.spr4w=31

'' --------------------------------- THE MAIN LOOP --------------------------------------------------------------------------------------

do
  waitvbl  
      											' synchronize with vblanks
  if modplaying=0 then framenum+=1 : scrollstatus((framenum) mod (8*sl))                        ' if not playing module let main loop scroll the status line
  if dmpplaying or modplaying or sidplaying then displaysamples
  if modplaying=1 then scrollinfo
  scope												' display scope
  bars												' display bars

'' --------------------------------  Getting the .wav file data in the main loop as no other cogs can acces the file system ------------

  if waveplaying=1 then
    getwave											' load the next chunk of wave file if needed
  endif  
  
'' ------------------------------- Display the playing time ----- TODO: correct the proper .wav time
  
  v.setwritecolors($e9,$e1)
  if modcog>(-1) then time2=framenum-modtime
  if waveplaying=1 then time2=(wavepos)/3528
  if (dmpplaying=1) or (sidplaying=1) then time2=sidtime/200
  position 2*15,19: v.write(v.inttostr2(time2/180000,2)): v.write(":"):v.write(v.inttostr2((time2 mod 180000)/3000,2)):v.write(":"):v.write(v.inttostr2((time2 mod 3000)/50,2)):v.write(":"):v.write(v.inttostr2((time2 mod 50),2))

'' ----------------------------- Get data from the keyboard
 
  if lpeek($30)<>0 then 									                         	' a Raspberry Pi based interface sent a message
    if peek($33)=$88 then  ansibuf(0)=ansibuf(1): ansibuf(1)=ansibuf(2) : ansibuf(2)=ansibuf(3) : ansibuf(3)=peek($31)   	' add it to the ANSI buffer
    lpoke $30,0 													 	' and clear the message
  endif  

  if lpeek($3c)<>0 then ansibuf(0)=ansibuf(1): ansibuf(1)=ansibuf(2) : ansibuf(2)=ansibuf(3) : ansibuf(3)=peek($3D): lpoke($3C,0) ' A serial interface at P62.63 from ANSI terminal
  if ansibuf(3)=asc(" ") then stop=not stop: ansibuf(3)=0 
  
  if (ansibuf(3)=asc("x")) and (sidplaying=1) then
    startsong+=1
    if startsong>songs then startsong=songs
    song=startsong-1
    jsr6502(song, init)
    waitms(1)
    ansibuf(3)=0
    endif
    
  if (ansibuf(3)=asc("z")) and (sidplaying=1) then
    startsong-=1
    if startsong<1 then startsong=1
    song=startsong-1
    jsr6502(song, init)
    waitms(1)
    ansibuf(3)=0
    endif
    
'' ---------------------------- Key 7,8,9 pressed - samplerate (period) change     

  if ansibuf(3)=asc("7") then 									' 7 - decrease the period
    samplerate-=1 : if samplerate<65 then samplerate=65
    lpoke base+28,samplerate+$80000000 : waitms(2) : lpoke base+28,0 : ansibuf(3)=0
  endif  
   
  if ansibuf(3)=asc("8") then 									' 8 - incerase the period    
    samplerate+=1 : if samplerate>65535 then samplerate=65535
    lpoke base+28,samplerate+$80000000 : waitms(2) : lpoke base+28,0 : ansibuf(3)=0
  endif 
     
  if ansibuf(3)=asc("9") then									' 9 - return to standard     
    if waveplaying=0 then lpoke base+28,$80000064 : samplerate=100				' 100=$64  if module playing
    if waveplaying=1 then lpoke base+28,$80000100 : samplerate=256				' 256=$100 if wave playing, $100 allows HQ DACs
     waitms(2) : lpoke base+28,0 : ansibuf(3)=0
   endif
   
  if ansibuf(3)=asc("d") then 									' 7 - decrease the period
    if sidfreq>=100 then sidfreq=sidfreq+50: if sidfreq>400 then sidfreq=400
    if sidfreq=60 then sidfreq=100
    if sidfreq=50 then sidfreq=60
    if sidfreq<50 then sidfreq=sidfreq+5
    if sidfreq=6 then sidfreq=5

    siddelay=clkfreq/sidfreq
    ansibuf(3)=0
  endif  
  
  if ansibuf(3)=asc("a") then 									' 7 - decrease the period
    if sidfreq<=50 then sidfreq=sidfreq-5: if sidfreq<1 then sidfreq=1
    if sidfreq=60 then sidfreq=50
    if sidfreq=100 then sidfreq=60
    if sidfreq>100 then sidfreq=sidfreq-50

    siddelay=clkfreq/sidfreq
    ansibuf(3)=0
  endif  
   
'' --------------------------- Keys 1..4 - channels on/off, 5,6 - stereo separation, +,- volume
   
  if ansibuf(3)=49 then channelvol(0)=1-channelvol(0) : ansibuf(3)=0									' 1 - channel 1	
  if ansibuf(3)=50 then channelvol(1)=1-channelvol(1) : ansibuf(3)=0									' 2 - channel 2
  if ansibuf(3)=51 then channelvol(2)=1-channelvol(2) : ansibuf(3)=0									' 3 - channel 3
  if ansibuf(3)=52 then channelvol(3)=1-channelvol(3) : ansibuf(3)=0									' 4 - channel 4
  if ansibuf(3)=53 andalso ansibuf(2)<>91 then ansibuf(3)=0 : ansibuf(2)=0: mainpan=mainpan-256: if mainpan<0 then mainpan=0		' 5 - decrease stereo separation
  if ansibuf(3)=54 andalso ansibuf(2)<>91 then ansibuf(3)=0 : ansibuf(2)=0: mainpan=mainpan+256: if mainpan>8192 then mainpan=8192	' 6 - increase stereo separation
  if ansibuf(3)=asc("+") orelse ansibuf(3)=asc("=") then mainvolume+=1: ansibuf(3)=0 : if mainvolume>128 then mainvolume=128 		' + - increase volume
  if ansibuf(3)=asc("-") then mainvolume-=1: ansibuf(3)=0 : if mainvolume<0  then mainvolume=0    					' - - decrease volume
   
  pan(0)=8192-mainpan : pan(1)=8192+mainpan : pan(2)=8192+mainpan : pan(3)=8192-mainpan 						' set channels position
  v.setwritecolors(122,114)
  position 2*2,22:  v.write("pan: "): v.write(v.inttostr2(mainpan/256,2))  								' display the status
  position 2*11,22: v.write("vol: "): v.write(v.inttostr2(mainvolume,3)) 
  position 2*21,22: v.write("chn: "): 
  if channelvol(0)=1 then position 2*26,22 :v.write("1")
  if channelvol(0)=0 then position 2*26,22 :v.write("-")
  if channelvol(1)=1 then position 2*28,22 :v.write("2")
  if channelvol(1)=0 then position 2*28,22 :v.write("-")
  if ((modplaying=1) or (sidplaying=1) or (dmpplaying=1)) and (channelvol(2)=1) then position 2*30,22 :v.write("3")
  if ((modplaying=1) or (sidplaying=1) or (dmpplaying=1)) and (channelvol(2)=0) then position 2*30,22 :v.write("-")
  if (modplaying=1) and (channelvol(3)=1) then position 2*32,22 :v.write("4")
  if (modplaying=1) and (channelvol(3)=0) then position 2*32,22 :v.write("-")   
  if (sidplaying=1) or (dmpplaying=1) or (waveplaying=1)then position 2*32,22 :v.write(" ")  
  if (waveplaying=1) then position 2*30,22 :v.write(" ")  
  if (sidplaying=1) then 
    position 2*33,22: v.write("song: ") : v.write(v.inttostr2(song+1,2))

  else
    position 2*33,22: v.write("        ") 
   endif
  if (dmpplaying=1) orelse (sidplaying=1) then 
    position 2*30,24: v.write("speed: ") : v.write(v.inttostr(sidfreq)) : v.write(" Hz ")
  else
    position 2*30,24: v.write("             ") 
  endif
  
'' -------------------------- R - rescan the directory 

  if (ansibuf(3)=asc("r")) orelse (ansibuf(3)=asc("R")) then getlists(1)  : ansibuf(3)=0 						' recreate dirlist

'' ------------------------- Enter and also directory panel active - change the current directory

  if (ansibuf(3)=13 orelse ansibuf(3)=141) andalso panel=0 then
    close #7: open currentdir$+"dirlist.txt" for input as #7					' open a directory list file
    for  iii=0 to dirnum2 : input #7,filename$ :next iii						' read dirnum2 entries - todo: use get instead
     filename$=rtrim$(filename$)								' delete spaces at the end
     if filename$<>".." then									' if not ".." then change the directory								
       close #7: chdir(currentdir$+filename$) : currentdir$=currentdir$+rtrim$(filename$)+"/"   ' and update currentdir$ as curdir$ function doesn't yet work as expected
       getlists(0)										' get and display file lists of the new directory
     else
       close #7											' .. - go up. The filesystem itself doesn't have .. - I had to do this manually
       e=instrrev(len(currentdir$)-1,currentdir$,"/")						' find the last "/" in currentdir$
       if e>1 then 										' e=1 means go to root, which is not allowed here (yet)
         currentdir$=left$(currentdir$,e-1)							' shorten the currentdir$
         chdir(currentdir$)									' and go up
         currentdir$=currentdir$+"/"								' now add "/" again to allow opening files in this directory
         getlists(0)										' get and display file lists
       endif  
     endif   
     v.setfontfamily(0)
								' display currentdir$ in the file panel
     v.box(363,41,719,59,40)	
     v.outtextxycf(373,42,left$(currentdir$,38),0)
  ansibuf(3)=0
  endif

'' -------------------- Enter and also file panel active - open and play the file
  
  if (ansibuf(3)=13 orelse ansibuf(3)=141) andalso panel=1 then
    open currentdir$+"filelist.txt" for input as #7						' open a file list
    if filenum2>0 then get #7,1+39*(filenum2-1),displayname(0),39 				' find the file name
    input #7,filename$ 				
    filename$=rtrim$(filename$)									' clean trailing spaces
    close #7
    let ext$=lcase$(right$(filename$,3))
    if ext$="mod" or ext$="dmp" or ext$="sid" or ext$="spc" or ext$="wav" or ext$="lac" then                  ' if the file is playable, stop playing the previous one
      if a6502cog>0 then cpustop(a6502cog) : a6502cog=-1
      if modcog>0 then cpustop(modcog)	: modcog=-1 :modplaying=0								
      if scog>0 then cpustop(scog): scog=-1 : dmpplaying=0 : sidplaying=0
      if scog2>0 then cpustop(scog2): scog2=-1   
      if audiocog>0 then stopaudio : audiocog=-1        
      waveplaying=0: modplaying=0 : spcplaying=0 : sidplaying=0: dmpplaying=0                   ' clear playing indicator variables
      v.spr1y=600: v.spr2y=600: v.spr3y=600: v.spr4y=600					' hide sprites
      close #8											' close an audio file channel
      v.box(529,428,719,554,16)									' clear the info panels
      v.box(725,428,1018,554,162)
      v.box(725,60,1018,403,147)
      waitms(1)											'
    endif  
    
    if ext$="lac" then 
      filename2$=currentdir$+filename$								' get a full filename with path
      open filename2$ for input as #8 : pos=1	
      flacopen
      close #8
    endif

    if ext$="mod" then							                        ' module file will be read into the PSRAM
      if audiocog<1 then startaudio   								' start the audio driver
      for i=0 to 7 : lpoke base+32*i+20,0 : next i 						' mute the sound
      filename2$=currentdir$+filename$								' get a full filename with path
      open filename2$ for input as #8 : pos=1							' open the module
      mb=addr(a6502buf)
      do
        get #8,pos,filebuf(0),4096,r : pos+=r 	
        psram.write(addr(filebuf(0)),mb,4096)	
        position 4,24: print pos-1; " bytes loaded     "				        ' get 4KB and update file position
        if mb<scope_ptr-4096 then for i=0 to r-1 : poke mb+i,filebuf(i) : next i                ' we have 68k 6502/spc/mod buffer to keep the mod header
        mb+=4096				                                               
      loop until r<>4096 									' do until eof 
      close #8
      tracker.initmodule(addr(a6502buf),0)							' init the tracker player
      samples=15: 
      if peek(addr(a6502buf)+1080)=asc("M") and peek(addr(a6502buf)+1082)=asc("K") then samples=31          ' get sample count
      getinfo(addr(a6502buf),samples)								' and information
      hubset(hubset336)										' set the main clock to Paula (PAL) * 100       
      samplerate=100 : lpoke base+28,$8000_005F: waitms(2): lpoke base+28,0   	   	        ' set the sample rate to standard Paula
      lpoke base+28+32,0 									' switch channel #1 to PSRAM after wav playing
      modcog=cpu (mainloop, @mainstack) 							' start the playing
      modtime=framenum										' get the current frame # for displaying module time
      v.setwritecolors($ea,$e1)									' yellow
      position 2*2,17:v.write(space$(38)): filename2$=right$(filename2$,38) 			' clear the place for a file name
      position 2*2,17: v.write(filename2$)							' display the 'now playing' filename 
      modplaying=1							
    endif
    
  if ext$="wav" then  										' this is a wave file. Todo - read and use the header!
    if modcog>0 then cpustop(modcog)	: modcog=-1	:modplaying=0			        ' if module playing, stop it
    if dmpplaying=1 then dmpplaying= 0: waitms(20): close #8 : cpustop(scog)                    ' if dmp file is playing, stop it
    if audiocog<1 then startaudio   
    for i=0 to 7 : lpoke base+32*i+20,0 : next i 					        ' mute the sound
    samplerate=256 : lpoke base+28,$80000100 : waitms(2) : lpoke base+28,$00000000              ' samplerate=clock/256 allows for HQ DAC
    hubset(hubset338)										' main clock=350 MHz, sample rate 1367187.5 Hz=31*44102.8 Hz - Todo: get a sample rate from a header and set it properly     
    filename3$=currentdir$+filename$								' get a filename with the path
    close #8: open filename3$ for input as #8: get #8,1,filebuf(0),$4000 
    psram.write(addr(filebuf(0)),0,$4000)          						' open the file and preload the buffer
    needbuf=1: currentbuf=0 :wavepos=$4001 : waveplaying=1   					' init buffering variables
    										                ' now init the driver. Todo: exact synchronization of stereo channels !!!!!
    lpoke base+12,0               								' loop start   
    lpoke base+16,$40000                                      					' loop end, we will use $50000 bytes as $50 4k buffers
    dpoke base+20,16384                                                                         ' set volume 
    dpoke base+22,16384                                                              		' set pan
    dpoke base+24,30 					                			' set period
    dpoke base+26,256  									' set skip, 1 stereo sample=4 bytes
    lpoke base+28,$0000_0000

    lpoke base+32+12,0                 								' loop start   
    lpoke base+32+16,$40000                                       				' loop end
    dpoke base+32+20,16384                                                                      ' volume
    dpoke base+32+22,0     	                                                                ' pan
    dpoke base+32+24, 30                                                                        ' period
    dpoke base+32+26, 256									' skip
    lpoke base+32+28,$0000_0000
    
    lpoke base+8, $d0000000  							  	        ' sample ptr, 16 bit, restart from 0 
    lpoke base+32+8, $f0000002							                ' sample ptr+2 (=another channel), synchronize #1 to #2
  
    v.setwritecolors($ea,$e1)									' yellow
    position 2*2,17:v.write(space$(38)): filename3$=right$(filename3$,38) 		 	' clear the place for a file name
    position 2*2,17: v.write(filename3$)						        ' display the 'now playing' filename 
    endif  

  if ext$="dmp" then  										' this is a sid dump file. 
    hubset(hubset336)										 
    filename3$=currentdir$+filename$								' get a filename with the path
    close #8: open filename3$ for input as #8: pos=1
    let psramptr=0 
    do
      get #8,pos,filebuf(0),512,r : pos+=r	
      psram.write(addr(filebuf(0)),psramptr,512)	
      position 4,24: print pos; " bytes loaded     "					         ' get 128 bytes and update file position
      psramptr+=512 					                                         ' move the buffer to the RAM and update RAM position. Todo: this can be done all at once
    loop until r<>512 '                          					         ' do until eof 
    close #8
    sidlen=psramptr
    dmpplaying=1   	
    sidpos=0
    v.setwritecolors($ea,$e1)									' yellow
    position 2*2,17:v.write(space$(38)): filename3$=right$(filename3$,38) 		 	' clear the place for a file name
    position 2*2,17: v.write(filename3$)						 	' display the 'now playing' filename 
    siddelay=336956522/50 : sidfreq=50 :sidtime=0
    for i=0 to 30: sid.regs(i)=0: next i
    scog=sid.start()
    scog2=cpu(sidloop,@mainstack)
    getdmpinfo
    waitms(100)
    endif  
 
  if ext$="sid" then  										' this is a sid file to execute by a 6502 CPU
    hubset(hubset336)										 
    filename3$=currentdir$+filename$								' get a filename with the path
    close #8: open filename3$ for input as #8: pos=1
    sidopen
    close #8
    sidplaying=1   	
    v.setwritecolors($ea,$e1)									' yellow
    position 2*2,17:v.write(space$(38)): filename3$=right$(filename3$,38) 		 	' clear the place for a file name
    position 2*2,17: v.write(filename3$)	
    sidtime=0
    for i=0 to 30: sid.regs(i)=0: next i
    scog=sid.start()
    scog2=cpu(sidloop,@mainstack)
    waitms(100)
    endif  

  if ext$="spc" then  										' this is a spc file. 
    hubset(hubset336)										 
    filename3$=currentdir$+filename$								' get a filename with the path
    close #8: open filename3$ for input as #8: pos=1
    do
      get #8,pos,a6502buf(pos-1),2048,r : pos+=r	
      position 4,24: print pos-1; " bytes loaded     "					        ' get 128 bytes and update file position
    loop until r<>2048 '                          					      ' do until eof 
    close #8
    spcplaying=1   	
    v.setwritecolors($ea,$e1)									' yellow
    position 2*2,17:v.write(space$(38)): filename3$=right$(filename3$,38) 		 	' clear the place for a file name
    position 2*2,17: v.write(filename3$)	
    scog=spc.start_spcfile(14,15,addr(a6502buf(0)))-1
    waitms(100)
    printmeta(addr(a6502buf(0)))
    endif  
  ansibuf(3)=0  
  endif

'' ----------------------------------- User interface panels control : tab, arrows, pg up/down, w, s
 
  if (ansibuf(3)=9) orelse (ansibuf(3)=137) then 						                                           ' TAB changes panel
    if panel=0 then highlight(panel,dirnum1,0)
    if panel=1 then highlight(panel,filenum1,0)
    panel=1-panel
    if panel=1 then highlight(panel,filenum1,1)
    if panel=0 then highlight(panel,dirnum1,1)
    ansibuf(3)=0
  endif
   
  if (ansibuf(3)=66 andalso ansibuf(2)=91 andalso ansibuf(1)=27) orelse (ansibuf(3)=$D0)  then filemove=1                                  ' arrow down  
  if (ansibuf(3)=54 andalso ansibuf(2)=91 andalso ansibuf(1)=27) orelse (ansibuf(3)=205) orelse (ansibuf(3)=asc("s")) then filemove=10     ' pg down or s - moves 10 positions down 
  if (ansibuf(3)=65 andalso ansibuf(2)=91 andalso ansibuf(1)=27) orelse (ansibuf(3)=$D1)  then filemove=(-1)                               ' arrow up 
  if (ansibuf(3)=53 andalso ansibuf(2)=91 andalso ansibuf(1)=27) orelse (ansibuf(3)=203) orelse (ansibuf(3)=asc("w"))  then filemove=(-10) ' pg up or w - moves 10 positions up 

'' ---------------------------------- If the "cursor" needs to be moved, do it

  if filemove>0 then											' move the "cursor" down
    if panel=0 then											' 0 - directory panel
      olddirnum1=dirnum1										' remember the current position
      dirnum1+=filemove  										' highlighting point
      dirnum2+=filemove 									        ' file point
      if dirnum2>=dirnum3 then dirnum2=dirnum3-1            						' dirnum2 has to be less than all directoriess count
      if dirnum1>=dirnum3 then dirnum1=dirnum3-1 ': goto 199 						' dirnum1 has to be less than all directories count. If it is, nothing more to do, go to the end of this part     
      if dirnum1<=9 then highlight(0,olddirnum1,0) : highlight(0,dirnum1,1) : goto 199                  ' only highlight changed, change the highlighted entry and go away
      highlight(0,olddirnum1,0)
      dirnum1=9	: v.setwritecolors($c9,$c1)    							        ' if we are still here, the highlight is at the bottom of the panel
      close #9 : open currentdir$+"dirlist.txt" for input as #9   					' and the new entry has to be read from the file, so open it
      for ii=dirnum2-9 to dirnum2
       get #9,1+39*ii,displayname(0),38									' get the name
        j=38 : do : j-=1 : loop until displayname(j)>32:  k=j 		     			        ' find the end of the nam
        v.box(8,(ii+4-dirnum2+9)*16,352,(ii+4-dirnum2+9)*16+15,193)
        position ((360-8*k-8)/8, ii+4-dirnum2+9)
        for j=0 to k: v.write(chr$(displayname(j))) :next j
      next ii
      close #9
      highlight(0,dirnum1,1) 										' highlight the selected entry         
    endif    

    if panel=1 then 											' 1 - file panel
      oldfilenum1=filenum1										' remember current
      filenum1+=filemove  										' highlighting
      filenum2+=filemove  										' file
      if filenum2>=filenum3 then filenum2=filenum3-1            					' filenum2 has to be less than all files count
      if filenum1>=filenum3 then filenum1=filenum3-1 ': goto 199 					' filenum1 has to be less than all files count, if not, go away     
      if filenum1<=20 then highlight(1,oldfilenum1,0) : highlight(1,filenum1,1) : goto 199              ' only highlight changed, go away
      filenum1=20 : v.setwritecolors($28,$22)  								' we are at the bottom now
      close #9 : open currentdir$+"filelist.txt" for input as #9                                        ' so do the same as in dir panel
      for ii=filenum2-20 to filenum2
       get #9,1+39*ii,displayname(0),38									' get the name
        j=38 : do : j-=1 : loop until displayname(j)>32:  k=j 		     			        ' find the end of the nam
        v.box(368,(ii+4-filenum2+20)*16,712,(ii+4-filenum2+20)*16+15,34)
        position ((720+360-8*k-8)/8, ii+4-filenum2+20)
        for j=0 to k: v.write(chr$(displayname(j))) :next j
      next ii
      close #9
      highlight(1,filenum1,1)                                      
    endif    
199 ansibuf(3)=0 : ansibuf(2)=0 : ansibuf(1)=0 : filemove=0  						' reset all these variables 
 
  endif
  
  if filemove<0 then 											' move up
    if panel=0 then											' dir panel
      olddirnum1=dirnum1										' remember current
      dirnum1+=filemove  										' highlighting
      dirnum2+=filemove 										' file
      if dirnum2<0 then dirnum2=0									' we are going up so dirnum2 may be negative and this is not allowed here
      if dirnum1>=0 then highlight(0,olddirnum1,0) : highlight(0,dirnum1,1) : goto 230 		        ' only change highlight and go away		
      highlight(0,olddirnum1,0)
      dirnum1=0 : v.setwritecolors($c9,$c1)  							        ' dirnum1 negative, read data from the file
      close #9 : open currentdir$+"dirlist.txt" for input as #9     				        ' do the same stuff as in dir panel down			
      for ii=dirnum2 to dirnum2+9
       get #9,1+39*ii,displayname(0),38									' get the name
        j=38 : do : j-=1 : loop until displayname(j)>32:  k=j 		     			        ' find the end of the nam
        v.box(8,(ii+4-dirnum2)*16,352,(ii+4-dirnum2)*16+15,193)
        position ((360-8*k-8)/8, ii+4-dirnum2)
        if ii<dirnum3 then for j=0 to k: v.write(chr$(displayname(j))) :next j
      next ii

      close #9
      highlight(0,dirnum1,1)    
    endif

    if panel=1 then											' file panel, move up, the same stuff again
      oldfilenum1=filenum1
      filenum1+=filemove  										' highlighting
      filenum2+=filemove
      if filenum2<0 then filenum2=0
      if filenum1>=0 then highlight(1,oldfilenum1,0) : highlight(1,filenum1,1) : goto 230    
      filenum1=0 : v.setwritecolors($28,$22)  
      close #9 : open currentdir$+"filelist.txt" for input as #9   
      
      for ii=filenum2 to filenum2+20
       get #9,1+39*ii,displayname(0),38									' get the name
        j=38 : do : j-=1 : loop until displayname(j)>32:  k=j 		     			        ' find the end of the nam
        v.box(368,(ii+4-filenum2)*16,712,(ii+4-filenum2)*16+15,34)
        position ((720+360-8*k-8)/8, ii+4-filenum2)
        if ii<filenum3 then for j=0 to k: v.write(chr$(displayname(j))) :next j
      next ii
      close #9
      highlight(1,filenum1,1) 
    endif
    
230  ansibuf(3)=0: ansibuf(2)=0 : ansibuf(1)=0  :filemove=0   
  endif
  if playnext=1 then playnext=0: ansibuf(3)=13
 
loop		

'' ------------------------------------------------ END OF THE MAIN LOOP started at 81 ---------------------------------------------------------------------------
'' ---------------------------------------------------------------------------------------------------------------------------------------------------------------

'' ------------------------------------------------ Helper functions for the main program -------------------------------------------------------------------------

'' -------------------------------------------------Display color channel bars in the oscilloscope panel ----------------------------------------------------------

sub bars

dim s1,s2,s21,s22,s31,s32,s41,s42 as integer

s1=32768: s21=32768 : s31=32768 : s41=32768
if (modplaying=1)  or (waveplaying=1)then

s1=lpeek(base+4)					' get a stereo sample from channel 1
s2=0
asm 							' and convert it to unsigned mono
  getword s2,s1,#1
  getword s1,s1,#0
  bitnot s1,#15
  bitnot s2,#15
  add s1,s2
  shr s1,#1
end asm

s21=lpeek(base+32+4)					
s22=0
asm 
  getword s22,s21,#1
  getword s21,s21,#0
  bitnot s21,#15
  bitnot s22,#15
  add s21,s22
  shr s21,#1
end asm

s31=lpeek(base+64+4)
s32=0
asm 
  getword s32,s31,#1
  getword s31,s31,#0
  bitnot s31,#15
  bitnot s32,#15
  add s31,s32
  shr s31,#1
end asm

s41=lpeek(base+96+4)
s42=0
asm 
  getword s42,s41,#1
  getword s41,s41,#0
  bitnot s41,#15
  bitnot s42,#15
  add s41,s42
  shr s41,#1
end asm

endif

if (dmpplaying=1) or (sidplaying=1)then

s1=sid.samples(0)+32768
s21=sid.samples(1)+32768
s31=sid.samples(2)+32768
s41=32768
endif

if spcplaying=1 then ' todo: add bars to .spc
s1=32768
s21=32768
s31=32768
s41=32768

endif

let bdiv=64: if waveplaying then let bdiv=96  
if spcplaying then let bdiv=96
if dmpplaying then let bdiv=48

s1=abs(s1-32768)				' compute the amplitude
if s1>=s1a then s1a=s1				' if bigger than average, replace average with amplitude (the bar goes up fast)
if s1<s1a then s1a=(15*s1a+s1)/16		' else decay slowly
s1b=s1a/bdiv :if s1b<0 then s1b=0		' but not less than 0
if s1b>120 then s1b=120				' and no more than 52 to fit in the panel

s21=abs(s21-32768)				' channel 2
if s21>s21a then s21a=s21
if s21<s21a then s21a=(15*s21a+s21)/16
s21b=s21a/bdiv :if s21b<0 then s21b=0
if s21b>120 then s21b=120

s31=abs(s31-32768)				' channel 3
if s31>s31a then s31a=s31
if s31<s31a then s31a=(15*s31a+s31)/16
s31b=s31a/bdiv :if s31b<0 then s31b=0
if s31b>120 then s31b=120

s41=abs(s41-32768)				' channel 4
if s41>s41a then s41a=s41
if s41<s41a then s41a=(15*s41a+s41)/16
s41b=s41a/bdiv :if s41b<0 then s41b=0
if s41b>120 then s41b=120

let s1c=s1b>>1
if s1c<16 then lpoke v.palette_ptr+4*$1,$00110000*((s1c+16)/2)             ' green
if s1c>=16 then lpoke v.palette_ptr+4*$1,$00FF0000+(s1c-16)*$11000000	   ' green to yellow
if s1c>=32 then lpoke v.palette_ptr+4*$1,$FFFF0000-(s1c-32)*$00220000	   ' yellow to red
if s1c>=48 then lpoke v.palette_ptr+4*$1,$FF000000		           ' red

let s21c=s21b>>1
if s21c<16 then lpoke v.palette_ptr+4*$2,$00110000*((s21c+16)/2)           ' the same for the rest of channels
if s21c>=16 then lpoke v.palette_ptr+4*$2,$00FF0000+(s21c-16)*$11000000    ' using colors b,c,d,e from the palette
if s21c>=32 then lpoke v.palette_ptr+4*$2,$FFFF0000-(s21c-32)*$00220000
if s21c>=48 then lpoke v.palette_ptr+4*$2,$FF000000

let s31c=s31b>>1
if s31c<16 then lpoke v.palette_ptr+4*$3,$00110000*((s31c+16)/2)
if s31c>=16 then lpoke v.palette_ptr+4*$3,$00FF0000+(s31c-16)*$11000000
if s31c>=32 then lpoke v.palette_ptr+4*$3,$FFFF0000-(s31c-32)*$00220000
if s31c>=48 then lpoke v.palette_ptr+4*$3,$FF000000

let s41c=s41b>>1
if s41c<16 then lpoke v.palette_ptr+4*$4,$00110000*((s41c+16)/2)
if s41c>=16 then lpoke v.palette_ptr+4*$4,$00FF0000+(s41c-16)*$11000000
if s41c>=32 then lpoke v.palette_ptr+4*$4,$FFFF0000-(s41c-32)*$00220000
if s41c>=48 then lpoke v.palette_ptr+4*$4,$FF000000

if waveplaying=1 then let add=46
if dmpplaying=1 or sidplaying=1 then let add=22
if modplaying=1 then let add=0

for ii=0 to s1b:  v.fastline(540+add,571+add,554-ii,$01) : next ii: for ii=s1b+1 to 120 :v.fastline(540+add,571+add,554-ii,16): next ii 'cc=$bbbbbbbb : for jj=270 to 278 step 4: lpoke graphicbuf_ptr+448*(59-ii)+jj,cc : next jj: next ii ' now draw these bars
for ii=0 to s21b: v.fastline(586+add,617+add,554-ii,$02) : next ii: for ii=s21b+1 to 120:v.fastline(586+add,617+add,554-ii,16): next ii 'cc=$bbbbbbbb : for jj=270 to 278 step 4: lpoke graphicbuf_ptr+448*(59-ii)+jj,cc : next jj: next ii ' now draw these bars
if (modplaying=1) or (dmpplaying=1) or (sidplaying=1) then for ii=0 to s31b: v.fastline(632+add,663+add,554-ii,$03) : next ii: for ii=s31b+1 to 120:v.fastline(632+add,663+add,554-ii,16): next ii 'cc=$bbbbbbbb : for jj=270 to 278 step 4: lpoke graphicbuf_ptr+448*(59-ii)+jj,cc : next jj: next ii ' now draw these bars
if modplaying=1 then for ii=0 to s41b: v.fastline(678,709,554-ii,$04) : next ii: for ii=s41b+1 to 120:v.fastline(678,709,554-ii,16): next ii 'cc=$bbbbbbbb : for jj=270 to 278 step 4: lpoke graphicbuf_ptr+448*(59-ii)+jj,cc : next jj: next ii ' now draw these bars
end sub

'' ---------------------------------------- Oscilloscope ----------------------------------------------------------------------------------------------

sub scope

dim ii as integer
var ttt=getct()
v.box(5,428,523,554,176)          
v.fastline(8,520,491,177)                                                                                                                               ' clear the panel
qq1=dpeek(scope_ptr):qq1+=dpeek(scope_ptr+2) 
							                                          ' try to trigger the scope at zero					
var iii=1: do : var oldqq1=qq1: qq1=dpeek(scope_ptr+4*iii):qq1+=dpeek(scope_ptr+4*iii+2) : iii+=1: loop until iii>=128  orelse (oldqq1<65536 andalso qq1>65536)   ' if not succeed with first 128 of 640 samples, there is no samples left for triggering
for ii=iii to iii+511 																		  ' display 512 samples																	
  qq1=dpeek(scope_ptr+4*ii)																	  ' left	
  qq1+=dpeek(scope_ptr+4*ii+2)																	  ' right
  if dmpplaying=0 then  qq1=qq1/1024 
  if dmpplaying=1 then  qq1=128-((qq1/512)-64)
  if qq1<2 then qq1=2 															          ' reduce from 17 to 6 bits		
  if qq1>126 then qq1=126
																	  ' clip to fit in the panel
  qq2=abs(65-qq1)/5' : position 1,1: v.write(v.inttostr2(qq2,3))
  if qq2=0 then let qq3=204
  if qq2=1 then let qq3=220
  if qq2=2 then let qq3=236
  if qq2=3 then let qq3=252
  if qq2=4 then let qq3=28
  if qq2=5 then let qq3=42
		
    qq1=qq1+428	
  													  ' compute the color
  v.putpixel(ii-iii+8,qq1,qq3)																	  ' and plot the pixel
next ii 
'print (getct()-ttt)/336
end sub


'' -------------------------------------- Module playing loop in its own cog  ------------------------  rev 20220205 ---------------------------------

sub mainloop

do
  tracker.tick							 ' let the player compute new values
  do : loop while v.vblank=1                                                       ' wait vor vblank
  do : loop while v.vblank=0                                                       ' wait vor vblank
  for mi=0 to 3 : setchannel(mi,oldtrigs(mi)) : next mi          ' this line has to be vblk syynchronized as much as possible - set new values in audio driver
  framenum+=1							 ' frame number to track time					
  scrollstatus((framenum) mod (8*sl))				 ' horizontal fine scroll the help/status line

  v.spr1ptr=@balls1+1024*(framenum mod 16)
  v.spr1x=1024-(1024*dpeek(base+0+24))/856
  if channelvol(0)=0 then v.spr1y=600
  if channelvol(0)>0 then v.spr1y=528-(dpeek(base+20)/17)

  v.spr2ptr=@balls2+1024*(framenum mod 16)
  v.spr2x=1024-(1024*dpeek(base+32+24))/856
  if channelvol(1)=0 then v.spr2y=600
  if channelvol(1)>0 then v.spr2y=528-(dpeek(base+32+20)/17)

  v.spr3ptr=@balls3+1024*(framenum mod 16)
  v.spr3x=1024-(1024*dpeek(base+64+24))/856
  if channelvol(2)=0 then v.spr3y=600
  if channelvol(2)>0 then v.spr3y=528-(dpeek(base+64+20)/17)

  
  v.spr4ptr=@balls4+1024*(framenum mod 16)
  v.spr4x=1024-(1024*dpeek(base+96+24))/856
  if channelvol(3)=0 then v.spr4y=600
  if channelvol(3)>0 then v.spr4y=528-(dpeek(base+96+20)/17)
  
  
loop
end sub

'' -------------------------------------- SID DMP playing loop in its own cog  ------------------------  rev 20220302 ---------------------------------


sub sidloop

dim i as integer
let newcnt=getcnt()+siddelay
do
  waitcnt(newcnt)
  sidtime+=siddelay/(336_96) ' 100 us tick
  newcnt+=siddelay
  if dmpplaying then
    psram.read1(addr(sid.oldregs(0)),sidpos,25)
    sidpos+=25
    if sidpos>=sidlen then sidpos=0
  endif
  if sidplaying then
    jsr6502(0,play)
    waitus(100)
    for i=0 to 24: sid.oldregs(i)=a6502buf($D400+i) : next i
  endif
  decoderegs(addr(sid.oldregs(0)),addr(sidregs(0)))
  if sidregs(2)<1 orelse sidregs(2)>8 then sidregs(8)=0
  if sidregs(11)<1 orelse sidregs(11)>8 then sidregs(17)=0
  if sidregs(20)<1 orelse sidregs(20)>8 then sidregs(26)=0
  sidregs(8)*=channelvol(0)
  sidregs(17)*=channelvol(1)
  sidregs(26)*=channelvol(2)
  for i=0 to 30 :sid.regs(i)=sidregs(i) :next i
  sid.regs(31)=256*mainvolume
  sid.regs(32)=8192+mainpan
  sid.regs(33)=8192
  sid.regs(34)=8192-mainpan
 
  v.spr1ptr=@balls1+1024*(framenum mod 16)
  v.spr1x=sidregs(0) /34000
  if channelvol(0)>0 then  v.spr1y=528-((sidregs(6) shr 28)*34)
  if channelvol(0)=0 then  v.spr1y=600
  
  v.spr2ptr=@balls2+1024*(framenum mod 16)
  v.spr2x=sidregs(9) /34000
  if channelvol(1)=0 then v.spr2y=600
  if channelvol(1)>0 then v.spr2y=528-((sidregs(15) shr 28)*34) 

  v.spr3ptr=@balls3+1024*(framenum mod 16)
  v.spr3x=sidregs(18) /34000
  if channelvol(2)=0 then v.spr3y=600
  if channelvol(2)>0 then v.spr3y=528-((sidregs(24) shr 28)*34)

   v.spr4y=600
   
loop 
end sub

'' -------------------------------------- Get a dir and file list after change a directory --------------------------------------------------------------

sub getlists(mode)

dim e,i,p as integer

if mode=1 then e=4: goto 360 								' if mode=1 then force error to rebuild fles

350 e=0
dirnum3=0
close #5 :open currentdir$+"dirlist.txt" for input as #5 				' try to open a directory list
e=geterr()
                                        
360 if e=4 then										' error #4=file not found - create a new file
  close #5										' todo: react to other errors (message box?)
  open currentdir$+"dirlist.txt" for output as #5
  print #5,".."+space$(36)								' this file system has no .. - it needs to be manually added
  filename$ = dir$("*", fbDirectory)							' find all directories
  while filename$ <> "" andalso filename$ <> nil
    if len(filename$)<38 then filename$=filename$+space$(38-len(filename$))		' the string has to be exactly 38 characters 
    filename$=right$(filename$,38)							' which enables to use get when reading
    print #5, filename$									' write directory name to the file
    filename$ = dir$()
    if waveplaying then getwave
  end while
  close #5										
  goto 350
endif

if e=0 then 										' now the directory list exists
  i=1
  v.setwritecolors($c8,$c1)
  v.box(5,60,357,235,193)						' clear the directory panel
  i=2
  do
    input #5,filename$									' write first 10 entries to the panel
    filename2$=rtrim$(filename$)
    p=(360-8*len(filename2$))/8
    if waveplaying then getwave
    if i<12 then position p,2+i : v.write(filename2$) 
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
    filename$ = dir$()
        if waveplaying then getwave

  end while
  goto 400
endif
    
if e=0 then ' file list exists
  v.setwritecolors($28,$22)
  v.box(363,60,719,403,34)
  i=2
  do
    input #5,filename$									' write first 10 entries to the panel
    filename2$=rtrim$(filename$)
    p=(720+360-8*len(filename2$))/8
    if waveplaying then getwave
    if i<23 then position p,2+i : v.write(filename2$) 
    i+=1
  loop until filename$=nil orelse filename$="" 
  filenum3=i-3
  close #5
endif

filenum1=0										' reset variables and highlight first directory position
filenum2=0
dirnum1=0
dirnum2=0
highlight(0,0,1)
panel=0
end sub

'' ------------------------------------------ Highlight the entry in the panel --------------------------------------------


sub highlight(hpanel,hpos,hhigh)

      var i=0
      var v0=0
      var v1=0
      var px=0
      var c=0
'goto 999

if hpanel=0 then

  var back=pspeek(v.buf_ptr+1024*(16*hpos+65)+13) 
  
  if ((hhigh=1) and (back<196)) or ((hhigh=0) and (back>=196)) then

    c=0
    for j=64+16*hpos to 79+16*hpos
      psram.read1($7a800,v.buf_ptr+1024*j+12,340)
      i=336
      v0=0
      v1=$7a800

 		asm

p001  		mov v0,v1
    		add v0,i
    		rdlong px,v0
        	getbyte c,px,#0
    		cmp c,#196 wcz
  	if_lt 	setbyte px,#200,#0
  	if_ge 	setbyte px,#193,#0
		getbyte c,px,#1
    		cmp c,#196 wcz
  	if_lt 	setbyte px,#200,#1
  	if_ge 	setbyte px,#193,#1
    		getbyte c,px,#2
    		cmp c,#196 wcz
  	if_lt 	setbyte px,#200,#2
  	if_ge 	setbyte px,#193,#2
    		getbyte c,px,#3
    		cmp c,#196 wcz
  	if_lt 	setbyte px,#200,#3
  	if_ge 	setbyte px,#193,#3
    		wrlong px,v0
    		sub i,#4 wcz
  	if_nc 	jmp #p001
  		
  		end asm

      psram.write($7a800,v.buf_ptr+1024*j+12,340)  
      next j
    endif  
  endif

if hpanel=1 then

  back=pspeek(v.buf_ptr+1024*(16*hpos+65)+373) 
  
  if ((hhigh=1) and (back<36)) or ((hhigh=0) and (back>=36)) then
    c=0
    for j=64+16*hpos to 79+16*hpos
      psram.read1($7a800,v.buf_ptr+1024*j+372,340)
      i=336
      v0=0
      v1=$7a800

 		asm

p002  		mov v0,v1
    		add v0,i
    		rdlong px,v0
        	getbyte c,px,#0
    		cmp c,#36 wcz
  	if_lt 	setbyte px,#40,#0
  	if_ge 	setbyte px,#34,#0
		getbyte c,px,#1
    		cmp c,#36 wcz
  	if_lt 	setbyte px,#40,#1
  	if_ge 	setbyte px,#34,#1
    		getbyte c,px,#2
    		cmp c,#36 wcz
  	if_lt 	setbyte px,#40,#2
  	if_ge 	setbyte px,#34,#2
    		getbyte c,px,#3
    		cmp c,#36 wcz
  	if_lt 	setbyte px,#40,#3
  	if_ge 	setbyte px,#34,#3
    		wrlong px,v0
    		sub i,#4 wcz
  	if_nc 	jmp #p002
  		
  		end asm

      psram.write($7a800,v.buf_ptr+1024*j+372,340)  
      next j
    endif  
  endif
       
999 end sub

' ---------------- Prepare the user interface --- rev 20220206 ---------------------------------------------------

sub preparepanels

' 1. Channel and oscilloscope panel at graphic canvas

cls(154,113)	
v.setfontfamily(4)						'
v.outtextxycz((1024-32*len(version$))/2,4,version$,120,113,4,2)
v.setfontfamily(0)						'

v.frame(4,408,524,555,15)							' clear the panel
v.box(5,409,523,427,188)							' clear the panel
v.box(5,428,523,554,177)							' clear the panel
v.outtextxycf(12,410,"Osciloscope",0)

v.frame(528,408,720,555,15)							' clear the panel
v.box(529,409,719,427,26)							' clear the panel
v.box(529,428,719,554,16)							' clear the panel
v.outtextxycf(536,410,"Visualization",0)

v.frame(724,408,1019,555,15)							' clear the panel
v.box(725,409,1018,427,170)							' clear the panel
v.box(725,428,1018,554,162)
v.outtextxycf(732,410,"Channels",0)

v.frame(724,40,1019,404,15)							' clear the panel
v.box(725,41,1018,59,154)
v.box(725,60,1018,403,147)
v.outtextxycf(732,43,"File info",0)

v.frame(362,40,720,404,15)							' clear the panel
v.box(363,41,719,59,40)							' clear the panel
v.box(363,60,719,403,34)							' clear the panel
v.outtextxycf(370,43,"Files",0)

v.frame(4,40,358,236,15)							' clear the panel
v.box(5,41,357,59,200)							' clear the panel
v.box(5,60,357,235,193)							' clear the panel
v.outtextxycf(12,43,"Directories",0)

v.frame(4,240,358,324,15)							' clear the panel
v.box(5,241,357,259,232)							' clear the panel
v.box(5,260,357,323,225)							' clear the panel
v.outtextxycf(12,243,"Now playing",0)

v.frame(4,328,358,404,15)							' clear the panel
v.box(5,329,357,347,122)							' clear the panel
v.box(5,348,357,403,114)							' clear the panel
v.outtextxycf(12,331,"Status",0)

let oldcpl=v.s_cpl: let oldcpl1=v.s_cpl1: let oldbufptr=v.s_buf_ptr: v.setfontfamily(4)
v.s_cpl=2048:v.s_cpl1=2048: v.s_buf_ptr=$700000: :position 0,0 : v.outtextxycg(0,0,statusline$+statusline$,120,113)
v.s_cpl=oldcpl:v.s_cpl1=oldcpl1:v.s_buf_ptr=oldbufptr: v.setfontfamily(0)


end sub

' ---------------- Find an adress of the current top of the stack --- rev 20220206 -------------------------------

function lomem() as ulong
dim as integer ptr x = __builtin_alloca(4)    	' allocate 4 bytes to find where is the stack
return (cast(ulong,x))
end function

' ---------------- Set channel registers with tracker data --- rev 20220205 ---------------------------------------

sub setchannel(channel,byref trigger as ulong)

if tracker.trigger(channel)<>trigger then                                                           ' tracker wants to trigger a note
  trigger=tracker.trigger(channel)                                                                  ' remember trigger count
  lpoke base+8+32*channel,tracker.currSamplePtr(channel) or $40000000                               ' set new sample ptr and request sample restart 
  lpoke base+12+32*channel,tracker.currsamplelength(channel)-tracker.currrepeatLength(channel)      ' set new loop start   
  lpoke base+16+32*channel,tracker.currsamplelength(channel)                                        ' set new loop and
endif
dpoke base+20+32*channel, (tracker.currVolume(channel)+tracker.deltavolume(channel))*mainvolume*channelvol(channel)      ' set volume - this and the rest doesn't depend on trigger
dpoke base+22+32*channel, pan(channel)                                                              ' set pan
dpoke base+24+32*channel, tracker.currPeriod(channel)+tracker.deltaperiod(channel)                  ' set period
dpoke base+26+32*channel, 256                                                                         ' set skip, always 1 here
end sub


'---------------- Get and display module information --------------------------

sub getinfo(ma,num)

v.box(725,60,1018,403,147)
v.setwritecolors($93,$9a)
position 184,4 : print "                                " 
position 184,4: print " ";filename$ :v.setwritecolors($9a,$93)                      ' test: module file name will be here
position 184,5 : print " Amiga module: "; samples;" samples"
position 186,7 : for i=ma to ma+19 : print chr$(peek(i) mod 128); : next i      ' first 20 bytes of module=title
for i=0 to 31: sn$(i)=space$(22) :next i
c=0
for i=1 to num
  for j=0 to 21
    var a=lpeek(addr(sn$(i)))
    var b=(peek(ma+20+30*(i-1)+j))
    if b>=32 then poke a+j,b : c=i ' c will be the last named sample
  next j
  sn$(i)=left$(sn$(i),22)
next i
' now prepare the scrolling info


let oldcpl=v.s_cpl: let oldcpl1=v.s_cpl1: let oldbufptr=v.s_buf_ptr: let oldlines=v.s_lines: v.setfontfamily(0)
v.s_cpl=64:v.s_cpl1=64: v.s_buf_ptr=$720000: v.s_lines=1024 :position 0,0: v.setwritecolors(154,147): v.box(0,0,255,1024,147)
for i=1 to c
  v.outtextxycg(0,16*(i-1),sn$(i),154,147)
next i
for i=c+2 to 2*c+1
  v.outtextxycg(0,16*(i-1),sn$(i-c-1),154,147)
next i
v.s_cpl=oldcpl:v.s_cpl1=oldcpl1:v.s_buf_ptr=oldbufptr: v.s_lines=oldlines: v.setfontfamily(0)
if c>16 then v.blit($40_720_000,0,0,255,255,256,$4000_0000+v.buf_ptr,744,144,1024)
if c<=16 then v.blit($40_720_000,0,0,255,16*c-1,256,$4000_0000+v.buf_ptr,744,144,1024)

end sub

'---------------- Display info about SID .dmp --------------------------

sub getdmpinfo

v.box(725,60,1018,403,147)
v.setwritecolors($93,$9a)
position 184,4 : print "                                " 
position 184,4: print " ";filename$ :v.setwritecolors($9a,$93)                      ' test: module file name will be here
position 184,6 : print " SID registers dump file "
end sub



'---------------- Display current samples and periods  using fast char output --- rev 20220205 ----------------------

sub displaysamples 

v.setwritecolors(170,162)

if modplaying then
position 246,29:v.write(v.inttostr2(tracker.currperiod(0)+tracker.deltaperiod(0),3))
position 246,30:v.write(v.inttostr2(tracker.currperiod(1)+tracker.deltaperiod(1),3))
position 246,31:v.write(v.inttostr2(tracker.currperiod(2)+tracker.deltaperiod(2),3))
position 246,32:v.write(v.inttostr2(tracker.currperiod(3)+tracker.deltaperiod(3),3))

if tracker.currsamplenr(0)<=samples then position 184,29: v.write(sn$(tracker.currsamplenr(0))) 
if tracker.currsamplenr(1)<=samples then position 184,30: v.write(sn$(tracker.currsamplenr(1)))
if tracker.currsamplenr(2)<=samples then position 184,31: v.write(sn$(tracker.currsamplenr(2)))
if tracker.currsamplenr(3)<=samples then position 184,32: v.write(sn$(tracker.currsamplenr(3)))
endif

if (dmpplaying=1) or (sidplaying=1) then
position 244,29:v.write(v.inttostr2(sidregs(0)/8718,4))
position 244,30:v.write(v.inttostr2(sidregs(9)/8718,4))
position 244,31:v.write(v.inttostr2(sidregs(18)/8718,4))

if sidregs(2)<=8  then position 184,29 : v.write(sidnames(sidregs(2)))
if sidregs(11)<=8 then position 184,30 : v.write(sidnames(sidregs(11)))
if sidregs(20)<=8 then position 184,31 : v.write(sidnames(sidregs(20)))
endif


end sub

'------------------ A status/help line fine horizontal scrolling --- rev 20220205 -------------------------------------------------------

sub scrollstatus(amount)

dim i as integer
for i=2 to 17: newdl(i)=$7000002+2*65536*(i-2)+amount<<4 :next i
end sub


'----------------- Prepare a custom displaylist for the player --- rev 20220205 ---------------------------------------------------------

sub getwave
    qqq=$4000											' one wave chunk to load, 4kB=27 ms
    currentbuf=lpeek(base) shr 20								' get a current playing 4k buffer# from the driver
    if needbuf<>currentbuf then									' if there is a buffer to load
'      get #8,wavepos,wavebuf(needbuf shl 14),$4000,qqq 		'
'      get #8,wavepos,wavebuf(needbuf shl 14),$4000,qqq 		'
   
   let aaaa=getct()
      get #8,wavepos,filebuf(0),$4000,qqq 		'
'   aaaa=getct()-aaaa: position 20,1: print aaaa /336  
      psram.write(addr(filebuf(0)), needbuf shl 14 ,$4000)
      needbuf=(needbuf+1) mod 16								' we can have any count of 4k buffers, now 2 used
      wavepos+=$4000      									' file position
      endif
    if qqq<>$4000 then 										' end of file
      do: currentbuf=lpeek(base) shr 20 : waitvbl: scope : bars : loop until currentbuf=(needbuf-1) mod 16				' wait until all buffers played					
      close #8 : waveplaying=0									' close the file, stop playing
      for i=0 to 7 : lpoke base+32*i+20,0 : next i 						' mute the sound
      filemove=1 : playnext=1							        	' experimental
    endif
end sub    



sub makedl
newdl(0)=559<<20+(0)<<16+%0001+ (0+(v.cpl1<<2)) <<4             
newdl(1)=v.buf_ptr<<4+%10  
for i=2 to 17: newdl(i)=$7000002+2*65536*(i-2) :next i
for i=18 to 32: newdl(i)=$7000002 : next i
v.dl_ptr=addr(newdl(0))
end sub


sub scrollinfo

if c>16 then 
  let from=(framenum mod (16*c+16))*256
  v.blit($40_720_000+from,0,0,255,255,256,$4000_0000+v.buf_ptr,744,144,1024)
endif  
end sub

'------ SID registers decoder borrowed here from SIDCog so it doesn't need to do this in the cog code ----- rev 20220408 ---------------

sub decoderegs(regaddr,outaddr)

'===========================================================
'   This is the code fragment moved here from SIDCog
'   to reduce SIDCog's loop processing time
'===========================================================
 
              cpu asm
              
              setq #6
              rdlong sidRegs0,regaddr
              
'===========================================================
'              Extract channel 1 register data
'===========================================================
              getword   frequency1, sidRegs0, #0
              getword   pulseWidth1, sidRegs0, #1
              shl       pulseWidth1, #20                    ' Shift in "12 bit" pulse width value( make it 32 bits )
              shl       frequency1, #9
'-----------------------------------------------------------
              getnib    selectedWaveform1, sidRegs1, #1
              getbyte   controlRegister1, sidRegs1,#0
'-----------------------------------------------------------
              getnib    r1, sidRegs1, #2
              alts      r1, #ADSRTable
              mov       decay1, 0-0
              getnib    r1, sidRegs1, #3
              alts      r1, #ADSRTable                      '|  Convert 4bit ADSR "presets" to their corresponding
              mov       attack1, 0-0                        '|  32bit values using the attack/decay table.
              getnib    r1, sidRegs1, #4
              alts      r1, #ADSRTable
              mov       release1, 0-0
              getnib    r1, sidRegs1, #5
              mov        sustain1,#0
              setnib    sustain1, r1, #7
              setnib    sustain1, r1, #6

'===========================================================
'              Extract channel 2 register data
'===========================================================
              getbyte   frequency2, sidRegs2, #0
              rolbyte   frequency2, sidRegs1, #3
              mov       pulseWidth2, sidRegs2 
              shr       pulseWidth2, #8
              zerox     pulseWidth2, #15
              shl       pulseWidth2, #20                    ' Shift in "12 bit" pulse width value( make it 32 bits )
              shl       frequency2, #9
'----------------------------------------------------------- 
              getnib    selectedWaveform2, sidRegs2, #7
              getbyte   controlRegister2,  sidRegs2, #3
'----------------------------------------------------------- 
              getnib    r1, sidRegs3, #0
              alts      r1, #ADSRTable
              mov       decay2, 0-0
              getnib    r1, sidRegs3, #1
              alts      r1, #ADSRTable                      '|  Convert 4bit ADSR "presets" to their corresponding
              mov       attack2, 0-0                        '|  32bit values using attack/decay tables. 
              getnib    r1, sidRegs3, #2           
              alts      r1, #ADSRTable
              mov       release2, 0-0
              getnib    r1, sidRegs3, #3
              mov       sustain2,#0
              setnib    sustain2, r1, #7
              setnib    sustain2, r1, #6

      
'===========================================================
'              Extract channel 3 register data
'===========================================================
              getword   frequency3, sidRegs3, #1
              getword   pulseWidth3, sidRegs4, #0
              shl       pulseWidth3, #20                    ' Shift in "12 bit" pulse width value( make it 32 bits )
              shl       frequency3, #9
'-----------------------------------------------------------
              getnib    selectedWaveform3, sidRegs4, #5
              getbyte   controlRegister3,  sidRegs4, #2
'-----------------------------------------------------------
              getnib    r1, sidRegs4, #6
              alts      r1, #ADSRTable
              mov       decay3, 0-0
              getnib    r1, sidRegs4, #7
              alts      r1, #ADSRTable                      '|  Convert 4bit ADSR "presets" to their corresponding
              mov       attack3, 0-0                        '|  32bit values using attack/decay tables.    
              getnib    r1, sidRegs5, #0
              alts      r1, #ADSRTable
              mov       release3, 0-0
              getnib    r1, sidRegs5, #1
              mov       sustain3,#0
              setnib    sustain3, r1, #7
              setnib    sustain3, r1, #6

'===========================================================
'            Extract filter/volume register data
'===========================================================
              getbyte   filterCutoff, sidRegs5, #2
              shl       filterCutoff, #2 ' was 3
              add       filterCutoff, #16
              getnib    filterControl, sidRegs5, #6
              getnib    filterResonance, sidRegs5, #7
              getnib    volume1, sidRegs6, #0 
              mov       volume2,volume1
              mov       volume3,volume1
              
              getnib    filterMode, sidRegs6, #1
              jmp 	#p999				   '| Jump over the variable block
              
'===========================================================
'            The variables
'===========================================================              
              

sidRegs0  		long 0
sidRegs1  		long 0
sidRegs2  		long 0
sidRegs3  		long 0
sidRegs4 		long 0
sidRegs5  		long 0
sidRegs6  		long 0
              
frequency1 		long 0
pulseWidth1		long 0
selectedWaveform1	long 0
controlRegister1 	long 0
attack1			long 0
decay1 			long 0
sustain1		long 0
release1 		long 0
volume1			long 0

frequency2 		long 0
pulseWidth2		long 0
selectedWaveform2	long 0
controlRegister2 	long 0
attack2			long 0
decay2 			long 0
sustain2		long 0
release2 		long 0
volume2			long 0

frequency3 		long 0
pulseWidth3		long 0
selectedWaveform3	long 0
controlRegister3 	long 0
attack3			long 0
decay3 			long 0
sustain3		long 0
release3 		long 0      
volume3			long 0

filterCutoff 		long 0
filterControl 		long 0
filterResonance 	long 0
filterMode 		long 0

r1 long 0

ADSRTable         	long 3784819
                    	long 1064480    
                    	long 540688
                    	long 358561  
                    	long 228613  
                    	long 154833   
                    	long 127578
                    	long 108828
                    	long 86896    
                    	long 34865
                    	long 17432   
                    	long 10896    
                    	long 8718   
                    	long 2906    
                    	long 1744    
                    	long 1090    
                    	
'===========================================================
'  Now write results and go away
'===========================================================                       	              

p999		        setq #30
          		wrlong frequency1,outaddr
   			
   			end asm
end sub   


dim xid6fields$(10) as string
'1:song name
'2 game title
'3 artist name
'4 dumper name
'5 dumped date
'6 emulator
'7 comments
'8 seconds to play
'9 fade

const XID6_FOURCC = $36646978

'---- end of test 

function getxidfield(f,a) as integer

let id=peek(f+$10208+a)
let t=peek(f+$10208+a+1)
let l=dpeek(f+$10208+a+2)
 
if (t=0) and (id=6) then 
  xid6fields$(6)=""
  if l=$30 then xid6fields$(6)="Unknown"
  if l=$31 then xid6fields$(6)="ZSNES"
  if l=$32 then xid6fields$(6)="Snes9x"
endif
if (t=1) and (((id>=1) and (id<=4)) or (id=7)) then
  xid6fields$(id)="" : for i=0 to l-1 : xid6fields$(id)= xid6fields$(id)+chr$(peek(f+$1020C+a+i)) : next i   
endif
if (t=4) and (id=5) then 
   xid6fields$(id)=decuns$(lpeek(f+$10208+a+4))
endif
if t=0 then return a+4
if t=1 then return a+l+4
if t=4 then return a+8
return -1
end function
  

function checkxid6(a) as integer
if lpeek(a+$10200)=XID6_FOURCC then 
  return 1
else
  return 0
end if
end function

function getxid6length(a) as integer
return lpeek(a+$10204) 
end function

sub printmeta(spcfile)

dim r as integer

v.box(725,60,1018,403,147)
v.setwritecolors($93,$9a)
position 184,4 : print "                                " 
position 184,4: print " ";filename$ :v.setwritecolors($9a,$93)                      ' test: module file name will be here
position 184,5 : print " SNES .spc file "

for i=1 to 10: xid6fields$(i)="" : next i
if checkxid6((spcfile))=1 then 
  let ll=getxid6length((spcfile)) 
'  print (" XID6 found, length ");ll
  let r=0 
   do: let r=getxidfield((spcfile),r) :  loop until (r>=ll) or (r=-1)
else
'  print(" XID6 not found")
endif


if xid6fields$(1)="" then 'song
  for i=0 to 31 : xid6fields$(1)=xid6fields$(1)+chr$(peek(spcfile+i+$2e)) : next i
endif
if xid6fields$(2)="" then 'game
  for i=0 to 31 : xid6fields$(2)=xid6fields$(2)+chr$(peek(spcfile+i+$4e)) : next i
endif
if xid6fields$(3)="" then 'artist
  for i=0 to 31 : xid6fields$(3)=xid6fields$(3)+chr$(peek(spcfile+i+$b1)) : next i
endif
if xid6fields$(4)="" then
  for i=0 to 15 : xid6fields$(4)=xid6fields$(4)+chr$(peek(spcfile+i+$6e)) : next i
endif
if xid6fields$(5)="" then
  for i=0 to 10 : xid6fields$(5)=xid6fields$(5)+chr$(peek(spcfile+i+$9e)) : next i
endif
if xid6fields$(6)="" then
  l=peek(spcfile+$D2) 
  xid6fields$(6)=""
  if l=$30 then xid6fields$(6)="Unknown"
  if l=$31 then xid6fields$(6)="ZSNES"
  if l=$32 then xid6fields$(6)="Snes9x" 
endif
if xid6fields$(7)="" then
  for i=0 to 31 : xid6fields$(7)=xid6fields$(7)+chr$(peek(spcfile+i+$7e)) : next i
endif
if xid6fields$(8)="" then
  for i=0 to 2 : xid6fields$(8)=xid6fields$(8)+chr$(peek(spcfile+i+$a9)) : next i
endif
if xid6fields$(9)="" then
  for i=0 to 4 : xid6fields$(9)=xid6fields$(9)+chr$(peek(spcfile+i+$ac)) : next i
endif
  
let px=184 : let py=7
v.setwritecolors(150,147) : if xid6fields$(1)<>"" then position px,py: print "Song title:       ": position px,py+1 :v.setwritecolors(154,147): print left$(xid6fields$(1),35) : py+=3
v.setwritecolors(150,147) : if xid6fields$(2)<>"" then position px,py: print "Game title:       ": position px,py+1 :v.setwritecolors(154,147): print left$(xid6fields$(2),35) : py+=3
v.setwritecolors(150,147) : if xid6fields$(3)<>"" then position px,py: print "Artist name:      ": position px,py+1 :v.setwritecolors(154,147): print left$(xid6fields$(3),35) : py+=3
v.setwritecolors(150,147) : if xid6fields$(7)<>"" then position px,py: print "Comments:         ": position px,py+1 :v.setwritecolors(154,147): print left$(xid6fields$(7),35) : py+=3
v.setwritecolors(150,147) : if xid6fields$(4)<>"" then position px,py: print "Dumper name:      ": position px+30,py :v.setwritecolors(154,147): print left$(xid6fields$(4),35) : py+=1
v.setwritecolors(150,147) : if xid6fields$(5)<>"" then position px,py: print "Dumped at:        ": position px,30+py :v.setwritecolors(154,147): print left$(xid6fields$(5),35) : py+=1
v.setwritecolors(150,147) : if xid6fields$(6)<>"" then position px,py: print "Emulator:         ": position px+30,py :v.setwritecolors(154,147): print left$(xid6fields$(6),35) : py+=1
v.setwritecolors(150,147) : if xid6fields$(8)<>"" then position px,py: print "Time:             ": position px+30,py :v.setwritecolors(154,147): print left$(xid6fields$(8),35); " s" : py+=1
v.setwritecolors(150,147) : if xid6fields$(9)<>"" then position px,py: print "Fade:             ": position px+30,py :v.setwritecolors(154,147): print left$(xid6fields$(9),35); " ms" : py+=1



end sub

' ----------------- Read and display SID file metadata, initialize the 6502 for playing the file  ------------------- rev 20220420 -----------------------------
 
sub sidopen()

dim i as integer
dim b as ubyte
dim cia as ulong

cpustop(a6502cog)												' stop the 6502

atitle=""													' clear info fields
author=""
copyright=""

get #8,5,version,1,r :    version=((version and 255) shl 8) or (version shr 8)      				' the file is already open: get info fields
get #8,7,offset,1,r  :    offset=(offset shl 8) or (offset shr 8) 						' these fields are big endian - what for? it's c64 low endian 6502 
get #8,9,load,1,r    :    load=(load shl 8) or (load shr 8)
get #8,11,init,1,r   :    init=(init shl 8) or (init shr 8) 
get #8,13,play,1,r   :    play=(play shl 8) or (play shr 8) 
get #8,15,songs,1,r  :    songs=(songs shl 8) or (songs shr 8)
get #8,17,startsong,1,r : startsong=(startsong shl 8) or (startsong shr 8) 
get #8,19,speed,1,r     
speed=speed shr 24+((speed shr 8) and $0000FF00) + ((speed shl 8) and $00FF0000) + (speed shl 24) 
get #8,23,ititle(0),32,r      
get #8,55,iauthor(0),32,r      
get #8,87,icopyright(0),32,r    
let offset1=offset

if version>1 then 												' if the version is 2 and load=0, the actual load field is at 125($7C) and is low endian
  get #8,119,flags,1,r : flags=(flags shl 8) or (flags shr 8)
  b=0 : if load=0 then b=1 : get #8,125,load,1,r  : let offset1=$7E
endif

for i=0 to 31 : atitle=atitle+chr$(ititle(i)): next i 								' convert bytes to strings
for i=0 to 31 : author=author+chr$(iauthor(i)) : next i   
for i=0 to 31 : copyright=copyright+chr$(icopyright(i)) : next i   

v.setwritecolors(147,154) 											' print the info
position 184,4 : print "                                " 
position 184,4:  print " ";filename$ :v.setwritecolors($9a,$93)                      
position 184,5  : v.write ("C64 .sid PSID file ")                ',178);
v.setwritecolors(150,147) : position 184,7 : v.write ("title:")
v.setwritecolors(154,147) : position 184,8:  v.write(atitle)
v.setwritecolors(150,147) : position 184,9 : v.write ("author:")
v.setwritecolors(154,147) : position 184,10:  v.write(author)
v.setwritecolors(150,147) : position 184,11 : v.write ("copyright:")
v.setwritecolors(154,147) : position 184,12:  v.write(copyright)
v.setwritecolors(150,147) : position 184,14 : v.write ("version:   "): v.setwritecolors(154,147) : v.write(v.inttohex(version,4))
v.setwritecolors(150,147) : position 184,15 : v.write ("offset:    "): v.setwritecolors(154,147) : v.write(v.inttohex(offset,4))
v.setwritecolors(150,147) : position 184,16 : v.write ("load:      "): v.setwritecolors(154,147) : v.write(v.inttohex(load,4))  
v.setwritecolors(150,147) : position 184,17 : v.write ("init:      "): v.setwritecolors(154,147) : v.write(v.inttohex(init,4))
v.setwritecolors(150,147) : position 184,18 : v.write ("play:      "): v.setwritecolors(154,147) : v.write(v.inttohex(play,4))
v.setwritecolors(150,147) : position 184,19 : v.write ("songs:     "): v.setwritecolors(154,147) : v.write(v.inttostr(songs))
v.setwritecolors(150,147) : position 184,20 : v.write ("startsong: "): v.setwritecolors(154,147) : v.write(v.inttostr(startsong))
v.setwritecolors(150,147) : position 184,21 : v.write ("speed:     "): v.setwritecolors(154,147) : v.write(v.inttohex(speed,8))
v.setwritecolors(150,147) : position 184,22 : v.write ("flags:     "): v.setwritecolors(154,147) : v.write(v.inttohex(flags,4))

pos=offset1+1													' FlexBasic file position starts at 1, why?
song=startsong-1												' they numbered songs from 1 while 6502 needs numbering from 0
a6502init													' prepare 6502 memory
a6502cog=a6502.start(a6502buf)											' start the 6502

do														' load the module
  get #8,pos,filebuf(0),128,r
  for i=0 to 127: poke addr(a6502buf(0))+load+i,filebuf(i) : next i 
  v.setwritecolors(122,114): position 4,24: print pos-1; " bytes loaded     "					' get 128 bytes and update file position
  pos+=r
  load+=r
loop until r<>128
close #8
a6502buf($DC04)=0: a6502buf($dc05)=0 										' clear C64 CIA register
jsr6502(song, init)												' call the initialization
waitms(1)													' wait for 6502 to finish it
cia=a6502buf($DC04)+256*a6502buf($DC05)										' read CIA value
v.setwritecolors(150,147) :position 184,23 :v.write ("cia:       ")  						' print it
v.setwritecolors(154,147) : v.write(v.inttohex(cia,4))		
sidfreq=50													' if there is 0 in CIA, use 50 Hz
siddelay=clkfreq/50  
if cia>0 then siddelay=clkfreq/((50*19652)/cia) : sidfreq=(50*19652)/cia					' else calculate the frequency from the CIA value
v.setwritecolors(150,147) :position 184,24  :v.write ("frequency: ")						' and print it
v.setwritecolors(154,147) : v.write(v.inttostr(sidfreq)): v.write(" Hz")
end sub       

'------------------------- Initialize 6502 memory for the player ----------------------------------------------- rev 20220420 ----------------------------

sub a6502init()

for i=0 to 65535 : a6502buf(i)=0 : next i									' clear the memory

a6502buf($fffc)= $80												' set the reset vector to $280
a6502buf($fffd)= $02

a6502buf($0200)= $AD  ' lda $0207										' the program at $200 calls the sub 			
a6502buf($0201)= $07  '												' load the acc value needed by the player
a6502buf($0202)= $02  
a6502buf($0203)= $20  ' jsr $0209, 										' the player will replace $0209 with the sid file init or play
a6502buf($0204)= $09  '
a6502buf($0205)= $02  '
a6502buf($0206)= $60  ' rts
a6502buf($0207)= 0
a6502buf($0208)= 0
a6502buf($0209)= $60  ' rts

a6502buf($0280)= $AD  ' lda $0208										' the main 6502 loop
a6502buf($0281)= $08												' check if there is 1 in $208
a6502buf($0282)= $02
a6502buf($0283)= $C9  ' cmp #$01
a6502buf($0284)= $01
a6502buf($0285)= $D0  ' bne $028F										' if not, repeat
a6502buf($0286)= $08												' if yes, the player wants to execute a procedure
a6502buf($0287)= $A9  ' lda #$00										' restore 0 in $208 
a6502buf($0288)= $00
a6502buf($0289)= $8D  ' sta $0208
a6502buf($028A)= $08
a6502buf($028B)= $02  
a6502buf($028C)= $20  ' jsr $0200										' call $200. This double call makes the process safer 
a6502buf($028D)= $00												' and allows to set the next call while the previous one is still running
a6502buf($028E)= $02
a6502buf($028F)= $4C  ' jmp $0280										' close the loop
a6502buf($0290)= $80
a6502buf($0291)= $02
end sub
 
'------------------------- Call a 6502 procedure at address with an acc ----------------------------------------------------------------- rev 20220420  
 
sub jsr6502(acc,addr)

a6502buf($0204)= (addr and $FF)											' set the procedure address in $204,205
a6502buf($0205)= addr >> 8
a6502buf($0207)= acc												' set the desired acc volume at $207
a6502buf($0208)= 1 												' tell the main 6502 loop to call the procedure
end sub 

'---------------------------------- THE END OF THE CODE ----------------------------------------------------------------

''-----------------------------------Trying to port the simple flac decoder ---------------------------------------------
sub flacopen


dim samplerate as ulong
dim numchannels as ulong
dim sampledepth as ulong
dim numsamples as ulong
dim magic as ulong
dim r as ulong
dim metahead as ulong
dim metalength,metatype,lastmeta,long1,long2 as ulong
dim flacsamplerate, flacchannels, flacdepth as ulong
dim meta as ulong
dim framehead as ushort
dim framecode as ubyte 

bitbuffer=0: bitbufferlen=0			
meta=0
pos=1
position 184,15
magic=readuint(32) : position 184,4 : print hex$(magic)
if magic<>$664C6143 then goto 9999


do
  lastmeta=readuint(1)
  metatype=readuint(7)
  metalength=readuint(24)
  if metatype<>0 then
    for i=0 to metalength-1: readuint(8) : next i
  else
    readuint(16)
    readuint(16)
    readuint(24)
    readuint(24)
    flacsamplerate=readuint(20)
    flacchannels=readuint(3)+1
    flacdepth=readuint(5)+1
    readuint(4)
    long2=readuint(32)
       position 184,9:  print "samples:",long2;"   "
       position 184,10: print "samplerate:",flacsamplerate
       position 184,11: print "channels:",flacchannels
       position 184,12: print "depth:",flacdepth
    for i=0 to 15: let q=readuint(8) : print hex$(q), : next i
  endif
  meta+=1
loop until lastmeta=1

9999 end sub


function decodeframe(channels,depth as ulong) as integer

dim temp,sync as integer

temp = readuint(8)
if r<>1 then return 0
sync = temp << 6 + readUint(6)
if (sync <> $3FFE) then return -1

readuint(1)
readuint(1)
let blockSizeCode = readuint(4)
let sampleRateCode = readuint(4)
let chanAsgn = readUint(4)
readUint(3)
readUint(1)
temp = readuint(8)
do while temp >= %11000000:
  readuint(8)
  temp = (temp shl 1) and 0xFF
loop  

if (blockSizeCode == 1) then
  let blockSize = 192
else if (blockSizeCode>=2 andalso blockSizeCode <= 5) then
  blockSize = 576 << (blockSizeCode - 2)
else if (blockSizeCode = 6) then
  blockSize = readUint(8) + 1
else if (blockSizeCode = 7) then
  blockSize = readUint(16) + 1
else if (blockSizeCode>=8 andalso blockSizeCode <= 15) then
  blockSize = 256 << (blockSizeCode - 8)
else
  return -2
endif
		
if (sampleRateCode = 12) then
  readUint(8)
else if (sampleRateCode == 13 orelse sampleRateCode == 14) then
  readUint(16)
endif
readUint(8)
  ' make 'samples array[numchannels][blocksize]		
 ' decodeSubframes(in, sampleDepth, chanAsgn, samples); 'TODO
		
alignToByte 
readUint(16)
		

'		for (int i = 0; i < blockSize; i++) {
'			for (int j = 0; j < numChannels; j++) {
'				int val = samples[j][i];
'				if (sampleDepth == 8)
'					val += 128;
'				writeLittleInt(sampleDepth / 8, val, out);
'			}
'		}
'		return true;
'	}
	

return 0

end function

/'

function decode_subframes(inp, blocksize, sampledepth, chanasgn) as integer

if chanasgn>=0 andalso chanasgn <= 7 then
  for ch = 0; ch < result.length; ch++)
				decodeSubframe(in, sampleDepth, subframes[ch]);


		return [decode_subframe(inp, blocksize, sampledepth) for _ in range(chanasgn + 1)]
	elif 8 <= chanasgn <= 10:
		temp0 = decode_subframe(inp, blocksize, sampledepth + (1 if (chanasgn == 9) else 0))
		temp1 = decode_subframe(inp, blocksize, sampledepth + (0 if (chanasgn == 9) else 1))
		if chanasgn == 8:
			for i in range(blocksize):
				temp1[i] = temp0[i] - temp1[i]
		elif chanasgn == 9:
			for i in range(blocksize):
				temp0[i] += temp1[i]
		elif chanasgn == 10:
			for i in range(blocksize):
				side = temp1[i]
				right = temp0[i] - (side >> 1)
				temp1[i] = right
				temp0[i] = right + side
		return [temp0, temp1]
	else:
		raise ValueError("Reserved channel assignment")


def decode_subframe(inp, blocksize, sampledepth):

	inp.read_uint(1)
	type = inp.read_uint(6)
	shift = inp.read_uint(1)
	if shift == 1:
		while inp.read_uint(1) == 0:
			shift += 1
	sampledepth -= shift
	
	if type == 0:  # Constant coding
		result = [inp.read_signed_int(sampledepth)] * blocksize
	elif type == 1:  # Verbatim coding
		result = [inp.read_signed_int(sampledepth) for _ in range(blocksize)]
	elif 8 <= type <= 12:
		result = decode_fixed_prediction_subframe(inp, type - 8, blocksize, sampledepth)
	elif 32 <= type <= 63:
		result = decode_linear_predictive_coding_subframe(inp, type - 31, blocksize, sampledepth)
	else:
		raise ValueError("Reserved subframe type")
	return [(v << shift) for v in result]

'/

dim bitbuffer,bitbufferlen as ulong 
dim temp as ubyte
dim result as ulong


function readuint(n as ulong) as ulong

do while bitbufferlen<n
  get #8,pos,temp,1,r: pos+=1
  bitbuffer=(bitbuffer shl 8) + temp
  bitbufferlen+=8
loop
bitbufferlen-=n
if n<32 then 
  result=(bitbuffer shr bitbufferlen) and ((1 shl n)-1) 
  bitbuffer=bitbuffer and ((1 shl bitbufferlen)-1)
else
  result=bitbuffer
  bitbuffer=0
endif  

return result
end function
  
	
sub alignToByte 
bitBufferLen -= bitBufferLen mod 8
end sub

''--------FLAC end 

' Semigraphic characters codes
' 3 hline 4 vline 5 T 6 up T 7 -| 8 |- 9rup 10 lup 11 rdown 12 ldown 13 cross

asm shared
balls1 file  "balls02.def"
balls2 file "balls06.def"
balls3 file "balls11.def"
balls4 file "balls14.def"
end asm
