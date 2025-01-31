'-----------------------------------------------------------------
' FORTKNOX - MSXBAS2ROM DEMO
'-----------------------------------------------------------------
' Game Info:
'   FORT KNOX is a remake of Bagman, an arcade video game released in 1982 by the French Valadon
'   Released as an Open source Freeware License (c) 2025 by GAMECAST Entertainment:
'     https://www.msxdev.org/2025/01/31/msxdev24-30-fort-knox/
'   Rewritten for MSXBAS2ROM by Amaury Carvalho (2025):
'     https://github.com/amaurycarvalho/msxbasic/Fortknox
'-----------------------------------------------------------------
' Stack:
'   https://github.com/amaurycarvalho/msxbas2rom/
'   https://julien-nevo.com/at3test/index.php/download/
'   https://msx.jannone.org/conv/
'   https://msx.jannone.org/tinysprite/tinysprite.html
'-----------------------------------------------------------------
' Compile:
'   msxbas2rom -x fortknox.bas
'-----------------------------------------------------------------

' Resources (when compiling on Windows, change slashs to backslashs: / to \ ) 
FILE "music/fortknox.akm"                               ' 0 - songs exported from ArkosTracker 3 (Music.aks)
FILE "music/effects.akx"                                ' 1 - sound effects exported from ArkosTracker 3 (SoundEffects.aks)
FILE "levels/SFBANK00.VRM"                              ' 2 - scenes from stage type 1
FILE "levels/SFBANK01.VRM"                              ' 3 - scenes from stage type 2
FILE "img/INTRO.SC1"                                    ' 4 - tile bank 
FILE "img/fortknox.spr"                                 ' 5 - sprites bank

' Initialization
1 DEFINT A-Y : DEFSTR Z 
2 DIM Z(28)
3 CMD PLYLOAD 0, 1                                      ' load music and effects from resources 0/1
4 SCREEN 1,2,0 : COLOR 15,0,0 
6 HI=512 : SC = 0 : TI = TIME : SN = 0 : MUS = 99       ' HI = high score, SC = score
7 WIDTH 32
8 IF NTSC() THEN TS = 60 : TD = 6 ELSE TS = 50 : TD = 5

' Intro screen
10 GOSUB 9050                                           ' load tiles bank 
12 GOSUB 9040                                           ' clear sprites
13 GOSUB 8020                                           ' print score and hi score
14 N = 200 : X = 11 : Y = 5 : GOSUB 8000                ' draw tile 2x2
15 N = 204 : X = 13 : GOSUB 8000
16 N = 208 : X = 16 : GOSUB 8000
17 N = 212 : X = 18 : GOSUB 8000
20 LOCATE  6, 8 : PRINT "the bagman return"
21 LOCATE  1,12 : PRINT "1UP BONUS EVERY FOR 30000 PTS"
22 LOCATE 10,14 : PRINT "INTRO MUSIC BY"
23 LOCATE  2,16 : PRINT "CLAUDIO LUPO & DANIEL TKACH"
24 LOCATE  0,18 : PRINT "   @ 1982 VALADON AUTOMATION"
25 LOCATE  2,20 : PRINT "PUSH SPACE OR FIRE TO START"
26 LOCATE  0,22 : PRINT " @ 2025 GAMECAST & danysoft"
27 IF MUS <> 0 THEN MUS = 0 : GOSUB 9060                ' play intro song

30 GOSUB 9000                                           ' get player input
31 IF K = 0 THEN 40
32   ST = 1 : SCN = 1 : SC = 0 : TI = TIME              ' ST = stage number, SCN = scene number, SC = score
33   GOTO 100                                           ' start gameplay

40 IF TIME < TI THEN TI = TIME 
41 DI = TIME - TI
42 IF DI < (TS*6) THEN 30
43 TI = TIME
44 SN = (SN + 1) MOD 2
45 IF SN = 0 THEN 10 

50 GOSUB 9050                                           ' load tiles bank 
51 PX = 16 : PY = 28 : GOSUB 8050                       ' show player sprite
52 CX = 10 : CY = 60 : GOSUB 8060                       ' show condor sprite
54 N = 144 : X = 2 : Y = 12 : GOSUB 8010                ' draw tile 2x1
55 N = 146 : Y = 13 : GOSUB 8010
56 N = 162 : Y = 16 : GOSUB 8010
57 LOCATE 6, 4 : PRINT "player1"
58 LOCATE 6, 8 : PRINT "bird condor"
59 LOCATE 6,13 : PRINT "bag"
60 LOCATE 6,16 : PRINT "whellbarrow"
61 GOSUB 8020                                           ' print score and hi score
62 LOCATE 2,20 : PRINT "TAKE ALL THE BAGS AND CARRY"
63 LOCATE 4,21 : PRINT "THEM ON THE WHEELBARROW"
64 GOTO 30

' Stage start screen
100 MUS = 1 : GOSUB 9060                                 ' stage start song
101 GOSUB 9050                                           ' load tiles bank 
102 LOCATE 11,10 : PRINT"STAGE";ST
103 LOCATE 12,12 : PRINT"READY"
104 I = 4 : GOSUB 9020                                   ' wait 4 seconds

' Gameplay screen
110 MUS = 2 : GOSUB 9060                                 ' gameplay song
111 GOSUB 8030                                           ' draw stage/scene on screen
112 GOSUB 9070                                           ' clear input buffer
113 GOSUB 9010                                           ' wait for player input

120 SCN = SCN + 1 : IF SCN > 8 THEN ST = ST + 1 : SCN = 1
121 GOTO 110

'-------------------------------------------
' KNOX SUPPORT ROUTINES
'-------------------------------------------

' Put tile block 2x2 started by N on X,Y
8000 PUT TILE N,(X,Y)
8001 PUT TILE N+1,(X,Y+1)
8002 PUT TILE N+2,(X+1,Y)
8003 PUT TILE N+3,(X+1,Y+1)
8004 RETURN

' Put tile block 2x1 started by N on X,Y
8010 PUT TILE N,(X,Y)
8011 PUT TILE N+1,(X+1,Y)
8012 RETURN

' Print score and hi score
8020 LOCATE 0, 0 : PRINT " SCORE        HI SCORE"
8021 PRINT USING$("######", SC*100.0); SPC(10); USING$("######", HI*100.0)
8022 RETURN

' Draw stage ST - scene SCN
8030 CMD RESTORE 2 + ((ST - 1) MOD 2)                   ' load level data file
8031 IRESTORE 37 + (SCN-1)*704                          ' set initial read position on level data file
8032 BUF = HEAP()                                       ' RAM buffer (next free space available)
8033 FOR N=0 TO 352                                     ' scene data loop (read two bytes of level data each time)
8034   IREAD B                                          ' read next integer data
8035   POKE BUF, (B AND 255) : BUF = BUF + 1            ' copy lower part to RAM buffer
8036   POKE BUF, (B SHR 8) : BUF = BUF + 1              ' copy higher part to RAM buffer
8037 NEXT
8038 CMD RAMTOVRAM BUF - 704, BASE(5)+64, 704           ' copy screen from RAM buffer to VRAM (name table position, line 2)
8039 GOSUB 8020                                         ' print score/hi-score

' Print stage/scene
8040 LOCATE 27,0 : PRINT "SCENE";
8041 LOCATE 27,1 : PRINT USING$("00", ST);"-";USING$("00", SCN);
8042 RETURN

' Show player sprite
8050 PUT SPRITE 0,(PX,PY),11,5
8051 PUT SPRITE 1,(PX,PY),8,6
8052 PUT SPRITE 2,(PX,PY),15,7
8053 RETURN
 
' Show condor sprite
8060 PUT SPRITE 3,(CX,CY),15,1
8061 PUT SPRITE 4,(CX+16,CY),15,2
8062 PUT SPRITE 5,(CX,CY),8,3
8063 PUT SPRITE 6,(CX+16,CY),8,4
8064 RETURN

'-------------------------------------------
' GENERAL SUPPORT ROUTINES
'-------------------------------------------

' Get player input (out: K, J)
9000 K = STRIG(0) OR STRIG(1)
9001 J = STICK(0) OR STICK(1)

' Next random number
9005 R = RND(1) * 100
9006 RETURN

' Wait for player hit a button
9010 GOSUB 9000                                         ' get player input
9011 IF K=0 THEN 9010
9012 RETURN

' Wait I seconds
9020 T1 = TIME : I = I * TS
9021 IF T1 > TIME THEN T1 = TIME
9022 DT = TIME - T1
9023 IF DT < I THEN 9021
9024 RETURN

' Play song (in: MUS)
9030 CMD PLYSONG MUS 
9031 CMD PLYPLAY
9032 RETURN

' Clear sprites
9040 FOR A=0 TO 31
9041   PUT SPRITE A,,,0
9042 NEXT
9043 RETURN

' Load tile and sprite bank
9050 SCREEN LOAD 4
9051 SPRITE LOAD 5
9052 RETURN

' Load song MU
9060 CMD PLYSONG MUS
9061 CMD PLYPLAY
9062 RETURN

' Clear input buffer
9070 GOSUB 9000 
9071 IF K <> 0 THEN 9070
9072 RETURN




