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
2 DIM LVA(13)                                           ' level data array 
3 DIM SB$(2,2)                                          ' scenes tiles data buffer
4 CMD PLYLOAD 0, 1                                      ' load music and effects from resources 0/1
5 SCREEN 2,2,0 : COLOR 15,0,0 
6 SET TILE ON                                           ' set tile mode on (locate and print stmts works like it is in text mode)
7 IF NTSC() THEN TS = 60 : TD = 6 ELSE TS = 50 : TD = 5

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
101 IF STN = 0 THEN LR = LR - 7 : GOTO 100              ' if end of level data, repeat last stage
102 PX = 0 : PY = 111 : PS = 0                          ' player x, y and sprite
103 PJ = 0                                              ' player jumping flag
104 PT = TIME                                           ' timer for player
105 OT = TIME                                           ' timer for remaining objects
106 SF = 0                                              ' sprite flag

110 SCR = SCN + 4 : SPR = 12 : GOSUB 9050               ' load level screen and sprites
111 GOSUB 9030                                          ' play level song
112 GOSUB 8030                                          ' draw stage number on screen
113 GOSUB 8050                                          ' show player sprite
114 GOSUB 8080                                          ' show player remaining lives
115 GOSUB 320                                           ' show remaining objects on screen

' Gameplay loop
120 GOSUB 200                                           ' player logic 
121 GOSUB 300                                           ' remaining objects logic
122 IF PX >= 240 THEN 900                               ' if player reached end of stage: next stage 
123 IF SC = 0 THEN 950                                  ' if nothing left: game over
124 GOTO 120

' Player movement logic
200 IF TIME < PT THEN PT = TIME                          
201 DI = TIME - PT
202 IF DI < TD THEN RETURN                              ' time step = 10x per second
203   PT = TIME

210 GOSUB 9000                                          ' get player input
211 IF K  <> 0 GOSUB 800                                ' player press the button?
212 IF PJ <> 0 GOSUB 810                                ' is player jumping?
213 ON J GOTO 220, 214, 230, 214, 240, 214, 250, 214    ' player press the stick? 
214   RETURN

' --> player moves UP
220 RETURN

' --> player moves RIGHT
230 IF PX >= 240 THEN RETURN                            ' if hit right border: return
231 GOSUB 260                                           ' get left/right tiles
232 IF TR1 > 128 OR TR2 > 128 THEN RETURN               ' if hit a obstacle, return
233   PX = PX + 4                                       ' moves right
234   IF PJ <> 0 THEN PS = 4 ELSE PS = (PS + 1) MOD 4   ' change player sprite                                  
235   GOTO 8050                                         ' show player sprite

' --> player moves DOWN 
240 RETURN

' --> player moves LEFT
250 IF PX <= 0 THEN RETURN                              ' if hit right border: return
251 GOSUB 260                                           ' get left/right tiles
252 IF TR1 > 128 OR TR2 > 128 THEN RETURN               ' if hit a obstacle, return
253   PX = PX - 4                                       ' moves right
254   IF PJ <> 0 THEN PS=10 ELSE PS=(PS + 1) MOD 4 + 6  ' change player sprite                                  
255   GOTO 8050                                         ' show player sprite

260 X=PX/8 : Y=PY/8                                     ' get LEFT/RIGHT tiles from player position
261 TL1=TILE(X-1,Y+1)                                   ' tile position in text mode coords
262 TL2=TILE(X-1,Y+2)
263 TR1=TILE(X+2,Y+1)
264 TR2=TILE(X+2,Y+2)
265 RETURN

270 X=PX/8 : Y=PY/8                                     ' get UP/DOWN tiles from player position
271 TU1=TILE(X,Y+1)                                     ' tile position in text mode coords
272 TD1=TILE(X,Y+3)
273 RETURN

280 X=PX/8 : Y=PY/8+1                                   ' get inner tiles from player position
281 TP1=TILE(X,Y)                                       ' tile position in text mode coords
282 TP2=TILE(X,Y+1)                                      
283 TP3=TILE(X+1,Y)                                      
284 TP4=TILE(X+1,Y+1)          
285 TPS=TP1 OR TP2 OR TP3 OR TP4                     
286 RETURN

' Remaining objects logic
300 IF TIME < OT THEN OT = TIME                          
301 DI = TIME - OT
302 IF DI < (TD*5) THEN RETURN                          ' time step = 2x per second
303   OT = TIME

310 IF SC > 0 THEN SC = SC - 1                          ' decrease score
311 SF = (SF + 1) MOD 2                                 ' change sprite flag

320 GOSUB 8040                                          ' draw score on screen
321 GOSUB 8200                                          ' draw horizon sprite 
322 GOSUB 8300                                          ' draw sky sprite
323 GOSUB 8400                                          ' draw bridge
324 GOSUB 8500                                          ' draw stationary obstacle 
325 GOSUB 8600                                          ' draw flying enemy
326 GOTO  8700                                          ' draw rolling enemy

' Condor movement logic
'400 CS = (CS + 1) MOD 2
'401 CX = CX + 8
'402 IF CX > 220 THEN CY = 212                            ' if right border: hide condor
'403 GOSUB 8200                                           ' show condor sprite

' Egg appearence logic
'500 IF TIME < ET THEN ET = TIME                          
'501 DI = TIME - ET
'502 IF DI < TD THEN RETURN                               ' time step = 10x per second
'503   ET = TIME

'510 IF EY < 212 THEN 600                                 ' if egg already in action: movement logic
'511   IF CY >= 212 THEN RETURN                           ' if condor not in action: return
'512     GOSUB 9005                                       ' next random number
'513     IF (R MOD 40) > ST THEN RETURN                   ' random egg appearence: higher stages = more appearences
'514       EY = CY : EX = CX + 8 
'515       GOTO 8070                                      ' show egg sprite

' Egg movement logic
'600 IF EY >= 212 THEN RETURN
'601   EY = EY + 6 
'602   GOSUB 8070                                         ' show egg sprite

' Egg vs player collision logic
'700 IF COLLISION(7,0) < 0 THEN RETURN                    ' if egg sprite collided with player sprite
'701   IF PS < 4 THEN PS = 3 ELSE PS = 7                  ' player is dead
'702     GOSUB 8050                                       ' show player sprite
'703     CMD PLYSOUND 1                                   ' play egg collision sound effect
'704     IF LV > 0 THEN LV = LV - 1 : GOSUB 8080          ' show lives
'705     EY = 212 
'706     GOTO 8070                                        ' hide egg

' Player jumping button
800 IF PJ <> 0 THEN RETURN                              ' ignore if player is already jumping
801   CMD PLYSOUND 7,2                                  ' player jumping sound effect 7 on channel 2 
802   PJ = -4                                           ' player jumping step
803   IF PS > 5 THEN PS = 10 ELSE PS = 4                ' player is jumping sprite
804   GOTO 8050                                         ' show player sprite
 
' Player jumping logic
810 PY = PY + PJ
811 IF PY <= 80 THEN PJ = 4                             ' if roof, reverse jumping
812 IF PY >= 111 THEN 820                               ' if floor, end jumping
813 GOTO 8050                                           ' show player sprite 

820 IF PS > 5 THEN PS = 6 ELSE PS = 0
821 PJ = 0
822 GOTO 8050


' Add score and reduce bags count
'840 SC = SC + 1                                          ' add to score points
'841 IF BC > 0 THEN BC = BC - 1                           ' reduce bags count
'842 GOTO 8040                                            ' print score

' Getting the car logic
'850 GOSUB 8015                                           ' clear car tile 
'851 GOSUB 8110                                           ' register getting the car on the scene buffer
'852 CMD PLYSOUND 4                                       ' play getting an item sound effect
'853 BF = 2 : GOSUB 8200                                  ' player holding the bag
'854 GOTO 8050                                            ' show player sprite
 
' Releasing the car logic
'860 IF TPS <> 32 AND TPS <> 0 THEN RETURN                ' if not an empty space, return
'861   N = &HA2 : Y = Y + 1 : GOSUB 8010                  ' release the car on the floor
'862   GOSUB 8130                                         ' register releasing the car on the scene buffer
'863   BF = 0 : GOSUB 8200                                ' player handsfree flag
'864   CMD PLYSOUND 4                                     ' play release an item sound effect
'865   GOTO 8050                                          ' show player sprite

' Next stage
900 LR = LR + 1 
901 SC = SC + 100
902 GOTO 100                                            ' go to next stage

' Game over
950 MUS = 5 : GOSUB 9030                                ' game over song
951 GOSUB 960                                           ' player is dead
952 GOSUB 9010                                          ' wait for player hit a button
953 GOTO 20                                             ' restart the game

' Player is dead logic
960 IF PS > 5 THEN PS = 11 ELSE PS = 5                  ' player is dead sprite
961 CMD PLYSOUND 5, 2                                   ' player is dead sound effect on channel 2
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

' Show stage STN 
8030 LOCATE 14,22 : PRINT USING$("###", STN);
8031 RETURN

' Print score 
8040 LOCATE 12, 0 
8041 PRINT USING$("######", SC*10.0);
8042 RETURN

' Show player sprite
8050 SS = (PS * 2)
8051 PUT SPRITE 0,(PX,PY),1,SS
8052 PUT SPRITE 1,(PX,PY),11,SS+1
8053 RETURN
 
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
8102 FOR I = 0 TO 13
8103   READ LVA(I)
8104 NEXT
8105 STN = LVA(0)                                       ' stage number
8106 SCN = LVA(1)                                       ' scene number
8107 MUS = LVA(2)                                       ' song number
8108 RETURN

' dummy code
8120 RETURN
8130 RETURN

' Show horizon sprite
8200 IF LVA(3) = 0 THEN RETURN                          ' if no horizon sprite, return
8201   SS = LVA(3) + SF*2
8202   PUT SPRITE 3,(HX,HY),15,SS
8203   PUT SPRITE 4,(HX+16,HY),15,SS+1
8204   PUT SPRITE 5,(HX,HY),8,SS+2
8205   PUT SPRITE 6,(HX+16,HY),8,SS+3
8206   RETURN

' Show sky sprite
8300 IF LVA(4) = 0 THEN RETURN                          ' if no sky sprite, return
8301   SS = LVA(4) + SF*2
8302   PUT SPRITE 3,(SX,SY),15,SS
8303   PUT SPRITE 4,(SX+16,SY),15,SS+1
8304   PUT SPRITE 5,(SX,SY),8,SS+2
8305   PUT SPRITE 6,(SX+16,SY),8,SS+3
8306   RETURN

' Show bridge
8400 IF LVA(5) = 0 THEN RETURN                          ' if no bridge, return
8401   RETURN

' Show stationary obstacle
8500 IF LVA(5) = 1 THEN RETURN                          ' if bridge, return
8501   X = LVA(8) : Y = 14                              ' stationary obstacle X position
8502   N = LVA(6+SF)                                    ' stationary obstacle tile number 
8503   GOTO 8090                                        ' print 2x2 block (horizontal way)

' Show flying enemy
8600 IF LVA(9) = 0 THEN RETURN                          ' if no flying enemy, return
8601   RETURN

' Show rolling enemy
8700 IF LVA(11) = 0 THEN RETURN                         ' if no rolling enemy, return
8701   RETURN

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

' Play song MUS
9030 IF MUS = OLDMUS THEN RETURN                        ' ignore if same song
9031   OLDMUS = MUS
9032   CMD PLYSONG MUS 
9033   CMD PLYPLAY
9034   RETURN

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


