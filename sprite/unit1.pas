unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  retro;

type

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    Image1: TImage;
    procedure BitBtn1Click(Sender: TObject);
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
  luma16:cardinal ;
  fh:cardinal;


begin
fh:=filecreate('balls8.def') ;
for n:=0 to 15 do
  for y:=0 to 31 do
    for z:=0 to 1 do
    for x:=0 to 31 do
      begin
      idx:=1024*n+32*y+x;
 //     image1.canvas.pixels[x+32*n,y]:=balls[idx] ;
      luma:=((balls[idx] and $ff)*0.3+ ((balls[idx] shr 8) and $ff)*0.2+((balls[idx] shr 16) and $ff)*0.3)/256 ;
      luma16:=round(luma*16);

       image1.canvas.pixels[x+32*n,y]:=luma16 shl 4+luma16 shl 12+luma16 shl 20 ;
       if balls[idx]<>0  then luma16+=0 else luma16:=0  ;
       filewrite(fh,luma16,1);        filewrite(fh,luma16,1);

      end;
  fileclose(fh);
end;

end.

