unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  StdCtrls, retro;

type

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    Button1: TButton;
    Button2: TButton;
    Image1: TImage;
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.BitBtn1Click(Sender: TObject);

var n,x,y,z,idx:cardinal;
  luma:double;
  luma16,chroma:cardinal ;
  fh:cardinal;
  filename:string;

begin
for z:=0 to 15 do
begin
filename:='balls'+inttohex(z,2)+'def' ;
fh:=filecreate(filename) ;
for n:=0 to 15 do
  for y:=0 to 31 do
 //   for z:=0 to 1 do
    for x:=0 to 31 do
      begin
      idx:=1024*n+32*y+x;
 //     image1.canvas.pixels[x+32*n,y]:=balls[idx] ;
      luma:=((balls[idx] and $ff)*0.3+ ((balls[idx] shr 8) and $ff)*0.2+((balls[idx] shr 16) and $ff)*0.3)/256 ;
      luma16:=round(luma*16);
       if (balls[idx] and $FF)<>(balls[idx] shr 16) then chroma:=16*z else chroma:=0;
       image1.canvas.pixels[x+32*n,y]:=luma16 shl 4+luma16 shl 12+luma16 shl 20 ;
       if balls[idx]<>0  then luma16+=0 else luma16:=0  ;
       luma16+=chroma;
       filewrite(fh,luma16,1);    //    filewrite(fh,luma16,1);

      end;
  fileclose(fh);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);


var i,j,fh:integer;
begin
  fh:=filecreate('amigafont.def');
  for i:=0 to 255 do
    for j:=0 to 15 do
     filewrite(fh,amigafont[i,j],1);
  fileclose(fh);
end;

procedure TForm1.Button2Click(Sender: TObject);

var n,x,y,z,idx:cardinal;
  luma:double;
  luma16,chroma:cardinal ;
  fh:cardinal;
  filename:string;

begin

filename:='mouse.def' ;
fh:=filecreate(filename) ;

for y:=0 to 31 do
    for x:=0 to 31 do
      begin
      idx:=32*y+x;
      luma:=((mysz[idx] and $ff)*0.3+ ((mysz[idx] shr 8) and $ff)*0.2+((mysz[idx] shr 16) and $ff)*0.3)/256 ;
      luma16:=round(luma*16);
      if mysz[idx]<>0  then luma16+=0 else luma16:=0  ;
      filewrite(fh,luma16,1);    //    filewrite(fh,luma16,1);
      end;
fileclose(fh);
end;

end.

