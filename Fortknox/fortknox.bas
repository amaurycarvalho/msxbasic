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
'   https://launchpad.net/nmsxtiles
'   https://github.com/pipagerardo/nMSXtiles
'-----------------------------------------------------------------
' Compile:
'   msxbas2rom -x fortknox.bas
'-----------------------------------------------------------------

' Resources (when compiling on Windows, change slashs to backslashs: / to \ ) 
FILE "music/fortknox.akm"                               ' 0 - songs exported from ArkosTracker 3 (Music.aks)
FILE "music/effects.akx"                                ' 1 - sound effects exported from ArkosTracker 3 (SoundEffects.aks)
FILE "levels/SFBANK00.VRM"                              ' 2 - scenes from stage type 1
FILE "levels/SFBANK01.VRM"                              ' 3 - scenes from stage type 2
FILE "img/INTRO.SC1"                                    ' 4 - tile bank (edited via nMSXTiles)
FILE "img/fortknox1.spr"                                ' 5 - sprites bank - player handsfree (plain text, edited via Tiny Sprite)
FILE "img/fortknox2.spr"                                ' 6 - sprites bank - player holding the bag (plain text, edited via Tiny Sprite)
FILE "img/fortknox3.spr"                                ' 7 - sprites bank - player pushing the car (plain text, edited via Tiny Sprite)

' Initialization
1 DEFINT A-Z
2 DIM SCA(351,7)                                        ' scenes data buffer (screen data=704 bytes, 8 scenes)
3 CMD PLYLOAD 0, 1                                      ' load music and effects from resources 0/1
4 SCREEN 1,2,0 : COLOR 15,0,0 
5 HI=512 : SC = 0 : TI = TIME : SN = 0 : MUS = 99       ' HI = high score, SC = score
6 WIDTH 32
7 IF NTSC() THEN TS = 60 : TD = 6 ELSE TS = 50 : TD = 5

' Intro screen
10 GOSUB 9040                                           ' clear sprites
11 GOSUB 9050                                           ' load tiles bank 
12 GOSUB 8020                                           ' print score and hi score
13 N = 200 : X = 11 : Y = 5 : GOSUB 8000                ' draw tile 2x2
14 N = 204 : X = 13 : GOSUB 8000
15 N = 208 : X = 16 : GOSUB 8000
16 N = 212 : X = 18 : GOSUB 8000
20 LOCATE  6, 8 : PRINT "the bagman return"
21 LOCATE  1,12 : PRINT "1UP BONUS EVERY FOR 30000 PTS"
22 LOCATE 10,14 : PRINT "INTRO MUSIC BY"
23 LOCATE  2,16 : PRINT "CLAUDIO LUPO & DANIEL TKACH"
24 LOCATE  0,18 : PRINT "   @ 1982 VALADON AUTOMATION"
25 LOCATE  2,20 : PRINT "PUSH SPACE OR FIRE TO START"
26 LOCATE  0,22 : PRINT "    @ 2025 GAMECAST & A.C."
27 IF MUS <> 0 THEN MUS = 0 : GOSUB 9030                ' play intro song

30 GOSUB 9000                                           ' get player input
31 IF K = 0 THEN 40
32   ST = 1 : SCN = 1                                   ' ST = stage number, SCN = scene number
33   SC = 0 : LV = 3                                    ' SC = score, LV = lives
34   TI = TIME              
35   GOTO 100                                           ' start gameplay

40 IF TIME < TI THEN TI = TIME 
41 DI = TIME - TI
42 IF DI < (TS*6) THEN 30
43   TI = TIME
44   SN = (SN + 1) MOD 2
45   IF SN = 0 THEN 10 

50 GOSUB 9050                                           ' load tiles bank 
51 PX = 16 : PY = 28 : PS = 0 : GOSUB 8050              ' show player sprite
52 CX = 10 : CY = 60 : CS = 0 : GOSUB 8060              ' show condor sprite
54 N = &H90 : X = 2 : Y = 11 : GOSUB 8010               ' draw bag top (tile 2x1)
55 N = &H92 : Y = 12 : GOSUB 8010                       ' draw bag bottom (tile 2x1)
56 N = &HA2 : Y = 15 : GOSUB 8010                       ' draw car
57 LOCATE 6, 4 : PRINT "player1"
58 LOCATE 6, 8 : PRINT "bird condor"
59 LOCATE 6,12 : PRINT "bag"
60 LOCATE 6,15 : PRINT "whellbarrow"
61 GOSUB 8020                                           ' print score and hi score
62 LOCATE 2,18 : PRINT "TAKE ALL THE BAGS AND CARRY"
63 LOCATE 2,20 : PRINT "  THEM ON THE WHEELBARROW"
64 LOCATE 2,22 : PRINT "   POWERED BY MSXBAS2ROM"
65 GOTO 30

' Stage initialization
100 GOSUB 9040                                           ' clear sprites
101 MUS = 1 : GOSUB 9030                                 ' stage start song
102 GOSUB 9050                                           ' load tiles bank
103 LOCATE 13,10 : PRINT "STAGE";ST
104 LOCATE 14,12 : PRINT "READY"
105 I = 4 : GOSUB 9020                                   ' wait 4 seconds
106 BF = 0 : GOSUB 8200                                  ' player action flag (0=handsfree, 1=holding the bag, 2=pushing the car)
107 BC = 65                                              ' bags count
108 GOSUB 8100                                           ' load stage scenes bank

' Scene initialization 
110 PX = 0 : PY = 15 : PS = 1                            ' player x, y and sprite
111 CX = 0 : CY = 212 : CS = 0                           ' condor x, y and sprite
112 EX = 0 : EY = 212                                    ' egg x, y
113 PT = TIME : CT = TIME : ET = TIME                    ' timers for player, condor and egg logic
114 GOSUB 9040                                           ' clear sprites
115 GOSUB 8030                                           ' draw stage/scene on screen
116 GOSUB 8050                                           ' show player sprite
117 GOSUB 8060                                           ' show condor sprite
118 GOSUB 8070                                           ' show egg sprite
119 GOSUB 8080                                           ' show lives

' Gameplay loop
120 GOSUB 200                                            ' player logic 
121 GOSUB 300                                            ' condor logic
122 GOSUB 500                                            ' egg logic
123 IF BC = 0 THEN 900                                   ' if no more bags: stage clear 
124 IF LV = 0 THEN 950                                   ' if nothing left: game over
125 GOTO 120

' Player movement logic
200 IF TIME < PT THEN PT = TIME                          
201 DI = TIME - PT
202 IF DI < (TD*2) THEN RETURN                           ' time step = 5x per second
203   PT = TIME

210 GOSUB 9000                                           ' get player input
211 IF K <> 0 GOSUB 800                                  ' player press the button?
212 ON J GOTO 220, 213, 230, 213, 240, 213, 250, 213     ' player press the stick? 
213   RETURN

220 IF PS = 2 THEN PS = 6 ELSE PS = 2                    ' --> player moves UP 
221 IF PY <= 15 THEN RETURN
222   GOSUB 270                                          ' get up/down tiles
223   IF TU1 <> &H88 OR BF = 2 THEN RETURN               ' if not a ladder (or pushing the car), return
224     PY = PY - 8
225     GOTO 8050                                        ' show player sprite

230 IF PS = 0 THEN PS = 1 ELSE PS = 0                    ' --> player moves RIGHT
231 IF PX < 240 THEN 236                                 ' if hit right border: next scene
232   IF SCN >= 8 THEN RETURN
233     SCN = SCN + 1 
234     PX = 0 : IF PS = 0 THEN PS = 1 ELSE PS = 0       ' player x, y and sprite
235     RETURN 111                                       ' next scene
236 GOSUB 260                                            ' get left/right tiles
237 IF TR1 = &H80 OR TR2 = &H80 THEN RETURN              ' if a wall, return
238   PX = PX + 8
239   GOTO 8050                                          ' show player sprite

240 IF PS = 2 THEN PS = 6 ELSE PS = 2                    ' --> player moves DOWN 
241 IF PY >= 170 THEN RETURN
242   GOSUB 270                                          ' get up/down tiles
243   IF TD1 <> &H88 OR BF = 2 THEN RETURN               ' if not a ladder (or pushing the car), return
244     PY = PY + 8
245     GOTO 8050                                        ' show player sprite

250 IF PS = 4 THEN PS = 5 ELSE PS = 4                    ' --> player moves LEFT
251 IF PX > 7 THEN 256                                   ' if hit left border: previous scene
252   IF SCN <= 1 THEN RETURN
253     SCN = SCN - 1 
254     PX = 240 : IF PS = 4 THEN PS = 5 ELSE PS = 4     ' player x, y and sprite 
255     RETURN 111                                       ' previous scene
256 GOSUB 260                                            ' get left/right tiles
257 IF TL1 = &H80 OR TL2 = &H80 THEN RETURN              ' if a wall, return
258   PX = PX - 8
259   GOTO 8050                                          ' show player sprite

260 X=PX/8 : Y=PY/8                                      ' get LEFT/RIGHT tiles from player position
261 TL1=TILE(X-1,Y+1)                                    ' tile position in text mode coords
262 TL2=TILE(X-1,Y+2)
263 TR1=TILE(X+2,Y+1)
264 TR2=TILE(X+2,Y+2)
265 RETURN

270 X=PX/8 : Y=PY/8                                      ' get UP/DOWN tiles from player position
271 TU1=TILE(X,Y+1)                                      ' tile position in text mode coords
272 TD1=TILE(X,Y+3)
273 RETURN

280 X=PX/8 : Y=PY/8+1                                    ' get inner tiles from player position
281 TP1=TILE(X,Y)                                        ' tile position in text mode coords
282 TP2=TILE(X,Y+1)                                      
283 TP3=TILE(X+1,Y)                                      
284 TP4=TILE(X+1,Y+1)          
285 TPS=TP1 OR TP2 OR TP3 OR TP4                     
286 RETURN

' Condor appearence logic
300 IF TIME < CT THEN CT = TIME                          
301 DI = TIME - CT
302 IF DI < (TD*3) THEN RETURN                           ' time step = 3x per second
303   CT = TIME

310 IF CY < 212 THEN 400                                 ' if condor already in action: movement logic 
311 GOSUB 9005                                           ' next random number
312 IF (R MOD 20) > ST THEN RETURN                       ' random condor appearence: higher stages = more appearences
313   CY = 0 : CX = 0
314   CS = 0
315   GOTO 8060                                          ' show condor sprite

' Condor movement logic
400 CS = (CS + 1) MOD 2
401 CX = CX + 8
402 IF CX > 220 THEN CY = 212                            ' if right border: hide condor
403 GOSUB 8060                                           ' show condor sprite

' Egg appearence logic
500 IF TIME < ET THEN ET = TIME                          
501 DI = TIME - ET
502 IF DI < TD THEN RETURN                               ' time step = 10x per second
503   ET = TIME

510 IF EY < 212 THEN 600                                 ' if egg already in action: movement logic
511   IF CY >= 212 THEN RETURN                           ' if condor not in action: return
512     GOSUB 9005                                       ' next random number
513     IF (R MOD 40) > ST THEN RETURN                   ' random egg appearence: higher stages = more appearences
514       EY = CY : EX = CX + 8 
515       GOTO 8070                                      ' show egg sprite

' Egg movement logic
600 IF EY >= 212 THEN RETURN
601   EY = EY + 6 
602   GOSUB 8070                                         ' show egg sprite

' Egg vs player collision logic
700 IF COLLISION(7,0) < 0 THEN RETURN                    ' if egg sprite collided with player sprite
701   IF PS < 4 THEN PS = 3 ELSE PS = 7                  ' player is dead
702     GOSUB 8050                                       ' show player sprite
703     CMD PLYSOUND 1                                   ' play egg collision sound effect
704     IF LV > 0 THEN LV = LV - 1 : GOSUB 8080          ' show lives
705     EY = 212 
706     GOTO 8070                                        ' hide egg

' Player trying to get an item 
800 GOSUB 280                                            ' get inner tiles from player position
801 ON BF GOTO 820, 860                                  ' player action status (0=handsfree, 1=holding the bag, 2=pushing the car)
802   IF TP2 = &HA2 THEN 850                             ' is it the car?
803     IF TP1 <> &H90 THEN RETURN                       ' if not a bag, return

' Getting the bag logic
810       GOSUB 8015                                     ' clear bag tile 
811       GOSUB 8110                                     ' register getting the bag on the scene buffer
812       CMD PLYSOUND 4                                 ' play getting an item sound effect
813       BF = 1 : GOSUB 8200                            ' player holding the bag
814       GOTO 8050                                      ' show player sprite

' Releasing the bag logic
820 IF TP2 = &HA2 OR TP2 = &HA3 THEN 830                 ' if car tile, release the bag
821   IF TPS <> 32 AND TPS <> 0 THEN RETURN              ' if not an empty space, return
822     N = &H90 : GOSUB 8090                            ' release the bag on the floor
823     GOSUB 8120                                       ' register releasing the bag on the scene buffer
824     BF = 0 : GOSUB 8200                              ' player handsfree flag
825     CMD PLYSOUND 4                                   ' play release an item sound effect
826     GOTO 8050                                        ' show player sprite

' Release the bag in the car logic
830 BF = 0 : GOSUB 8200                                  ' player handsfree flag
831 GOSUB 8050                                           ' show player sprite
832 CMD PLYSOUND 4                                       ' play release an item sound effect      

' Add score and reduce bags count
840 SC = SC + 1                                          ' add to score points
841 IF BC > 0 THEN BC = BC - 1                           ' reduce bags count
842 GOTO 8020                                            ' print score/hi-score

' Getting the car logic
850 GOSUB 8015                                           ' clear car tile 
851 GOSUB 8110                                           ' register getting the car on the scene buffer
852 CMD PLYSOUND 4                                       ' play getting an item sound effect
853 BF = 2 : GOSUB 8200                                  ' player holding the bag
854 GOTO 8050                                            ' show player sprite
 
' Releasing the car logic
860 IF TPS <> 32 AND TPS <> 0 THEN RETURN                ' if not an empty space, return
861   N = &HA2 : Y = Y + 1 : GOSUB 8010                  ' release the car on the floor
862   GOSUB 8130                                         ' register releasing the car on the scene buffer
863   BF = 0 : GOSUB 8200                                ' player handsfree flag
864   CMD PLYSOUND 4                                     ' play release an item sound effect
865   GOTO 8050                                          ' show player sprite

' Stage clear
900 ST = ST + 1 : SCN = 1
901 IF LV < 5 THEN LV = LV + 1 : GOSUB 8080              ' show lives
902 LOCATE 3,10 : PRINT "+----------------------+"
903 LOCATE 3,11 : PRINT "+ S T A G E  C L E A R +"
904 LOCATE 3,12 : PRINT "+----------------------+"
905 MUS = 3 : GOSUB 9030                                 ' stage clear song
906 I = 3 : GOSUB 9020                                   ' wait 3 seconds
907 GOTO 100                                             ' go to next stage

' Game over
950 IF SC > HI THEN HI = SC                              ' new high score
951 LOCATE 5,10 : PRINT "+--------------------+"
952 LOCATE 5,11 : PRINT "+  G A M E  O V E R  +"
953 LOCATE 5,12 : PRINT "+--------------------+"
954 MUS = 2 : GOSUB 9030                                 ' game over song
955 GOSUB 9010                                           ' wait for player hit a button
956 SN = 0 : TI = TIME
957 GOTO 10                                              ' return to initialize game

'-------------------------------------------
' KNOX SUPPORT ROUTINES
'-------------------------------------------

' Put tile block 2x2 started by N on X,Y (vertical way)
8000 PUT TILE N,(X,Y)
8001 PUT TILE N+1,(X,Y+1)
8002 PUT TILE N+2,(X+1,Y)
8003 PUT TILE N+3,(X+1,Y+1)
8004 RETURN

' Put tile block 2x1 started by N on X,Y
8010 PUT TILE N,(X,Y)
8011 PUT TILE N+1,(X+1,Y)
8012 RETURN

' Clear tile block 2x2 on X,Y
8015 PUT TILE 32,(X,Y)
8016 PUT TILE 32,(X,Y+1)
8017 PUT TILE 32,(X+1,Y)
8018 PUT TILE 32,(X+1,Y+1)
8019 RETURN

' Print score and hi score
8020 LOCATE 0, 0 : PRINT " SCORE        HI SCORE"
8021 PRINT USING$("######", SC*100.0); SPC(10); USING$("######", HI*100.0)
8022 RETURN

' Draw stage ST - scene SCN
8030 BUF = VARPTR(SCA(0,SCN-1))                          ' start address of element SCENE,SCREEN_INTEGER
8031 CMD RAMTOVRAM BUF, BASE(5)+64, 704                  ' copy screen from RAM buffer to VRAM (name table position, line 2)
8032 GOSUB 8020                                          ' print score/hi-score

' Print stage/scene
8040 LOCATE 27,0 : PRINT "SCENE";
8041 LOCATE 27,1 : PRINT USING$("00", ST);"-";USING$("00", SCN);
8042 RETURN

' Show player sprite
8050 SS = (PS * 3) + 9
8051 PUT SPRITE 0,(PX,PY),11,SS
8052 PUT SPRITE 1,(PX,PY),8,SS+1
8053 PUT SPRITE 2,(PX,PY),15,SS+2
8054 RETURN
 
' Show condor sprite
8060 SS = CS*4 + 1
8061 PUT SPRITE 3,(CX,CY),15,SS
8062 PUT SPRITE 4,(CX+16,CY),15,SS+1
8063 PUT SPRITE 5,(CX,CY),8,SS+2
8064 PUT SPRITE 6,(CX+16,CY),8,SS+3
8065 RETURN

' Show egg sprite
8070 PUT SPRITE 7,(EX,EY),15,0
8071 RETURN

' Show lives
8080 X = 23 : Y = 0
8081 FOR I = 1 TO 4
8082   IF I < LV THEN C = &H86 ELSE C = 32
8083   PUT TILE C,(X, Y)
8084   X = X + 1
8085 NEXT
8086 RETURN

' Put tile block 2x2 started by N on X,Y (horizontal way)
8090 PUT TILE N,(X,Y)
8091 PUT TILE N+1,(X+1,Y)
8092 PUT TILE N+2,(X,Y+1)
8093 PUT TILE N+3,(X+1,Y+1)
8094 RETURN

' Load stage scenes bank to RAM buffer
8100 CMD RESTORE 2 + ((ST - 1) MOD 2)                    ' load stage data file
8101 IRESTORE 39                                         ' set initial read position on stage data file
8102 FOR Y = 0 TO 7                                      ' scenes data loop 
8103   FOR X = 0 TO 351                                  ' screen from scene data loop
8104     IREAD SCA(X,Y)                                  ' read next integer data to scenes buffer (screen_data,scene)
8105   NEXT
8106 NEXT
8107 RETURN

' Register getting the bag in the scene buffer
8110 N = ((Y - 2) * 32 + X)                              ' element on scenes buffer
8111 BUF = VARPTR(SCA(0, SCN-1)) + N
8112 POKE BUF, &H20
8113 POKE BUF+1, &H20
8114 POKE BUF+32, &H20
8115 POKE BUF+33, &H20
8116 RETURN

' Register release the bag in the scene buffer
8120 N = ((Y - 2) * 32 + X)                             ' element on scenes buffer
8121 BUF = VARPTR(SCA(0, SCN-1)) + N
8122 POKE BUF, &H90
8123 POKE BUF+1, &H91
8124 POKE BUF+32, &H92
8125 POKE BUF+33, &H93
8126 RETURN

' Register release the car in the scene buffer
8130 N = ((Y - 2) * 32 + X)                             ' element on scenes buffer
8131 BUF = VARPTR(SCA(0, SCN-1)) + N
8132 POKE BUF, &HA2
8133 POKE BUF+1, &HA3
8134 RETURN

' Load sprite bank (player handsfree, holding the bag, pushing the car)
8200 SPRITE LOAD 5 + BF
8201 RETURN 

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
9010 GOSUB 9000                                          ' get player input
9011 IF K=0 THEN 9010
9012 RETURN

' Wait I seconds
9020 T1 = TIME : I = I * TS
9021 IF T1 > TIME THEN T1 = TIME
9022 DT = TIME - T1
9023 IF DT < I THEN 9021
9024 RETURN

' Play song MUS
9030 CMD PLYSONG MUS 
9031 CMD PLYPLAY
9032 RETURN

' Clear sprites
9040 FOR A=0 TO 31
9041   PUT SPRITE A,,0,0
9042 NEXT
9043 RETURN

' Load tile and sprite bank
9050 SCREEN LOAD 4
9051 SPRITE LOAD 5
9052 RETURN

' Clear input buffer
9060 GOSUB 9000 
9061 IF K <> 0 THEN 9060
9062 RETURN




