#include "retromachine.bi"
startvideo (512+48,0)
'
' translated to BASIC from mandelbrot16-20180406-fds.spin
'-------------------------------------------------------------------------------

xmin# = -2.3
xmax# =  1.7

ymin# = -1.2
ymax# =  1.2

maxiter = 256

MPX = 799 ' 0..79
MPY = 479 ' 0..24

dx# = (xmax#-xmin#)/MPX
dy# = (ymax#-ymin#)/MPY

c4# = 4.0 ' square of escape radius
 
cy# = ymin#
for py = 0 to MPY
  cx# = xmin#
  for px = 0 to MPX
    x# = 0.0
    y#= 0.0
    x2# = 0.0
    y2# = 0.0
    iter = 0
    while iter < maxiter and x2#+y2# <= c4#
   	  y# = 2.0*x#*y#+cy#
  	  x# = x2#-y2#+cx#
	  iter = iter+1
	  x2# = x#*x#
	  y2# = y#*y#
    end while
    cx# = cx#+dx#
    if iter=maxiter then
      q3=0 
    else 
      q1=(iter+64)/16 : q2=iter mod 16 : q3=16*q2+q1
    endif
    putpixel px,py,q3
  next px
  cy# = cy#+dy#
next py
