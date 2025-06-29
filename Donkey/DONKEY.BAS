'-----------------------------------------------------------------
' DONKEY.BAS - MSXBAS2ROM DEMO (v.1.2)
'-----------------------------------------------------------------
' Game Info:
'   DONKEY.BAS is a computer game written in 1981 and included with early versions of the PC DOS operating system 
'   distributed with the original IBM PC. It is a driving game in which the player must avoid hitting donkeys. 
'   The game was written by Microsoft co-founder Bill Gates and Neil Konzen.
'     https://en.wikipedia.org/wiki/DONKEY.BAS
'   Original PC version:
'     The IBM Personal Computer Donkey
'     Version 1.10 (C)Copyright IBM Corp 1981, 1982
'     Licensed Material - Program Property of IBM
'     https://github.com/philspil66/DONKEY.BAS
'   Remake to MSX by Amaury Carvalho (2025):
'     https://github.com/amaurycarvalho/msxbasic/Donkey
'-----------------------------------------------------------------
' Stack:
'   https://github.com/amaurycarvalho/msxbas2rom/
'-----------------------------------------------------------------
' Compile:
'   msxbas2rom DONKEY.BAS
'-----------------------------------------------------------------

1010 KEY OFF:SCREEN 0,1,0:COLOR 15,0,0:WIDTH 40:CLS:LOCATE 19,5:PRINT "IBM"
1020 LOCATE 12,7:PRINT "Personal Computer"
1030 COLOR 10,0:LOCATE 9,10:PRINT CHR$(213)+STRING$(21,205)+CHR$(184)
1040 LOCATE 9,11:PRINT CHR$(179)+"       DONKEY        "+CHR$(179)
1050 LOCATE 9,12:PRINT CHR$(179)+STRING$(21,32)+CHR$(179)
1060 LOCATE 9,13:PRINT CHR$(179)+"    Version 1.1O     "+CHR$(179)
1070 LOCATE 9,14:PRINT CHR$(212)+STRING$(21,205)+CHR$(190)
1080 COLOR 15,0:LOCATE 4,17:PRINT "(C) Copyright IBM Corp 1981, 1982"
1090 COLOR 14,0:LOCATE 7,23:PRINT "Press space bar to continue"
1100 IF INKEY<>0 THEN GOTO 1100
1110 K = INKEY
1120 IF K = 0 THEN GOTO 1110
1130 IF K = 27 THEN GOTO 1298
1140 IF K = 32 THEN GOTO 1291
1150 GOTO 1110

1291 KEY OFF
1293 PLAY "L10CDE"
1294 GOTO 1410

1298 SCREEN 1,1,0
1299 COLOR 7,0,0:CLS:END

1410 COLOR 0
1420 DEFINT A-Y
1440 SCREEN 2,0,0:COLOR 8,1
1450 DIM Q%(500)
1460 DIM D1%(150),D2%(150),C1%(200),C2%(200)
1470 DIM DNK%(300)
1480 GOSUB 1940
1490 GOSUB 1780
1500 CLS
1510 DIM B%(300)
1520 FOR I=2 TO 300:B%(I)=-16384+192:NEXT
1530 B%(0)=2:B%(1)=193

1540 CX=110
1550 CLS
1590 LINE (0,0)-(305,199),,B
1600 LINE (6,6)-(97,195),1,BF
1610 LINE (183,6)-(305,195),1,BF
1620 LOCATE 5,3:PRINT "Donkey"
1630 LOCATE 29,3:PRINT "Driver"
1631 LOCATE 25,19:PRINT"Press Space  ";
1632 LOCATE 25,20:PRINT"Bar to switch";
1633 LOCATE 25,21:PRINT"lanes        ";
1635 LOCATE 25,23:PRINT"Press ESC    ";
1636 LOCATE 25,24:PRINT"to exit      ";
1640 FOR Y=4 TO 199 STEP 20:LINE(140,Y)-(140,Y+10):NEXT
1650 CY=105:CX=105
1660 LINE (100,0)-(100,199):LINE(180,0)-(180,199)
1670 LOCATE 6,5:PRINT SD:LOCATE 31,5:PRINT SM
1680 CY=CY-4:IF CY<60 THEN 2230
1690 COPY CAR% TO (CX,CY) ',PRESET
1700 DX=105+42*INT(RND(1)*2)
1710 FOR Y=(RND(1)*-4)*8 TO 124 STEP 6
1720 PLAY "C" 'SOUND 20000,1
1730 K=INKEY : IF K=27 THEN 1298 ELSE IF K > 0 THEN LINE (CX,CY)-(CX+28,CY+44),0,BF:CX=252-CX:COPY CAR% TO (CX,CY) : BEEP ',PRESET:SOUND 200,1
1740 IF Y>=3 THEN COPY DNK% TO (DX,Y) ',PSET
1750 IF CX=DX AND Y+25>=CY THEN 2060
1760 IF Y AND 3 THEN COPY B% TO (140,6)
1770 NEXT:LINE (DX,124)-(DX+32,149),0,BF:GOTO 1670

1780 CLS
1790 DRAW "S8C3"
1800 DRAW"BM12,1r3m+1,3d2R1ND2u1r2d4l2u1l1"
1810 DRAW"d7R1nd2u2r3d6l3u2l1d3m-1,1l3"
1820 DRAW"m-1,-1u3l1d2l3u6r3d2nd2r1u7l1d1l2"
1830 DRAW"u4r2d1nd2R1U2"
1840 DRAW"M+1,-3"
1850 DRAW"BD10D2R3U2M-1,-1L1M-1,1"
1860 DRAW"BD3D1R1U1L1BR2R1D1L1U1"
1870 DRAW"BD2BL2D1R1U1L1BR2R1D1L1U1"
1880 DRAW"BD2BL2D1R1U1L1BR2R1D1L1U1"
1890 LINE(0,0)-(40,60),,B
1900 PAINT (1,1)
1910 DIM CAR%(900)
1920 COPY (1,1)-(29,45) TO CAR%
1930 RETURN

1940 CLS
1950 DRAW"S08"
1960 DRAW "BM14,18"
1970 DRAW"M+2,-4R8M+1,-1U1M+1,+1M+2,-1"
1980 DRAW"M-1,1M+1,3M-1,1M-1,-2M-1,2"
1990 DRAW"D3L1U3M-1,1D2L1U2L3D2L1U2M-1,-1"
2000 DRAW"D3L1U5M-2,3U1"
2010 PAINT (21,14),3
2020 PRESET (37,10):PRESET (40,10)
2030 PRESET (37,11):PRESET (40,11)
2040 COPY (13,0)-(45,25) TO DNK%
2050 RETURN

2060 SD=SD+1:LOCATE 6,14:PRINT "BOOM!"
2070 COPY (DX,Y)-(DX+16,Y+25) TO D1%
2080 D1X=DX:D1Y=Y:D2X=DX+17
2090 COPY (DX+17,Y)-(DX+31,Y+25) TO D2%
2100 COPY (CX,CY)-(CX+14,CY+44) TO C1%
2110 COPY (CX+15,CY)-(CX+28,CY+44) TO C2%
2120 C1X=CX:C1Y=CY:C2X=CX+15
2130 FOR P=6 TO 0 STEP -1:Z=1/(2^P):Z1=1-Z
2140 COPY C1% TO (C1X,C1Y) : COPY C2% TO (C2X,C1Y)
2150 COPY D1% TO (D1X,D1Y) : COPY D2% TO (D2X,D1Y)
2160 C1X=CX*Z1:D1Y=Y*Z1:C2X=C2X+(291-C2X)*Z
2170 D1X=DX*Z1:C1Y=C1Y+(155-C1Y)*Z:D2X=D2X+(294-D2X)*Z
2180 COPY C1% TO (C1X,C1Y) : COPY C2% TO (C2X,C1Y)
2190 COPY D1% TO (D1X,D1Y) : COPY D2% TO (D2X,D1Y)
2200 BEEP : NEXT 'SOUND 37+RND(1)*200,4:NEXT
2210 FOR Y=1 TO 2000:NEXT

2220 CLS:GOTO 1540
2230 SM=SM+1:LOCATE 25,7:PRINT "Donkey loses!"
2240 FOR Y=1 TO 1000:NEXT
2250 CLS:GOTO 1540

