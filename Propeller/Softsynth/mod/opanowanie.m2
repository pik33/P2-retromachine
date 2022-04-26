PC Softsynth Module
10 ; 40: / opanowanie / (C)
20 speed 3
30 gain 0.4
40 set 1,ODD,PERCUS2,15,20,20
50 set 2,RANDOM,PERCUS,10,8,20
60 set 3,ZACKE2,DIMX,7,180,120
70 set 4,ZACKE2,DIMX,7,180,120
80 vib 3,SINUS,1,15
90 vib 4,SINUS,1,15
100 vib 2,SINUS,1,3
110 tron 1
120 wait 240
130 tron 2
140 wait 240
150 tron 3
160 tron 4
170 wait 1920
180 troff 3
190 troff 4
200 set 3,ZACKE,DIMX,7,180,120
210 set 4,ZACKE,DIMX,7,180,120
220 tron 3
230 tron 4
240 wait 1920
250 troff 3
260 troff 4
270 set 3,LAUTI,SAXT,15,100,30
280 set 4,LAUTO,DIMX,7,241,120
290 tron 5
300 tron 6
310 wait 1920
320 troff 5
330 set 3,D12,PERCUS2,8,241,240
340 play 3,c,60,120,>c,240,60
350 set 3,RANDOM,SINUS,8,200,240
360 play 3,c-3,120,>c,120
370 set 3,OTTO1,ECHO,8,241,240
380 play 3,c2,120,>'16.2,120
390 set 3,ZACKE2,ORGEL1,8,241,240
400 play 3,c-1,120,>c,120
410 set 3,LAUTA,SAXT,8,241,240
420 play 3,c-1,240,>c2,240
430 set 3,LAUTE,SINUS,8,241,240
440 play 3,c2,240,>c,240,-50
450 play 3,c,120,>c4,480
460 play 4,c,120,>c4,480
470 play 3,c-2,0,>c3,960,-20
480 play 4,c3,240,>c-2,480,20
490 play 4,c-1,0,>c1,480,-20
500 play 3,'16.2,480,>c,480,-20
510 set 3,LAUTU,DIMX,6,180,120
520 set 4,LAUTU,DIMX,6,180,120
530 vib 3,SINUS,1,15
540 vib 4,SINUS,1,15
550 troff 6
560 tron 3
570 tron 4
580 wait 1920
590 set 3,LAUTE,DIMX,6,180,120
600 set 4,LAUTE,DIMX,6,180,120
610 wait 1920
620 troff 3
630 troff 4
640 troff 1
650 troff 2
660 vib 2,SINUS,1,24
670 set 3,ZACKE2,ORGEL1,2,130,0
680 set 4,ZACKE2,ORGEL1,2,130,120
690 tron 7
700 play 3,g1
710 play 4,d#1
720 play 3,g#1
730 play 4,d#1
740 play 3,a#1
750 play 4,f1
760 play 3,a1
770 play 4,f1
780 tron 1
790 play 3,g1
800 play 4,d#1
810 play 3,g#1
820 play 4,d#1
830 play 3,a#1
840 play 4,f1
850 play 3,a1
860 play 4,f1
870 set 3,ZACKE2,SOFT,9,241,120
880 set 4,ZACKE2,SOFT,9,241,120
890 vib 3,SINUS,1,15
900 vib 4,SINUS,1,15
910 tron 3
920 tron 4
930 wait 1920
940 set 3,ZACKE2,ECHO,9,241,120
950 set 4,ZACKE2,ECHO,9,241,120
960 wait 1440
970 troff 7
980 wait 240
990 troff 1
1000 wait 240
1010 ;
1020 track 1
1030 play 1,c-3
1040 play 1,c-2,10
1050 play 1,g-2
1060 play 1,c-3,10
1070 play 1,c-2
1080 play 1,c-3,10
1090 play 1,d#-2
1100 play 1,c-2,10
1110 track 2
1120 play 2,'3,13,8,10
1130 play 2,'399.9,5,4,5
1140 play 2,'399.9,3,4,5
1150 play 2,'399.9,4,4,5
1160 play 2,'399.9,3,4,5
1170 play 2,'15,8,15,10
1180 play 2,'399.9,5,4,10
1190 play 2,'399.9,3,4,9
1200 play 2,'399.9,3,4,1
1210 play 2,'3,13,8,10
1220 play 2,'399.9,5,4,10
1230 play 2,'399.9,3,15,10
1240 play 2,'15,8,15,10
1250 play 2,'399.9,3,15,10
1260 play 2,'399.9,3,3,9
1270 play 2,'399.9,5,3,1
1280 track 3
1290 play 3,d#
1300 play 3,f
1310 play 3,g,240
1320 play 3,d#
1330 play 3,f
1340 play 3,g,240
1350 play 3,g
1360 play 3,f
1370 play 3,d#,60
1380 play 3,f,60
1390 play 3,d#,60
1400 play 3,d,60
1410 play 3,c
1420 play 3,a#-1
1430 play 3,g-1,240
1440 track 4
1450 play 4,c
1460 play 4,d
1470 play 4,d#,240
1480 play 4,c
1490 play 4,d
1500 play 4,d#,240
1510 play 4,d#
1520 play 4,d
1530 play 4,c,60
1540 play 4,d,60
1550 play 4,c,60
1560 play 4,a#-1,60
1570 play 4,g-1
1580 play 4,f-1
1590 play 4,c-1,240
1600 track 5
1610 play 3,g-1,120
1620 play 3,g#-1,60
1630 play 3,a#-1,60
1640 play 3,a#-1,60
1650 play 3,f-1
1660 play 3,a#-1
1670 play 3,a-1
1680 play 3,f-1
1690 play 3,g#-1
1700 play 3,g-1
1710 play 3,g-1,120
1720 play 3,g#-1,60
1730 play 3,a#-1,60
1740 play 3,a#-1,60
1750 play 3,f-1
1760 play 3,a#-1
1770 play 3,a-1,120
1780 play 3,g-1,120
1790 play 3,g#-1,60
1800 play 3,a#-1,60
1810 play 3,c,60
1820 play 3,d#
1830 play 3,c
1840 play 3,f
1850 play 3,d#
1860 play 3,a#-1
1870 play 3,c
1880 play 3,g-1,120
1890 play 3,g#-1,60
1900 play 3,a#-1,60
1910 play 3,c,240
1920 track 6
1930 play 4,d#-2,240
1940 play 4,f-2,240
1950 track 7
1960 play 2,'399.9,5,4,5
1970 play 2,'399.9,3,4,5
1980 play 2,'399.9,3,4,10
1990 play 2,'399.9,3,4,10
2000 play 2,'5.1,20,10
2010 play 2,'399.9,5,4,10
2020 play 2,'3,10
2030 play 2,'3,10
2040 play 2,'399.9,3,4,10
2050 play 2,'3,10
2060 play 2,'5.1,20,10
2070 play 2,'5.1,20,10
2080 play 2,'19.9,10,10
2090 play 2,'3,5
2100 play 2,'399.9,5,4,5
2110 play 2,'399.9,3,4,5
2120 play 2,'399.9,2,4,5
2130 play 2,'3,10
2140 play 2,'5.1,20,5
2150 play 2,'399.9,5,4,5
2160 play 2,'399.9,3,4,10
2170 play 2,'3,10
2180 play 2,'399.9,5,4,5
2190 play 2,'399.9,5,4,5
2200 play 2,'399.9,5,15,10
2210 play 2,'3,10
2220 play 2,'19.9,20,10
2230 play 2,'19.9,20,10
2240 play 2,'11,20,10