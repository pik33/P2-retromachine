program Project1;

{$mode objfpc}{$H+}

uses
  GlobalConst,
  GlobalTypes,
  Platform,
  Threads,
  classes,
  Console,
  Framebuffer,
  BCM2835,
  BCM2708,
  SysUtils,
  Serial,
  fatfs,
  retrokeyboard,
  retromouse,
  dwcotg;

type
Tmouse= class(TThread)
private
protected
  procedure Execute; override;
public
 Constructor Create(CreateSuspended : boolean);
end;

TKeyboard= class(TThread)
private
protected
  procedure Execute; override;
public
 Constructor Create(CreateSuspended : boolean);
end;


var
 Count:LongWord;
 Character:Char;
 Characters:String;
 WindowHandle:TWindowHandle;

 akeyboard:tkeyboard;
 amouse:tmouse;
    mousereports:array[0..31] of TMouseReport;
    mousex,mousey,mousek:integer;
    xres:integer=1024;
    yres:integer=576;
    mousewheel:integer=128;
    mouseclick,mousedblclick:integer;
    key_release,key_modifiers,key_charcode,key_scancode:integer;
     kbdreport:       array[0..7] of byte;
    oldkr,oldkm,oldkc,oldks:integer;
    oldmx,oldmy,oldmk,oldmc,oldmd,oldmw:integer;
    b:byte ;

type TReport=array[0..3] of byte ;

var report:TReport;

procedure sendreport(report:TReport);

var i,b:byte;

begin
for i:=0 to 3 do
  begin
  b:=report[i];
  SerialWrite(@b,1,Count);
  end;
end;


 operator =(a,b:tmousereport):boolean;

 var i:integer;

 begin
 result:=true;
 for i:=0 to 7 do if a[i]<>b[i] then result:=false;
 end;
 constructor TMouse.Create(CreateSuspended : boolean);

 begin
 FreeOnTerminate := True;
 inherited Create(CreateSuspended);
 end;

 procedure TMouse.Execute;

 label p101,p102;

 var mb:tmousedata;
     i,j:integer;
     mi:cardinal;
     x,y,w:integer;
     m:TMouseReport;
     mousexy,buttons,offsetx,offsety,wheel:integer;
     const mousecount:integer=0;

 begin
 ThreadSetpriority(ThreadGetCurrent,5);
 threadsleep(1);
 mousetype:=0;
   repeat
     p102:
     repeat m:=getmousereport; threadsleep(2); until m[0]<>255;

     if (mousetype=1) and (m=mousereports[7]) and (m[0]=1) and (m[2]=0) and (m[3]=0) and (m[4]=0) and (m[5]=0) then goto p102; //ignore empty M1 records

     mousecount+=1;
     j:=0; for i:=0 to 7 do if m[i]<>0 then j+=1;
     if (j>1) or (mousecount<16) then
       begin
       for i:=0 to 7 do mouserecord[i]:=(m[i]);
       for i:=0 to 6 do mousereports[i]:=mousereports[i+1];
       mousereports[7]:=m;
       end;

     j:=0;
     for i:=0 to 6 do if mousereports[i,7]<>m[7]  then j+=1;
     for i:=0 to 6 do if mousereports[i,6]<>m[6]  then j+=1;
     for i:=0 to 6 do if mousereports[i,5]<>m[5]  then j+=1;
     for i:=0 to 6 do if mousereports[i,4]<>m[4]  then j+=1;
     for i:=0 to 6 do if (mousereports[i,2]>$F0) and (mousereports[i,3]=$FF) then j+=1;   // 16 bit mouse slowing run at x
     for i:=0 to 6 do if (mousereports[i,4]>$F0) and (mousereports[i,5]=$FF) then j+=1;   // 16 bit mouse slowing run at x
     if (j=0) then begin mousetype:=0; goto p101; end;

     j:=0;
     for i:=0 to 6 do begin j+=mousereports[i,1]; j+=mousereports[i,7]; end;
     for i:=0 to 6 do if (mousereports[i,3]<>$FF) and (mousereports[i,3]<>0) then j+=1;
     if j=0 then begin mousetype:=3; goto p101; end;

     for i:=0 to 6 do if mousereports[i,7]<>m[7] then mousetype:=m[0]; // 1 or 2

 p101:

     if mousetype=0 then  // most standard mouse type
        begin
        buttons:=m[0];
        offsetx:=shortint(m[1]);
        offsety:=shortint(m[2]);
        wheel:=shortint(m[3]);
        end
     else if mousetype=2 then  // the strange Logitech wireless 12-bit mouse
        begin
        buttons:=m[1];
        mousexy:=m[2]+256*(m[3] and 15);
        if mousexy>=2048 then mousexy:=mousexy-4096;
        if m[6]=0 then offsetx:=mousexy else offsetx:=0;
        mousexy:=m[4]*16 + m[3] div 16;
        if mousexy>=2048 then mousexy:=mousexy-4096;
        if m[6]=0 then offsety:=mousexy else offsety:=0;
        if ((m[7]=134) or (m[7]=198)) and (m[6]=0) and (m[1]=0) and (m[2]=0) and (m[3]=0) and (m[4]=0) then wheel:=shortint(m[5]) else wheel:=0;
        end
      else if mousetype=1 then
        begin
        buttons:=m[1];
        mousexy:=m[2]+256*(m[3] and 15);
        if mousexy>=2048 then mousexy:=mousexy-4096;
        offsetx:=mousexy;
        mousexy:=m[4]*16 + m[3] div 16;
        if mousexy>=2048 then mousexy:=mousexy-4096;
        offsety:=mousexy;
        wheel:=shortint(m[5]);
        end
     else if mousetype=3 then  // 16-bit mouse
        begin
        buttons:=shortint(m[0]);
        offsetx:=shortint(m[2]);
        offsety:=shortint(m[4]);
        wheel:=shortint(m[6]);
        end;
     x:=mousex+offsetx;
     if x<0 then x:=0;
     if x>(xres-1) then x:=xres-1;
     mousex:=x;
     y:=mousey+offsety;
     if y<0 then y:=0;
     if y>(yres-1) then y:=yres-1;
     mousey:=y;
     mousek:=Buttons and 255;
     if wheel<-1 then wheel:=-1;
     if wheel>1 then wheel:=1;
     w:=mousewheel+Wheel;
     if w<127 then w:=127;
     if w>129 then w:=129;
     mousewheel:=w;
   until terminated;
 end;

 // ---- TKeyboard thread methods --------------------------------------------------

 constructor TKeyboard.Create(CreateSuspended : boolean);

 begin
 FreeOnTerminate := True;
 inherited Create(CreateSuspended);
 end;


 procedure TKeyboard.Execute;

 // At every vblank the thread tests if there is a report from the keyboard
 // If yes, the kbd codes are poked to the system variables
 // $60028 - translated code
 // $60029 - modifiers
 // $6002A - raw code
 // This thread also tracks mouse clicks

 const rptcnt:integer=0;
       activekey:integer=0;
       olactivekey:integer=0;
       oldactivekey:integer=0;
       lastactivekey:integer=0;
       m:integer=0;
       c:integer=0;
       dblclick:integer=0;
       dblcnt:integer=0;
       clickcnt:integer=0;
       click:integer=0;

 var ch:TKeyboardReport;
     i,j:integer;
     keyrelease, found:integer;

 begin
 ThreadSetpriority(ThreadGetCurrent,5);
 threadsleep(1);
 for i:=0 to 7 do kbdreport[i]:=0;
 repeat
   sleep(20);

   if mousedblclick=2 then begin dblclick:=0; dblcnt:=0; mousedblclick:=0; end;
   if (dblclick=0) and (mousek=1) then begin dblclick:=1; dblcnt:=0; end;
   if (dblclick=1) and (mousek=0) then begin dblclick:=2; dblcnt:=0; end;
   if (dblclick=2) and (mousek=1) then begin dblclick:=3; dblcnt:=0; end;
   if (dblclick=3) and (mousek=0) then begin dblclick:=4; dblcnt:=0; end;

   inc(dblcnt); if dblcnt>10 then begin dblcnt:=10; dblclick:=0; end;
   if dblclick=4 then mousedblclick:=1 {else mousedblclick:=0};

   if mouseclick=2 then begin click:=2; clickcnt:=10; end;
   if (mousek=1) and (click=0) then begin click:=1; clickcnt:=0; end;
   inc(clickcnt); if clickcnt>10 then  begin clickcnt:=10; click:=2; end;
   if (mousek=0) then click:=0;
   if click=1 then mouseclick:=1 else mouseclick:=0;

  ch:=getkeyboardreport;

  if ch[7]<>255 then
    begin

 //   box(0,0,300,16,0); for i:=0 to 7 do outtextxy(i*32,0, inttostr(ch[i]),120);
 //   generate a key release events, too...
    keyrelease:=0;
    for i:=2 to 7 do
       begin
       if kbdreport[i]>3 then
         begin
         found:=0;
         for j:=2 to 7 do
           begin
           if ch[j]=kbdreport[i] then found:=1;
           end;
         if found=0 then keyrelease:=kbdreport[i];
         end;
       end;

    if keyrelease<>0 then key_release:=keyrelease;

    for i:=0 to 7 do kbdreport[i]:=ch[i];
    olactivekey:=lastactivekey;
    oldactivekey:=activekey;
    lastactivekey:=0;
    activekey:=0;
    if ch[0]>0 then begin m:=ch[0]; key_modifiers:=m; end else key_modifiers:=0;
    for i:=2 to 7 do if (ch[i]>3) and (ch[i]<255) then lastactivekey:=i;
    if (lastactivekey>olactivekey) and (lastactivekey>0) then begin rptcnt:=0; activekey:=ch[lastactivekey];  end
    else if (lastactivekey<olactivekey) then begin rptcnt:=0; activekey:=0; end
    else if (lastactivekey=olactivekey) and (lastactivekey>0) and (oldactivekey<>ch[lastactivekey]) then begin rptcnt:=0; activekey:=ch[lastactivekey]; end;
    if lastactivekey<2 then begin rptcnt:=0; activekey:=0; m:=0; end;
    c:=byte(translatescantochar(activekey,0));
    if (m and $22)<>0 then c:=byte(translatescantochar(activekey,1));
    if (m and $42)=$40 then c:=byte(translatescantochar(activekey,2));
    if (m and $42)=$42 then c:=byte(translatescantochar(activekey,3));
    end;

  if (c>2) then inc(rptcnt);

  if rptcnt>26 then rptcnt:=24 ;
  if (rptcnt=1) or (rptcnt=24) then
    begin
    key_charcode:=byte(c);
    key_scancode:=activekey mod 256;
    end;
 until terminated;
 end;



begin

amouse:=tmouse.create(true);
amouse.start;

akeyboard:=tkeyboard.create(true);
akeyboard.start;

startreportbuffer;
startmousereportbuffer;


WindowHandle:=ConsoleWindowCreate(ConsoleDeviceGetDefault,CONSOLE_POSITION_FULL,True);      //debug

if SerialOpen(1920000,SERIAL_DATA_8BIT,SERIAL_STOP_1BIT,SERIAL_PARITY_NONE,SERIAL_FLOW_NONE,0,0) = ERROR_SUCCESS then
  begin
  ConsoleWindowWriteLn(WindowHandle,'Serial device opened');

  Count:=0;
  Characters:='';

  while True do
    begin
    if oldmx<>mousex then
       begin
       oldmx:=mousex;
       report[0]:=$81; report[1]:=(mousex mod 128); report[2]:=(mousex div 128); report[3]:=$FF;
       sendreport(report);
       end;
    if oldmy<>mousey then
       begin
       oldmy:=mousey;
       report[0]:=$82; report[1]:=(mousey mod 128); report[2]:=(mousey div 128); report[3]:=$FF;
       sendreport(report);
       end;
    if mousewheel<>128 then
       begin
      // oldmw:=mousewheel;
       report[0]:=$83; report[1]:=(mousewheel mod 128); report[2]:=(mousewheel div 128); report[3]:=$FF;
       mousewheel:=128;
       sendreport(report);
       end;
    if oldmk<>mousek then
       begin
       oldmk:=mousek;
       report[0]:=$84; report[1]:=(mousek mod 128); report[2]:=(mousek div 128); report[3]:=$FF;
       sendreport(report);
       end;
    if mouseclick=1 then
       begin
       report[0]:=$85; report[1]:=1; report[2]:=0; report[3]:=$FF;
       sendreport(report);
       mouseclick:=2;
       end;
    if mousedblclick=1 then
       begin
       mousedblclick:=2;
       report[0]:=$86; report[1]:=1; report[2]:=0; report[3]:=$FF;
       sendreport(report);
       end;
    if key_release<>0 then
       begin
       report[0]:=$87; report[1]:=key_release; report[2]:=0; report[3]:=$FF;
       key_release:=0;
       sendreport(report);
       end;
    if key_scancode<>0 then
       begin
       report[0]:=$88; report[1]:=key_scancode; report[2]:=key_charcode; report[3]:=$FF;
       sendreport(report);
       key_scancode:=0;
       end;
    if key_modifiers<>oldkm then
       begin
       oldkm:=key_modifiers;
       report[0]:=$89; report[1]:=key_modifiers mod 128; report[2]:=key_modifiers div 128; report[3]:=$FF;
       sendreport(report);
       end;
      end;
    end;


//     SerialRead(@Character,SizeOf(Character),Count);

end.
