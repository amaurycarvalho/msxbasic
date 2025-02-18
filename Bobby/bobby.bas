'-----------------------------------------------------------------
' BOBBY IS STILL GOING HOME - MSXBAS2ROM DEMO
'-----------------------------------------------------------------
' Game Info:
'   Bobby is Going Home is a platform game released for the Atari 2600 console in 1983.
'     https://en.wikipedia.org/wiki/Bobby_is_Going_Home
'     https://www.retrogames.cz/play_192-Atari2600.php
'   Remake by Amaury Carvalho (2025):
'     https://github.com/amaurycarvalho/msxbasic/Bobby
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
'   msxbas2rom -x bobby.bas
'-----------------------------------------------------------------

' Resources (when compiling on Windows, change slashs to backslashs: / to \ ) 
FILE "music/bobby.akm"                                  ' 0 - songs exported from ArkosTracker 3 (bobby.aks)
FILE "music/bobby_se.akx"                               ' 1 - sound effects exported from ArkosTracker 3 (bobby_se.aks)
FILE "levels/levels.csv"                                ' 2 - stage levels
FILE "img/splash.SC2"                                   ' 3 - splash screen (edited via nMSXTiles)
FILE "img/scene0.SC2"                                   ' 4 - scene 0 screen (edited via nMSXTiles)
FILE "img/scene1.SC2"                                   ' 5 - scene 1 screen (edited via nMSXTiles)
FILE "img/scene2.SC2"                                   ' 6 - scene 2 screen (edited via nMSXTiles)
FILE "img/scene3.SC2"                                   ' 7 - scene 3 screen (edited via nMSXTiles)
FILE "img/scene4.SC2"                                   ' 8 - scene 4 screen (edited via nMSXTiles)
FILE "img/scene5.SC2"                                   ' 9 - scene 5 screen (edited via nMSXTiles)
FILE "img/scene6.SC2"                                   ' 10 - scene 6 screen (edited via nMSXTiles)
FILE "img/scene7.SC2"                                   ' 11 - scene 7 screen (edited via nMSXTiles)
FILE "img/bobby.spr"                                    ' 12 - sprites bank (plain text, edited via Tiny Sprite)

' Initialization
1 DEFINT A-Z
2 DIM SB$(2,2)                                          ' scenes tiles data buffer
3 CMD PLYLOAD 0, 1                                      ' load music and effects from resources 0/1
4 SCREEN 2,2,0 : COLOR 15,0,0 
5 SET TILE ON                                           ' set tile mode on (locate and print stmts works like it is in text mode)
6 IF NTSC() THEN TS = 60 : TD = 6 ELSE TS = 50 : TD = 5

' Splash screen 
10 SCR = 3 : SPR = 12 : GOSUB 9050                      ' load splash screen and sprites
11 MUS = 6 : GOSUB 9030                                 ' play splash screen song
12 GOSUB 9010                                           ' wait for player hit a button
13 CMD PLYMUTE                                          ' mute song

' Game start
20 LR = 0                                               ' level row number in resource CSV
21 SC = 300                                             ' player initial score
22 LV = 4                                               ' player remainder lives

' Level initialization
100 GOSUB 8100                                          ' load level data from resource
101 PX = 0 : PY = 100 : PS = 1                          ' player x, y and sprite
102 PT = TIME                                           ' timer for player
103 CT = TIME                                           ' timer for cloud/horizon/score

110 SCR = SCN + 4 : SPR = 12 : GOSUB 9050               ' load level screen and sprites
111 GOSUB 9030                                          ' play level song
112 GOSUB 8020                                          ' draw score on screen
113 GOSUB 8030                                          ' draw stage number on screen
114 GOSUB 8040                                          ' draw floor obstacle 
115 GOSUB 8050                                          ' show player sprite
116 GOSUB 8080                                          ' show player remaining lives

' Gameplay loop
120 GOSUB 200                                           ' player logic 
121 GOSUB 300                                           ' cloud/horizon/score logic
'122 GOSUB 500                                            ' egg logic
'123 IF BC = 0 THEN 900                                   ' if no more bags: stage clear 
124 IF SC = 0 THEN 950                                   ' if nothing left: game over
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

' Cloud/horizon/score logic
300 IF TIME < CT THEN CT = TIME                          
301 DI = TIME - CT
302 IF DI < (TD*5) THEN RETURN                           ' time step = 2x per second
303   CT = TIME

310 IF SC > 0 THEN SC = SC - 1
311 GOTO 8020                                           ' show score

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
842 GOTO 8020                                            ' print score

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
950 MUS = 5 : GOSUB 9030                                ' game over song
951 GOSUB 960                                           ' player is dead
952 GOSUB 9010                                          ' wait for player hit a button
953 GOTO 20                                             ' restart the game

' Player is dead logic
960 PS = 0                                              ' player is dead sprite
961 CMD PLYSOUND 5                                      ' player is dead sound effect
962 GOTO 8050                                           ' show player sprite 

'-------------------------------------------
' GAME SUPPORT ROUTINES
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

' Print score 
8020 LOCATE 12, 0 
8021 PRINT USING$("######", SC*10.0);
8022 RETURN

' Show stage STN 
8030 LOCATE 14,22 : PRINT USING$("###", STN);
8031 RETURN

' Show floor obstacle
8040 X = FOX : Y = 14
8041 N = FO1 
8042 GOTO 8090                                          ' print 2x2 block (horizontal way)

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
8080 X = 1 : Y = 22
8081 FOR I = 1 TO 5
8082   IF I <= LV THEN C = 58 ELSE C = 32
8083   PUT TILE C,(X, Y)
8084   X = X + 2
8085 NEXT
8086 RETURN

' Put tile block 2x2 started by N on X,Y (horizontal way)
8090 PUT TILE N,(X,Y)
8091 PUT TILE N+1,(X+1,Y)
8092 PUT TILE N+2,(X,Y+1)
8093 PUT TILE N+3,(X+1,Y+1)
8094 RETURN

' Load stage setup from levels data resource 
8100 CMD RESTORE 2                                      ' levels data on resource number 2
8101 RESTORE LR                                         ' go to row number LR in levels data resource CSV
8102 READ STN                                           ' stage number
8103 READ SCN                                           ' scene number
8104 READ MUS                                           ' song number
8105 READ FO1                                           ' floor obstacle tile 1 number
8106 READ FO2                                           ' floor obstacle tile 2 number
8107 READ FOX                                           ' floor obstacle X position
8108 READ HSN                                           ' horizon sprite number
8109 READ CSN                                           ' cloud sprite number    
8110 READ BRF                                           ' bridge flag (0=no bridge, 1=bridge)
8111 READ BSN                                           ' bat sprite number (0=no bat, other=sprite number)
8112 READ BSP                                           ' bat speed (0=fastest, 1=fast, 2=slow, 3=slowest)
8113 READ CTN                                           ' chicken tile number (0=no chicken, other=tile number)
8114 READ CSP                                           ' chicken speed (0=fastest, 1=fast, 2=slow, 3=slowest)
8115 READ CQT                                           ' chicken quantity
8116 RETURN

' dummy code
8120 RETURN
8130 RETURN
8200 RETURN

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

' Load screen (SCR) and sprite (SPR) resources 
9050 SCREEN OFF
9051 SCREEN LOAD SCR
9052 SPRITE LOAD SPR
9053 GOSUB 9040                                         ' clear sprites
9054 SCREEN ON
9055 RETURN

' Clear input buffer
9060 GOSUB 9000 
9061 IF K <> 0 THEN 9060
9062 RETURN


