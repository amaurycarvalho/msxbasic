'-----------------------------------------------------------------
' PICKINX - v1.2
'-----------------------------------------------------------------
' Game Info:
'   Pickin'X is a MSX clone of the arcade game of similar name developed by Valadon Automation in 1983.
'     https://www.arcade-museum.com/Videogame/pickin
'   Remake to MSX1 created by Amaury Carvalho (2021):
'     https://github.com/amaurycarvalho/msxbasic/PickinX
'     https://www.msxdev.org/2021/05/16/msxdev21-15-pickinx/
'-----------------------------------------------------------------
' Stack:
'   https://github.com/amaurycarvalho/msxbas2rom/
'   https://julien-nevo.com/at3test/index.php/download/
'   https://msx.jannone.org/conv/
'   https://msx.jannone.org/tinysprite/tinysprite.html
'   https://launchpad.net/nmsxtiles
'   https://github.com/pipagerardo/nMSXtiles
'-----------------------------------------------------------------
' Compile:
'   msxbas2rom pickinx.bas
'-----------------------------------------------------------------

' Resources (when compiling on Windows, change slashs to backslashs: / to \ ) 
FILE "music/pickinx.akm"                            ' 0
FILE "music/pickinx.akx"                            ' 1
FILE "img/screen_0_0.plet5"                         ' 2
FILE "img/screen_1_0.plet5"                         ' 3
FILE "img/screen_2_0.plet5"                         ' 4
FILE "img/screen_3_0.plet5"                         ' 5
FILE "img/screen_4_0.plet5"                         ' 6
FILE "img/screen_5_0.plet5"                         ' 7
FILE "img/screen_6_0.plet5"                         ' 8
FILE "img/screen_7_0.plet5"                         ' 9
FILE "img/tiles.chr.plet5"                          ' 10
FILE "img/tiles.clr.plet5"                          ' 11
FILE "img/sprites.spr"                              ' 12 - plain text file (load on TinySprite)

1 DATA "[ G O O D  W O R K ! ]"
2 DATA "[ WAS IT JUST LUCK?? ]"
3 DATA "[ YOU DID IT AGAIN ! ]"
4 DATA "[    Y E A H ! ! !   ]" 
5 DATA "[  YOU'RE THE BEST ! ]"
6 DATA "[   W  O  W  !  !  ! ]"
7 DATA "[ YOU ARE THE KING ! ]"

'==== GAME START
10 SCREEN 2, 2, 0 : COLOR 15, 0, 0
11 CMD DISSCR
12 CMD WRTCHR 10
13 CMD WRTCLR 11
14 SPRITE LOAD 12
15 CMD SETFNT 1
17 CMD WRTSCR 2
18 CMD PLYLOAD 0,1

20 LOCATE 07,  9 : PRINT "v1.2 BY AC (2021)" 
21 LOCATE 13, 12 : PRINT "PICKER";
22 LOCATE 13, 14 : PRINT "TRANSPOSER";
23 LOCATE 13, 16 : PRINT "DISTURBER";
24 LOCATE 13, 18 : PRINT "KILLER";
25 CMD ENASCR 

30 PUT SPRITE 0, (60,90), 15, 0
31 PUT SPRITE 1, (60,107), 13, 7
32 PUT SPRITE 2, (60,125), 11, 8
33 PUT SPRITE 3, (60,140),  8, 10
34 PUT SPRITE 4,,0,4
35 PUT SPRITE 5,,0,4

40 GOSUB 1510 
41 GOSUB 1000         ' GET PLAYER INPUT
42 IF B% = 0 THEN 41
43 GOSUB 1100         ' CLEAR PLAYER INPUT
44 CMD PLYMUTE

50 DIM BX%(2,20), BY%(2,20), BT%(2,20), BC%(2)
51 AC% = 1 : SS% = 3 : SC% = 500 : TT% = 0 : MR% = HEAP() : MV% = BASE(10)
52 IF NTSC() THEN L1% = 60 : L2% = 30 : L3% = 4 ELSE L1% = 50 : L2% = 25 : L3% = 2
 
'==== INITIALIZE LEVEL
60 CMD DISSCR
61 CMD WRTSCR SS%
62 GOSUB 2000 : GOSUB 1300
63 CMD ENASCR
64 GOSUB 1520 

70 PX% = 120 : PY% = 175 : PS% = 0 : PB% = 0 : GO% = -1 
71 DX% = 120 : DY% = 17 : DS% = 8 : DB% = 0 : DM% = 0 : DT% = 0 
72 IF AC% > 3 THEN DL% = 5 ELSE DL% = 10
73 IF (RR% MOD 2) = 0 THEN DK% = 3 : KK% = 7 ELSE DK% = 7 : KK% = 3
74 TX% = 0 : TY% = 0 : TS% = 5 : TXI% = 6 : TYI% = 6
75 KX% = 0 : KY% = 0 : KS% = 10 : WI% = 0 : SM% = 0
76 T1% = TIME : T2% = TIME : T3% = TIME : TT% = 0 : BP% = 0 : TF% = -1
77 GOSUB 1200 : GOSUB 1615 : GOSUB 1420 : GOSUB 1430

'==== MAIN LOOP
100 GOSUB 1400                                 ' SHOW SPRITES

110 GOSUB 1600                                 ' TIMERS

115 IF GO% = 0 THEN 3000                       ' GAME OVER
116 IF WI% > 0 THEN 3100                       ' VICTORY

120 GOSUB 1000                                 ' GET PLAYER INPUT
121 IF X% <> 0 OR Y% = 27 THEN GOSUB 3200      ' PAUSE/RESTART
122 IF K% = 0 AND B% = 0 THEN 110

125 IF TF% = 0 THEN 140

130 IF K% <> 0 THEN GOSUB 2200

140 IF B% <> 0 THEN GOSUB 2300

150 GOTO 100

'==== GET PLAYER INPUT
1000 K% = STICK(0) OR STICK(1) 
1001 X% = STRIG(3)
1002 B% = STRIG(0) OR STRIG(1) 
1003 Y% = INKEY
1004 GOTO 1900

'==== WAIT UNTIL INPUT
1100 IF strig(0) OR strig(1) OR stick(0) OR stick(1) OR strig(3) THEN 1100
1101 IF INKEY > 0 THEN 1101
1102 RETURN

'==== SHOW SCORE
1200 LOCATE 0, 0  : PRINT "LEFT:";USING$("####",SC%);
1201 LOCATE 25, 0 : PRINT "ACT:";USING$("###",AC%);
1202 LOCATE 11, 0 : PRINT "ELAPSED:";USING$("####",TT%);
1203 RETURN 

'==== CLEAR SPRITES
1300 FOR I% = 0 TO 3 : PUT SPRITE I%,,0 : NEXT : RETURN

'==== SHOW SPRITES
1400 PUT SPRITE 0,(PX%, PY%),15,PS%
1401 IF PB% > 0 THEN GOSUB 1420
1402 PUT SPRITE 2,(DX%, DY%),11,DS%
1403 IF DB% > 0 THEN GOSUB 1430
1404 IF TY% > 0 THEN PUT SPRITE 1,(TX%, TY%),13,TS% 
1405 IF KY% > 0 THEN PUT SPRITE 3,(KX%, KY%),8,KS% 
1406 RETURN

1420 PUT SPRITE 4,(PX%, PY%),PB% : RETURN

1430 PUT SPRITE 5,(DX%, DY%),DB% : RETURN

'==== SPLASH SCREEN
1510 LOCATE  3, 20 : PRINT "     ARE YOU READY ?     ";
1511 LOCATE  3, 21 : PRINT "SPACE OR TRIGGER TO START";
1512 CMD PLYSONG 1 : CMD PLYPLAY 
1513 RETURN

'==== LEVEL START MELODY
1520 CMD PLYSONG 2 : CMD PLYPLAY
1521 RETURN

'==== TIMERS
1600 D1% = ABS(TIME - T1%) : D2% = ABS(TIME - T2%) : D3% = ABS(TIME - T3%)
1601 IF D1% > L1% THEN GOSUB 1610
1602 IF D2% > L2% THEN GOSUB 1630
1603 IF D3% > L3% THEN GOTO  1650
1604 RETURN

1610 T1% = TIME : TT% = TT% + 1 : LOCATE 19, 0 : PRINT USING$("####",TT%);
1611 SC% = SC% - 1 : LOCATE 5, 0 : PRINT USING$("####",SC%); : IF SC% <= 0 THEN GO% = 0 : RETURN
1612 DI% = TT% - DT% : IF DI% > DL% THEN DT% = TT% : DM% = DM% XOR 1
1613 IF TT% > 120 AND TY% = 0 THEN CMD PLYSONG 3 : CMD PLYPLAY : GOSUB 1620
1614 IF TT% > 180 AND KY% = 0 THEN KY% = 17 : KX% = 120 : CMD PLYSONG 4 : CMD PLYPLAY

1615 'CMD VRAMTORAM MV%, MR%, 768 
1616 RETURN

1620 GOSUB 1900 : TY% = RR% MOD 150 + 20 : GOSUB 1900 : TX% = RR% MOD 200 : RETURN

1630 T2% = TIME
1631 IF DS% = 8 THEN DS% = 9 ELSE DS% = 8
1632 TS% = TS% + 1 : IF TS% > 7 THEN TS% = 5
1633 IF KS% = 10 THEN KS% = 11 ELSE KS% = 10
1634 IF DM% = 1 THEN 1950
1635 GOTO 1980

1640 IF SM% = 0 THEN RETURN
1641 CMD PLYSOUND SM%, 2
1642 IF SM% = 2 OR SM% >= 4 THEN SM% = 0 : RETURN
1643 SM% = SM% + 1
1644 RETURN

1650 GOSUB 1640 : T3% = TIME 
1651 IF TY% > 0 THEN GOSUB 1840
1652 IF KY% > 0 THEN GOSUB 1870
1653 GOTO 1800

1700 NX% = X% : NY% = Y% : NS% = S% : O% = 0
1701 IF K% = 3 THEN NX% = NX% + NI% : NS% = 1
1702 IF K% = 7 THEN NX% = NX% - NI% : NS% = 3
1703 IF K% = 5 THEN NY% = NY% + NI% : NS% = 2
1704 IF K% = 1 THEN NY% = NY% - NI% : NS% = 0
1705 IF NX% < 0 OR NX% > 240 THEN RETURN
1706 IF NY% < 17 OR NY% > 175 THEN RETURN
1707 AX% = NX% + 2  : AY% = NY% + 2 : IF K% = 1 OR K% = 7 GOSUB 1720
1708 AX% = NX% + 14 : IF K% = 1 OR K% = 3 GOSUB 1720
1709 AY% = NY% + 14 : IF K% = 3 OR K% = 5 GOSUB 1720
1710 AX% = NX% + 2  : IF K% = 5 OR K% = 7 GOSUB 1720
1711 X% = NX% : Y% = NY% : S% = NS% : O% = 1
1712 RETURN

1720 GOSUB 1750 : IF A% > 127 THEN RETURN 1712
1721 IF P% = 0 THEN IF PB% > 0 AND A% <> 0 THEN RETURN 1712
1722 RETURN

1750 XT% = AX% / 8 : YT% = AY% / 8
1751 A% = TILE( XT%, YT% )  
1752 RETURN

1800 GOSUB 1900 : RR% = RR% MOD 2 : NI% = 6
1801 X% = DX% : Y% = DY% : P% = 1
1802 IF DK% = 3 OR DK% = 7 THEN IF RR% = 0 THEN K% = 1 ELSE K% = 5
1803 IF DK% = 1 OR DK% = 5 THEN IF RR% = 0 THEN K% = 3 ELSE K% = 7
1804 GOSUB 1700
1805 IF O% = 1 THEN 1820
1806 X% = DX% : Y% = DY% : K% = DK% : GOSUB 1700
1807 IF O% = 1 THEN 1820

1810 IF DK% = 3 THEN DK% = 7 : GOTO 1806
1811 IF DK% = 7 THEN DK% = 3 : GOTO 1806
1812 IF DK% = 1 THEN DK% = 5 : GOTO 1806
1813 DK% = 1 : GOTO 1806

1820 DX% = X% : DY% = Y% : DK% = K%
1821 GOTO 1400

1840 TX% = TX% + TXI% : IF TX% < 0 OR TX% > 240 THEN TXI% = -TXI% : GOTO 1840
1841 TY% = TY% + TYI% : IF TY% < 17 OR TY% > 175 THEN TYI% = -TYI% : GOTO 1841
1842 IF TF% <> 0 THEN TF% = COLLISION(1, 0)
1843 IF TF% <> 0 THEN RETURN
1844 PX% = TX% : PY% = TY%
1845 RETURN

1870 GOSUB 1900 : RR% = RR% MOD 2 : NI% = 6
1871 X% = KX% : Y% = KY% : P% = 2
1872 IF KK% = 3 OR KK% = 7 THEN IF RR% = 0 THEN K% = 1 ELSE K% = 5
1873 IF KK% = 1 OR KK% = 5 THEN IF RR% = 0 THEN K% = 3 ELSE K% = 7
1874 GOSUB 1700
1875 IF O% = 1 THEN 1890
1876 X% = KX% : Y% = KY% : K% = KK% : GOSUB 1700
1877 IF O% = 1 THEN 1890

1880 IF KK% = 3 THEN KK% = 7 : GOTO 1876
1881 IF KK% = 7 THEN KK% = 3 : GOTO 1876
1882 IF KK% = 1 THEN KK% = 5 : GOTO 1876
1883 KK% = 1 : GOTO 1876

1890 KX% = X% : KY% = Y% : KK% = K% : GO% = COLLISION(3, 0)
1891 RETURN

'==== GET NEXT RANDOM NUMBER
1900 RR% = RND(1) * 100 : RETURN

1950 IF DB% > 0 THEN RETURN
1951 GOTO 2600

1980 IF DB% = 0 THEN RETURN
1981 GOTO 2600

'==== CHECK MAZE STATUS
2000 FOR I% = 0 TO 2 : BC%(I%) = 0 : NEXT
2010 FOR X% = 0 TO 31 STEP 2
2011   FOR Y% = 0 TO 22 STEP 2
2020     A% = TILE(X%, Y%) : I% = 3
2021     IF A% >= 1 AND A% <= 4  THEN I% = 0
2022     IF A% >= 5 AND A% <= 8  THEN I% = 1
2023     IF A% >= 9 AND A% <= 12 THEN I% = 2
2024     IF I% = 3 THEN 2030
2025     A% = BC%(I%) 
2026     BX%(I%,A%) = X% : BY%(I%,A%) = Y% : BT%(I%,A%) = 0
2027     BC%(I%) = A% + 1
2030   NEXT
2031 NEXT
2040 FOR I% = 0 TO 2 
2041   FOR A% = 0 TO BC%(I%) - 1
2042     GOSUB 1900 : RR% = RR% MOD 3 : IF RR% = I% THEN 2042
2043     K% = A% MOD BC%(RR%)
2044     IF BT%(I%,A%) > 0 OR BT%(RR%,K%) > 0 THEN 2060
2045     X% = BX%(I%,A%) : Y% = BY%(I%,A%) : BT%(I%,A%) = 1
2046     B% = RR% : GOSUB 2100
2047     X% = BX%(RR%,K%) : Y% = BY%(RR%,K%) : BT%(RR%,K%) = 1
2048     B% = I% : GOSUB 2100
2060   NEXT
2061 NEXT
2062 RETURN

2100 IF B% = 0 THEN W% = 1
2101 IF B% = 1 THEN W% = 5
2102 IF B% = 2 THEN W% = 9
2103 PUT TILE W%, (X%, Y%)
2104 PUT TILE W%+1, (X%+1, Y%)
2105 PUT TILE W%+2, (X%, Y%+1)
2106 PUT TILE W%+3, (X%+1, Y%+1)
2107 RETURN

2200 X% = PX% : Y% = PY% : S% = PS% : NI% = 2 : P% = 0 : GOSUB 1700 
2201 IF O% = 1 THEN 2250
2202 IF K% = 3 OR K% = 7 THEN 2220

2210 FOR I% = 1 TO 8
2211    X% = PX% + I% : GOSUB 1700 : IF O% = 1 THEN 2250
2212    X% = PX% - I% : GOSUB 1700 : IF O% = 1 THEN 2250
2213 NEXT
2214 RETURN

2220 FOR I% = 1 TO 8
2221   Y% = PY% + I% : GOSUB 1700 : IF O% = 1 THEN 2250
2222   Y% = PY% - I% : GOSUB 1700 : IF O% = 1 THEN 2250
2223 NEXT
2224 RETURN

2250 PX% = X% : PY% = Y% : PS% = S%
2251 RETURN

'==== GET OBJECT
2300 IF ABS(TIME - BP%) < L2% THEN RETURN
2301 BP% = TIME 
2302 AX% = PX%+8 : AY% = PY%+8 : GOSUB 2400
2303 IF TF% = 0 AND A% = 0 THEN TF% = -1 : GOTO 1620
2304 IF PB% > 0 THEN 2350
2305 IF BS% = 0 THEN 2360
2306 PB% = BS% : SM% = 1    
2307 GOTO 2500

'==== RELEASE OBJECT
2350 IF A% <> 0 THEN 2360
2351 BS% = PB% : GOSUB 2550
2352 IF W% > 0 THEN PB% = 0 : SM% = 3 : GOSUB 1420 : GOTO 2700
2353 RETURN

'==== WRONG OBJECT
2360 SM% = 5 : RETURN

2400 BS% = 0 : GOSUB 1750
2401 IF A% = 0 OR A% > 12 THEN RETURN
2402 IF A% <= 4 THEN BS% = 2 : RETURN
2403 IF A% <= 8 THEN BS% = 4 : RETURN
2404 BS% = 8 
2405 RETURN 

2500 A% = (A% - 1) MOD 4
2501 IF A% = 1 OR A% = 3 THEN XT% = XT% - 1
2502 IF A% = 2 OR A% = 3 THEN YT% = YT% - 1
2503 PUT TILE 0, (XT%, YT%)
2504 PUT TILE 0, (XT%+1, YT%)
2505 PUT TILE 0, (XT%, YT%+1)
2506 PUT TILE 0, (XT%+1, YT%+1)
2507 RETURN 
 
2550 W% = 0 : X% = (AX% - 4) / 8 : Y% = (AY% - 4) / 8
2551 IF TILE(X%+1,Y%+1) <> 0 OR TILE(X%+1,Y%) <> 0 OR TILE(X%,Y%+1) <> 0 OR TILE(X%,Y%) <> 0 THEN 2360
2552 IF BS% = 2 THEN W% = 1 : GOTO 2103
2553 IF BS% = 4 THEN W% = 5 : GOTO 2103
2554 W% = 9  
2555 GOTO 2103

2600 AX% = DX%+8 : AY% = DY%+8 : GOSUB 2400
2601 IF DB% > 0 THEN 2650
2602 IF BS% = 0 THEN RETURN
2603 DB% = BS%
2604 GOTO 2500

2650 IF A% <> 0 THEN RETURN
2651 BS% = DB% : GOSUB 2550
2652 IF W% > 0 THEN DB% = 0 : GOTO 1430
2653 RETURN

2700 WI% = 1
2701 FOR I% = 0 TO 2 
2702   FOR A% = 0 TO BC%(I%) - 1
2703     X% = BX%(I%,A%) : Y% = BY%(I%,A%)
2704     W% = TILE(X%,Y%)
2705     IF I% = 0 THEN IF W% < 1 OR W% > 4 THEN WI% = 0 : RETURN
2706     IF I% = 1 THEN IF W% < 5 OR W% > 8 THEN WI% = 0 : RETURN
2707     IF I% = 2 THEN IF W% < 9 OR W% > 12 THEN WI% = 0 : RETURN
2720   NEXT
2721 NEXT
2722 RETURN

'==== WAIT X% SECONDS
2800 Y% = TIME : X% = X% * L1%
2801 IF TIME < Y% THEN Y% = TIME
2802 DI% = TIME - Y%
2803 IF DI% < X% THEN 2801
2804 RETURN

'==== GAME OVER
3000 LOCATE 03,01 
3001 IF SC% = 0 THEN PRINT "[   G A M E   O V E R   ]"; ELSE PRINT "[  YOU GOT CAUGHT !!!!! ]";
3002 CMD PLYSONG 5 : CMD PLYPLAY
3003 GOSUB 1100                                                 ' CLEAR KEY BUFFER
3004 X% = 2 : GOSUB 2800                                        ' WAIT X% SECONDS
3010 GOSUB 1000 : IF B% = 0 THEN 3010
3011 CMD PLYMUTE : GOSUB 1100
3012 IF SC% = 0 THEN 10 ELSE 60

'==== VICTORY AND NEXT LEVEL
3100 IF SS% = 3 THEN RESTORE 1
3101 READ MS$ : LOCATE 05,01 : PRINT MS$;
3102 CMD PLYSONG 6 : CMD PLYPLAY
3103 GOSUB 1100                                                 ' CLEAR KEY BUFFER
3104 X% = 2 : GOSUB 2800                                        ' WAIT X% SECONDS
3110 GOSUB 1000 : IF B% = 0 THEN 3110
3111 CMD PLYMUTE : GOSUB 1100
3120 SS% = AC% MOD 7 + 3 : AC% = AC% + 1 
3121 SC% = SC% + 300
3122 GOTO 60

'==== PAUSE/RETURN
3200 LOCATE 0,0 : PRINT ">>>>>>>>>[ P A U S E ]<<<<<<<<<<";
3201 CMD PLYSONG 0 : CMD PLYPLAY : CMD PLYSOUND 6               ' PAUSE SOUND
3202 GOSUB 1100                                                 ' CLEAR KEYBOARD BUFFER
3203 X% = 1 : GOSUB 2800                                        ' WAIT X% SECONDS
3210 IF STRIG(0) OR STRIG(1) THEN 3220
3211 IF INKEY = 27 OR STRIG(3) THEN GOSUB 1100 : RETURN 10
3212 GOTO 3210
3220 GOSUB 1100                                                 ' CLEAR KEYBOARD BUFFER
3221 CMD PLYSOUND 6                                             ' PAUSE SOUND
3222 LOCATE 0,0 : PRINT "                                ";
3223 GOTO 1200                                                  ' SHOW SCORE


