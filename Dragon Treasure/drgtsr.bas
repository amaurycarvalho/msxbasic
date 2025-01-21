'-----------------------------------------------------------------
' DRAGON TREASURE - MSXBAS2ROM DEMO
'-----------------------------------------------------------------
' Game Info:
'   Dragonfire is a 1982 game written by Bob Smith and published by Imagic for Atari 2600
'   Remake to MSX1 created by Amaury Carvalho (2023):
'     https://github.com/amaurycarvalho/msxbasic/Dragon Treasure
'-----------------------------------------------------------------
' Stack:
'   https://github.com/amaurycarvalho/msxbas2rom/
'   https://julien-nevo.com/at3test/index.php/download/
'   https://msx.jannone.org/conv/
'   https://msx.jannone.org/tinysprite/tinysprite.html
'-----------------------------------------------------------------
' Compile:
'   msxbas2rom drgtsr.bas
'-----------------------------------------------------------------

' Resources (when compiling on Windows, change slashs to backslashs: / to \ ) 
FILE "music/drgtsr.akm"                 ' 0 - game songs - exported from Arkos Tracker 3 
FILE "music/drgtsr.akx"                 ' 1 - sound effects - exported from Arkos Tracker 3
FILE "img/SCR0.SC2"                     ' 2 - opening screen 
FILE "img/SCR1.SC2"                     ' 3 - outdoors screen
FILE "img/SCR2.SC2"                     ' 4 - indoors screen
FILE "img/SCR3.SC2"                     ' 5 - inbetween castles screen
FILE "img/SPRITES1.SPR"                 ' 6 - sprites 1
FILE "img/SPRITES2.SPR"                 ' 7 - sprites 2

' GAME START
10 SCREEN 2, 2, 0
11 COLOR 15, 0, 0
12 CMD PLYLOAD 0, 1
13 SET TILE ON                          ' uses tiled mode instead of graphical mode

' OPENING SCREEN
20 SC% = 2 : MU% = 0 : SP% = 6
21 GOSUB 9000                           ' show screen
22 GOSUB 8000                           ' initialize fire effect
23 GOSUB 8020                           ' do fire effect
24 GOSUB 9100 : IF B% = 0 THEN 23       ' wait player press a key
25 GOSUB 9100 : IF B% <> 0 THEN 25
26 LV% = 0                              ' level number
27 E1% = 0                              ' special item 1 (sword) on/off

' OUTDOORS CASTLE SCREEN
30 SC% = 3 : MU% = 1 : SP% = 6 : JP% = 0
31 GOSUB 9000                           ' show screen
32 PX% = 210 : PY% = 110 : PS% = 0 : T1% = TIME
33 GOSUB 9200                           ' show player

' OUTDOORS CASTLE LOOP
40 GOSUB 9100               ' PLAYER INPUT
41 IF K% = 27 THEN 90
42 GOSUB 9300               ' DO PLAYER MOVES (OUTSIDE CASTLE)
43 GOSUB 9350               ' RIVER ANIMATION
44 GOSUB 9600               ' JUMPING LOGIC
45 IF PX% > 20 THEN 40

' INDOORS CASTLE SCREEN
50 SC% = 4 : MU% = 2 : SP% = 7
51 GOSUB 9000
52 PX% = 230 : PY% = 124 : PS% = 6 : T1% = TIME
53 GOSUB 9200               ' SHOW PLAYER
54 GOSUB 9500               ' SHOW ITEMS
55 I% = 1 : GOSUB 9120      ' WAIT I% SECONDS
56 SET TILE COLOR 143, 8    ' CLOSE DOOR
57 CMD PLYSOUND 1, 2        ' CLOSE DOOR SOUND

' INDOORS CASTLE LOOP
60 GOSUB 9100               ' PLAYER INPUT
61 IF K% = 27 THEN 90
62 GOSUB 9400               ' DO PLAYER MOVES (INSIDE CASTLE)
63 GOSUB 9440               ' CHECK INSIDE CASTLE COLLISIONS
64 IF E2% = 1 THEN IF PX% < 8 AND PY% < 24 THEN 70   ' EXIT DOOR LOGIC
65 GOTO 60

' PUT SPRITE 1, (100,146), 2, 20  ' DRAGON
' PUT SPRITE 2, (116,146), 2, 21
' PUT SPRITE 3, (116,130), 8, 31  ' FIREBALL UP

' INBETWEEN CASTLES SCREEN
70 LV% = LV% + 1
71 SC% = 5 : MU% = 1 : SP% = 6 : JP% = 0
72 GOSUB 9000
73 PX% = 210 : PY% = 110 : PS% = 0 : T1% = TIME
74 GOSUB 9200               ' SHOW PLAYER

' PUT SPRITE 1, (26, 110), 8, 18   ' FIREBALL RIGHT

' INBETWEEN CASTLES LOOP
80 GOSUB 9100               ' PLAYER INPUT
81 IF K% = 27 THEN 90
82 GOSUB 9300               ' DO PLAYER MOVES (OUTSIDE CASTLE)
83 IF PX% <= 20 THEN 50
84 GOSUB 9350               ' RIVER ANIMATION
85 GOSUB 9600               ' JUMPING LOGIC
86 GOTO 80

' RESTART GAME
90 GOTO 20

' FIRE EFFECT 
8000 VR1% = HEAP() : VR2% = BASE(10) + 672      ' initialize: 21 lines * 32 chars = 672
8001 S% = VR1%                                  
8010 FOR I% = 0 TO 95
8011   IF I% < 64 THEN C% = 231 : GOTO 8014
8012   GOSUB 9110
8013   C% = 232 + (R% MOD 8)
8014   POKE S%, C%
8015   S% = S% + 1
8016 NEXT
8017 RETURN

8020 S% = VR1%                                  ' propagate: 3 lines * 32 chars = 96
8030 FOR I% = 0 TO 63
8031   Y% = (I% MOD 32) 
8032   IF Y% > 0 AND Y% < 31 THEN GOSUB 9110 : X% = 31 + (R% MOD 3) ELSE X% = 32
8033   C% = PEEK(S% + X%)
8034   IF C% <> 231 THEN C% = C% + 8
8040   POKE S%, C%
8041   S% = S% + 1
8042 NEXT
8050 FOR I% = 64 TO 95
8051   C% = PEEK(S%) + 1  
8052   IF C% > 239 THEN GOSUB 9110 : C% = 232 + (R% MOD 8)
8053   POKE S%, C%
8054   S% = S% + 1
8055 NEXT
8060 CMD RAMTOVRAM VR1%, VR2%, 96
8061 RETURN

' LOAD SCREEN, MUSIC AND SPRITES
9000 SCREEN OFF                 ' disable screen
9001 SCREEN LOAD SC%            ' load screen resource SC
9002 SPRITE LOAD SP%            ' load sprite resource SP
9003 IF SC% <> 2 GOSUB 9050
9004 CMD PLYSONG MU%            ' set song MU
9005 CMD PLYPLAY                ' play song
9006 SCREEN ON                  ' enable screen
9007 RETURN

' SET LEVEL FOOTER
9050 SET FONT 2
9051 LOCATE 0, 22
9052 PRINT "LEVEL    LIFES   SHIELDS    GOLD";

' SHOW SCORE
9060 LOCATE 0, 23 : PRINT USING$("00", LV%);
9061 RETURN

' PLAYER INPUTS
9100 K% = INKEY
9101 J% = STICK(0) OR STICK(1)
9102 B% = STRIG(0) OR STRIG(1)

' RANDOM NUMBER
9110 R% = RND(1) * 1000
9111 RETURN

' WAIT I% SECONDS
9120 T1% = TIME : I% = I% * 60
9121 IF T1% > TIME THEN T1% = TIME
9122 DT% = TIME - T1%
9123 IF DT% < I% THEN 9121
9124 RETURN

' SHOW PLAYER
9200 PUT SPRITE 0, (PX%,PY%), 15, PS%
9201 RETURN

' DO PLAYER MOVES (OUTSIDE CASTLE)
9300 IF J% = 0 AND B% = 0 THEN RETURN
9301 IF T1% > TIME THEN T1% = TIME
9302 DT% = TIME - T1%
9303 IF DT% < 2 THEN RETURN
9304 T1% = TIME

9310 IF JP% = 0 THEN GOSUB 9330 

9320 DX% = 0 : DY% = 0 
9321 IF J% = 3 THEN DX% = 2 : IF JP% = 0 THEN IF PS% = 4 THEN PS% = 5 ELSE PS% = 4 
9322 IF J% = 7 THEN DX% = -2 : IF JP% = 0 THEN IF PS% = 0 THEN PS% = 1 ELSE PS% = 0
9323 DX% = DX% + PX% : DY% = DY% + PY%
9324 IF DX% > 210 THEN RETURN
9325 PX% = DX% : PY% = DY%
9326 GOTO 9200

9330 IF J% <> 5 THEN 9340
9331 IF PS% < 4 THEN PS% = 2 ELSE PS% = 6    ' activate bowing
9332 GOTO 9200 

9340 IF B% = 0 THEN RETURN
9341 JP% = 12                                ' activate jumping
9342 IF PS% < 4 THEN PS% = 3 ELSE PS% = 7
9343 RETURN

' RIVER ANIMATION
9350 IF T3% > TIME THEN T3% = TIME
9351 DT% = TIME - T3%
9352 IF DT% < 30 THEN RETURN
9353 T3% = TIME
9360 COPY (5, 19)-(14,19) TO TMP$
9361 COPY (17,19)-(26,19) TO (5,19)
9362 COPY TMP$ TO (17,19)
9363 SET TILE COLOR 171, STCO%
9364 IF STCO% = 15 THEN STCO% = 13 ELSE STCO% = 15 
9365 SET TILE COLOR 176, STCO%
9366 RETURN

' DO PLAYER MOVES (INSIDE CASTLE)
9400 IF J% = 0 THEN RETURN
9401 IF T1% > TIME THEN T1% = TIME
9402 DT% = TIME - T1%
9403 IF DT% < 2 THEN RETURN
9404 T1% = TIME
9410 DX% = 0 : DY% = 0 
9411 IF J% = 8 OR J% = 1 OR J% = 2 THEN DY% = -2 
9412 IF J% >= 4 AND J% <= 6 THEN DY% = 2 
9413 IF J% >= 2 AND J% <= 4 THEN DX% = 2 : IF PS% = 2 THEN PS% = 3 ELSE PS% = 2
9414 IF J% >= 6 AND J% <= 8 THEN DX% = -2 : IF PS% = 6 THEN PS% = 7 ELSE PS% = 6
9415 IF J% = 1 THEN IF PS% = 0 THEN PS% = 1 ELSE PS% = 0
9416 IF J% = 5 THEN IF PS% = 4 THEN PS% = 5 ELSE PS% = 4
9420 DX% = DX% + PX% : DY% = DY% + PY%
9421 IF DX% < 6 OR DX% > 230 OR DY% > 124 OR DY% < 8 THEN RETURN
9422 PX% = DX% : PY% = DY%
9423 GOTO 9200

' CHECK INSIDE CASTLE COLLISIONS
9440 IF T2% > TIME THEN T2% = TIME
9441 DT% = TIME - T2%
9442 IF DT% < 15 THEN RETURN
9443 T2% = TIME
9444 I% = COLLISION(0)
9445 IF I% < 0 THEN RETURN
9446 IF I% = 4 THEN 9530    ' GOT KEY
9447 RETURN

' SHOW ITEMS
9500 E2% = 0                ' SPECIAL ITEM 2 (KEY) ON/OFF
9501 IE% = LV% MOD 3 + 24   ' SPECIAL ITEM ON SCREEN (0=SHIELD, 1=HEART, 2=CROWN)
9502 IF IE% = 24 THEN IC% = 14 ELSE IF IE% = 25 THEN IC% = 8 ELSE IC% = 10
9503 IQ% = LV% * 3 + 1      ' ITEMS QUANTITY ON SCREEN (LEVEL 0 = NOTHING)
9504 IF IQ% > 9 THEN IQ% = 9
9510 FOR I% = 0 TO IQ%
9511   GOSUB 9110 : X% = R% MOD 180 + 20
9512   GOSUB 9110 : Y% = R% MOD 110 + 20
9513   GOSUB 9110 : C% = R% MOD 5 + 10
9514   GOSUB 9110 : S% = R% MOD 4 + 27
9515   IF I% = 0 THEN C% = 15  : S% = 23
9516   IF I% = 1 THEN C% = IC% : S% = IE% 
9517   GOSUB 9590  ' SHOW ITEM
9520 NEXT
9521 RETURN

' KEY COLLISION AND OPEN EXIT DOOR
9530 E2% = 1               
9531 SET TILE COLOR 142, 1
9532 CMD PLYSOUND 1, 2      ' OPEN DOOR SOUND
9533 I% = 0 : Y% = 184 : C% = 0 
9534 GOTO 9590

9590 PUT SPRITE I%+4,(X%,Y%),C%,S%
9591 RETURN

' JUMPING LOGIC
9600 IF T4% > TIME THEN T4% = TIME
9601 DT% = TIME - T4%
9602 IF DT% < 3 THEN RETURN
9603 T4% = TIME

9610 IF JP% = 0 THEN RETURN
9611 JP% = JP% - 1
9612 IF JP% > 5 THEN PY% = PY% - 4 ELSE PY% = PY% + 4

9620 IF JP% > 0 THEN 9200
9621 IF PS% < 4 THEN PS% = 0 ELSE PS% = 4
9622 GOTO 9200             ' show player



