
#include "retromachine.bi"

const HEAPSIZE = 8192
const version$="Prop2play v.0.22"
const statusline$=" Propeler2 wav/sid/mod player v. 0.22 --- 2022.03.13 --- pik33@o2.pl --- use serial terminal or RPi KBM interface to control --- arrows up,down move - pgup/pgdn or w/s move 10 positions - enter selects - tab switches panels - +,- controls volume - 1..4 switch channels on/off - 5,6 stereo separation - 7,8,9 sample rate - a,d SID speed - R rescans current directory ------"
const hubset350=%1_000001__00_0010_0010__1111_1011 '350_000_000 =31*44100
const hubset354=%1_110000__11_0110_1100__1111_1011 '354_693_878
const hubset356=%1_001010__00_1100_0011__1111_1011 '356_352_000 =29*256*48001,5673491
const hubset338=%1_111011__11_1111_0111__1111_1011 '338_666_667 =30*44100 
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
'dim filebuf(127) as ubyte
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
declare wavebuf alias $28000 as ubyte($48000)
declare filebuf alias $721B8 as ubyte(127)
'declare wavebuf2 alias $48000 as ubyte($28000)
dim modplaying,waveplaying,dmpplaying, needbuf,playnext as ubyte
dim scog as integer
dim dmppos as ulong
dim newcnt,bufptr,siddelay,scog2,sidfreq,sidtime as integer


' ----------------------------Main program start ------------------------------------

channelvol(0)=1 : channelvol(1)=1 : channelvol(2)=1 : channelvol(3)=1    
mainvolume=127 : mainpan=2048  ' vol: 1..128..(255)  pan 0 (mono)..8192 (full)
startmachine
startpsram
startvideo
startaudio
v.cursoroff
makedl
lpoke addr(sl),len(statusline$)  ' cannot assign to sl, but still can lpoke :) 
framenum=0
for i=0 to 3 : oldtrigs(i)=0 : next i
pan(0)=8192-mainpan : pan(1)=8192+mainpan : pan(2)=8192+mainpan : pan(3)=8192-mainpan
preparepanels
waveplaying=0: modplaying=0 : dmpplaying=0


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
  waitvbl                     									' synchronize with vblanks
  if cog=(-1) then framenum+=1  :  scrollstatus((framenum) mod (8*sl))                 		' if not playing module let main loop scroll the status line
  scope												' display scope
  bars												' display bars
  
  if ansibuf(3)=asc("d") then ansibuf(3)=0: demo

'' --------------------------------  Playing the .wav file in the main loop as no other cogs can acces the file system
 
  if waveplaying=1 then
    qqq=$1000											' one wave chunk to load, 4kB=27 ms
    currentbuf=lpeek(base) shr 12								' get a current playing 4k buffer# from the driver
    if needbuf<>currentbuf then									' if there is a buffer to load
      get #8,wavepos,wavebuf((needbuf) shl 12),$1000,qqq 					' then load it
      needbuf=(needbuf+1) mod $48  								' we can have any count of 4k buffers, now 2 used
      wavepos+=$1000      									' file position
      endif
    if qqq<>$1000 then 										' end of file
      do: currentbuf=lpeek(base) shr 12 : loop until currentbuf=needbuf				' wait until all buffers played					
      close #8 : waveplaying=0									' close the file, stop playing
      for i=0 to 7 : lpoke base+32*i+20,0 : next i 						' mute the sound
      for i=$28000 to $70FFC step 4: lpoke i,$00000000: next i                                  ' clear the ram
      filemove=1 : playnext=1										' experimental
    endif
  endif  
  
'' ------------------------------- End of wave playing   

'' --------------------------------  Playing the .dmp file in the main loop as no other cogs can acces the file system
 
  if dmpplaying=1 then
    qqq=250											' one wave chunk to load, 4kB=27 ms
    currentbuf=(bufptr-$28000)/250								' get a current playing 4k buffer# from the driver
    if needbuf<>currentbuf then									' if there is a buffer to load
      get #8,dmppos,wavebuf(needbuf*250),250,qqq 					' then load it
      needbuf=(needbuf+1) mod $50  								' we can have any count of 4k buffers, now 2 used
      dmppos+=250   								         	' file position
      endif
    if qqq<>250 then 										' end of file
      do: currentbuf=(bufptr-$28000)/250 : loop until currentbuf=needbuf				' wait until all buffers played					
      close #8 : dmpplaying=0									' close the file, stop playing
'      for i=0 to 7 : lpoke base+32*i+20,0 : next i 						' mute the sound
      for i=$28000 to $70FFC step 4: lpoke i,$00000000: next i                                  ' clear the ram
'      filemove=1 : playnext=1										' experimental
      cpustop(scog) : scog=-1
      cpustop(scog2) :scog2=-1
    endif
  endif      
 
'' ------------------------------- End of dmp playing   

'' ------------------------------- Display the playing time
  
  v.setwritecolors($29,$e1)
  if cog>(-1) then time2=framenum-modtime
  if waveplaying=1 then time2=(wavepos)/3528
  if dmpplaying=1 then time2=sidtime/200
  position 15,17: v.write(v.inttostr2(time2/180000,2)): v.write(":"):v.write(v.inttostr2((time2 mod 180000)/3000,2)):v.write(":"):v.write(v.inttostr2((time2 mod 3000)/50,2)):v.write(":"):v.write(v.inttostr2((time2 mod 50),2))
  position 15,18: v.write(v.inttostr2(lpeek(0),8))
'' ----------------------------- Get data from the keyboard
 
  if lpeek($30)<>0 then 									                         ' a Raspberry Pi based interface sent a message
    if peek($33)=$88 then  ansibuf(0)=ansibuf(1): ansibuf(1)=ansibuf(2) : ansibuf(2)=ansibuf(3) : ansibuf(3)=peek($31)   ' add it to the ANSI buffer
    lpoke $30,0 													 ' and clear the message
  endif  

  if lpeek($3c)<>0 then ansibuf(0)=ansibuf(1): ansibuf(1)=ansibuf(2) : ansibuf(2)=ansibuf(3) : ansibuf(3)=peek($3D): lpoke($3C,0) ' A serial interface at P62.63 from ANSI terminal
  
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
  position 3,19:  v.write("pan: "): v.write(v.inttostr2(mainpan/256,2))  								' display the status
  position 13,19: v.write("vol: "): v.write(v.inttostr2(mainvolume,3)) 
  position 24,19: v.write("chn: "): 
  if channelvol(0)=1 then position 29,19 :v.write("1")
  if channelvol(0)=0 then position 29,19 :v.write("-")
  if channelvol(1)=1 then position 31,19 :v.write("2")
  if channelvol(1)=0 then position 31,19 :v.write("-")
  if channelvol(2)=1 then position 33,19 :v.write("3")
  if channelvol(2)=0 then position 33,19 :v.write("-")
  if channelvol(3)=1 then position 35,19 :v.write("4")
  if channelvol(3)=0 then position 35,19 :v.write("-")   
  
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
     v.setwritecolors($29,$22)									' display currentdir$ in the file panel
     position 44,0: v.write(string$(38,chr$(3)))
     position 44,0: v.write(left$(currentdir$,38))
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
        get #4,pos,filebuf(0),128,r : pos+=r	
        psram.write(addr(filebuf(0)),mb,128)	
        position 1,16: print mb					        ' get 128 bytes and update file position
        if mb<addr(mainstack) then for i=0 to r-1 : poke mb+i,filebuf(i) : next i 
        mb+=128 					' move the buffer to the RAM and update RAM position. Todo: this can be done all at once

      loop until r<>128 ' orelse mb>=addr(mainstack)						' do until eof or end of available RAM
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
      position 2,15:v.write(space$(38)): filename2$=right$(filename2$,38) 			' clear the place for a file name
      position 2,15: v.write(filename2$)							' display the 'now playing' filename 
    endif
    
  if lcase$(right$(filename$,3))="wav" then  							' this is a wave file. Todo - read and use the header!
    if cog>0 then cpustop(cog)									' if module playing, stop it
    if dmpplaying=1 then dmpplaying= 0: waitms(20): close #8 : cpustop(scog)                    ' if dmp file is playing, stop it
    if audiocog<1 then startaudio   
    for i=0 to 7 : lpoke base+32*i+20,0 : next i 						' mute the sound
    samplerate=256 : lpoke base+28,$80000100 : waitms(2) : lpoke base+28,$40000000             ' samplerate=clock/256 allows for HQ DAC
    hubset(hubset338)										' main clock=350 MHz, sample rate 1367187.5 Hz=31*44102.8 Hz - Todo: get a sample rate from a header and set it properly     
    filename3$=currentdir$+filename$								' get a filename with the path
    close #8: open filename3$ for input as #8: get #8,1,wavebuf(0),$1000			' open the file and preload the buffer
    needbuf=1: currentbuf=0 :wavepos=$1001 : waveplaying=1   					' init buffering variables
      										                ' now init the driver. Todo: exact synchronization of stereo channels !!!!!
    lpoke base+12,0               								' loop start   
    lpoke base+16,$48000                                      					' loop end, we will use $50000 bytes as $50 4k buffers
    dpoke base+20,16384                                                                       ' set volume 
    dpoke base+22,16384                                                              		' set pan
    dpoke base+24,30 					                			' set period
    dpoke base+26, 4    									' set skip, 1 stereo sample=4 bytes

    lpoke base+32+12,2                 								' loop start   
    lpoke base+32+16,$48000                                       				' loop end
    dpoke base+32+20,16384                                                                      ' volume
    dpoke base+32+22,0     	                                                                ' pan
    dpoke base+32+24, 30                                                                        ' period
    dpoke base+32+26, 4    									' skip
    lpoke base+32+28,$4000_0000
    
    lpoke base+8, $28000 or $c0000000  								' sample ptr, 16 bit, restart from 0 
    lpoke base+32+8, $28002 or $c0000000							' sample ptr+2 (=another channel), it is now 44 clocks delayed and the phase is random. Todo: synchronizing command in the driver
    v.setwritecolors($ea,$e1)									' yellow
    position 2,15:v.write(space$(38)): filename3$=right$(filename3$,38) 		 	' clear the place for a file name
    position 2,15: v.write(filename3$)							        ' display the 'now playing' filename 
    endif  

  if lcase$(right$(filename$,3))="dmp" then  							' this is a wave file. Todo - read and use the header!
    if cog>0 then cpustop(cog)	: cog=-1								' if module playing, stop it
    if scog>0 then cpustop(scog): scog=-1
    if scog2>0 then cpustop(scog2): scog2=-1
    if waveplaying=1 then waveplaying= 0: waitms(100): close #8                                   ' if dmp file is playing, stop it
    if audiocog>0 then stopaudio    
   
    hubset(hubset336)										 
  

    filename3$=currentdir$+filename$								' get a filename with the path
    close #8: open filename3$ for input as #8:      		                        	' open the file and preload the buffer
    close #8: open filename3$ for input as #8: get #8,1,wavebuf(0),250			        ' open the file and preload the buffer
    needbuf=1: currentbuf=0 :dmppos=251: dmpplaying=1   	
    
    v.setwritecolors($ea,$e1)									' yellow
    position 2,15:v.write(space$(38)): filename3$=right$(filename3$,38) 		 	' clear the place for a file name
    position 2,15: v.write(filename3$)	
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
      if dirnum1>=dirnum3 then dirnum1=dirnum3-1 : goto 199 						' dirnum1 has to be less than all directories count. If it is, nothing more to do, go to the end of this part     
      if dirnum1<=9 then highlight(0,olddirnum1,0) : highlight(0,dirnum1,1) : goto 199                  ' only highlight changed, change the highlighted entry and go away
      dirnum1=9	: v.setwritecolors($c9,$c1)    							        ' if we are still here, the highlight is at the bottom of the panel
      close #9 : open currentdir$+"dirlist.txt" for input as #9   					' and the new entry has to be read from the file, so open it
      for ii=dirnum2-9 to dirnum2									' read and display directory names from the file
        get #9,1+39*ii,displayname(0),38 : displayname(38)=32								' get the name
        j=38 : do : j-=1 : loop until displayname(j)>32:  k=j 		     			        ' find the end of the name
        position 2,ii+2-dirnum2+9: for j=0 to (39-k)/2-2: v.write(" ") : next j                         ' clear the space before the centered name
        for j=0 to 39-(38-k)/2-1: v.write(chr$(displayname(j))) :next j					' display the name and spaces after it
      next ii
      close #9
      highlight(0,dirnum1,1) 										' highlight the selected entry         
    endif    

    if panel=1 then											' 1 - file panel
      oldfilenum1=filenum1										' remember current
      filenum1+=filemove  										' highlighting
      filenum2+=filemove  										' file
      if filenum2>=filenum3 then filenum2=filenum3-1            					' filenum2 has to be less than all files count
      if filenum1>=filenum3 then filenum1=filenum3-1 : goto 199 					' filenum1 has to be less than all files count, if not, go away     
      if filenum1<=17 then highlight(1,oldfilenum1,0) : highlight(1,filenum1,1) : goto 199              ' only highlight changed, go away
      filenum1=17 : v.setwritecolors($29,$22)  								' we are at the bottom now
      close #9 : open currentdir$+"filelist.txt" for input as #9                                        ' so do the same as in dir panel
      for ii=filenum2-17 to filenum2: get #9,1+39*ii,displayname(0),38: displayname(38)=32		' except we have now 18 slots
        j=38 : do : j-=1 : loop until displayname(j)>32: k=j 
        position 44,ii+2-filenum2+17: for j=0 to (39-k)/2-2: v.write(" ") : next j  
        for j=0 to 39-(38-k)/2-1: v.write(chr$(displayname(j))) :next j
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
      dirnum1=0 : v.setwritecolors($c9,$c1)  							        ' dirnum1 negative, read data from the file
      close #9 : open currentdir$+"dirlist.txt" for input as #9     				        ' do the same stuff as in dir panel down			
      for ii=dirnum2 to dirnum2+9 : get #9,1+39*ii,displayname(0),38: displayname(38)=32	
        j=38 : do : j-=1 : loop until displayname(j)>32:  k=j 
        position 2,ii+2-dirnum2: for j=0 to (39-k)/2-2: v.write(" ") : next j  
        if ii<dirnum3 then for j=0 to 39-(38-k)/2-1: v.write(chr$(displayname(j))) :next j
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
      filenum1=0 : v.setwritecolors($29,$22)  
      close #9 : open currentdir$+"filelist.txt" for input as #9   
      for ii=filenum2 to filenum2+17 : get #9,1+39*ii,displayname(0),38 : displayname(38)=32	
        j=38 : do : j-=1 : loop until displayname(j)>32:  k=j 
        position 44,ii+2-filenum2: for j=0 to (39-k)/2-2: v.write(" ") : next j  
        for j=0 to 39-(38-k)/2-1: v.write(chr$(displayname(j))) :next j
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


s1=abs(s1-32768)				' compute the amplitude
if s1>=s1a then s1a=s1				' if bigger than average, replace average with amplitude (the bar goes up fast)
if s1<s1a then s1a=(15*s1a+s1)/16		' else decay slowly
s1b=s1a/128 :if s1b<0 then s1b=0		' but not less than 0
if s1b>52 then s1b=52				' and no more than 52 to fit in the panel

s21=abs(s21-32768)				' channel 2
if s21>s21a then s21a=s21
if s21<s21a then s21a=(15*s21a+s21)/16
s21b=s21a/128 :if s21b<0 then s21b=0
if s21b>52 then s21b=52

s31=abs(s31-32768)				' channel 3
if s31>s31a then s31a=s31
if s31<s31a then s31a=(15*s31a+s31)/16
s31b=s31a/256 :if s31b<0 then s31b=0
if s31b>52 then s31b=52

s41=abs(s41-32768)				' channel 4
if s41>s41a then s41a=s41
if s41<s41a then s41a=(15*s41a+s41)/16
s41b=s41a/128 :if s41b<0 then s41b=0
if s41b>52 then s41b=52

if s1b<16 then lpoke v.palette_ptr+4*$b,$00110000*((s1b+16)/2)             ' green
if s1b>=16 then lpoke v.palette_ptr+4*$b,$00FF0000+(s1b-16)*$11000000	   ' green to yellow
if s1b>=32 then lpoke v.palette_ptr+4*$b,$FFFF0000-(s1b-32)*$00220000	   ' yellow to red
if s1b>=48 then lpoke v.palette_ptr+4*$b,$FF000000		           ' red

if s21b<16 then lpoke v.palette_ptr+4*$c,$00110000*((s21b+16)/2)           ' the same for the rest of channels
if s21b>=16 then lpoke v.palette_ptr+4*$c,$00FF0000+(s21b-16)*$11000000    ' using colors b,c,d,e from the palette
if s21b>=32 then lpoke v.palette_ptr+4*$c,$FFFF0000-(s21b-32)*$00220000
if s21b>=48 then lpoke v.palette_ptr+4*$c,$FF000000

if s31b<16 then lpoke v.palette_ptr+4*$d,$00110000*((s31b+16)/2)
if s31b>=16 then lpoke v.palette_ptr+4*$d,$00FF0000+(s31b-16)*$11000000
if s31b>=32 then lpoke v.palette_ptr+4*$d,$FFFF0000-(s31b-32)*$00220000
if s31b>=48 then lpoke v.palette_ptr+4*$d,$FF000000

if s41b<16 then lpoke v.palette_ptr+4*$e,$00110000*((s41b+16)/2)
if s41b>=16 then lpoke v.palette_ptr+4*$e,$00FF0000+(s41b-16)*$11000000
if s41b>=32 then lpoke v.palette_ptr+4*$e,$FFFF0000-(s41b-32)*$00220000
if s41b>=48 then lpoke v.palette_ptr+4*$e,$FF000000

for ii=0 to s1b:  cc=$bbbbbbbb : for jj=270 to 278 step 4: lpoke graphicbuf_ptr+448*(59-ii)+jj,cc : next jj: next ii ' now draw these bars
for ii=0 to s21b: cc=$cccccccc : for jj=286 to 294 step 4: lpoke graphicbuf_ptr+448*(59-ii)+jj,cc : next jj: next ii
for ii=0 to s31b: cc=$dddddddd : for jj=302 to 310 step 4: lpoke graphicbuf_ptr+448*(59-ii)+jj,cc : next jj: next ii
for ii=0 to s41b: cc=$eeeeeeee : for jj=318 to 326 step 4: lpoke graphicbuf_ptr+448*(59-ii)+jj,cc : next jj: next ii
end sub

'' ---------------------------------------- Oscilloscope ----------------------------------------------------------------------------------------------

sub scope

dim ii as integer

for jj=3136 to 26432 step 448: for ii=4 to 328 step 4: lpoke graphicbuf_ptr+ii+jj,0 :next ii : next jj                                                            ' clear the panel
qq1=dpeek(scope_ptr):qq1+=dpeek(scope_ptr+2) 										                                          ' try to trigger the scope at zero					
var iii=1: do : var oldqq1=qq1: qq1=dpeek(scope_ptr+4*iii):qq1+=dpeek(scope_ptr+4*iii+2) : iii+=1: loop until iii>=128  orelse (oldqq1<65536 andalso qq1>65536)   ' if not succeed with first 128 of 640 samples, there is no samples left for triggering
for ii=iii to iii+511 																		  ' display 512 samples																	
  qq1=dpeek(scope_ptr+4*ii)																	  ' left	
  qq1+=dpeek(scope_ptr+4*ii+2)																	  ' right
  qq1=qq1/2048 : if qq1<7 then qq1=7 															          ' reduce from 17 to 6 bits		
  if qq1>59 then qq1=59																		  ' clip to fit in the panel
  qq2=1+abs(32-qq1)/2 : if qq2>7 then qq2=7															  ' compute the color
  putpixel4(ii-iii+16,qq1,qq2)																	  ' and plot the pixel
next ii 
end sub
			    
'' -------------------------------------- Fast putpixel for the 4bpp graphic panel

sub putpixel4(x,y,c) 

var b=peek(graphicbuf_ptr+448*y+(x shr 1))					' get byte = 2 pixels
b=b and not(%1111<<((x mod 2)<<2))						' clear the nibble
b=b or (c<<((x mod 2)<<2))							' and set a new value
poke graphicbuf_ptr+448*y+(x>>1),b						' then put it back to the framebuffer
end sub

'' -------------------------------------- Module playing loop in its own cog  ------------------------  rev 20220205 ---------------------------------

sub mainloop

do
  tracker.tick							 ' let the player compute new values
  waitvbl                                                        ' wait vor vblank
  for mi=0 to 3 : setchannel(mi,oldtrigs(mi)) : next mi          ' this line has to be vblk syynchronized as much as possible - set new values in audio driver
  framenum+=1							 ' frame number to track time					
  movedl							 ' vertical fine scroll the file info panel via DL 
  scrollstatus((framenum) mod (8*sl))				 ' horizontal fine scroll the help/status line
  displaysamples						 ' display current playing samples information
loop
end sub

'' -------------------------------------- SID DMP playing loop in its own cog  ------------------------  rev 20220302 ---------------------------------


sub sidloop

dim i as integer

newcnt=getcnt()+177000000
bufptr=$28000
do
  waitcnt(newcnt)
  sidtime+=siddelay/(336_96) ' 100 us tick
  newcnt+=siddelay
  for i=0 to 24: sid.regs(i)=peek(bufptr) : bufptr+=1 : next i
  if bufptr>=$28000+$50*250 then bufptr=$28000
loop
end sub

'' -------------------------------------- Get a dir and file list after change a directory --------------------------------------------------------------

sub getlists(mode)

dim e,i as integer

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
  end while
  close #5										
  goto 350
endif

if e=0 then 										' now the directory list exists
  i=1
  v.setwritecolors($c8,$c1)
  for  i=1 to 11: position 2,i : print space$(38) : next i  				' clear the directory panel
  i=2
  do
    input #5,filename$									' write first 10 entries to the panel
    filename2$=rtrim$(filename$)
    filename2$=space$((38-len(filename2$))/2)+filename2$
    if i<12 then position 2,i : v.write(filename2$) 
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
  end while
  goto 400
endif
    
if e=0 then ' file list exists
  v.setwritecolors($29,$22)
  for i=1 to 19: position 44,i : print space$(38) : next i  
  i=2
  do
    input #5,filename$
    filename2$=rtrim$(filename$)
    filename2$=space$((38-len(filename2$))/2)+filename2$
    if i<20 then position 44,i : v.write(filename2$) 
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

sub highlight(hpanel,hpos,hhigh)								' panel 0 dir, 1 file, high0 = off, 1 - on

var hq1=8+42*4*hpanel										' compute x offset for the panel
var hq2=mainbuf_ptr+(2+hpos)*84*4                                                               ' compute adderss + y offset
if hpanel=0 andalso hhigh=1 then var hq3=$c1c80000						' determine colors
if hpanel=0 andalso hhigh=0 then hq3=$c8c10000
if hpanel=1 andalso hhigh=1 then hq3=$22290000
if hpanel=1 andalso hhigh=0 then hq3=$29220000
for hi=0 to 37: lpoke hq1+hq2+hi*4,((lpeek(hq1+hq2+hi*4) and $FFFF) or hq3 ): next hi           ' and change colors 
end sub


' ---------------- Prepare the user interface --- rev 20220206 ---------------------------------------------------

sub preparepanels

' 1. Channel and oscilloscope panel at graphic canvas

v.s_buf_ptr=graphicbuf_ptr						' tell the driver to operate on the graphics buffer
v.s_cpl=112								' char per line
v.s_lines=64								' lines				
v.putpixel=v.p4								' set putpixel function to 4 bpp							
v.font_family=2								' Atari 8 bit 8x8 font
v.box(0,0,895,63,0)							' clear the panel
v.frame(675,3,892,60,15)						' draw a box
v.frame(676,3,891,60,15)
outtext48(86,0," Channels ",15)						' print a header
v.buf_ptr=mainbuf_ptr
v.frame(3,3,668,60,15)							' repeat for oscilloscope
v.frame(4,3,667,60,15)
outtext48(2,0," Oscilloscope ",15)
v.draw(16,32,655,32,14)                                                 ' cannot use "line"

' 2 File info scrolling panel

v.s_buf_ptr=infobuf_ptr                                                                                                       'set display variables to info buffer
v.s_lines=40
v.s_cpl=28
v.s_buflen=40*28
cls($9a,$93) 
poke infobuf_ptr, 10: poke infobuf_ptr+4,3 : for i=13 to 26:poke infobuf_ptr+4*i,3 : next i : poke infobuf_ptr+4*i,9           'Upper line with semigraphic frame
poke infobuf_ptr+39*28*4, 12: for i=1 to 26 : poke infobuf_ptr+39*28*4+i*4,3 :  next i : poke infobuf_ptr+39*28*4+4*i,11       'Lower (#39, but displayed at #20 via DL) semigraphic frame
for i=1 to 38: poke infobuf_ptr+112*i,4:  poke infobuf_ptr+112*i+108,4: next i                                                 'Left and right semigraphic
position 3,0 : print "File info"                                                                                               'Header

' 3 Directories, files and now playing on the main panel

v.s_buf_ptr=mainbuf_ptr
v.s_lines=21
v.s_cpl=84
v.s_buflen=21*84
cls($c8,$c1)                                                                                                                    'clear the buffer and make it green
for i=0 to 20: for j=42 to 83:  lpoke mainbuf_ptr+4*(84*i+j), $29220020 :next j : next i					'red for files
for i=13 to 20: for j=0 to 41:  lpoke mainbuf_ptr+4*(84*i+j), $EAE10020 :next j : next i                                        'yellow for playing timer
poke mainbuf_ptr, 10: for i=1 to 40:poke mainbuf_ptr+4*i,3 : next i : poke mainbuf_ptr+4*i,9                                    'Upper line with semigraphic frame
poke mainbuf_ptr+12*84*4, 12: for i=1 to 40 : poke mainbuf_ptr+12*84*4+i*4,3 :  next i : poke mainbuf_ptr+12*84*4+4*i,11        'Lower semigraphic frame
for i=1 to 11: poke mainbuf_ptr+84*4*i,4:  poke mainbuf_ptr+(84*4)*i+41*4,4: next i                                             'Left and right semigraphic
position 2,0 : print " Directories "                                                                                            'Header

poke mainbuf_ptr+42*4, 10: for i=1 to 40:poke mainbuf_ptr+42*4+4*i,3 : next i : poke mainbuf_ptr+42*4+4*i,9                   
poke mainbuf_ptr+42*4+20*84*4, 12: for i=1 to 40 : poke mainbuf_ptr+42*4+20*84*4+i*4,3 :  next i : poke mainbuf_ptr+42*4+20*84*4+4*i,11       
for i=1 to 19: poke mainbuf_ptr+42*4+84*4*i,4:  poke mainbuf_ptr+42*4+(84*4)*i+41*4,4: next i                                                  
v.setwritecolors($29,$22): position 44,0 : print " Files "                                                                     

poke mainbuf_ptr+13*84*4, 10: for i=1 to 40 : poke mainbuf_ptr+13*84*4+i*4,3 : next i : poke mainbuf_ptr+13*84*4+4*i,9            
poke mainbuf_ptr+20*84*4, 12: for i=1 to 40 : poke mainbuf_ptr+20*84*4+i*4,3 : next i : poke mainbuf_ptr+20*84*4+4*i,11       
for i=14 to 19: poke mainbuf_ptr+84*4*i,4:  poke mainbuf_ptr+(84*4)*i+41*4,4: next i                                                 
v.setwritecolors($ea,$e1) : position 2,13 : print " Now playing "                                                                    
                                 
v.setbordercolor2(v.getpalettecolor(113))											' dark blue border
lpoke v.palette_ptr+4,lpeek(v.palette_ptr+4*202)										' colors for the scope
lpoke v.palette_ptr+8,lpeek(v.palette_ptr+4*218)
lpoke v.palette_ptr+12,lpeek(v.palette_ptr+4*234)
lpoke v.palette_ptr+16,lpeek(v.palette_ptr+4*250)
lpoke v.palette_ptr+20,lpeek(v.palette_ptr+4*26)
lpoke v.palette_ptr+24,lpeek(v.palette_ptr+4*42)
lpoke v.palette_ptr+28,lpeek(v.palette_ptr+4*58)

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

v.s_buf_ptr=infobuf_ptr        					              ' set display variables to info buffer
v.s_lines=40
v.s_cpl=28
v.s_buflen=40*28
v.setwritecolors($9a,$93)
for i=1 to 38: position 1,i : print space$(26): next i 
v.setwritecolors($93,$9a)
position 2,2 : print "                        " 
position 2,2: print filename$ :v.setwritecolors($9a,$93)                      ' test: module file name will be here
position 2,3 : print "Amiga module: "; samples;" samples"
position 2,5 : for i=ma to ma+19 : print chr$(peek(i) mod 128); : next i      ' first 20 bytes of module=title
for i=0 to 31: sn$(i)=space$(22) :next i
c=0
for i=1 to num
  for j=0 to 21
    var a=lpeek(addr(sn$(i)))
    var b=(peek(ma+20+30*(i-1)+j))
    if b>=32 then poke a+j,b : c=i ' c will be the last named sample
  next j
next i
for i=1 to c: position 2,i+5 :print sn$(i) :next i
v.s_buf_ptr=mainbuf_ptr
v.s_lines=21
v.s_cpl=84
v.s_buflen=21*84'print

end sub


''------------ Fast character output on 4bpp graphic canvas - reduce time 19x comparing to high level spin code --- rev 20220205 ---------

'----------- text output

sub outtext48(x,y, s$ as string ,c)

for i=0 to len(s$)-1
putchar48(graphicbuf_ptr,112,x+i,y,peek(addr(s$(0))+i),v.font_ptr+2048,15)
next i
end sub

'----------- Single char output

sub putchar48(buf,cpl,x,y,char,font,c)

dim q,i,b,r  as ulong


asm
          mov i,#7
       
p101      mov b,char
          shl b,#3
          add b,font
          add b,i
          rdbyte b,b
          mergeb b
          getword q,b,#1
          mul b,c
          mul q,c
          setword b,q,#1
          mov q,y
          add q,i
          mul q,cpl
          shl q,#2
          add q,buf
          mov r,x
          shl r,#2
          add q,r
          wrlong b,q
          djnf i,#p101
   
end asm

end sub

'---------------- Display current samples and periods  using fast char output --- rev 20220205 ----------------------

sub displaysamples 


outtext48(108,20,v.inttostr2(tracker.currperiod(0)+tracker.deltaperiod(0),3),15)
outtext48(108,28,v.inttostr2(tracker.currperiod(1)+tracker.deltaperiod(1),3),15)
outtext48(108,36,v.inttostr2(tracker.currperiod(2)+tracker.deltaperiod(2),3),15)
outtext48(108,44,v.inttostr2(tracker.currperiod(3)+tracker.deltaperiod(3),3),15)

outtext48(86,20,sn$(tracker.currsamplenr(0)),15) 
outtext48(86,28,sn$(tracker.currsamplenr(1)),15)
outtext48(86,36,sn$(tracker.currsamplenr(2)),15)
outtext48(86,44,sn$(tracker.currsamplenr(3)),15)

end sub

'------------------ A status/help line fine horizontal scrolling --- rev 20220205 -------------------------------------------------------

sub scrollstatus(amount)

dim i as integer
lpoke statusline_ptr, peek(addr(statusline$(0))+(0+amount/8) mod sl)+$71710000
lpoke statusline_ptr+4,peek(addr(statusline$(0))+(1+amount/8) mod sl)+$71710000
lpoke statusline_ptr+4*112, peek(addr(statusline$(112))+(112+amount/8) mod (0))+$71710000
lpoke dlcopy_ptr+4*729, %0000_0000_0000_0000_0000_0000_0101_0011 + (((amount mod 8)+8) shl 8) 
for i=2 to 111 : lpoke statusline_ptr+4*i, peek(addr(statusline$(0))+(i+(amount/8)) mod sl)+$77710000: next i
end sub

'------------------ A display list vertical scrolling of file info screen  --- rev 20220205 --------------------------------------------

sub movedl

dim i,j as integer

for i=0 to 14 
  for j=0 to 15  
     lpoke dlcopy_ptr+4*(200+32*i+2*j+0), ((infobuf_ptr+560+112*((i+((framenum+j) /16)) mod (c+2)))  shl 14)+ %0000_0001_1100_1111+(0 shl 4) + ((j+framenum) mod 16) shl 12
   next j
next i

end sub  

'----------------- Prepare a custom displaylist for the player --- rev 20220205 ---------------------------------------------------------

sub makedl

' Make colors 0 and 15 blue-green for the graphics part of the screen

'dltest=v.dl_ptr
var palettetest=v.palette_ptr
lpoke palettetest,lpeek(palettetest+161*4)
lpoke palettetest+15*4,lpeek(palettetest+168*4)

' Prepare the title
var i=0
var address=addr(version$(0))
for i=0 to 27: lpoke title_ptr+4*i,$77710000 : next i
var start=(28-len(version$)) / 2
for i=start to start+len(version$)-1: lpoke title_ptr+4*i,$77710000+peek(address+i-start): next i

' clear the display list

for i=0 to 767: lpoke dlcopy_ptr+4*i,0 : next i

' First 4 lines = 0 for upper border over the title
' then a big title, 32 lines in 4x horizontal, 2x vertical zoom

for i=0 to 15
  for j=0 to 1
    lpoke dlcopy_ptr+4*(4+2*i+j),(title_ptr shl 12)+%10_0000_0000_00_01+(i shl 8)
  next j
next i  

' lines 36 to 42 empty, then 21 lines (= 21*16 screen lines and 21*32 DL entries) of 8x16 text with split screen - 84 chars from mainbuf, 28 from infobuf

address=mainbuf_ptr
var address2=infobuf_ptr

for i=0 to 20
  if i=20 then address2=infobuf_ptr+39*28*4 'display line 39 here
  for j=0 to 15
     lpoke dlcopy_ptr+4*(40+32*i+2*j+0),(address2 shl 14)+ %0000_0001_1100_1111+(0 shl 4) + j shl 12
     lpoke dlcopy_ptr+4*(40+32*i+2*j+1),(address shl 12)+ (j shl 8) + (i shl 2) + 1
  next j
  address=address+84*4
  address2=address2+28*4
next i
  
' Live change registers have to be cleared now

lpoke dlcopy_ptr+4*714, %0000_0000_0000_0000_0000_1111_1111_1111 

' Next 6 lines empty, over the graphic part
' We will use repeat command for this

lpoke dlcopy_ptr+4*721, %0000_1000_0000_0001_0001_1100_0000_0111   ' repeat 128, every second line add 448 (=2x vertical zoom)
'lpoke dlcopy_ptr+4*721, graphicbuf_ptr shl 12 +%00_0000_0000_1010  ' graphic line with 4bpp
lpoke dlcopy_ptr+4*722, graphicbuf_ptr shl 12 +%00_0000_0000_1010  ' graphic line with 4bpp

' 6 empty lines under the graphic lines. 2 lines before status/help line enable the horizontal fine scroll

lpoke dlcopy_ptr+4*728, %0000_0000_0000_0000_0001_0000_0101_0011

' scrolling help line, using repeat 

lpoke dlcopy_ptr+4*730, %0000_0001_0000_1111_0000_0000_0000_0111          ' repeat 16
lpoke dlcopy_ptr+4*731, (statusline_ptr+4) shl 12+ %00_0000_0000_0001     ' text line

lpoke dlcopy_ptr+4*732, %0000_0000_0000_0000_0001_0000_0101_0011          ' reset horizontal scroll to 0

' the rest of DL are zero
' Now tell the driver wheere is a new DL

v.dl_ptr=dlcopy_ptr 
end sub

'-----------------------------------------------------------------------------------------------------------------------
'----------------------------- The file cog ----------------------------------------------------------------------------
'-----------------------------------------------------------------------------------------------------------------------

sub demo()

dim scog, r,b, dp as integer

scog=sid.start()
dp=1
open "/sd/dmp/Alloyrun.dmp" for input as #8
do
  get #8,dp,sid.regs(0),25,r
  dp+=25
  waitms(20)
loop until r<>25
close #8
cpustop(scog)
end sub

'---------------------------------- THE END OF THE CODE ----------------------------------------------------------------

' Semigraphic characters codes
' 3 hline 4 vline 5 T 6 up T 7 -| 8 |- 9rup 10 lup 11 rdown 12 ldown 13 cross
