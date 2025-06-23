'-----------------------------------------------------------------
' FLUBBER IN THE UPSIDE DOWN WORLD (v1.2)
'-----------------------------------------------------------------
' Game Info:
'   Flubber is a side-scrolling bouncing ball game where the goal is to get through an obstacle course and 
'   reach the finish flag in less than a minute.
'   Developed by Amaury Carvalho (2021-2023)
'   All songs are variations of Perez Prado's Mambos
'     https://github.com/amaurycarvalho/msxbasic/Flubber
'     https://www.msxdev.org/2023/06/07/msxdev23-08-flubber-in-the-upside-down-world/
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
'   msxbas2rom flubber.bas
'-----------------------------------------------------------------

' Resources (when compiling on Windows, change slashs to backslashs: / to \ ) 
FILE "music/flubber.akm"                ' 0
FILE "music/effects.akx"                ' 1
FILE "img/splash.sc2"                   ' 2
FILE "img/playfield.sc2"                ' 3
FILE "img/finale.sc2"                   ' 4
FILE "img/flubber.spr"                  ' 5
FILE "levels/levels.txt"                ' 6

'==== GAME INITIALIZE
10 DIM PX%(1), PY%(1), PS%(1), PJ%(1), PM%(1), PC%(2)
11 DIM BX%(15), SBUF$(2), LBUF$(7)                        ' screen and level buffers 
12 IF NTSC() THEN TM% = 60 : TH% = 30 : TS% = 6 ELSE TM% = 50 : TH% = 25 : TS% = 5
13 CBUF$ = "" : CBP% = VARPTR(CBUF$)                      ' cloud buffer and pointer
14 SBP% = VARPTR(SBUF$(0)) : LBP% = VARPTR(LBUF$(0))      ' screen and level buffer pointers
15 SVP% = BASE(10) + 32                                   ' screen vram pointer
16 HS# = 0                                                ' hi-score

20 SCREEN 2, 2, 0
22 SET TILE ON
23 CMD RESTORE 6
24 CMD PLYLOAD 0, 1

'==== GAME START
30 CMD DISSCR
31 COLOR 15, 0, 0 
32 SCREEN LOAD 2
33 GOSUB 5200               ' set game font

40 GOSUB 2000               ' clear sprites
41 LOCATE 02,14 : PRINT "        I N   T H E";
42 LOCATE 02,16 : PRINT "     UPSIDE DOWN WORLD";
43 LOCATE 02,19 : PRINT "  BY AMAURY CARVALHO (2023)";
44 LOCATE 02,23 : PRINT "  SPACE OR TRIGGER TO START";
45 CMD PLYSONG 0            ' opening song
46 CMD PLYPLAY
47 CMD ENASCR

50 PC%(0) = 12 : PC%(1) = 0 : PC%(2) = 15 : W% = 0
51 GOSUB 3400               ' splash animation
52 GOSUB 1000 : IF B% = 0 THEN 51
53 GOSUB 2200               ' wait player to release space or button
54 CMD PLYMUTE

60 PP# = 0 : PN% = 0        ' player points 
61 PL% = 3                  ' player lives            <=========== game parameter
62 LV% = 1                  ' level number            <=========== game parameter
63 MT% = 0                  ' mute flag (0=sound, 1=mute)
64 SG% = 1                  ' playing song
65 CF% = 0                  ' cloud flag

'==== LEVEL START
70 PX%(0) = 20 : PY%(0) = 71 : PS%(0) = 0 : PJ%(0) = 0
71 PX%(1) = PX%(0) : PY%(1) = PY%(0) + 32 : PS%(1) = 12 : PJ%(1) = 0
72 PM%(0) = 2 : PM%(1) = PM%(0)
73 PT% = TIME : PMT% = PT%
74 PI% = 2 : PMI% = PI%
75 T0% = TIME : T1% = TIME : T2% = TIME : T3% = TIME
76 LT% = 60                 ' level time              <=========== game parameter
77 LSS% = 0                 ' level scroll step
78 LST% = 0                 ' level status (0=playing, 1=finish flag, 2=knife)

80 GOSUB 4000               ' show playfield  

90 GOSUB 2100               ' show sprites
91 GOSUB 2320               ' play song

'==== MAIN LOOP
100 GOSUB 1000       ' PLAYER INPUT
101 IF K% = 27 OR C% <> 0 THEN 3000   ' PAUSE
102 GOSUB 3100       ' MOVE PLAYER
103 GOSUB 3200       ' GRAVITY AND JUMPING
104 GOSUB 3300       ' MOVE CLOUDS
105 GOSUB 3700       ' TIME UPDATE

110 IF LT% = 0 OR PL% = 0 THEN 3800          ' TIME IS UP OR LIFE'S END
111 ON LST% GOTO 3900, 3830                  ' finish flag was reached or a knife was hitted
112 IF K% = 77 OR K% = 109 GOSUB 2300        ' M = MUTE
'113 IF K% = 9 THEN 3900                      ' TAB = NEXT LEVEL

120 GOTO 100

'==== PLAYER INPUT
1000 A% = STICK(0) OR STICK(1)
1001 B% = STRIG(0) OR STRIG(1)
1002 C% = STRIG(3) 
1003 K% = INKEY

'==== RANDOM NUMBER
1100 R% = RND(1) * 100
1101 RETURN

'==== CLEAR SPRITES
2000 FOR I% = 0 TO 15
2001   PUT SPRITE I%,,0
2002 NEXT
2003 RETURN

'==== SHOW SPRITES
2100 PUT SPRITE 0,(PX%(0), PY%(0)), 1, PS%(0)
2101 PUT SPRITE 1,(PX%(0), PY%(0)), 2, PS%(0)+1
2102 PUT SPRITE 2,(PX%(1), PY%(1)), 1, PS%(1)
2103 PUT SPRITE 3,(PX%(1), PY%(1)), 12, PS%(1)+1
2104 RETURN

'==== WAIT WHILE A SPACE/TRIGGER
2200 GOSUB 1000
2201 IF B% <> 0 OR C% <> 0 OR K% <> 0 THEN 2200
2202 RETURN

'==== MUTE
2300 IF MT% = 1 THEN 2310
2301   MT% = 1
2302   SG% = 4       ' mute song
2303   GOTO 2320

2310 MT% = 0
2311 SG% = 1         ' gameplay song

2320 CMD PLYSONG SG% 
2321 CMD PLYPLAY
2322 RETURN

'==== WAIT n CYCLES (n = NC%)
2400 T2% = TIME
2410 IF TIME < T2% THEN T2% = TIME
2411 DI% = TIME - T2%
2412 IF DI% < NC% THEN 2410
2413 RETURN

'==== PAUSE
3000 GOSUB 2200                                                   ' WAIT WHILE A SPACE/TRIGGER
3001 CMD PLYSONG 4 : CMD PLYPLAY : CMD PLYSOUND 4                 ' PAUSE SOUND
3002 LOCATE 10,23 : PRINT "PAUSE";

3010 GOSUB 1000
3011 IF K% = 27 THEN 30                                           ' RESTART GAME
3012 IF B% = 0 AND C% = 0 THEN 3010
3013 CMD PLYSONG SG% : CMD PLYPLAY
3014 LOCATE 10,23 : PRINT "     "; 
3015 GOTO 100                                                     ' MAIN LOOP

'==== MOVE PLAYER
3100 IF TIME < PT% THEN PT% = TIME
3101 DI% = TIME - PT%
3102 IF DI% < PI% THEN RETURN
3103 PT% = TIME
3104 IF A% = 0 AND B% = 0 THEN RETURN
3105 GOSUB 3110                                     ' check arrows
3106 GOTO 3150                                      ' check button

' check arrows
3110 SS% = 0
3111 IF A% >= 2 AND A% <= 4 THEN 3130
3112 IF A% >= 6 AND A% <= 8 THEN 3120
3113 RETURN

3120 X% = PX%(0) - 4 
3121 Y% = PY%(1) - 7                                ' check obstacle at left of flubber down
3122 GOSUB 5100 : IF O% = 0 THEN RETURN
3123 Y% = PY%(0) + 1                                ' check obstacle at left of flubber up
3124 GOSUB 5100 : IF O% = 0 THEN RETURN
3125 SS% = 4
3126 GOSUB 3600                                     ' do playfield level left scrolling
3127 GOTO 3140

3130 X% = PX%(0) + 4 
3131 Y% = PY%(1) - 7                                ' check obstacle at right of flubber down
3132 GOSUB 5110 : IF O% = 0 THEN RETURN
3133 Y% = PY%(0) + 1                                ' check obstacle at right of flubber up
3134 GOSUB 5110 : IF O% = 0 THEN RETURN
3135 SS% = 2
3136 GOSUB 3500                                     ' do playfield level right scrolling

3140 PX%(0) = X% : PX%(1) = X%
3141 IF PJ%(0) > 0 OR PS%(0) >= 6 THEN PS%(0) = SS% + 6 ELSE PS%(0) = SS%
3142 IF PJ%(1) > 0 OR PS%(1) >= 18 THEN PS%(1) = SS% + 18 ELSE PS%(1) = SS% + 12
3143 GOTO 2100                                      ' show sprites

' check button
3150 IF PJ%(0) > 0 THEN RETURN
3151 IF PS%(0) >= 6 THEN RETURN
3152 IF B% <> 0 THEN PM%(0) = 4 : JS% = 4 : GOTO 3160
3153 IF A% = 8 OR A% = 1 OR A% = 2 THEN PM%(0) = 2 : JS% = 1 : GOTO 3160
3154 RETURN

3160 PJ%(0) = 12                                    ' activate jump
3161 IF A% = 1 THEN PS%(0) = 6 ELSE PS%(0) = PS%(0) + 6
3162 CMD PLYSOUND JS%, 2
3163 GOTO 2100                                      ' show sprites

'==== GRAVITY AND JUMPING
3200 IF TIME < PMT% THEN PMT% = TIME
3201 DI% = TIME - PMT%
3202 IF DI% < PMI% THEN RETURN
3203 PMT% = TIME
3204 IF PJ%(0) = 0 THEN GOSUB 3210 ELSE GOSUB 3230  ' choose between gravity or jumping for flubber up
3205 IF PJ%(1) = 0 THEN GOTO 3250 ELSE GOTO 3270    ' choose between gravity or jumping for flubber down

' gravity for flubber up
3210 X% = PX%(0) : Y% = PY%(0) + PM%(0)
3212 GOSUB 5130                                     ' check obstacle down
3213 IF O% = 1 THEN 3240

3220 IF PS%(0) < 6 THEN RETURN
3221 PS%(0) = PS%(0) - 6                            ' end of fall
3222 CMD PLYSOUND 1, 2 
3223 IF PJ%(1) > 0 THEN 2100
3224 PM%(1) = PM%(0)                                ' activate flubber down jump
3225 PJ%(1) = 12 
3226 PS%(1) = PS%(0) + 18
3227 GOTO 2100                                      ' show sprites

' jumping for flubber up
3230 PJ%(0) = PJ%(0) - 1 
3231 X% = PX%(0) : Y% = PY%(0) - PM%(0)
3232 GOSUB 5120                                     ' check obstacle up
3233 IF O% = 1 THEN 3240
3234 PJ%(0) = 0 
3235 RETURN

3240 PY%(0) = Y%
3241 GOTO 2100                                      ' show sprites

' gravity for flubber down
3250 X% = PX%(1) : Y% = PY%(1) - PM%(1) - 6
3251 GOSUB 5120                                     ' check obstacle up
3252 IF O% = 1 THEN 3280

3260 IF PS%(1) < 18 THEN RETURN
3261 PS%(1) = PS%(1) - 6                            ' end of fall
3262 CMD PLYSOUND 1, 2 
3263 GOTO 2100                                      ' show sprites

' jumping for flubber down
3270 PJ%(1) = PJ%(1) - 1 
3271 X% = PX%(1) : Y% = PY%(1) + PM%(1) - 6
3272 GOSUB 5130                                     ' check obstacle down
3273 IF O% = 1 THEN 3280
3274 PJ%(1) = 0 
3275 RETURN

3280 PY%(1) = Y% + 6
3281 GOTO 2100                                      ' show sprites

'==== MOVE CLOUDS
3300 IF TIME < T1% THEN T1% = TIME
3301 DI% = TIME - T1%
3302 IF DI% < TS% THEN RETURN           ' 10x/s
3303 T1% = TIME

3310 CF% = (CF% + 1) MOD 3
3311 I% = CBP%                          ' move cloud 1
3312 IF CF% = 0 THEN I% = I% + 64       ' else, move cloud 2
3313 X% = PEEK(I%) : Y% = PEEK(I%+32)   ' cloud scrolling
3314 CMD RAMTORAM I%+1, I%, 64
3315 POKE I%+31, X% : POKE I%+63, Y%
3320 GOTO 4250                          ' copy buffer to clouds vram

'==== SPLASH ANIMATION
3400 IF TIME < PT% THEN PT% = TIME
3401 DI% = TIME - PT%
3402 IF DI% < TS% THEN RETURN
3403 PT% = TIME

3410 IF PC%(0) = 12 THEN GOSUB 3421 : GOSUB 3420 ELSE GOSUB 3420 : GOSUB 3421
3411 PC%(0) = PC%(0) XOR 12 : PC%(1) = PC%(1) XOR 12
3412 W% = (W% + 1) MOD 5
3413 IF W% > 0 THEN RETURN
3414 PC%(2) = PC%(2) XOR 10
3415 FOR I% = 130 TO 138 : SET TILE COLOR I%, PC%(2), 4 : NEXT
3416 RETURN

3420 SET TILE COLOR 139, PC%(0), 1 : SET TILE COLOR 144, PC%(0), 1 : SET TILE COLOR 145, PC%(0), 1 : SET TILE COLOR 146, PC%(0), 1 : RETURN
3421 SET TILE COLOR 192, PC%(1), 1 : SET TILE COLOR 193, PC%(1), 1 : SET TILE COLOR 194, PC%(1), 1 : SET TILE COLOR 195, PC%(1), 1 : RETURN

'==== SCROLL PLAYFIELD LEVEL TO RIGHT
3500 IF PX%(0) < 168 THEN RETURN
3501 IF LSS% >= 96 THEN RETURN
3502 LSS% = LSS% + 1 : X% = X% - 4
3503 GOTO 4800                          ' copy playfield level to screen

'==== SCROLL PLAYFIELD LEVEL TO LEFT
3600 IF PX%(0) > 80 THEN RETURN
3601 IF LSS% = 0 THEN RETURN
3602 LSS% = LSS% - 1 : X% = X% + 4
3603 GOTO 4800                          ' copy playfield level to screen

'==== TIME UPDATE
3700 IF TIME < T0% THEN T0% = TIME
3701 DI% = TIME - T0%
3702 IF DI% < TM% THEN RETURN           ' 1x/min
3703 T0% = TIME
3710 IF LT% > 0 THEN LT% = LT% - 1
3711 IF MT% = 0 THEN IF LT% = 12 THEN CMD PLYSONG 5 : CMD PLYPLAY
3712 GOTO 4100                          ' score update

'==== TIME'S UP OR LIFE'S END
3800 IF PL% > 0 THEN PL% = PL% - 1 : GOSUB 4100
3801 IF PL% = 0 THEN 3850
3810 LOCATE 4, 10 : PRINT "+-----------------------+";
3811 LOCATE 4, 11 : PRINT "+  T I M E  I S  U P !  +";
3812 LOCATE 4, 12 : PRINT "+-----------------------+";
3813 CMD PLYSONG 3 : CMD PLYPLAY
3814 GOSUB 5300                         ' player is dead
3815 NC% = TM% : GOSUB 2400             ' wait NC% cycles
3820 GOSUB 1000 : IF B% = 0 THEN 3820
3821 GOSUB 2200                         ' wait player to release space or button
3822 CMD PLYMUTE
3823 GOTO 70

'==== A KNIFE WAS HITTED
3830 IF PL% > 0 THEN PL% = PL% - 1 : GOSUB 4100
3831 IF PL% = 0 THEN 3850
3840 LOCATE 4, 10 : PRINT "+-----------------------+";
3841 LOCATE 4, 11 : PRINT "+ OOPS! TRY IT AGAIN... +";
3842 LOCATE 4, 12 : PRINT "+-----------------------+";
3843 CMD PLYSONG 3 : CMD PLYPLAY
3844 GOSUB 5300                         ' player is dead
3845 NC% = TM% : GOSUB 2400             ' wait NC% cycles
3846 GOSUB 1000 : IF B% = 0 THEN 3846
3847 GOSUB 2200                         ' wait player to release space or button
3848 CMD PLYMUTE
3849 GOTO 70

'==== GAME OVER
3850 LOCATE 4, 10 : PRINT "+-----------------------+";
3851 LOCATE 4, 11 : PRINT "+   G A M E   O V E R   +";
3852 LOCATE 4, 12 : PRINT "+-----------------------+";
3853 CMD PLYSONG 3 : CMD PLYPLAY
3854 GOSUB 5300                         ' player is dead
3855 NC% = TM% : GOSUB 2400             ' wait NC% cycles
3860 GOSUB 1000 : IF B% = 0 THEN 3860
3861 GOSUB 2200                         ' wait player to release space or button
3862 CMD PLYMUTE
3863 GOTO 30

'==== LEVEL VICTORY
3900 LOCATE 4, 10 : PRINT "+-----------------------+";
3901 LOCATE 4, 11 : PRINT "+ Y O U  M A D E  I T ! +";
3902 LOCATE 4, 12 : PRINT "+-----------------------+";
3903 CMD PLYSONG 2 : CMD PLYPLAY
3904 GOSUB 2000                         ' clear sprites
3905 GOSUB 3930                         ' add points
3906 NC% = TM% : GOSUB 2400             ' wait NC% cycles
3910 GOSUB 1000 : IF B% = 0 THEN 3910
3911 GOSUB 2200                         ' wait player to release space or button
3912 LV% = LV% + 1
3920 CMD PLYMUTE
3921 IF LV% > 15 THEN 3950
3922 GOTO 70

' add points
3930 IF LT% = 0 THEN RETURN
3931 PP# = PP# + 10 : PN% = PN% + 1 : LT% = LT% - 1                     ' add 10 points for each second left
3932 IF PN% >= 100 AND PL% < 99 GOSUB 3940                              ' add 1 life for each 1000 points
3933 IF HS# < PP# THEN HS# = PP#                                        ' hi-score control
3934 GOSUB 4100                                                         ' update score
3935 CMD PLYSOUND 6, 2                                                  ' countdown sound
3936 NC% = 1 : GOSUB 2400                                               ' wait NC% cycles
3937 GOTO 3930

3940 CMD PLYSOUND 3, 0
3941 PN% = PN% - 100 
3942 PL% = PL% + 1
3943 RETURN

'==== CONGRATULATIONS
3950 CMD DISSCR
3951 GOSUB 2000                         ' clear sprites
3952 SCREEN LOAD 4
3953 GOSUB 5200                         ' set game font
3954 CMD ENASCR
3960 LOCATE 2, 11 : PRINT "    CONGRATULATIONS!!!!";
3961 LOCATE 2, 12 : PRINT "    -------------------";
3962 LOCATE 2, 14 : PRINT "    YOU BRAVELY REACHED";
3963 LOCATE 2, 16 : PRINT "      THE LAST LEVEL!";
3964 LOCATE 2, 18 : PRINT "  YOUR FINAL SCORE: "; USING$("00000",PP#);
3965 LOCATE 1, 22 : PRINT "SPACE OR TRIGGER TO PLAY AGAIN";
3970 CMD PLYSONG 6 : CMD PLYPLAY
3971 NC% = TM% * 2 : GOSUB 2400         ' wait NC% cycles
3972 GOSUB 1000 : IF B% = 0 THEN 3972
3973 GOSUB 2200                         ' wait player to release space or button
3974 CMD PLYMUTE
3975 GOTO 30

'==== SHOW PLAYFIELD
4000 CMD DISSCR
4001 COLOR 15, 0, 0 
4002 GOSUB 2000                         ' clear sprites
4003 SCREEN LOAD 3
4004 SPRITE LOAD 5
4005 GOSUB 5200                         ' set game font
4006 LOCATE 0,  0 : PRINT "LIVES: 00 TIME: 000 SCORE: 00000";
4007 LOCATE 0, 23 : PRINT "LEVEL: 00        HI-SCORE: 00000";
4008 GOSUB 4100                         ' show score panel

4010 GOSUB 4200                         ' copy vram clouds to buffer
4011 GOSUB 4300                         ' load playfield level data
4012 GOSUB 4800                         ' copy playfield level to screen

4020 CMD ENASCR
4021 RETURN

'==== SHOW SCORE PANEL
4100 LOCATE  7,  0 : PRINT USING$("##", PL%);
4101 LOCATE 16,  0 : PRINT USING$("###", LT%);
4102 LOCATE 27,  0 : PRINT USING$("00000", PP#);
4103 LOCATE  7, 23 : PRINT USING$("##", LV%);
4104 LOCATE 27, 23 : PRINT USING$("00000", HS#);
4105 RETURN

'==== COPY VRAM CLOUDS TO BUFFER
4200 CMD VRAMTORAM SVP%, CBP%, 64
4201 CMD VRAMTORAM SVP%+640, CBP%+64, 64
4202 RETURN

'==== COPY BUFFER TO VRAM CLOUDS
4250 CMD RAMTOVRAM CBP%, SVP%, 64
4251 CMD RAMTOVRAM CBP%+64, SVP%+640, 64
4252 RETURN

'==== LOAD PLAYFIELD LEVEL DATA
4300 RESTORE LV% - 1
4301 GOSUB 4500                         ' up part
4302 GOSUB 4600                         ' down part
4303 GOTO 4700                          ' initialize screen buffer

4410 POKE Y%, C% : POKE Y%+1, C% : POKE Y%+128, C% : POKE Y%+129, C% : RETURN
4420 POKE Y%, C% : POKE Y%+1, C%+1 : POKE Y%+128, C%+2 : POKE Y%+129, C%+3 : RETURN

' Level data scheme:
'         X   X   X   W   X           = 0
'         X   X           W           = 1
'     X   X                       M   = 2
' X   X                       M   X   = 3
' --- --- --- --- --- --- --- --- ---
' 1   2   3   4   5   w   W   m   M
' 049 050 051 052 053 119 087 109 077

'====  LOAD PLAYFIELD LEVEL DATA - UP PART
4500 READ LS$                           ' up level
4510 Y% = LBP%                          ' level buffer pointer
4511 FOR K% = 0 TO 3
4512   X% = VARPTR(LS$) + 1             ' level data pointer
4513   FOR I% = 0 TO 63
4514     W% = PEEK(X%)
4515     C% = 128
4516     ON K% GOTO 4530, 4540, 4550
'        row 0
4520        IF W% >= 51 AND W% <= 53 OR W% = 87 THEN C% = 138 : GOTO 4560  ' 3, 4, 5, W
4521        IF W% = 119 THEN C% = 144                                      ' w
4522        GOTO 4560
'        row 1
4530        IF W% = 51 OR W% = 52 THEN C% = 138 : GOTO 4560                ' 3, 4
4531        IF W% = 87 THEN C% = 144                                       ' W
4532        GOTO 4560
'        row 2
4540        IF W% = 50 OR W% = 51 THEN C% = 138 : GOTO 4560                ' 2, 3
4541        IF W% = 77 THEN C% = 142                                       ' M
4542        GOTO 4560
'        row 3
4550        IF W% = 49 OR W% = 50 OR W% = 77 THEN C% = 138 : GOTO 4560     ' 1, 2, M
4551        IF W% = 109 THEN C% = 142 : GOTO 4560                          ' m
4552        IF W% = 60 THEN C% = 130 : GOTO 4560                           ' <
4553        IF W% = 62 THEN C% = 134                                       ' >
'        continue   
4560     IF C% = 128 THEN GOSUB 4410 ELSE GOSUB 4420
4561     X% = X% + 1
4562     Y% = Y% + 2
4570   NEXT
4571   Y% = Y% + 128
4580 NEXT
4581 RETURN

'====  LOAD PLAYFIELD LEVEL DATA - DOWN PART
4600 READ LS$                           ' down level
4610 FOR K% = 0 TO 3
4611   X% = VARPTR(LS$) + 1             ' level data pointer
4613   FOR I% = 0 TO 63
4614     W% = PEEK(X%) 
4615     C% = 160
4616     ON K% GOTO 4630, 4640, 4650
'        row 0
4620        IF W% = 49 OR W% = 50 OR W% = 77 THEN C% = 170 : GOTO 4660     ' 1, 2, M
4621        IF W% = 109 THEN C% = 172 : GOTO 4660                          ' m
4622        IF W% = 60 THEN C% = 162 : GOTO 4660                           ' <
4623        IF W% = 62 THEN C% = 166                                       ' >
4624        GOTO 4660
'        row 1
4630        IF W% = 50 OR W% = 51 THEN C% = 170 : GOTO 4660                ' 2, 3
4631        IF W% = 77 THEN C% = 172                                       ' M
4632        GOTO 4660
'        row 2
4640        IF W% = 51 OR W% = 52 THEN C% = 170 : GOTO 4660                ' 3, 4
4641        IF W% = 87 THEN C% = 176                                       ' W
4642        GOTO 4660
'        row 3
4650        IF W% >= 51 AND W% <= 53 OR W% = 87 THEN C% = 170 : GOTO 4660  ' 3, 4, 5, W
4651        IF W% = 119 THEN C% = 176                                      ' w
'        continue   
4660     IF C% = 160 THEN GOSUB 4410 ELSE GOSUB 4420
4661     X% = X% + 1
4662     Y% = Y% + 2
4670   NEXT
4671   Y% = Y% + 128
4680 NEXT
4681 RETURN

'==== INITIALIZE SCREEN BUFFER
4700 DST% = SBP%
4701 FOR I% = 0 TO 767
4702    POKE DST%, 138
4703    DST% = DST% + 1
4704 NEXT
4705 RETURN

'==== COPY PLAYFIELD LEVEL DATA TO SCREEN VRAM
4800 SRC% = LBP% + LSS%                   ' level buffer + level scroll skip
4801 DST% = SBP% + 32                     ' screen buffer
4802 FOR I% = 1 TO 16
4803   CMD RAMTORAM SRC%, DST%, 32
4804   SRC% = SRC% + 128
4805   DST% = DST% + 32
4806   IF I% = 8 THEN DST% = DST% + 32
4807 NEXT 
4810 CMD RAMTOVRAM SBP%+32, SVP%+64, 256
4811 CMD RAMTOVRAM SBP%+320, SVP%+384, 256
4812 RETURN

'==== CHECK OBSTACLE CALCULATIONS
5000 IK% = ((Y%-24) / 8) * 32 + (X% / 8) 
5001 W% = PEEK(SBP%+IK%+32)
5002 RETURN

5010 IF W% = 128 OR W% = 160 THEN O% = 1 : RETURN                                               ' the way is clear to go
5011 IF W% >= 134 AND W% <= 137 OR W% >= 166 AND W% <= 169 THEN LST% = 1                        ' finish flag reached
5012 RETURN

5020 IF W% = 142 OR W% = 143 OR W% = 146 OR W% = 147 OR W% >= 174 AND W% <= 177 THEN LST% = 2   ' knife hitted
5021 RETURN

'==== CHECK OBSTACLE ON LEFT
5100 O% = 0
5101 IF X% < 5 THEN RETURN
5102 GOSUB 5000                     ' get tile (left up)
5103 GOSUB 5010                     ' is it a free position?
5104 IF O% = 0 THEN RETURN
5105 O% = 0
5106 Y% = Y% + 15 : GOSUB 5000      ' get tile (left down)
5107 Y% = Y% - 15 : GOTO 5010       ' is it a free position?

'==== CHECK OBSTACLE ON RIGHT
5110 O% = 0
5111 IF X% >= 240 THEN RETURN
5112 X% = X% + 15 : GOSUB 5000      ' get tile (right up)
5113 GOSUB 5010                     ' is it a free position?
5114 IF O% = 0 THEN X% = X% - 15 : RETURN
5115 O% = 0
5116 Y% = Y% + 15 : GOSUB 5000      ' get tile (right down)
5117 Y% = Y% - 15 : X% = X% - 15
5118 GOTO 5010                      ' is it a free position?

'==== CHECK OBSTACLE ON UP
5120 O% = 0
5121 GOSUB 5000                     ' get tile (left up) 
5122 GOSUB 5020                     ' test if knife was hitted
5123 GOSUB 5010                     ' is it a free position?
5124 IF O% = 0 THEN RETURN 
5125 O% = 0
5126 X% = X% + 15 : GOSUB 5000      ' get tile (right up)
5127 GOSUB 5020                     ' test if knife was hitted
5128 X% = X% - 15 : GOTO 5010       ' is it a free position?

'==== CHECK OBSTACLE ON DOWN
5130 O% = 0
5131 Y% = Y% + 15 : GOSUB 5000      ' get tile (left down)
5132 GOSUB 5020                     ' test if knife was hitted
5133 GOSUB 5010                     ' is it a free position?
5134 IF O% = 0 THEN Y% = Y% - 15 : RETURN 
5135 O% = 0
5136 X% = X% + 15 : GOSUB 5000      ' get tile (right down)
5137 GOSUB 5020                     ' test if knife was hitted
5138 X% = X% - 15 : Y% = Y% - 15
5139 GOTO 5010                      ' is it a free position?

'==== SET GAME FONT
5200 SET FONT 2
5201 FOR I% = 33 TO 122
5202    SET TILE COLOR I%, (12,12,3,3,3,12,12,12), (0,0,0,0,0,0,0,0)
5203 NEXT
5204 RETURN

'==== PLAYER IS DEAD
5300 PS%(0) = 6 : PS%(1) = 18 
5310 O% = 0 : GOSUB 2100            ' show sprites
5311 IF PY%(0) > 10 THEN PY%(0) = PY%(0) - 4 : O% = 1
5312 IF PY%(1) < 166 THEN PY%(1) = PY%(1) + 4 : O% = 1
5313 NC% = TS% : GOSUB 2400         ' wait NC% cycles
5314 IF O% = 1 THEN 5310
5320 GOTO 2000                      ' clear sprites



