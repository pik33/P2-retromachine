'********************************************************************************************
' Nostalgic displaylisted HDMI for P2 Retromachine
' Version 0.31 alpha -20220118
' 1 cog,text and graphics with or without border, 8x16 selectable and redefinable font
' The P2 Retromachine version - 960x540 

' (c) 2012-2021 Piotr Kardasz pik33@o2.pl
' MIT license
'
' Available functions:
'
'- font functions
'
'pub setfontnum(afontnum) - set a font offset. To be removed in the next version
'pub defchar(fn,ch,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15) - redefine a character
'
'- cursor functions
'
'pub cursoron() - switch the cursor on
'pub cursoroff() - switch the cursor off
'pub setcursorpos(x,y) - set the (x,y) position of cursor
'pub setcursorshape(shape) - define a cursor shape (0-full..15-line)
'
'- vblank functions
'
'pub waitvbl(amount) - wait for start of vblank. Amount=delay in framesi
'pub waitvblend(amount) - wait for end of vblank. Amount=delay in frames
'
'- color functions
'
'pub getvgacolor(color) - get a palette color number of VGA DOS color
'pub setscreencolors(ff,bb) - set font and back colors for all screen - from 256 color palett
'pub setbordercolors(r,g,b) - set border color for all screen - rgb
'pub setcharcolor(x,y,c) - set the color for the character at line y and position x
'pub setbackcolor(x,y,c) - set the background color at line y and position x
'pub setbordercolor(line,r,g,b) - set the border color, o is upper border, lines+1 is lower border
'pub setwritecolors(ff,bb) - set colors for putchar, write and writeln
'pub setcolor(c,r,g,b) -set color #c in palette to r,g,b
'
'- text functions
'
'pub cls(fc,bc) - clear the screen, set its foreground/background color
'pub putcharxy(x,y,achar) - cutput a char at x,y, don't change colors and cursor position
'pub putcharxyc(x,y,achar,f,b) - output a char at x,y and colors f,b, don't change a cursor position
'pub outtextxy(x,y,text) - output a string at position x,y without changing colors and cursor position
'pub outtextxyc(x,y,text,f,b) - output a string at position x,y and colors b,f without changing a cursor position
'pub putchar(achar) - output a char at the cursor position, move the cursor
'pub write(text) - output a string at the cursor position, move the cursor
'pub writeln(text) - output a string at the cursor position x,y, move the cursor to the next line
'pub scrollup() - scroll the screen one line up
'pub scrolldown() - scroll the screen one line down
'pub crlf() - set cursor at the first character in a new line, scroll if needed
'pub bksp() - backspace. Move the cursor back, clear a character
'
'- converting
'
'pub inttostr(i) - convert a integer to dec string, return a pointer
'pub inttohex(i,d) - convert unsigned integer to hex string with d digits, return a pointer
'
' - Starting and mode setting
'
'pub setmode(mode) - set the graphics mode
'pub start(mode,base) - start the driver with graphics mode 'mode' at pins 'base'
'
'***************************************************************************************************

 

' We use 200*Atari 8bit / 100*Paula / 50*classic Amiga clock and 960x540 in PAL based 50 Hz modes, 848x480 in NTSC based 60 Hz modes
' Modes can be bordered or borderless. Bordered modes are 896x496 50 Hz and 800x480 60 Hz
' There is also classic Atari/Amiga mode for emulation using 160x Atari 8bit clock. 768x576 50 Hz or 768x480 60 Hz, 912 pixel per line  

' Clocks: 

' 354_689_500   200x Atari 8-bit PAL,  50x Amiga PAL  - real settings: 49,869-> 354_693_878  - 1.0000123 
' 357_954_500   200x Atari 8-bit NTSC, 50x Amiga NTSC - real settings: 49,877-> 357_959_184  - 1.0000131 

' 319_220_550   180x PAL  - real settings: 51,814-> 319_215_686 - 0.9999848 
' 322_159_050   180x NTSC - real settings: 37,596-> 322_162_162 - 1.0000097 

' 283_751_600   160x PAL  - real settings: 64,908-> 283_750_000 - 0.9999944 
' 286_363_600   160x NTSC - real settings: 22,315-> 286_363_636 - 1.0000001 

' Mode setting

' The mode number can be calculated from its bitfield: gf_ab_cc_vv_hh
' g - 1: graphics mode, 0: character mode
' f - 0: 50 Hz, 1: 60 Hz
' a - 0: standard mode, 1 - retrocomputer compatibility mode 
' b - 1: borderless, 0: with border
' cc - color depth for graphics mode - 1/2/4/8 bpp. Text mode is always 256 colors unless I write something else
' vv - vertical zoom 1/2/4/8 x
' hh - horizontal zoom, 1/2/4 x - for 8bpp modes also 8x zoom is available

' This driver doesn't use a "mode" for the display: the mode set procedure generates a display list for it.
' This means a lot of custom modes can be generated and a lot of effects can be done.
' It is possible to mix bordered and borderless lines, set the size of up/down borders, etc. 

' The driver starts to display the frame by reading the first DL entry and interpret this.
' Then it reads the next entry, interprets, etc, until all screen lines defined in the mode are displayed.

' A standard display list entry:

' - display the character mode line: %aaaa_aaaa_aaaa_aaaa_aazz_nnnn_llll_ll_01 
'    aaaa_aaaa_aaaa_aaaa_aa00 - address of the display data, aligned to long
'    zz - zoom (horizontal, vertical zoom is done by repeating the same line) 00-1x, 01 - 2x, 10 - 4x, 11 - blank line 
'    nnnn - font line # 
'    llllll - character line #. This is used to place a "hardware" blinking text cursor.
 
' - display the graphics line: aaaa_aaaa_aaaa_aaaa_aazz_rrrr_rrrr_cc_10
'    aaaa_aaaa_aaaa_aaaa_aa00 - address of the display data, aligned to long
'    zz - zoom (horizontal, vertical zoom is done by repeating the same line)
'    r - reserved, now unused bits
'    cc - color depth, 1/2/4/8 bpp

' - extended entry:

'' - repeat                 %nnnn_nnnn_nnnn_qqqq_mmmm_mmmm_mmmm_0111    repeat the next dl line n times, after q lines add offset m (works)
'' TODO, planned:
'' - reload palette         %mmmm_mmmm_nnnn_nnnn_qqqq_qqqq_qqqq_1011    reload n palette entries from m color from palette_ptr+q
'' - set border color       %rrrr_rrrr_gggg_gggg_bbbb_bbbb_0001_0011    set border to rgb
'' - set border color       %0000_0000_0000_0000_pppp_pppp_0001_1011    set border color to palette entry #p
'' - set fine hscroll       %0000_0000_0000_0000_000s_pppp_0001_1111    set the horizontal fine scroll, +- 15 px, I don't know if doable at all 

' Only repeat implemented now (as in v0.31)
  
' In 8 bpp modes Atari 8-bit type palette is used, 16 colors, 16 brightness

'---------------------------------------------------------------------------------------------------------------------------
'------------ Constants ----------------------------------------------------------------------------------------------------
'---------------------------------------------------------------------------------------------------------------------------

''--------- VGA DOS color definition constants

const c_black         =    0
const c_blue          =  117
const c_green         =  199
const c_cyan          =  149
const c_red           =   39
const c_magenta       =   71
const c_brown         =  246
const c_lightgray     =   10
const c_darkgray      =    5
const c_lightblue     =  121
const c_lightgreen    =  203
const c_lightcyan     =  155
const c_lightred      =   43
const c_lightmagenta  =   75
const c_yellow        =  234
const c_white         =   15

const timingsxxt      =  $70810000

' variables


'----------  A pointer block, these pointers will be passed to the cog

dim buf_ptr     as ulong       'main buffer pointer
dim font_ptr    as ulong       'font definition pointer
dim border_ptr  as ulong       'border colors buffer pointer
dim vblank_ptr  as ulong       'vblank signalling variable pointer
dim cursor_ptr  as ulong       'cursor position pointer
dim mode_ptr    as ulong       'graphics mode # pointer
dim palette_ptr as ulong       '256-color palette pointer; bit 31 set: do not read
dim dl_ptr      as ulong       'display list pointer
dim fontnum_ptr as ulong       'offset to the font pointer : TODO - remove this, use byte #1 in the buffer
dim hdmibase    as ulong       'HDMI pin#

/'
'----------

long cog               'driver cog#
long bordercolor       'border color
long buflen            'buffer length in longs
byte cursor_x          'X cursor position in text modes
byte cursor_y          'Y cursor position
byte cursor_sh         'cursor shape, 0 to 15, 0=full rectangle..15-one line, >=16 no cursor
byte dummyalign        'alignment dummy byte
long write_color       'character color for write/writeln
long write_background  'background color for write/writeln
long vblank            'vblank signalling
byte n_string[12]      'string buffer for inttostr and hextostr
long timings[16]       'graphic mode timings
long cpl               'char/pixels per line

long lines             'screen text lines count
long fontnum           'offset to font
long streamer[6]       'streamer constants
byte colors[16]        'vga colors
long graphmode
long font_family

long xzoom, yzoom, azoom
long putpixel
long p1,p2,p4,p8


''--------- timings
' 0  m_bs        - before sync,             16      80
' 1  m_sn        - sync                     80     160
' 2  m_bv        - before visible           20      84
' 3  m_vi        - visible                1024     816
' 4  m_border    - left and right borders  112       8
' 5  m_lut1      - pixels per char           8       8
' 6  i_vborder   - up and down border       48       8
' 7  i_upporch   - up non visible           16       8
' 8  i_vsync     - vsync                    16      12
' 9  i_downporch - down non visible         16       8
'10  mode #
'11  cpl         - character per line
'12  scanlines #
'13  clock
'14  hubset value for clock settings


'*************************************************************************
'                                                                        *
'  A dummy start function if someone runs this driver alone              *
'                                                                        *
'*************************************************************************

pub dummy()|i,x,y,ntsc,bbb,ccc,zzx,zzy,amode,x1,x2,y1,y2,r
'' this is not a main program.


'------------------------------

pub fcircle(x0,y0,r,c) | d,x,y,da,db

d:=5-4*r
x:=0
y:=r
da:=(-2*r+5)*4
db:=3*4
repeat while (x<=y) 
  line(x0-x,y0-y,x0+x,y0-y,c)
  line(x0-x,y0+y,x0+x,y0+y,c)
  line(x0-y,y0-x,x0+y,y0-x,c)
  line(x0-y,y0+x,x0+y,y0+x,c)
  if d>0 
    d+=da
    y-=1
    x+=1
    da+=4*4
    db+=2*4
  else
    d+=db
    x+=1
    da+=2*4
    db+=2*4
 
 
 
pub circle(x0,y0,r,c) | d,x,y,da,db

 
d:=5-4*r
x:=0
y:=r
da:=(-2*r+5)*4
db:=3*4
repeat while (x<=y) 
  putpixel(x0-x,y0-y,c)
  putpixel(x0-x,y0+y,c)
  putpixel(x0+x,y0-y,c)
  putpixel(x0+x,y0+y,c)
  putpixel(x0-y,y0-x,c)
  putpixel(x0-y,y0+x,c)
  putpixel(x0+y,y0-x,c)
  putpixel(x0+y,y0+x,c)
  if d>0 
    d+=da
    y-=1
    x+=1
    da+=4*4
    db+=2*4
  else
    d+=db
    x+=1
    da+=2*4
    db+=2*4


pub frame(x1,y1,x2,y2,c)

line(x1,y1,x2,y1,c)
line(x1,y2,x2,y2,c)
line(x1,y1,x1,y2,c)
line(x2,y1,x2,y2,c)

pub box(x1,y1,x2,y2,c) |yy

repeat yy from y1 to y2
  line(x1,yy,x2,yy,c)


pub line(x1,y1,x2,y2,c) | d,dx,dy,ai,bi,xi,yi,x,y


x:=x1
y:=y1

if (x1<x2) 
  xi:=1
  dx:=x2-x1
else
  xi:=-1
  dx:=x1-x2
  
if (y1<y2) 
  yi:=1
  dy:=y2-y1
else
  yi:=-1
  dy:=y1-y2

putpixel(x,y,c)

if (dx>dy)
  ai:=(dy-dx)*2
  bi:=dy*2
  d:= bi-dx
  repeat while (x<>x2) 
    if (d>=0) 
      x+=xi
      y+=yi
      d+=ai
    else
      d+=bi
      x+=xi
    putpixel(x,y,c)
else
  ai:=(dx-dy)*2
  bi:=dx*2
  d:=bi-dy
  repeat while (y<>y2)
    if (d>=0)
      x+=xi
      y+=yi
      d+=ai
    else
      d+=bi
      y+=yi
    putpixel(x, y,c)





pub putcharxycf(x,y,achar,f) |xx, yy,bb

repeat yy from 0 to 15
  bb:=byte[@vga_font+font_family<<10+achar<<4+yy]
  repeat xx from 0 to 7
    if (bb&(1<<xx))<>0
      putpixel(xx+x,yy+y,f)

pub putcharxycg(x,y,achar,f,b) |xx, yy,bb

repeat yy from 0 to 15
  bb:=byte[@vga_font+font_family<<10+achar<<4+yy]
  repeat xx from 0 to 7
    if (bb&(1<<xx))<>0
      putpixel(xx+x,yy+y,f)
    else
      putpixel(xx+x,yy+y,b)

pub putcharxycz(x,y,achar,f,b,xz,yz) |xx,xxx,yy,yyy,bb

repeat yy from 0 to 15
  bb:=byte[@vga_font+font_family<<10+achar<<4+yy]
  repeat xx from 0 to 7
    if (bb&(1<<xx))<>0
      repeat yyy from 0 to yz-1
        repeat xxx from 0 to xz-1
          putpixel(xz*xx+xxx+x,yz*yy+yyy+y,f)
    else
      repeat yyy from 0 to yz-1
        repeat xxx from 0 to xz-1
          putpixel(xz*xx+xxx+x,yz*yy+yyy+y,b)

pub outtextxycg(x,y,text,f,b) | iii,c

repeat iii from 0 to strsize(text)-1
  putcharxycg(x+8*iii,y,byte[text+iii],f,b)

pub outtextxycf(x,y,text,f) | iii,c

repeat iii from 0 to strsize(text)-1
  putcharxycf(x+8*iii,y,byte[text+iii],f)

pub outtextxycz(x,y,text,f,b,xz,yz) | iii,c

repeat iii from 0 to strsize(text)-1
  putcharxycz(x+8*xz*iii,y,byte[text+iii],f,b,xz,yz)


''---------- putpixel - put a pixel on the screen

pub putpixel1(x,y,c) |byte b


if ((x>=0) & (x<32*cpl) & (y>=0) & (y<lines))
    b:=byte[buf_ptr+4*cpl*y+(x>>3)]
    if (c==0)
      b:=b & !(1<<(x//8))
    else
      b:=b |(1<<(x//8))
    byte[buf_ptr+4*cpl*y+(x>>3)]:=b


pub putpixel2(x,y,c) |byte b


if ((x>=0) & (x<16*cpl) & (y>=0) & (y<lines))
    b:=byte[buf_ptr+4*cpl*y+(x>>2)]
    b:=b & !(%11<<((x//4)<<1))
    b:=b |(c<<((x//4)<<1))
    byte[buf_ptr+4*cpl*y+(x>>2)]:=b


pub putpixel4(x,y,c) |byte b

if ((x>=0) & (x<16*cpl) & (y>=0) & (y<lines))
    b:=byte[buf_ptr+4*cpl*y+(x>>1)]
    b:=b & !(%1111<<((x//2)<<2))
    b:=b |(c<<((x//2)<<2))
    byte[buf_ptr+4*cpl*y+(x>>1)]:=b


pub putpixel8(x,y,c)

if ((x>=0) & (x<4*cpl) & (y>=0) & (y<lines))
    byte[buf_ptr+4*cpl*y+x]:=c




'**********************************************************************r***
'                                                                        *
' Font related functions                                                 *
'                                                                        *
'*************************************************************************

''--------- Set a font offset. TODO: rremove, use byte#1 instead

pub setfontfamily(afontnum)

font_family:=afontnum

''--------- Redefine a character

pub defchar(fn,ch,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15) :s

s:=@st_font+fn+ch*16
byte[s+00]:=b0
byte[s+01]:=b1
byte[s+02]:=b2
byte[s+03]:=b3
byte[s+04]:=b4
byte[s+05]:=b5
byte[s+06]:=b6
byte[s+07]:=b7
byte[s+08]:=b8
byte[s+09]:=b9
byte[s+10]:=b10
byte[s+11]:=b11
byte[s+12]:=b12
byte[s+13]:=b13
byte[s+14]:=b14
byte[s+15]:=b15

'*************************************************************************
'                                                                        *
'  Cursor functions                                                      *
'                                                                        *
'*************************************************************************

pub cursoron()

''---------- Switch the cursor on

cursor_sh+=16

pub cursoroff()

''---------- Switch the cursor off

cursor_sh-=16

pub setcursorpos(x,y)

''---------- Set the (x,y) position of cursor

cursor_x:=x
cursor_y:=y

pub setcursorshape(shape)

''---------- Define a cursor shape (0-full..15-line)

cursor_sh:=shape

'*************************************************************************
'                                                                        *
'  VBlank functions                                                      *
'                                                                        *
'*************************************************************************

pub waitvbl(amount) | i

''---------- Wait for start of vblank. Amount=delay in frames

repeat i from 1 to amount
  repeat until vblank==0
    waitus(100)
  repeat until vblank==1
    waitus(100)


pub waitvblend(amount) | i

''---------- Wait for end of vblank. Amount=delay in frames

repeat i from 1 to amount
  repeat until vblank==1
    waitus(100)
  repeat until vblank==0
    waitus(100)

'*************************************************************************
'                                                                        *
'  Color functions                                                       *
'                                                                        *
'*************************************************************************

''---------- Get a VGA color code

pub getvgacolor(color):r

return colors[color]

pub getpalettecolor(color):r

return long[@ataripalette+4*color]

''---------- Set font and back colors for all screen - from 256 color palette

pub setscreencolors(ff,bb) | c ,i

c:=ff<<24+bb<<16

repeat i from 0 to buflen-1
   long[buf_ptr+4*i]:= (long[buf_ptr+4*i] & $FFFF) |  c

''---------- Set the color for the character at line y and position x

pub setcharcolor(x,y,c) | place, color

place:=(x)+(y*cpl)

if (place>buflen-1)
  place:=buflen-1

color:=(long[buf_ptr+4*place] &$FFFFFF) | (c<<24)
long[buf_ptr+4*place]:=color

''---------- Set the background color at line y and position x

pub setbackcolor(x,y,c) | place, color

place:=(x)+(y*cpl)

if (place>buflen-1)
  place:=buflen-1

color:=(long[buf_ptr+4*place] &$FF00FFFF) | (c<<16)
long[buf_ptr+4*place]:=color

''---------- Set the border color, o is upper border, lines+1 is lower border

pub setbordercolor(r,g,b) | color

color:=r<<24+g<<16+b<<8
bordercolor:=color

''---------- Set colors for putchar, write and writeln

pub setwritecolors(ff,bb)


write_color:=ff
write_background:=bb

''---------- Set color #c in palette to r,g,b

pub setcolor(c,r,g,b)  |cc

cc:=r<<24+g<<16+b<<8
long[palette_ptr+4*c]:=cc


'*************************************************************************
'                                                                        *
'  Text functions                                                        *
'                                                                        *
'*************************************************************************

''---------- Clear the screen, set its foreground/background color

pub cls(fc,bc)   :c

if (graphmode<512)
  c:=fc<<24+bc<<16+$20
  longfill(buf_ptr,c,buflen)
else
  if (graphmode & 48) ==48
    c:=bc
  elseif (graphmode & 48) ==32
    c:=bc<<4+bc
  elseif (graphmode & 48) ==16
    c:=bc<<6+bc<<4+bc<<2+bc
  else
    if bc==1
      c:=255
    else
      c:=0
  bytefill(buf_ptr,c,buflen*4)
setwritecolors(fc,bc)
cursor_x:=0
cursor_y:=0

''---------- Output a char at x,y, don't change colors and cursor position

pub putcharxy(x,y,achar) | c

long[buf_ptr+4*(cpl*y+x)]:=(long[buf_ptr+4*(cpl*y+x)] & $FFFFFF00)  |(achar & $000000FF)

''---------- Output a char at x,y and colors f,b, don't change a cursor position

pub putcharxyct(x,y,achar,f,b) | c

c:=f<<24+b<<16
long[buf_ptr+4*(cpl*y+x)]:=long[buf_ptr+4*(cpl*y+x)] &$FFFF | c
long[buf_ptr+4*(cpl*y+x)]:=(long[buf_ptr+4*(cpl*y+x)] & $FFFFFF00)  |(achar & $000000FF)

''--------- Output a string at position x,y without changing colors

pub outtextxy(x,y,text) | iii

repeat iii from 0 to strsize(text)-1
  long[buf_ptr+4*(cpl*y+x+iii)]:=(long[buf_ptr+4*(cpl*y+x+iii)] & $FFFFFF00)  | byte[text+iii]


''--------- Output a string at position x,y and colors b,f

pub outtextxyct(x,y,text,f,b) | iii,c

c:=f<<24+b<<16
repeat iii from 0 to strsize(text)-1
  long[buf_ptr+4*(cpl*y+x+iii)]:=(long[buf_ptr+4*(cpl*y+x+iii)] & $FFFFFF00)  | byte[text+iii]
  long[buf_ptr+4*(cpl*y+x+iii)]:=(long[buf_ptr+4*(cpl*y+x+iii)] & $0000FFFF)  | c

''---------- Output a char at the cursor position, move the cursor

pub putchar(achar) | c,x,y

if achar==10
  crlf()
else  
  x:=cursor_x
  y:=cursor_y
  c:=write_color<<24+write_background<<16
  long[buf_ptr+4*(cpl*y+x)]:=long[buf_ptr+4*(cpl*y+x)] &$FFFF | c
  long[buf_ptr+4*(cpl*y+x)]:=(long[buf_ptr+4*(cpl*y+x)] & $FFFFFF00)  |(achar & $000000FF)
  cursor_x+=1
  if cursor_x==cpl
    cursor_x:=0
    cursor_y+=1
    if cursor_y>lines-1
      scrollup()
      cursor_y:=lines-1
    
pub putchar2(achar) | c,x,y

x:=cursor_x
y:=cursor_y
c:=write_color<<24+write_background<<16
long[buf_ptr+4*(cpl*y+x)]:=long[buf_ptr+4*(cpl*y+x)] &$FFFF | c
long[buf_ptr+4*(cpl*y+x)]:=(long[buf_ptr+4*(cpl*y+x)] & $FFFFFF00)  |(achar & $000000FF)
cursor_x+=1
if cursor_x==cpl
  cursor_x:=0
  cursor_y+=1
  if cursor_y>lines-1
    scrollup()
    cursor_y:=lines-1    

''--------- Output a string at the cursor position, move the cursor

pub write(text) | iii,c,ncx,ncy

c:=write_color<<24+write_background<<16
'debug(uhex_long(write_color))
ncy:=cursor_y
ncx:=cursor_x+strsize(text)
repeat while ncx>cpl-1
  ncx-=cpl
  ncy+=1
repeat while ncy>lines-1
  ncy-=1
  scrollup()
  cursor_y-=1

repeat iii from 0 to strsize(text)-1

  long[buf_ptr+4*(cpl*cursor_y+cursor_x+iii)]:=long[buf_ptr+4*(cpl*cursor_y+cursor_x+iii)] &$FFFF | c

outtextxy(cursor_x,cursor_y,text)

cursor_x:=ncx
cursor_y:=ncy

'--------- Output a string at the cursor position x,y, move the cursor to the next line

pub writeln(text)

write(text)
cursor_x:=0
cursor_y+=1
if (cursor_y>lines-1)
  scrollup()
  cursor_y:=lines-1

''-----------  Scroll the screen one line up

pub scrollup() | i

longmove(buf_ptr,buf_ptr+4*cpl,buflen-cpl)
repeat i from buflen-cpl to buflen-1
  long[buf_ptr+4*i]:=(long[buf_ptr+4*i] & $FFFF0000) | 32

''----------- Scroll the screen one line down

pub scrolldown() | i

longmove(buf_ptr+cpl*4,buf_ptr,buflen-cpl)
repeat i from 0 to cpl-1
  long[buf_ptr+4*i]:=(long[buf_ptr+4*i] & $FFFF0000) | 32

''----------- Set cursor at the first character in a new line, scroll if needed

pub crlf()

cursor_x:=0
cursor_y+=1
if cursor_y>lines-1
  scrollup()
  cursor_y:=lines-1

''---------- Backspace. Move the cursor back, clear a character

pub bksp()

cursor_x-=1
if cursor_x==255
  cursor_x:=cpl-1
  cursor_y-=1
  if cursor_y==255
    cursor_y:=0
    scrollup()

outtextxy(cursor_x,cursor_y,string(" "))


'*************************************************************************
'                                                                        *
'  Conversions                                                           *
'                                                                        *
'*************************************************************************

''---------- Convert a integer to dec string, return a pointer

pub inttostr(i):result |q,pos,k,j

j:=i
pos:=10
k:=0

if (j==0)
  n_string[0]:=48
  n_string[1]:=0

else
  if (j<0)
    j:=0-j
    k:=45

  n_string[11]:=0
  repeat while (pos>-1)
    q:=j//10
    q:=48+q
    n_string[pos]:=q
    j:=j/10
    pos-=1
  repeat while n_string[0]==48
    bytemove(@n_string,@n_string+1,12)

  if k==45
     bytemove(@n_string+1,@n_string,12)
     n_string[0]:=k

q:=@n_string
return q



pub inttostr2(i,d):result |q,pos,k,j

j:=i
pos:=d-1
k:=0

n_string[d]:=0
repeat k from 0 to d-1
  n_string[k]:=48

if (j<>0)

  repeat while (pos>-1)
    q:=j+//10
    q:=48+q
    n_string[pos]:=q
    j:=j+/10
    pos-=1


q:=@n_string
return q

''----------  Convert unsigned integer to hex string with d digits, return a pointer

pub inttohex(i,d):result |q,pos,k,j

j:=i
pos:=d-1
k:=0
n_string[d]:=0
repeat k from 0 to d-1
  n_string[k]:=48
if (j<>0)

  repeat while (pos>-1)
    q:=j+//16
    if (q>9)
      q:=q+7
    q:=48+q
    n_string[pos]:=q
    j:=j+/16
    pos-=1

q:=@n_string
return q



'*************************************************************************
'                                                                        *
'  Mode setting and driver start                                                          *
'                                                                        *
'*************************************************************************

''---------  Set the graphics mode



pub setmode(mode) | i', 'xzoom, yzoom, azoom

'' mode:tn_bb_cc_vv_hh
'' hh - h.zoom, vv-v.zoom, cc-c.depth,
'' bb - borders/total pixels, 00-wide/1140, 01 medium/1026, 10 narrow/912, 11 no border, 1024 px PAL, 880 px NTSC

if mode==(512+192+48)
  return 'no RAM

case_fast (mode>>6) & 7 ' timings are the same for graphic and text

    0:  longmove(@timings,@timings000,16)   'PAL 50 Hz signaling 1140x624, active 800x480, 100x30 text, wide border, 2 colors per pixel, 00_00_00_00_00=0, 354_693_878 Hz
    1:  longmove(@timings,@timings064,16)   'PAL 50 Hz signaling 1026x624, active 880x496, 110x31 text, medium border, 2 colors per pixel 00_01_00_00_00=64, 319_215_686 Hz
    2:  longmove(@timings,@timings128,16)   'PAL 50 Hz signaling 912x624, active 800x480, 100x30 text, medium border, 2 colors per pixel 00_10_00_00_00=64, 283750000z
    3:  longmove(@timings,@timings192,16)   'PAL 50 Hz signaling 1140x624, active 1024x576, 128x36 text, borderless, 2 colors per pixel 00_11_00_00_00=6192, 354_693_878 Hz
    4:  longmove(@timings,@timings256,16)   'NTSC 50 Hz signaling 1140x524, active 800x480, 100x30 text, NO PLACE FOR wide border, 2 colors per pixel, 01_00_00_00_00=256, 357959184 Hz
    5:  longmove(@timings,@timings320,16)   'NTSC 50 Hz signaling 1026x524, active 800x480, 100x30 text, NO PLACE FOR wide border, 2 colors per pixel, 01_01_00_00_00=320, 322162162 Hz
    6:  longmove(@timings,@timings384,16)   'NTSC 50 Hz signaling 912x524, active 800x480, 100x30 text, NO PLACE FOR wide border, 2 colors per pixel, 01_10_00_00_00=384, 286363636 Hz
    7:  longmove(@timings,@timings448,16)   'NTSC 50 Hz signaling 1026x524, active 880x496, 110x31 text, borderless, 2 colors per pixel, 01_11_00_00_00=496, 322162162 Hz

' 4-bit graphics: do nothing with timings :)
if mode<512
  palette_ptr:=@ataripalette

if (mode & (%10_00_11_0000))==(%10_00_11_0000) ' 8bit graphics, 4 pixels per long instead of 8, cpp x2
  timings[5]:=4
  timings[11]:=timings[11]<<1
  putpixel:=p8
  palette_ptr:=@ataripalette

if (mode & (%10_00_11_0000))==(%10_00_01_0000) ' 2bit graphics, 16 pixels per long instead of 8, cpp /2
  timings[5]:=16
  timings[11]:=timings[11]>>1
  putpixel:=p2
  palette_ptr:=@fourcolors

if (mode & (%10_00_11_0000))==(%10_00_00_0000) ' 1bit graphics, 32 pixels per long instead of 8, cpp /4
  timings[5]:=32
  timings[11]:=timings[11]>>2
  putpixel:=p1
  palette_ptr:=@twocolors

if (mode & (%10_00_11_0000))==(%10_00_10_0000) ' 4bit graphics,
  putpixel:=p4
  palette_ptr:=@vga16

repeat i from 0 to 4
  timings[i]:=timings[i]+hdmibase<<17+ timingsxxt
timings[5]:=timings[5]+hdmibase<<17
clkfreq:=timings[13]
hubset(timings[14])
waitms(1)


xzoom:=1<<(mode & 3)

if (xzoom==8) && (((mode>>4)&3)<>3)
  xzoom:=4

yzoom:=1<<((mode>>2) & 3)
azoom:=xzoom*yzoom

cpl:=timings[11]
if (mode<512)
  lines:=(timings[12]>>4)+/yzoom
  if ((timings[12]>>4)+//yzoom) <>0
    lines +=1

else
  lines:=timings[12]/yzoom
  if cpl//xzoom==0
    cpl:=cpl/xzoom
  else
    cpl:=cpl/xzoom+1

buflen:=(cpl*lines)
buf_ptr:=$80000-4*buflen
mode_ptr:=@timings
graphmode:=mode
makedl(mode)




'---------- Make a display list

pub makedl (mode) |i, fontline2,charline,bufstart,zoom1,vzoom,lpc,hzoom

''--%aaaa_aaaa_aaaa_aaaa_aazz_nnnn_llll_ll_01 - txt
  '' aaaa_aaaa_aaaa_aaaa_aazz_rrrr_rrrr_cc_10 - graph
  '' aaaa_aaaa_aaaa-aaaa_aarr_rrrr_rrrr_rr_11 - extended, next long to read

'   0 - display a up/down border line

'  ' aaaa_aaaa_aaaa_aaaa_aazz_nnnn_llll_ll_01 - text line
'    aaaa_aaaa_aaaa_aaaa_aa00 - buffer start, has to be aligned, 1 long for char, ff_bb_rr_cc, foreground, background,reserved, charcode
'    zz - zoom, 00-x1, 01-x2, 10-x4, 11-blank line
'    nnnn - font line to display, 0..15
'    llllll - character line, determines the cursor Y position


if (mode &256==0)
  dl_ptr:=buf_ptr-4*576
else
  dl_ptr:=buf_ptr-4*496
 ' dl_ptr:=buf_ptr-4*540

vzoom:=((mode>>2) & 3)


if mode<512 '' text modes

  if timings[6]>0 'borders
    repeat i from 0 to timings[6]-1 '0 to -1
      long[dl_ptr+4*i]:=$0
    repeat i from timings[6]+timings[12] to timings[15]-1
      long[dl_ptr+4*i]:=$0
  lpc:=16<<vzoom
  repeat i from timings[6] to timings[6]+timings[12]-1
    fontline2:=((i-timings[6])+//lpc)>>vzoom
    charline:=(i-timings[6])+/lpc
    bufstart:=buf_ptr+4*((cpl)*charline)+(mode&3)
    long[dl_ptr+4*i]:=(bufstart<<12)+(fontline2<<8)+(charline<<2)+1



if (mode>=512)' and (mode & (%10_00_00_0000))==(%10_00_00_0000) ' graphics -> all modes TODO :mode 560+192=752 = 10_11_11_0000 impossib,e because out of memory

  if timings[6]>0 'borders
    repeat i from 0 to timings[6]-1 '0 to -1
      long[dl_ptr+4*i]:=$0
    repeat i from timings[6]+timings[12] to timings[15]-1
      long[dl_ptr+4*i]:=$0
  repeat i from timings[6] to timings[6]+timings[12]-1
    bufstart:=buf_ptr+4*(cpl*((i-timings[6])>>vzoom))+(mode&3)
    long[dl_ptr+4*i]:=(bufstart<<12)+2+(mode &48)>>2


pub maketestdl (mode) |i, fontline2,charline,bufstart,zoom1,vzoom,lpc,hzoom




if (mode &256==0)
  dl_ptr:=buf_ptr-4*576-100
else
  dl_ptr:=buf_ptr-4*496-100

vzoom:=((mode>>2) & 3)

if (mode>=512)' and (mode & (%10_00_00_0000))==(%10_00_00_0000) ' graphics -> all modes TODO :mode 560+192=752 = 10_11_11_0000 impossib,e because out of memory

  if timings[6]>0 'borders
    repeat i from 0 to timings[6]-1 '0 to -1
      long[dl_ptr+4*i]:=$0
    repeat i from timings[6] to timings[15]+20
      long[dl_ptr+4*i]:=$0
    i:=timings[6]
      long[dl_ptr+4*i]:=%0001_1110_0000_0000_0011_0010_0000_0111  
      long[dl_ptr+4*i+4]:=(buf_ptr<<12)+2+(mode &48)>>2
      
'--------- Start the driver with graphics mode 'mode' at pins 'base'

pub start(mode,base):result

' initialize pointers and variables

border_ptr:=@bordercolor
font_ptr:=@st_font
hdmibase:=base
p1:=@putpixel1
p2:=@putpixel2
p4:=@putpixel4
p8:=@putpixel8


' the mode has to be set here to enable computing the buffer length

setmode(mode)

vblank_ptr:=@vblank
cursor_ptr:=@cursor_x

fontnum_ptr:=@fontnum

fontnum:=0  ' PC type font ' TODO: font# in buffer byte #1
bytemove(@colors,@vgacolors,16)

' initialize a cursor

cursor_x:=0
cursor_y:=0
cursor_sh:=14


' start the cog

cog:=coginit(16,@hdmi, @buf_ptr)
waitms(20)

' clear the screen and set the colors to green on black

cls(c_green,c_black)
setbordercolor(0,0,128)
setwritecolors(c_green,c_black)

return cog

'**********************************************************************************
'
'        Fonts and palettes
'
'**********************************************************************************
dat
vga_font       file "vgafont.def"
st_font        file "st4font.def"
twocolors      long  $00000000,$FFFFFF00
fourcolors     long  $00000000,$80808000,$FF000000,$FFFFFF00 'black,red,gray,white
vga16          long  $00000000,$00008000,$00800000,$00808000,$80000000,$80008000,$80400000,$AAAAAA00,$55555500,$0000FF00,$00FF0000,$00FFFF00,$FF000000,$FF00FF00,$FFFF0000,$FFFFFF00
ataripalette   file "ataripalettep2.def"
'**********************************************************************************
'
'        Timings and colors definitions
'
'**********************************************************************************

   'streamer sets for text mode, to add to timings[0..5]
' todo for the retromachine: 768x576

'                     bf.hs, hs,  bf.vis  visible, lr bord, pixel, ud bord,  up p., vsync, down p., mode, cpl, scanlines,  clock,                  hubset                  total vis lines
timings000      long   16,   80,    20,    1024,    112,     8,     48,      16,      16,    16,      0,  100,   480,     354693878,   %1_110000__11_0110_1100__1111_1011,   576
'timings064      long   18,   48,    16,     944,     24,     8,     24,      24,      32,    24,     64,  112,   496,     319215686,   %1_110010__11_0010_1101__1111_1011,   544'
'timings064      long   8,   50,    8 ,    960,     32,     8,      22,       24,      36,    24,     64,  112,   496,     319215686,   %1_110010__11_0010_1101__1111_1011,   540
timings064      long   48,   80,    52 ,    960,     32,     8,      22,       24,      36,    24,     64,  112,   496,     354693878,   %1_110000__11_0110_1100__1111_1011,   540
'timings064      long   18,   48,    16,     944,     24,     8,     24,      24,      32,    24,     64,  112,   496,     320000000,   %1_0000_00__00_0000_1111__1111_1011,   544
timings128      long   16,   64,    16,     816,      8,     8,     8,       32,      64,    32,    128,  100,   480,     283750000,   %1_111111__11_1000_1011__1111_1011,   496
timings192      long   16,   66,    20,    1024,      0,     8,     0,       16,      16,    16,    192,  128,   576,     354693878,   %1_110000__11_0110_1100__1111_1011,   576
timings256      long   80,  160,    84,     816,      8,     8,     8,        8,      12,     8,    256,  100,   480,     357959184,   %1_110000__11_0110_0100__1111_1011,   496
timings320      long   80,   50,    80,     816,      8,     8,     8,        8,      12,     8,    320,  100,   480,     322162162,   %1_100100__10_0101_0011__1111_1011,   496
timings384      long   24,   48,    24,     816,      8,     8,     8,        8,      12,     8,    384,  100,   480,     286363636,   %1_010101__01_0011_1010__1111_1011,   496
timings448      long   32,   64,    34,     896,      0,     8,     0,        8,      12,     8,    448,  112,   496,     322162162,   %1_100100__10_0101_0011__1111_1011,   496
'timings999      long    0,    0,     0,       0,      0,     0,     0,        0,       0,     0,      0,    0,     0,             0,                                    0,     0
vgacolors       byte   0, 117, 199, 151, 39, 71, 246, 10, 5, 121, 203, 155, 43, 75, 234, 15


'**********************************************************************************
'
'        PASM driver code
'
'**********************************************************************************

DAT             org

hdmi            setq    #9
                rdlong  framebuf,  ptra                  'read pointers
           '     setq2   #255
            '    rdlong  $100, paletteptr 
                wrlong  #aend,#0                         'write driver length to hub#0: DEBUG/demo
                setcmod #$100                            'enable HDMI mode
                mov     ii,#448                          '7 << 6          
                add     ii,hbase
                drvl    ii                                 '#7<<6 + hdmi_base      ' enable HDMI pins
                wrpin   ##%10110_1111_0111_10_00000_0, ii  '#7<<6 + hdmi_base      ' a '123 ohm BITDAC for pins

                setxfrq ##$0CCCCCCC+1                   'set streamer freq to 1/10th clk


''--------  frame rendering main loop  ---------------------------------------------------

p101
                setq    #10
                rdlong  framebuf,  ptra
                setq    #15
                rdlong  m_bs,modeptr                     ' read timings
                rdlong  border,borderptr

                add     frames,#1
                mov     dlptr2,dlptr

                rdlong  cursorx, cursorptr               ' read cursor position
                getbyte cursory, cursorx,#1              ' y position at byte #1
                getbyte cursorsh,cursorx,#2              ' shape at byte #2
                and     cursorx,#255                     ' clear the cursor x varioble from y and shape
 '' up porch

                mov     hsync0,sync_000                  '
                mov     hsync1,sync_001
                callpa  i_upporch ,#blank
                wrlong  #0,vblankptr
                
                testb   paletteptr,#31 wc
         if_nc  setq2   #255
         if_nc  rdlong  $000, paletteptr                'read palette

'' cursor blinking

                testb   frames,#4 wz                     ' cursor blinks at framerate/16, todo: define
         if_z   mov     cursorx,#129                     ' to switch the cursor off, move it out of the screen

'' main screen

                mov linenum,#0
                mov rcnt,#0
                mov rcnt2a,#0


p301            cmp rcnt,#0 wz
        if_z    jmp #p306
                sub rcnt,#1
                mov dl,rdl
               incmod rcnt2a,rcnt2 wz
   if_z        add dl,roffset  
                mov rdl,dl
                jmp #p307          
          
                
p306            rdlong  dl,dlptr2
p307            mov     framebuf2,dl wcz                  'read a line start in the framebuffer from DL entry
                rczr    framebuf2 wcz                     'but only if not %11 at lowest bits which means special DL entry
   if_nz_or_nc  jmp     #p303                        

'' Special entry:
'' - repeat                 %nnnn_nnnn_nnnn_qqqq_mmmm_mmmm_mmmm_0111    repeat the next dl line n times, after q lines add offset m
'' - reload palette         %mmmm_mmmm_nnnn_nnnn_qqqq_qqqq_qqqq_1011    reload n palette entries from m color from palette_ptr+q
'' - set border color       %rrrr_rrrr_gggg_gggg_bbbb_bbbb_0001_0011    set border to rgb
'' - set border color       %0000_0000_0000_0000_pppp_pppp_0001_1011    set border color to palette entry #p
'' todo: set horizontal scroll (if needed)

                shl framebuf2,#2
                getnib dlc,framebuf2,#0
                cmp dlc,#%100 wz
  
                
                add dlptr2,#4
                             if_nz  jmp #p301  '' now ignore unknown instruction 
                 rdlong rdl,dlptr2
                 getword rcnt,framebuf2,#1 
                 shr rcnt,#4
             
                 getnib rcnt2,framebuf2,#4
                 getword roffset,framebuf2,#0
                
                 shr roffset,#4
                 shl roffset,#12
  
                 jmp #p301
                 
                 
p303           ' mov     framebuf2,dl                    ' read a line start in the framebuffer from DL entry
                shr     framebuf2,#12
                shl     framebuf2,#2

                getbyte t1,dl,#0
                cmp     t1,#0 wz
    if_z        jmp     #borderline

                 testb   dl,#0  wc     ' bit 0 set = text OR extended:TODO
          if_c   jmp     #textline
          if_nc  jmp     #graphline
'
p302            add     linenum,#1
                add     dlptr2,#4
                cmp     linenum,i_totalvis  wz
         if_nz  jmp     #p301

p112            wrlong  #1,vblankptr
                callpa  i_downporch ,#blank             'bottom blanks

                mov     hsync0,sync_222                 'vsync on
                mov     hsync1,sync_223
                callpa  i_vsync,#blank                  'vertical sync blanks
                jmp     #p101

'' ---------------  END of frame rendering loop -------------------------------------------


borderline      call    #hsync                      ' make a border
                xcont   m_vi,border
                jmp     #p302


blank           call    #hsync                          'blank lines
                xcont   m_vi,hsync0
        _ret_   djnz    pa,#blank

hsync           xcont   m_bs,hsync0                     'horizontal sync
                xzero   m_sn,hsync1
        _ret_   xcont   m_bv,hsync0



''--%aaaa_aaaa_aaaa_aaaa_aazz_nnnn_llll_ll_01 - txt
  '' aaaa_aaaa_aaaa_aaaa_aazz_rrrr_rrrr_cc_10 - graph
  '' aaaa_aaaa_aaaa-aaaa_aarr_rrrr_rrrr_rr_11 - extended, next long to read

'' Display a text line DL[31..12]=addr, nibble #1=textline, zoom: todo

textline        mov     cursorpos2,cursorx              ' we need another var for cursor as this code will repeat 16x for every char line

                getnib  fontline,dl,#2                 ' fontline is 0 to 15, a line in font def
                getnib  zoom, dl,#3
                and             zoom, #3



                mov     linestart,dl                    ' linestart will be used for checking cursor y and compute line start addr in the buffer
                shr     linestart,#2                    ' scanline to char line
                and     linestart,#63
                cmp     linestart,cursory wz            ' if the cursor is not here
          if_nz mov     cursorpos2,#129                 ' move it out of the screen

                call    #hsync                          ' now call hsync to gain some time between xconts

                       ' if fontline =0, get a border color

p102            getword t1,m_border,#0
                cmp     t1, #0 wz
          if_nz xcont   m_border,border                 ' display a left border if exists

                cmp     fontline,cursorsh wcz           ' if the cursor have to be not displayed due to its shape
          if_c  mov     cursorpos,#129                  ' move it out of the screen
         if_nc  mov     cursorpos,cursorpos2
                add     cursorpos,#1                    ' we will substract #1 below so compensate this here
                mov     t2,fontbuf                      ' font definition pointer
                add     t2,fontline                     ' add a current font line
                mov m_lut2, m_lut1
                add m_lut2, lutt1
                mov cpl2,i_cpl

               cmp zoom,#2 wz
          if_z jmp #p420
               cmp zoom,#1 wz
          if_z jmp #p410
                cmp zoom,#0 wz
          if_z jmp #p400
               jmp #p430

                   '
 ''---------------------------------------------------------------------------------------------------------
 p400                   rdlong  char,framebuf2          ' read a long char                          '1
                        getbyte backcolor,char,#2       ' byte #2 - background color                '2
                        getbyte charcolor,char,#3       ' byte #3 - foreground color                '3
                        getbyte char,char, #0           ' word #0 - char code                       '4
                        add     framebuf2,#4            ' point to the next long                    '5
                        shl     char,#4                 ' 1 char=16 bytes in font def               '6
                        add     char,t2                 ' add this to font/line pointer             '7
                        rdbyte  t1,char                 ' and get 8 pixels prom there               '8
                        sub     cursorpos,#1 wz         ' if there is a cursor                      '9
                  if_z  xor     t1, #$FF                ' reverse the colors                        '10

                        xcont m_lut2,t1

                        rdlut   t5,backcolor            ' read a background color from palette      '13
                        wrlut   t5,lutaddr              ' and write it to LUT #0 or #32             '14
                        add     lutaddr,#1                                                          '15
                        rdlut   t5,charcolor            ' the same for the foreground               '16
                        wrlut   t5,lutaddr                                                          '17
                        sub     lutaddr,#1

                        bitnot  m_lut2,#16                                                          '19
                        bitnot  m_lut1,#16                                                          '19
                        xor     lutaddr,#32             ' use LUT #0-1 and 32-33                    '20

                        djnz   cpl2,#p400
 p401                   jmp    #p103

''------------------------------------------------------------------------------------------------------------

 p410                   shr cpl2,#1

''---------------------------------------------------------------------------------------------------------
 p412                   rdlong  char,framebuf2          ' read a long char                          '1
                        getbyte backcolor,char,#2       ' byte #2 - background color                '2
                        getbyte charcolor,char,#3       ' byte #3 - foreground color                '3
                        getbyte char,char, #0           ' word #0 - char code                       '4
                        add     framebuf2,#4            ' point to the next long                    '5
                        shl     char,#4                 ' 1 char=16 bytes in font def               '6
                        add     char,t2                 ' add this to font/line pointer             '7
                        rdbyte  t1,char                 ' and get 8 pixels prom there               '8
                        sub     cursorpos,#1 wz         ' if there is a cursor                      '9
                  if_z  xor     t1, #$FF                ' reverse the colors                        '10


                        getnib t3,t1,#1                   ' 4 pixels to t3                                              '1  - +
                        getnib t1,t1,#0                   ' 4 pixels to t1                                                      '2  - +
                        mergew t1                         ' make 01010101 from 1111                                     '3  - +
                        mul t1,#3
                        xcont m_lut2,t1
                        rdlut   t5,backcolor            ' read a background color from palette      '13
                        wrlut   t5,lutaddr              ' and write it to LUT #0 or #32             '14
                        add     lutaddr,#1                                                          '15
                        rdlut   t5,charcolor            ' the same for the foreground               '16
                        wrlut   t5,lutaddr                                                          '17
                        sub     lutaddr,#1
                        mergew t3
                        mul t3,#3
                        xcont m_lut2,t3

                        bitnot  m_lut2,#16                                                          '19
                        bitnot  m_lut1,#16                                                          '19

                        xor     lutaddr,#32             ' use LUT #0-1 and 32-33                    '20

                        djnz   cpl2,#p412
 p411                   jmp    #p103

''------------------------------------------------------------------------------------------------------------

 p420                   shr cpl2,#2

''---------------------------------------------------------------------------------------
 p422                   rdlong  char,framebuf2          ' read a long char                          '1
                        getbyte backcolor,char,#2       ' byte #2 - background color                '2
                        getbyte charcolor,char,#3       ' byte #3 - foreground color                '3
                        getbyte char,char, #0           ' word #0 - char code                       '4
                        add     framebuf2,#4            ' point to the next long                    '5
                        shl     char,#4                 ' 1 char=16 bytes in font def               '6
                        add     char,t2                 ' add this to font/line pointer             '7
                        rdbyte  t1,char                 ' and get 8 pixels prom there               '8
                        sub     cursorpos,#1 wz         ' if there is a cursor                      '9
                  if_z  xor     t1, #$FF                ' reverse the colors                        '10

                        mergeb t1
                        getword t3,t1,#1
                        mul t1,#15
                        xcont m_lut2,t1

                        rdlut   t5,backcolor            ' read a background color from palette      '13
                        wrlut   t5,lutaddr              ' and write it to LUT #0 or #32             '14
                        add     lutaddr,#1                                                          '15
                        rdlut   t5,charcolor            ' the same for the foreground               '16
                        wrlut   t5,lutaddr                                                          '17
                        sub     lutaddr,#1

                        getbyte t4,t1,#1        '
                        xcont m_lut2,t4                                                                                                           '

                        mul t3,#15
                        xcont m_lut2,t3

                        getbyte t5,t3,#1
                        xcont m_lut2, t5
                        bitnot  m_lut2,#16                                                          '19
                        bitnot  m_lut1,#16                                                          '19

                        xor     lutaddr,#32             ' use LUT #0-1 and 32-33                    '20

                        djnz   cpl2,#p422
 p421                   jmp    #p103

'--------------------------------------------------------------------------------------------------------------

 p430                   rdlong  char,framebuf2          ' read a long char                          '1
                        getbyte backcolor,char,#2       ' byte #2 - background color                '2
                        getbyte charcolor,char,#3       ' byte #3 - foreground color                '3

                        xcont m_lut2,#0

                        rdlut   t5,backcolor            ' read a background color from palette      '13
                        wrlut   t5,lutaddr              ' and write it to LUT #0 or #32             '14
                        add     lutaddr,#1                                                          '15
                        rdlut   t5,charcolor            ' the same for the foreground               '16
                        wrlut   t5,lutaddr                                                          '17
                        sub     lutaddr,#1

                        djnz   cpl2,#p430
 p431                   jmp    #p103

''------------------------------------------------------------------------------------------------------------



p103            getword  mb2,m_border,#0
                cmp      mb2, #0 wz
                if_nz    xcont   m_border,border            'display a right border if exists

                jmp #p302

'' -------------------------------------- END of text line ---------------------------------

  '' aaaa_aaaa_aaaa_aaaa_aazz_rrrr_rrrr_cc_10 - graph - display a graphics line

graphline       call    #hsync                          ' now call hsync to gain some time between xconts


p202            getword mb2,m_border,#0
                cmp     mb2, #0 wz
          if_nz xcont   m_border,border                 ' display a left border if exists

'----------------------------------------- display pixels

                mov     m_lut2,m_lut1                   ' m_lut1 loaded from hub timing block, pixel per long
                mov     cpl2,i_cpl                      ' i_cpl in graphic modes is longs per line

                getnib  zoom, dl,#3
                and             zoom, #3                        ' get a horizontal zoom for the line

                mov     colordepth,dl                   ' get a color depth, reuse linestart var f         '
                and     colordepth,#12

                cmp     colordepth,#%0000 wz            ' 1 bpp modes
          if_z  add     m_lut2,lutg1
          if_z  jmp     #p240

                cmp     colordepth,#%0100 wz            ' 2 bpp modes
          if_z  add     m_lut2,lutg2
          if_z  jmp     #p250

                cmp     colordepth,#%1000 wz            ' 4 bpp modes
          if_z  add     m_lut2,lutg4
          if_z  jmp     #p260

                add m_lut2,lutg8                        ' 8 bpp modes

'' --- 8 bit color modes

                cmp zoom, #%00 wz   '256 colors, zoom x1
                if_z jmp #p251      'there is an universal loop for 1x zoom at p251, saves one long of skip pattern

                cmp zoom, #%01 wz   '256 colors, zoom x2
                if_z mov skippattern,#%101010
       
 '  
                cmp zoom, #%10 wz   '256 colors, zoom x4
                if_z mov skippattern,#%100101
    
 
                if_nz mov skippattern,#%000101
                if_nz shr cpl2,#1         ' if 8x zoom, 2 xconts used in one loop, so divide loop count by 2
        

        
p235               rdlong  char,framebuf2
                   skipf skippattern
                   add     framebuf2,#2             '0 1 1
                   add     framebuf2,#1             '1 0 0
                   movbyts char,#%01010000          '0 1 1
                   movbyts char,#%00000000          '1 0 0
                   xcont   m_lut2,char              '0 0 0
                   xcont   m_lut2,char              '1 1 0
                   djnz    cpl2,#p235

               jmp    #p203
                  


'' --- 1 bit color modes

p240          cmp zoom, #%00 wz     '2 colors, zoom x1
       if_z   jmp #p251              'there is an universal loop for 1x zoom at p251, saves one long of skip pattern

              cmp zoom, #%01 wz     '2 colors, zoom x2
       if_z   mov skippattern,#%10011
       if_nz  mov skippattern,#%01000


p241               rdword  char,framebuf2
                   movbyts char,#%01000100
                   mergew  char
                   skipf skippattern
                   movbyts char,#%01000100         ' 1 0
                   mergew  char                    ' 1 0
                   xcont   m_lut2,char             ' 0 0
                   add     framebuf2,#2                    ' 0 1
                   add     framebuf2,#1                ' 1 0
                   djnz   cpl2,#p241


               jmp    #p203

'' --- 2 bit color modes

p250          cmp zoom, #%00 wz     '4 colors, zoom x1
       if_z   jmp #p251

              cmp zoom, #%01 wz     '4 colors, zoom x2
       if_z   jmp #p252


p254               rdbyte char,framebuf2
                   mov  t5,#4
p255               shl  char,#2
                   getnib  t1,char,#2
                   and     t1,#3
                   mul     t1,#$55
                   rolbyte  t2,t1,#0
                   djnz    t5,#p255
                   xcont   m_lut2,t2
                   add     framebuf2,#1
                   djnz    cpl2,#p254
                   jmp     #p203

p252               rdword char,framebuf2
                   mov  t5,#8
p253               shl  char,#2
                   getnib  t1,char,#4
                   and     t1,#3
                   mul     t1,#5
                   rolnib  t2,t1,#0
                   djnz    t5,#p253
                   xcont   m_lut2,t2
                   add     framebuf2,#2
                   djnz    cpl2,#p252
                   jmp     #p203

'' ------ 4 bit color modes

p260          cmp zoom, #%00 wz     '4 colors, zoom x1, the same loop as 2bpp
       if_z   jmp #p251

              cmp zoom, #%01 wz     '4 colors, zoom x2
       if_z   jmp #p262


p263               rdbyte char,framebuf2
                           rep #5,#2
                             rolnib t2,char,#1
                                 rolnib t2,char,#1
                             rolnib t2,char,#1
                                 rolnib t2,char,#1
                             shl char,#4
                   xcont   m_lut2,t2
                   add     framebuf2,#1
                   djnz    cpl2,#p263
                   jmp     #p203

p262               rdword  char,framebuf2
                           rep #3,#4
                             rolnib t2,char,#3
                                 rolnib t2,char,#3
                             shl char,#4
                   xcont   m_lut2,t2
                   add     framebuf2,#2
                   djnz    cpl2,#p262
                   jmp     #p203

''---------- all color modes without zoom

p251               rep  #3,cpl2
                   rdlong  char,framebuf2
                   add     framebuf2,#4
                   xcont   m_lut2,char
          
 ''-----------------------------------------------------------------------------------------
p203           ' getword  mb2,m_border,#0
                cmp      mb2, #0 wz
                if_nz    xcont   m_border,border            'display a right border if exists

                jmp #p302

'' -------------------------------------- END of graph  line ---------------------------------

'' consts and vars

sync_000        long    %1101010100_1101010100_1101010100_10    '
sync_001        long    %1101010100_1101010100_0010101011_10    '        hsync
sync_222        long    %0101010100_0101010100_0101010100_10    'vsync
sync_223        long    %0101010100_0101010100_1010101011_10    'vsync + hsync

border          long    %00000000_00011010_00101100_00000000

'------ these longs will be set by setmode function

m_bs            long    0        'blanks before sync
m_sn            long    0        'sync
m_bv            long    0        'blanks before visible
m_vi            long    0        'visible pixels #
m_border        long    0        'left/right borders
m_lut1          long    0        'characters
i_vborder       long    0        'up/down borders
i_upporch       long    0        'up porch lines
i_vsync         long    0        'vsync lines
i_downporch     long    0        'down porch lines
i_modenum       long    0        'mode #
i_cpl           long    0        'chars/longs per line
i_lines         long    0        'scanlines #
i_clock         long    0
i_hubset        long    0
i_totalvis      long    0

'-------------------------------------

m_lut2          long    0

colordepth
linestart       long    0
linenum         long    0
lutaddr         long    256

cursorsh        long    14
frames          long    0
cursorx         long    0
cursory         long    0
cursorpos       long    0
cursorpos2      long    0
fontstart       long    0
border2         long 0
lutiv           long $70810000
lutt1           long $00880000
lutg1           long $00800000
lutg2           long $10800000
lutg4           long $20800000
lutg8           long $30800000
framebuf        long 0
fontbuf         long 0
borderptr       long 0
vblankptr       long 0
cursorptr       long 0
modeptr         long 0
paletteptr      long 0
dlptr           long 0
fontnumptr      res     1
hbase           res     1
borderptr2      res     1
dlptr2 res 1
dl              res 1
ii              res     1
framebuf2       res     1
hsync0          res     1
hsync1          res     1
fontline        res     1
t1              res     1
t2              res     1
t3 res 1
t4 res 1
t5 res 1
skippattern res 1
cpl2 res 1
char            res     1
backcolor       res     1
charcolor       res     1
zoom res 1
rcnt long 0 'dl repeat count
rcnt2 long 0
rcnt2a long 0
roffset long 0
rdl long 0  'dl repeat line
dlc long 0 'dl command
mb2 long 0
aend             long 0
                fit     496                     '





{{
------------ MIT License ---------------
}}
'/
