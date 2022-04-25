PC Softsynth Module
10 ; PIANO-SIMULATION
20 ;
30 ; IRISCHES VOLKSLIED
40 ; umgesetzt von
50 ; CHRISTIAN NIEBER 1985
60 ;
70 speed 6
80 gain 0.4
90 set 1,GEIGE,PERCUS,0,40,10
100 set 2,GEIGE,PERCUS,0,40,10
110 set 3,GEIGE,PERCUS,0,40,10
120 set 4,GEIGE,PERCUS,0,40,10
130 set 5,GEIGE,PERCUS,15,40,10
140 set 6,GEIGE,PERCUS,15,40,10
150 set 7,GEIGE,PERCUS,15,40,10
160 set 8,GEIGE,PERCUS,15,40,10
170 set 9,GEIGE,PERCUS,15,40,10
180 set 10,GEIGE,PERCUS,15,40,10
190 set 11,GEIGE,PERCUS,15,40,10
200 set 12,GEIGE,PERCUS,15,40,10
210 int 5,1,0.1
220 int 6,2,0.1
230 int 7,3,0.1
240 int 8,4,0.1
250 int 9,1,-0.1
260 int 10,2,-0.1
270 int 11,3,-0.1
280 int 12,4,-0.1
290 pan 9,0
300 pan 10,10
310 pan 11,20
320 pan 12,30
330 pan 5,97
340 pan 6,107
350 pan 7,117
360 pan 8,127
365 wait 10
370 tron 1
380 play 1,f#,20
390 play 2,f#
400 play 1,g#
410 play 2,a#,20
420 play 1,a#
430 play 2,h
440 ;
450 play 1,c#1,20
460 play 2,d#1
470 play 1,c#1
480 play 2,a#,40
490 ;
500 play 1,c#1,20
510 play 2,h
520 play 1,a#
530 play 2,g#,40
540 ;
550 play 1,h,20
560 play 2,a#
570 play 1,g#
580 play 2,f#,40
590 ;
600 play 1,f#,20
610 play 2,f#
620 play 1,g#
630 play 2,a#,20
640 play 1,a#
650 play 2,h
660 ;
670 play 2,c#1,20
680 play 1,d#1
690 play 2,c#1
700 play 1,a#,40
710 ;
720 play 2,c#1,20
730 play 1,h
740 play 2,a#
750 play 1,g#,20
760 play 2,a#
770 play 1,g#
780 ;
790 play 2,f#,80
800 ;
810 play 1,c#1,20
820 play 2,h
830 play 1,a#
840 play 2,g#,40
850 ;
860 play 1,h,20
870 play 2,a#
880 play 1,g#
890 play 2,f#,40
900 ;
910 play 1,c#1,20
920 play 2,h
930 play 1,a#
940 play 2,g#,40
950 ;
960 play 1,h,20
970 play 2,a#
980 play 1,g#
990 play 2,f#,40
1000 ;
1010 play 1,f#,20
1020 play 2,f#
1030 play 1,g#
1040 play 2,a#,20
1050 play 1,a#
1060 play 2,h
1070 ;
1080 play 1,c#1,20
1090 play 2,d#1
1100 play 1,c#1
1110 play 2,a#,40
1120 ;
1130 play 1,c#1,20
1140 play 2,h
1150 play 1,a#
1160 play 2,g#,20
1170 play 1,a#
1180 play 2,g#
1190 ;
1200 play 1,f#,80
1210 ;
1220 track 1
1230 play 3,f#-1
1240 play 4,c#
1250 play 3,a#-1
1260 play 4,c#
1270 play 3,f#-1
1280 play 4,c#
1290 play 3,a#-1
1300 play 4,c#
1310 ;
1320 play 3,f#-1
1330 play 4,c#
1340 play 3,a#-1
1350 play 4,c#
1360 play 3,f#-1
1370 play 4,c#
1380 play 3,a#-1
1390 play 4,c#
1400 ;
1410 play 3,f-1
1420 play 4,c#
1430 play 3,g#-1
1440 play 4,c#
1450 play 3,f-1
1460 play 4,c#
1470 play 3,g#-1
1480 play 4,c#
1490 ;
1500 play 3,f#-1
1510 play 4,c#
1520 play 3,a#-1
1530 play 4,c#
1540 play 3,f#-1
1550 play 4,c#
1560 play 3,a#-1
1570 play 4,c#
1580 ;
1590 play 3,f#-1
1600 play 4,c#
1610 play 3,a#-1
1620 play 4,c#
1630 play 3,f#-1
1640 play 4,c#
1650 play 3,a#-1
1660 play 4,c#
1670 ;
1680 play 3,f#-1
1690 play 4,c#
1700 play 3,a#-1
1710 play 4,c#
1720 play 3,f#-1
1730 play 4,c#
1740 play 3,a#-1
1750 play 4,c#
1760 ;
1770 play 3,c#-1
1780 play 4,h-1
1790 play 3,f-1
1800 play 4,h-1
1810 play 3,c#-1
1820 play 4,h-1
1830 play 3,f-1
1840 play 4,h-1
1850 ;
1860 play 3,f#-1
1870 play 4,c#
1880 play 3,a#-1
1890 play 4,c#
1900 play 3,f#-1
1910 play 4,c#
1920 play 3,a#-1
1930 play 4,c#
1940 ;
1950 play 3,f-1
1960 play 4,c#
1970 play 3,g#-1
1980 play 4,c#
1990 play 3,f-1
2000 play 4,c#
2010 play 3,g#-1
2020 play 4,c#
2030 ;
2040 play 3,f#-1
2050 play 4,c#
2060 play 3,a#-1
2070 play 4,c#
2080 play 3,f#-1
2090 play 4,c#
2100 play 3,a#-1
2110 play 4,c#
2120 ;
2130 play 3,f-1
2140 play 4,c#
2150 play 3,g#-1
2160 play 4,c#
2170 play 3,f-1
2180 play 4,c#
2190 play 3,g#-1
2200 play 4,c#
2210 ;
2220 play 4,f#-1
2230 play 3,c#
2240 play 4,a#-1
2250 play 3,c#
2260 play 4,f#-1
2270 play 3,c#
2280 play 4,a#-1
2290 play 3,c#
2300 ;
2310 play 4,f#-1
2320 play 3,c#
2330 play 4,a#-1
2340 play 3,c#
2350 play 4,f#-1
2360 play 3,c#
2370 play 4,a#-1
2380 play 3,c#
2390 ;
2400 play 4,f#-1
2410 play 3,c#
2420 play 4,a#-1
2430 play 3,c#
2440 play 4,f#-1
2450 play 3,c#
2460 play 4,a#-1
2470 play 3,c#
2480 ;
2490 play 4,c#-1
2500 play 3,h-1
2510 play 4,f-1
2520 play 3,h-1
2530 play 4,c#-1
2540 play 3,h-1
2550 play 4,f-1
2560 play 3,h-1
2570 ;
2580 play 4,f#-1
2590 play 3,c#
2600 play 4,a#-1
2610 play 3,c#
2620 play 4,f#-1,40
