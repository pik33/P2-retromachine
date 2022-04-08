
#include "retromachine.bi"

const HEAPSIZE = 8192
const version$="Prop2play v.0.25"
const statusline$=" Propeller2 wav/sid/mod player v. 0.25 --- 2022.04.08 --- pik33@o2.pl --- use a serial terminal or a RPi KBM interface to control --- arrows up,down move - pgup/pgdn or w/s move 10 positions - enter selects - tab switches panels - +,- controls volume - 1..4 switch channels on/off - 5,6 stereo separation - 7,8,9 sample rate - a,d SID speed - R rescans current directory ------"
const hubset350=%1_000001__00_0010_0010__1111_1011 '350_000_000 =31*44100
const hubset354=%1_110000__11_0110_1100__1111_1011 '354_693_878
const hubset356=%1_001010__00_1100_0011__1111_1011 '356_352_000 =29*256*48001,5673491
const hubset338=%1_111011__11_1111_0111__1111_1011 '338_666_667 =30*44100 
const hubset338a=%1_111010__11_1110_0110__1111_1011 '338_644_068 =30*44100 
const hubset336=%1_101101__11_0000_0110__1111_1011 '336_956_522 =paula*95

' Place graphics buffers at the top of memory so they will not move while editing the program
const base2=$72000
const infobuf_ptr=$7EE80
const graphicbuf_ptr=$77E80
const mainbuf_ptr=$73A70
const statusline_ptr=$738A8
const title_ptr=$73838
const dlcopy_ptr=$72c38
const scope_ptr=$72238
'const displayname_ptr=$72210		
'declare displayname alias $72210 as ubyte(40)

' global vars

dim displayname(39) as ubyte
dim displayname_ptr as ulong
dim oldtrigs(4) as ulong
dim pan(4)
dim sn$(32)
dim sl as ulong
dim filebuf(511) as ubyte
dim r as ulong
dim i,j,k,l,m,qqq as integer
dim ansibuf(3) as ubyte
declare mainstack alias $720B8 as ulong
dim filename$,filename2$,filename3$ as string
dim s1a,s1b,s21a,s21b,s31a,s31b,s41a,s41b,cog as integer
dim cc,qq1,qq2,framenum,e as ulong
dim dirnum1,dirnum2,dirnum3,filenum1,filenum2,filenum3,olddirnum1,oldfilenum1,filemove,modtime,time2 as integer
dim samples,panel,c,ma,mb,pos as ulong
dim currentdir$ as string
dim channelvol(4), channelpan(4) as integer
dim mainvolume, mainpan as integer
dim samplerate,wavepos,currentbuf as ulong
declare wavebuf alias $50000 as ubyte($20000)
dim newdl(32)

'declare filebuf alias $721B8 as ubyte(127)
'declare wavebuf2 alias $48000 as ubyte($28000)
dim modplaying,waveplaying,dmpplaying, needbuf,playnext as ubyte
dim scog as integer
dim dmppos as ulong
dim newcnt,bufptr,siddelay,scog2,sidfreq,sidtime as integer
dim sidpos,sidlen as ulong
dim stop as ulong

' ----------------------------Main program start ------------------------------------

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
waveplaying=0: modplaying=0 : dmpplaying=0
stop=0

mount "/sd", _vfs_open_sdcard()
chdir "/sd"
currentdir$="/sd/"
filemove=0

getlists(0)
ma=lomem()+1024 :  mb=ma 
pos=1

cog=-1
panel=0
s1a=0
samplerate=100   

'' --------------------------------- THE MAIN LOOP ----------------------------------------------------------------------------------

do
'  let bbbb=getct()-bbbb
'  position 1,1: v.write(v.inttostr2(bbbb/336,6))  
  waitvbl    
'  let bbbb=getct()                 									' synchronize with vblanks
  if cog=(-1) then framenum+=1  :  scrollstatus((framenum) mod (8*sl))                 		' if not playing module let main loop scroll the status line
  if cog>0 then displaysamples
  if cog>0 then scrollinfo
  scope	
'  position 0,0: print 1234											' display scope
for i=0 to 7: position 24*i ,0: v.write(v.inttostr2(sid.regs(i),10)) : next i
for i=0 to 7: position 24*i ,1: v.write(v.inttostr2(sid.regs(i+8),10)) : next i
for i=0 to 7: position 24*i ,2: v.write(v.inttostr2(sid.regs(i+16),10)) : next i

  bars												' display bars


'' --------------------------------  Playing the .wav file in the main loop as no other cogs can acces the file system

  if waveplaying=1 then
    getwave
  endif  
  
'' ------------------------------- End of wave playing   

'' ------------------------------- Display the playing time
  
  v.setwritecolors($29,$e1)
  if cog>(-1) then time2=framenum-modtime
  if waveplaying=1 then time2=(wavepos)/3528
  if dmpplaying=1 then time2=sidtime/200
  position 2*15,19: v.write(v.inttostr2(time2/180000,2)): v.write(":"):v.write(v.inttostr2((time2 mod 180000)/3000,2)):v.write(":"):v.write(v.inttostr2((time2 mod 3000)/50,2)):v.write(":"):v.write(v.inttostr2((time2 mod 50),2))
  position 2*15,20: v.write(v.inttostr2(lpeek(0),8))
'' ----------------------------- Get data from the keyboard
 
  if lpeek($30)<>0 then 									                         ' a Raspberry Pi based interface sent a message
    if peek($33)=$88 then  ansibuf(0)=ansibuf(1): ansibuf(1)=ansibuf(2) : ansibuf(2)=ansibuf(3) : ansibuf(3)=peek($31)   ' add it to the ANSI buffer
    lpoke $30,0 													 ' and clear the message
  endif  

  if lpeek($3c)<>0 then ansibuf(0)=ansibuf(1): ansibuf(1)=ansibuf(2) : ansibuf(2)=ansibuf(3) : ansibuf(3)=peek($3D): lpoke($3C,0) ' A serial interface at P62.63 from ANSI terminal
  
  if ansibuf(3)=asc("q") then let aaa=getct(): v.blit($40000000+v.buf_ptr,725,111,1018,403,1024,$40000000+v.buf_ptr,725,110,1024): ansibuf(3)=0 : let aaa=getct()-aaa: position 128,20: print aaa/336
  'v.box(725,60,1018,403,147)
  if ansibuf(3)=asc(" ") then stop=not stop: ansibuf(3)=0 
  'v.box(725,60,1018,403,147)
  
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
    sidfreq=sidfreq+50: if sidfreq>400 then sidfreq=400
    siddelay=clkfreq/sidfreq
    ansibuf(3)=0
  endif  
  
  if ansibuf(3)=asc("a") then 									' 7 - decrease the period
    sidfreq=sidfreq-50: if sidfreq<50 then sidfreq=50
    siddelay=clkfreq/sidfreq
    ansibuf(3)=0
  endif  
'   position 0,0: print 1235  
   
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
  v.setwritecolors($ca,$e1)
  position 2*3,22:  v.write("pan: "): v.write(v.inttostr2(mainpan/256,2))  								' display the status
  position 2*13,22: v.write("vol: "): v.write(v.inttostr2(mainvolume,3)) 
  position 2*24,22: v.write("chn: "): 
  if channelvol(0)=1 then position 2*29,22 :v.write("1")
  if channelvol(0)=0 then position 2*29,22 :v.write("-")
  if channelvol(1)=1 then position 2*31,22 :v.write("2")
  if channelvol(1)=0 then position 2*31,22 :v.write("-")
  if channelvol(2)=1 then position 2*33,22 :v.write("3")
  if channelvol(2)=0 then position 2*33,22 :v.write("-")
  if channelvol(3)=1 then position 2*35,22 :v.write("4")
  if channelvol(3)=0 then position 2*35,22 :v.write("-")   
  
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

    if lcase$(right$(filename$,3))="mod" then							' module file will be read into the hub ram
      if cog>0 then cpustop(cog): cog=-1								' stop playing the module
      if waveplaying=1 then waveplaying= 0: waitms(1000): close #8			        ' if wav file is playing, stop it
      if dmpplaying=1 then 
         dmpplaying= 0: waitms(20): close #8 : cpustop(scog) :cpustop(scog2) :scog=(-1):scog2=(-1)                  ' if wav file is playing, stop it
      endif
      if audiocog<1 then startaudio   
      for i=0 to 7 : lpoke base+32*i+20,0 : next i 						' mute the sound
      for i=ma to addr(mainstack)-4 step 4: lpoke i,0: next i  					' clean the RAM
      filename2$=currentdir$+filename$								' get a full filename with path
      mb=ma											' ma is approximate low mem address available
      open filename2$ for input as #4 : pos=1							' open the module
      do
        get #4,pos,filebuf(0),512,r : pos+=r	
        psram.write(addr(filebuf(0)),mb,512)	
        position 4,24: print pos; " bytes loaded     "					        ' get 128 bytes and update file position
        if mb<addr(mainstack) then for i=0 to r-1 : poke mb+i,filebuf(i) : next i 
        mb+=512					' move the buffer to the RAM and update RAM position. Todo: this can be done all at once

      loop until r<>512 ' orelse mb>=addr(mainstack)						' do until eof or end of available RAM
      close #4
      tracker.initmodule(ma,0)									' init the tracker player
      samples=15: if peek(ma+1080)=asc("M") and peek(ma+1082)=asc("K") then samples=31          ' get sample count
      getinfo(ma,samples)									' and information
      hubset(hubset336)										' set the main clock to Paula (PAL) * 100       
      samplerate=100 : lpoke base+28,$8000_005F: waitms(2): lpoke base+28,0   	   	        ' set the sample rate to standard Paula
      lpoke base+28+32,0 									' switch channel #1 to PSRAM after wav playing
      cog=cpu (mainloop, @mainstack) 								' start the playing
      modtime=framenum										' get the current frame # for displaying module time
      v.setwritecolors($ea,$e1)									' yellow
      position 2*2,17:v.write(space$(38)): filename2$=right$(filename2$,38) 			' clear the place for a file name
      position 2*2,17: v.write(filename2$)							' display the 'now playing' filename 
    endif
    
  if lcase$(right$(filename$,3))="wav" then  							' this is a wave file. Todo - read and use the header!
    if cog>0 then cpustop(cog)	: cog=-1								' if module playing, stop it
    if dmpplaying=1 then dmpplaying= 0: waitms(20): close #8 : cpustop(scog)                    ' if dmp file is playing, stop it
    if audiocog<1 then startaudio   
    for i=0 to 7 : lpoke base+32*i+20,0 : next i 						' mute the sound
    samplerate=256 : lpoke base+28,$80000100 : waitms(2) : lpoke base+28,$00000000             ' samplerate=clock/256 allows for HQ DAC
    hubset(hubset338)										' main clock=350 MHz, sample rate 1367187.5 Hz=31*44102.8 Hz - Todo: get a sample rate from a header and set it properly     
    filename3$=currentdir$+filename$								' get a filename with the path
    close #8: open filename3$ for input as #8: get #8,1,wavebuf(0),$4000 
    psram.write(addr(wavebuf(0)),0,$4000)          						' open the file and preload the buffer
    needbuf=1: currentbuf=0 :wavepos=$4001 : waveplaying=1   					' init buffering variables
    										                ' now init the driver. Todo: exact synchronization of stereo channels !!!!!
    lpoke base+12,0               								' loop start   
    lpoke base+16,$40000                                      					' loop end, we will use $50000 bytes as $50 4k buffers
    dpoke base+20,16384                                                                       ' set volume 
    dpoke base+22,16384                                                              		' set pan
    dpoke base+24,30 					                			' set period
    dpoke base+26, 4    									' set skip, 1 stereo sample=4 bytes
    lpoke base+28,$0000_0000

    lpoke base+32+12,0                 								' loop start   
    lpoke base+32+16,$40000                                       				' loop end
    dpoke base+32+20,16384                                                                      ' volume
    dpoke base+32+22,0     	                                                                ' pan
    dpoke base+32+24, 30                                                                        ' period
    dpoke base+32+26, 4    									' skip
    lpoke base+32+28,$0000_0000
    
'    lpoke base+8, addr(wavebuf(0)) or $c0000000  								' sample ptr, 16 bit, restart from 0 
'    lpoke base+32+8, addr(wavebuf(0))+2 or $c0000000							' sample ptr+2 (=another channel), synchronize #1 to #2
    lpoke base+8, $c0000000  								' sample ptr, 16 bit, restart from 0 
    lpoke base+32+8, $e0000002							         ' sample ptr+2 (=another channel), synchronize #1 to #2
  

    v.setwritecolors($ea,$e1)									' yellow
    position 2*2,17:v.write(space$(38)): filename3$=right$(filename3$,38) 		 	' clear the place for a file name
    position 2*2,17: v.write(filename3$)							        ' display the 'now playing' filename 
    endif  

  if lcase$(right$(filename$,3))="dmp" then  							' this is a wave file. Todo - read and use the header!
    if cog>0 then cpustop(cog)	: cog=-1								' if module playing, stop it
    if scog>0 then cpustop(scog): scog=-1
    if scog2>0 then cpustop(scog2): scog2=-1
    if waveplaying=1 then waveplaying= 0: waitms(100): close #8                                   ' if dmp file is playing, stop it
    if audiocog>0 then stopaudio    
   
    hubset(hubset336)										 
  
   
    filename3$=currentdir$+filename$								' get a filename with the path
    close #8: open filename3$ for input as #8: pos=1
    let psramptr=0 
    do
      get #8,pos,filebuf(0),512,r : pos+=r	
      psram.write(addr(filebuf(0)),psramptr,512)	
      position 4,24: print pos; " bytes loaded     "					        ' get 128 bytes and update file position
      psramptr+=512 					' move the buffer to the RAM and update RAM position. Todo: this can be done all at once
    loop until r<>512 '                          					' do until eof 
    close #8
    sidlen=psramptr
    dmpplaying=1   	
    sidpos=0
    v.setwritecolors($ea,$e1)									' yellow
    position 2*2,17:v.write(space$(38)): filename3$=right$(filename3$,38) 		 	' clear the place for a file name
    position 2*2,17: v.write(filename3$)	
					        ' display the 'now playing' filename 
    siddelay=336956522/50 : sidfreq=50 :sidtime=0
    for i=0 to 17: sid.regs(i)=0: next i
    scog=sid.start()
    scog2=cpu(sidloop,@mainstack)
    waitms(100)

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
       get #9,1+39*ii,displayname(0),38								' get the name
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
       get #9,1+39*ii,displayname(0),38								' get the name
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
       get #9,1+39*ii,displayname(0),38								' get the name
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
       get #9,1+39*ii,displayname(0),38								' get the name
        j=38 : do : j-=1 : loop until displayname(j)>32:  k=j 		     			        ' find the end of the nam
        v.box(368,(ii+4-filenum2)*16,712,(ii+4-filenum2)*16+15,34)
        position ((720+360-8*k-8)/8, ii+4-filenum2)
        if ii<filenum3 then for j=0 to k: v.write(chr$(displayname(j))) :next j
      next ii


'      for ii=filenum2 to filenum2+17 : get #9,1+39*ii,displayname(0),38 : displayname(38)=32	
'        j=38 : do : j-=1 : loop until displayname(j)>32:  k=j 
'        position 2*44,ii+2-filenum2: for j=0 to (39-k)/2-2: v.write(" ") : next j  
'        for j=0 to 39-(38-k)/2-1: v.write(chr$(displayname(j))) :next j
'      next ii
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
bdiv=64: if waveplaying then let bdiv=96 

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
if s1c<16 then lpoke v.palette_ptr+4*$b,$00110000*((s1c+16)/2)             ' green
if s1c>=16 then lpoke v.palette_ptr+4*$b,$00FF0000+(s1c-16)*$11000000	   ' green to yellow
if s1c>=32 then lpoke v.palette_ptr+4*$b,$FFFF0000-(s1c-32)*$00220000	   ' yellow to red
if s1c>=48 then lpoke v.palette_ptr+4*$b,$FF000000		           ' red

let s21c=s21b>>1
if s21c<16 then lpoke v.palette_ptr+4*$c,$00110000*((s21c+16)/2)           ' the same for the rest of channels
if s21c>=16 then lpoke v.palette_ptr+4*$c,$00FF0000+(s21c-16)*$11000000    ' using colors b,c,d,e from the palette
if s21c>=32 then lpoke v.palette_ptr+4*$c,$FFFF0000-(s21c-32)*$00220000
if s21c>=48 then lpoke v.palette_ptr+4*$c,$FF000000

let s31c=s31b>>1
if s31c<16 then lpoke v.palette_ptr+4*$d,$00110000*((s31c+16)/2)
if s31c>=16 then lpoke v.palette_ptr+4*$d,$00FF0000+(s31c-16)*$11000000
if s31c>=32 then lpoke v.palette_ptr+4*$d,$FFFF0000-(s31c-32)*$00220000
if s31c>=48 then lpoke v.palette_ptr+4*$d,$FF000000

let s41c=s41b>>1
if s41c<16 then lpoke v.palette_ptr+4*$e,$00110000*((s41c+16)/2)
if s41c>=16 then lpoke v.palette_ptr+4*$e,$00FF0000+(s41c-16)*$11000000
if s41c>=32 then lpoke v.palette_ptr+4*$e,$FFFF0000-(s41c-32)*$00220000
if s41c>=48 then lpoke v.palette_ptr+4*$e,$FF000000

for ii=0 to s1b:  v.fastline(540,571,554-ii,$0b) : next ii: for ii=s1b+1 to 120 :v.fastline(540,571,554-ii,16): next ii 'cc=$bbbbbbbb : for jj=270 to 278 step 4: lpoke graphicbuf_ptr+448*(59-ii)+jj,cc : next jj: next ii ' now draw these bars
for ii=0 to s21b: v.fastline(586,617,554-ii,$0c) : next ii: for ii=s21b+1 to 120:v.fastline(586,617,554-ii,16): next ii 'cc=$bbbbbbbb : for jj=270 to 278 step 4: lpoke graphicbuf_ptr+448*(59-ii)+jj,cc : next jj: next ii ' now draw these bars
for ii=0 to s31b: v.fastline(632,663,554-ii,$0d) : next ii: for ii=s31b+1 to 120:v.fastline(632,663,554-ii,16): next ii 'cc=$bbbbbbbb : for jj=270 to 278 step 4: lpoke graphicbuf_ptr+448*(59-ii)+jj,cc : next jj: next ii ' now draw these bars
for ii=0 to s41b: v.fastline(678,709,554-ii,$0e) : next ii: for ii=s41b+1 to 120:v.fastline(678,709,554-ii,16): next ii 'cc=$bbbbbbbb : for jj=270 to 278 step 4: lpoke graphicbuf_ptr+448*(59-ii)+jj,cc : next jj: next ii ' now draw these bars
'for ii=0 to s21b: 'cc=$cccccccc : for jj=286 to 294 step 4: lpoke graphicbuf_ptr+448*(59-ii)+jj,cc : next jj: next ii
'for ii=0 to s31b: 'cc=$dddddddd : for jj=302 to 310 step 4: lpoke graphicbuf_ptr+448*(59-ii)+jj,cc : next jj: next ii
'for ii=0 to s41b: 'cc=$eeeeeeee : for jj=318 to 326 step 4: lpoke graphicbuf_ptr+448*(59-ii)+jj,cc : next jj: next ii
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
  qq1=qq1/1024 : if qq1<2 then qq1=2 															          ' reduce from 17 to 6 bits		
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
 				 ' display current playing samples information
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
  psram.read1(addr(sid.oldregs(0)),sidpos,25)
  decoderegs(addr(sid.oldregs(0)),addr(sid.regs(0)))

    sidpos+=25
  if sidpos>=sidlen then sidpos=0
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

v.frame(4,240,358,404,15)							' clear the panel
v.box(5,241,357,259,232)							' clear the panel
v.box(5,260,357,403,225)							' clear the panel
v.outtextxycf(12,243,"Now playing",0)


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
dpoke base+26+32*channel, 1                                                                         ' set skip, always 1 here
end sub


'---------------- Get and display module information --------------------------

sub getinfo(ma,num)

v.box(725,60,1018,403,147)
v.setwritecolors($93,$9a)
position 184,4 : print "                        " 
position 184,4: print filename$ :v.setwritecolors($9a,$93)                      ' test: module file name will be here
position 184,5 : print "Amiga module: "; samples;" samples"
position 184,7 : for i=ma to ma+19 : print chr$(peek(i) mod 128); : next i      ' first 20 bytes of module=title
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
if c>16 then v.blit($40_720_000,0,0,255,255,256,$4000_0000+v.buf_ptr,736,144,1024)
if c<=16 then v.blit($40_720_000,0,0,255,16*c-1,256,$4000_0000+v.buf_ptr,736,144,1024)

end sub

'---------------- Display current samples and periods  using fast char output --- rev 20220205 ----------------------

sub displaysamples 

v.setwritecolors(170,162)
position 246,29:v.write(v.inttostr2(tracker.currperiod(0)+tracker.deltaperiod(0),3))
position 246,30:v.write(v.inttostr2(tracker.currperiod(1)+tracker.deltaperiod(1),3))
position 246,31:v.write(v.inttostr2(tracker.currperiod(2)+tracker.deltaperiod(2),3))
position 246,32:v.write(v.inttostr2(tracker.currperiod(3)+tracker.deltaperiod(3),3))

if tracker.currsamplenr(0)<=samples then position 184,29: v.write(sn$(tracker.currsamplenr(0))) 
if tracker.currsamplenr(1)<=samples then position 184,30: v.write(sn$(tracker.currsamplenr(1)))
if tracker.currsamplenr(2)<=samples then position 184,31: v.write(sn$(tracker.currsamplenr(2)))
if tracker.currsamplenr(3)<=samples then position 184,32: v.write(sn$(tracker.currsamplenr(3)))

end sub

'------------------ A status/help line fine horizontal scrolling --- rev 20220205 -------------------------------------------------------

sub scrollstatus(amount)

dim i as integer
for i=2 to 17: newdl(i)=$7000002+2*65536*(i-2)+amount<<4 :next i
end sub


'----------------- Prepare a custom displaylist for the player --- rev 20220205 ---------------------------------------------------------

sub getwave
    qqq=$4000											' one wave chunk to load, 4kB=27 ms
    currentbuf=lpeek(base) shr 14								' get a current playing 4k buffer# from the driver
    if needbuf<>currentbuf then									' if there is a buffer to load
'      get #8,wavepos,wavebuf(needbuf shl 14),$4000,qqq 		'
'      get #8,wavepos,wavebuf(needbuf shl 14),$4000,qqq 		'
   
   let aaaa=getct()
      get #8,wavepos,wavebuf(0),$4000,qqq 		'
'   aaaa=getct()-aaaa: position 20,1: print aaaa /336  
      psram.write(addr(wavebuf(0)), needbuf shl 14 ,$4000)
      needbuf=(needbuf+1) mod 16								' we can have any count of 4k buffers, now 2 used
      wavepos+=$4000      									' file position
      endif
    if qqq<>$4000 then 										' end of file
      do: currentbuf=lpeek(base) shr 14 : waitvbl: scope : bars : loop until currentbuf=(needbuf-1) mod 16				' wait until all buffers played					
      close #8 : waveplaying=0									' close the file, stop playing
      for i=0 to 7 : lpoke base+32*i+20,0 : next i 						' mute the sound
      for i=$28000 to $70FFC step 4: lpoke i,$00000000: next i                                  ' clear the ram
      filemove=1 : playnext=1										' experimental
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
  v.blit($40_720_000+from,0,0,255,255,256,$4000_0000+v.buf_ptr,736,144,1024)
endif  
end sub



sub decoderegs(regaddr,outaddr)
 
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
              mov       attack1, 0-0                          '|  32bit values using the attack/decay table.
              getnib    r1, sidRegs1, #4
              alts      r1, #ADSRTable
              mov       release1, 0-0
              getnib    r1, sidRegs1, #5
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
              mov       attack2, 0-0                          '|  32bit values using attack/decay tables. 
              getnib    r1, sidRegs3, #2           
              alts      r1, #ADSRTable
              mov       release2, 0-0
              getnib    r1, sidRegs3, #3
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
              mov       attack3, 0-0                          '|  32bit values using attack/decay tables.    
              getnib    r1, sidRegs5, #0
              alts      r1, #ADSRTable
              mov       release3, 0-0
              getnib    r1, sidRegs5, #1
              setnib    sustain3, r1, #7
              setnib    sustain3, r1, #6
'-----------------------------------------------------------

'===========================================================
'            Extract filter/volume register data
'===========================================================
              getbyte   filterCutoff, sidRegs5, #2
              shl       filterCutoff, #2 ' was 3
              add       filterCutoff, #16
              getnib    filterControl, sidRegs5, #6
              getnib    filterResonance, sidRegs5, #7
              getnib    volume, sidRegs6, #0 
              getnib    filterMode, sidRegs6, #1
              jmp #p999

sidRegs0  long 0
sidRegs1  long 0
sidRegs2  long 0
sidRegs3  long 0
sidRegs4  long 0
sidRegs5  long 0
sidRegs6  long 0


              
frequency1 		long 0
pulseWidth1		long 0
selectedWaveform1	long 0
controlRegister1 	long 0
attack1			long 0
decay1 			long 0
sustain1		long 0
release1 		long 0

frequency2 		long 0
pulseWidth2		long 0
selectedWaveform2	long 0
controlRegister2 	long 0
attack2			long 0
decay2 			long 0
sustain2		long 0
release2 		long 0

frequency3 		long 0
pulseWidth3		long 0
selectedWaveform3	long 0
controlRegister3 	long 0
attack3			long 0
decay3 			long 0
sustain3		long 0
release3 		long 0      

filterCutoff long 0
filterControl long 0
filterResonance long 0
filterMode long 0
volume long 0


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

p999

          setq #28
          wrlong frequency1,outaddr
   end asm
end sub   


'-----------------------------------------------------------------------------------------------------------------------
'----------------------------- The file cog ----------------------------------------------------------------------------
'-----------------------------------------------------------------------------------------------------------------------

'---------------------------------- THE END OF THE CODE ----------------------------------------------------------------

' Semigraphic characters codes
' 3 hline 4 vline 5 T 6 up T 7 -| 8 |- 9rup 10 lup 11 rdown 12 ldown 13 cross
