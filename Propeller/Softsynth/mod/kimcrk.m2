PC Softsynth Module
10 ; 50:
20 speed 5
30 gain 0.29
40 set 1,PILA1,PERCUS,15,20,10
50 set 2,RANDOM,PERCUS,15,7,20
60 set 3,ORGEL,PERCUS,15,20,10
70 set 4,ORGEL,PERCUS,15,20,10
80 tron 1
90 tron 4
100 wait 160
110 troff 1
120 tron 1
130 wait 130
140 tron 2
150 tron 3
160 wait 30
170 troff 1
180 tron 1
190 wait 480
200 troff 4
210 tron 5
220 wait 450
230 troff 2
240 troff 3
250 troff 5
260 tron 5
270 wait 30
280 troff 5
290 tron 5
300 wait 130
310 troff 2
320 troff 3
330 int 4,3,1
340 tron 6
350 wait 30
360 troff 1
370 tron 7
380 wait 1280
390 troff 7
400 tron 9
410 troff 6
420 tron 8
430 wait 640
440 troff 9
450 play 4,d-2
460 play 3,d-1,0
470 wait 130
480 vib 3,off
490 vib 4,off
500 troff 9
510 int 4,3,1
520 tron 6
530 wait 30
540 troff 8
550 tron 7
560 wait 1280
570 troff 7
580 tron 9
590 troff 6
600 tron 8
610 wait 640
620 play 4,d-2
630 play 3,d-1,0
640 troff 9
650 wait 130
660 vib 3,off
670 vib 4,off
680 tron 10
690 wait 30
700 troff 8
710 tron 1
720 wait 1120
730 troff 1
740 tron 11
750 wait 240
760 troff 5
770 tron 4
780 wait 290
790 troff 10
800 echo,off
810 tron 2
820 tron 3
830 wait 30
840 troff 10
850 troff 4
860 tron 5
870 troff 11
880 tron 1
890 wait 450
900 troff 3
910 troff 2
920 tron 10
930 wait 430
940 troff 10
950 tron 12
960 wait 80
970 troff 1
980 troff 5
990 play 1,d-3,80,160
1000 track 1
1010 play 1,d-2
1020 play 1,d-1
1030 play 1,d-2
1040 play 1,d-1
1050 play 1,d-2
1060 play 1,d-1
1070 play 1,d-2
1080 play 1,d-1
1090 play 1,d-2
1100 play 1,d-1
1110 play 1,d-2
1120 play 1,d-1
1130 play 1,d-2
1140 play 1,d-1
1150 play 1,d-2
1160 play 1,d-1
1170 play 1,f-2
1180 play 1,f-1
1190 play 1,f-2
1200 play 1,f-1
1210 play 1,f-2
1220 play 1,f-1
1230 play 1,f-2
1240 play 1,f-1
1250 play 1,f-2
1260 play 1,f-1
1270 play 1,f-2
1280 play 1,f-1
1290 play 1,f-2
1300 play 1,f-1
1310 play 1,f-2
1320 play 1,f-1
1330 play 1,a#-2
1340 play 1,a#-1
1350 play 1,a#-2
1360 play 1,a#-1
1370 play 1,a#-2
1380 play 1,a#-1
1390 play 1,a-2
1400 play 1,a-1
1410 play 1,g-2
1420 play 1,g-1
1430 play 1,g-2
1440 play 1,g-1
1450 play 1,g-2
1460 play 1,g-1
1470 play 1,g-2
1480 play 1,g-1
1490 track 2
1500 set 3,ORGEL,PERCUS,15,20,10
1510 play 3,a-1,5
1520 play 3,a-1,5
1530 play 3,a-1
1540 play 3,a-1
1550 play 3,a#-1,20
1560 play 3,g-1
1570 play 3,a-1,20
1580 play 3,f-1,5
1590 play 3,f-1,5
1600 play 3,f-1
1610 play 3,f-1
1620 play 3,g-1,20
1630 play 3,e-1
1640 play 3,f-1,20
1650 play 3,a-1,5
1660 play 3,a-1,5
1670 play 3,a-1
1680 play 3,a-1
1690 play 3,a#-1,20
1700 play 3,g-1
1710 play 3,a-1,20
1720 play 3,f-1
1730 play 3,f-1
1740 play 3,f-1
1750 play 3,a#-1,20
1760 play 3,c,20
1770 play 3,a#-1,20
1780 play 3,a-1,20
1790 play 3,g-1,130
1800 track 3
1810 set 4,ORGEL,PERCUS,15,20,10
1820 play 4,f-1,5
1830 play 4,f-1,5
1840 play 4,f-1
1850 play 4,f-1
1860 play 4,g-1,20
1870 play 4,e-1
1880 play 4,f-1,20
1890 play 4,d-1,5
1900 play 4,d-1,5
1910 play 4,d-1
1920 play 4,d-1
1930 play 4,e-1,20
1940 play 4,c#-1
1950 play 4,d-1,20
1960 play 4,f-1,5
1970 play 4,f-1,5
1980 play 4,f-1
1990 play 4,f-1
2000 play 4,g-1,20
2010 play 4,e-1
2020 play 4,f-1,20
2030 play 4,c-1
2040 play 4,c-1
2050 play 4,c-1
2060 play 4,g-1,20
2070 play 4,a-1,20
2080 play 4,g-1,20
2090 play 4,f-1,20
2100 play 4,d-1,130
2110 track 4
2120 play 2,'3
2130 track 5
2140 play 2,'3
2150 play 2,'15,15,10,20
2160 track 6
2170 set 3,SAEGE,PERCUS,15,50,10
2180 set 4,SAEGE,DIMX,5,50,0
2190 echo 4,3,10
2200 int 4,3,1
2210 play 3,a
2220 play 3,a
2230 play 3,a
2240 play 3,a#,20
2250 play 3,g
2260 play 3,a,20
2270 play 3,f
2280 play 3,f
2290 play 3,f
2300 play 3,g,20
2310 play 3,e
2320 play 3,f,20
2330 play 3,a
2340 play 3,a
2350 play 3,a
2360 play 3,a#,20
2370 play 3,g
2380 play 3,a,20
2390 play 3,f
2400 play 3,f
2410 play 3,f
2420 play 3,g,20
2430 play 3,f
2440 play 3,a,20
2450 play 3,a
2460 play 3,a
2470 play 3,a
2480 play 3,a,20
2490 play 3,g
2500 play 3,g,20
2510 play 3,f
2520 play 3,f
2530 play 3,f
2540 play 3,f,20
2550 play 3,g
2560 play 3,g,20
2570 play 3,a
2580 play 3,a
2590 play 3,a
2600 play 3,a,20
2610 play 3,g
2620 play 3,g,20
2630 play 3,f
2640 play 3,f
2650 play 3,f
2660 play 3,f,20
2670 play 3,g
2680 play 3,g,20
2690 play 3,a#
2700 play 3,a#
2710 play 3,a#
2720 play 3,a#,20
2730 play 3,a
2740 play 3,a,20
2750 play 3,g
2760 play 3,g
2770 play 3,g
2780 play 3,g,20
2790 play 3,f
2800 play 3,f,20
2810 play 3,a#
2820 play 3,a#
2830 play 3,a#
2840 play 3,a#,20
2850 play 3,a
2860 play 3,a,20
2870 play 3,g
2880 play 3,g
2890 play 3,f
2900 play 3,g,20
2910 play 3,f
2920 play 3,a,20
2930 play 3,a
2940 play 3,a
2950 play 3,a
2960 play 3,a,20
2970 play 3,g
2980 play 3,g,20
2990 play 3,f
3000 play 3,f
3010 play 3,f
3020 play 3,f,20
3030 play 3,g
3040 play 3,g,20
3050 play 3,a
3060 play 3,a
3070 play 3,a
3080 play 3,a,20
3090 play 3,g
3100 play 3,g,50
3110 set 4,SAEGE,PERCUS,15,50,0
3120 echo,off
3130 play 4,e
3140 play 3,g
3150 play 4,e
3160 play 3,g
3170 play 4,e
3180 play 3,g
3190 play 4,f
3200 play 3,a
3210 play 4,g
3220 play 3,a#,20
3230 play 4,g
3240 play 3,a#,20
3250 track 7
3260 play 1,d-2
3270 play 1,d-1
3280 play 1,d-2
3290 play 1,d-1
3300 play 1,d-2
3310 play 1,d-1
3320 play 1,d-2
3330 play 1,d-1
3340 play 1,d-2
3350 play 1,d-1
3360 play 1,d-2
3370 play 1,d-1
3380 play 1,d-2
3390 play 1,d-1
3400 play 1,d-2
3410 play 1,d-1
3420 play 1,f-2
3430 play 1,f-1
3440 play 1,f-2
3450 play 1,f-1
3460 play 1,f-2
3470 play 1,f-1
3480 play 1,f-2
3490 play 1,f-1
3500 play 1,f-2
3510 play 1,f-1
3520 play 1,f-2
3530 play 1,f-1
3540 play 1,f-2
3550 play 1,f-1
3560 play 1,f-2
3570 play 1,f-1
3580 play 1,c-2
3590 play 1,c-1
3600 play 1,c-2
3610 play 1,c-1
3620 play 1,c-2
3630 play 1,c-1
3640 play 1,c-2
3650 play 1,c-1
3660 play 1,c-2
3670 play 1,c-1
3680 play 1,c-2
3690 play 1,c-1
3700 play 1,c-2
3710 play 1,c-1
3720 play 1,c-2
3730 play 1,c-1
3740 play 1,g-3
3750 play 1,g-2
3760 play 1,g-3
3770 play 1,g-2
3780 play 1,g-3
3790 play 1,g-2
3800 play 1,g-3
3810 play 1,g-2
3820 play 1,c-2
3830 play 1,c-1
3840 play 1,c-2
3850 play 1,c-1
3860 play 1,c-2
3870 play 1,c-1
3880 play 1,c#-2
3890 play 1,c#-1
3900 track 8
3910 play 1,d-2
3920 play 1,d-1
3930 play 1,d-2
3940 play 1,d-1
3950 play 1,d-2
3960 play 1,d-1
3970 play 1,d-2
3980 play 1,d-1
3990 play 1,d-2
4000 play 1,d-1
4010 play 1,d-2
4020 play 1,d-1
4030 play 1,d-2
4040 play 1,d-1
4050 play 1,d-2
4060 play 1,d-1
4070 play 1,f-2
4080 play 1,f-1
4090 play 1,f-2
4100 play 1,f-1
4110 play 1,f-2
4120 play 1,f-1
4130 play 1,f-2
4140 play 1,f-1
4150 play 1,g-3
4160 play 1,g-2
4170 play 1,g-3
4180 play 1,g-2
4190 play 1,a-3
4200 play 1,a-2
4210 play 1,a-3
4220 play 1,a-2
4230 track 9
4240 set 3,LAUTE,ORGEL1,15,55,10
4250 set 4,LAUTE,ORGEL1,15,55,0
4260 vib 3,SINUS,1,8
4270 vib 4,SINUS,1,8
4280 play 4,a-1
4290 play 3,a-2,30
4300 play 4,f-1
4310 play 3,f-2
4320 play 4,d-1
4330 play 3,d-2,60
4340 play 4,d-1
4350 play 3,d-2
4360 play 4,e-1
4370 play 3,e-2
4380 play 4,f-1
4390 play 3,f-2
4400 play 4,d-1
4410 play 3,d-2
4420 play 4,f-1
4430 play 3,f-2
4440 play 4,d
4450 play 3,d-1
4460 play 4,c
4470 play 3,c-1,30
4480 play 4,a-1
4490 play 3,a-2
4500 play 4,f-1
4510 play 3,f-2,40
4520 play 4,a#-1
4530 play 3,a#-2
4540 play 4,a-1
4550 play 3,a-2
4560 play 4,g-1
4570 play 3,g-2
4580 play 4,f-1
4590 play 3,f-2
4600 play 4,g-1
4610 play 3,g-2
4620 play 4,a-1
4630 play 3,a-2
4640 play 4,f-1
4650 play 3,f-2
4660 play 4,e-1
4670 play 3,e-2
4680 track 10
4690 set 3,SAEGE,PERCUS,15,50,10
4700 set 4,SAEGE,DIMX,5,50,0
4710 echo 4,3,10
4720 int 4,3,1
4730 play 3,a
4740 play 3,a
4750 play 3,a
4760 play 3,a#,20
4770 play 3,g
4780 play 3,a,20
4790 play 3,f
4800 play 3,f
4810 play 3,f
4820 play 3,g,20
4830 play 3,e
4840 play 3,f,20
4850 play 3,a
4860 play 3,a
4870 play 3,a
4880 play 3,a#,20
4890 play 3,g
4900 play 3,a,20
4910 play 3,f
4920 play 3,f
4930 play 3,f
4940 play 3,g,20
4950 play 3,a,20
4960 play 3,g,20
4970 play 3,f,20
4980 play 3,d,80
4990 wait 50
5000 play 3,a
5010 play 3,a
5020 play 3,a
5030 play 3,a#,20
5040 play 3,g
5050 play 3,a,20
5060 play 3,f
5070 play 3,f
5080 play 3,f
5090 play 3,g,20
5100 play 3,e
5110 play 3,f,20
5120 play 3,a
5130 play 3,a
5140 play 3,a
5150 play 3,a#,20
5160 play 3,g
5170 play 3,a,20
5180 play 3,f
5190 play 3,f
5200 play 3,f
5210 play 3,g,20
5220 play 3,a,20
5230 play 3,g,20
5240 play 3,f,20
5250 play 3,d,130
5260 play 3,d
5270 play 3,d
5280 play 3,c
5290 play 3,d,200
5300 play 3,d1,40
5310 play 3,c1,40
5320 play 3,a,80
5330 play 3,d1,40
5340 play 3,c1,40
5350 play 3,f,250
5360 track 11
5370 play 1,c-2
5380 play 1,c-1
5390 play 1,c-2
5400 play 1,c-1
5410 play 1,c-2
5420 play 1,c-1
5430 play 1,c-2
5440 play 1,c-1
5450 play 1,d-2
5460 play 1,d-1
5470 play 1,d-2
5480 play 1,d-1
5490 play 1,d-2
5500 play 1,d-1
5510 play 1,d-2
5520 play 1,d-1
5530 play 1,c-2
5540 play 1,c-1
5550 play 1,c-2
5560 play 1,c-1
5570 play 1,c-2
5580 play 1,c-1
5590 play 1,c-2
5600 play 1,c-1
5610 play 1,a#-3,496,320
5620 track 12
5630 play 3,g
5640 play 3,g
5650 play 3,g
5660 play 3,a
5670 play 3,a#,20
5680 play 3,a#,20
5690 play 3,a,161,160
