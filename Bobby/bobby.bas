'-----------------------------------------------------------------
' BOBBY IS STILL GOING HOME - MSXBAS2ROM DEMO (v.1.0)
'-----------------------------------------------------------------
' Game Info:
'   Bobby is Going Home is a platform game released for the Atari 2600 console in 1983.
'     https://en.wikipedia.org/wiki/Bobby_is_Going_Home
'     https://www.rfgeneration.com/news/2600/Banana-s-Rotten-Reviews-Bobby-Is-Going-Home-3473.php
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
2 DIM LVA(15), BRBUF(5,14), REBUF(64,3)                 ' level data array, bridge and rolling enemies buffer
3 DIM HOS(2), SKS(4), SOT(3,1), FES(3), RET(2)          ' horizon, sky, stationary object, flying enemy and rolling enemy tiles/sprites
4 CMD PLYLOAD 0, 1                                      ' load music and effects from resources 0/1
5 SCREEN 2,2,0 : COLOR 15,0,0 
6 SET TILE ON                                           ' set tile mode on (locate and print stmts works like it is in text mode)
7 IF NTSC() THEN TS = 60 : TD = 6 ELSE TS = 50 : TD = 5
8 VRSK = BASE(10) + 64                                  ' name table pointer to sky
9 VRRE = VRSK + 384 : VRBR = VRRE + 43                  ' name table pointer to rolling enemies and bridge in VRAM 

' Splash screen 
10 SCR = 3 : SPR = 12 : GOSUB 9050                      ' load splash screen and sprites
11 MUS = 6 : GOSUB 9030                                 ' play splash screen song
12 GOSUB 9010                                           ' wait for player hit a button
13 CMD PLYMUTE                                          ' mute song

' Game start
20 LR = 0                                               ' level row number in resource CSV
21 SC = 300                                             ' player initial score
22 LV = 5                                               ' player remainder lives
23 STI = 0                                              ' stage increment

' Level initialization
100 GOSUB 8100                                          ' load level data from resource
101 IF STN = 0 THEN LR=LR-8 : STI=STI+1 : GOTO 100      ' if end of level data, repeat last stage with a plus
102 GOSUB 400                                           ' level data initialization
103 GOSUB 8800                                          ' populate bridge and rolling enemies buffer 

110 SCR = SCN + 4 : SPR = 12 : GOSUB 9050               ' load level screen and sprites
111 GOSUB 9030                                          ' play level song
112 GOSUB 8030                                          ' draw stage number on screen
113 GOSUB 8050                                          ' show player sprite
114 GOSUB 8080                                          ' show player remaining lives
115 GOSUB 320                                           ' show remaining objects on screen

' Gameplay loop
120 GOSUB 200                                           ' player logic 
121 IF SC = 0 OR LV = 0 THEN 950                        ' if no score left or no more lives: game over
122 IF RST = 1 THEN 100                                 ' if restart is flagged: restart stage

130 GOSUB 300                                           ' remaining objects logic
131 IF SC = 0 OR LV = 0 THEN 950                        ' if no score left or no more lives: game over
132 IF RST = 1 THEN 100                                 ' if restart is flagged: restart stage

140 IF PX >= 240 THEN 900                               ' if player reached end of stage: next stage
141 IF LVA(1) = 7 THEN IF PX > 200 THEN 910             ' if player arrived at home: do player at home logic 
'142 IF INKEY = 9 THEN LR = LR + 1 : GOTO 100

150 GOTO 120

' Player movement logic
200 IF TIME < PT THEN PT = TIME                          
201 DI = TIME - PT
202 IF DI < TD THEN RETURN                              ' time step = 10x per second
203   PT = TIME

210 GOSUB 9000                                          ' get player input
211 IF K  <> 0 GOSUB 800                                ' player press the button?
212 IF PJ <> 0 GOSUB 810                                ' is player jumping?
213 IF RST = 1 THEN RETURN                              ' if restart is flagged: return
214 ON J GOTO 220, 219, 230, 219, 240, 219, 250, 219    ' player press the stick? 
219   RETURN

' --> player moves UP
220 RETURN

' --> player moves RIGHT
230 IF PX >= 240 THEN RETURN                            ' if hit right border: return
231   PX = PX + PI                                      ' moves right
232   IF PJ <> 0 THEN PS = 4 ELSE PS = (PS + 1) MOD 4   ' change player sprite                                  
233   GOTO 260                                          ' show player and test collision

' --> player moves DOWN 
240 RETURN

' --> player moves LEFT
250 IF PX <= 0 THEN RETURN                              ' if hit right border: return
251   PX = PX - PI                                      ' moves left
252   IF PJ <> 0 THEN PS=10 ELSE PS=(PS + 1) MOD 4 + 6  ' change player sprite                                  
253   GOTO 260                                          ' show player and test collision

' Player tiles collision logic
260 GOSUB 8050                                          ' show player sprite
261 GOSUB 8060                                          ' get player tiles
262 IF PTBL >= 97 THEN IF ((PTBL - 97) MOD 4) >= 2 THEN 290     ' player hit an obstacle or rolling enemy? 
263 IF PTBR >= 97 THEN IF ((PTBR - 97) MOD 4) >= 2 THEN 290     ' player hit an obstacle or rolling enemy?  
264 IF PY < 111 THEN 280                                ' is player in the air?

270 IF PTBL <> 36 OR PTBR <> 36 THEN 280                ' player not fell on a hole?
271   MUS = 5 : GOSUB 9030                              ' player is drowning song
272   GOSUB 340                                         ' player loses 1 life logic
273   FOR SS = 24 TO 32 STEP 3
274     GOSUB 8070                                      ' player is drowning sprite
275     CMD PLYSOUND 6, 2                               ' player is drowning sound effect on channel 2
276     I = 1 : GOSUB 9020                              ' wait 1 second
277   NEXT
278   I = 1 
279   GOTO 9020                                         ' wait 1 second

' Player sprite collision logic
280 OS = COLLISION(0,7)                                 ' check if player sprite collided with a flying enemy sprite
281 IF OS < 0 THEN RETURN                               ' if nothing collided with player, return
282   DX = PX - FX                                      ' calculate how far the sprites are from each other
283   DY = PY - FY
284   IF DX < -10 OR DX > 10 THEN RETURN                ' ignore if distance is not close enough
285   IF DY < -10 OR DY > 10 THEN RETURN
286   GOTO 290                                          ' player hit something logic

' Player hit something logic
290 GOSUB 340                                           ' player loses 1 life logic
291 GOSUB 960                                           ' show player is dead
292 IF LV = 0 THEN RETURN                               ' if no more lives, game over
293   I = 2 
294   GOTO 9020                                         ' wait 2 seconds

' Remaining objects logic
300 IF TIME < OT THEN OT = TIME                          
301 DI = TIME - OT
302 IF DI < (TD*2) THEN RETURN                          ' time step = 5x per second
303   OT = TIME

310 IF LVA(1) < 7 THEN SC = SC - (OSF AND 1)            ' if player not at home, decrease score 2x per second
311 OSF = (OSF + 1) MOD 5                               ' change object step flag

320 GOSUB 8040                                          ' draw score on screen
321 GOSUB 8200                                          ' draw horizon sprite 
322 GOSUB 8300                                          ' draw sky sprite
323 GOSUB 8400                                          ' draw bridge
324 GOSUB 8500                                          ' draw stationary obstacle 
325 GOSUB 8600                                          ' draw flying enemy
326 GOSUB 8700                                          ' draw rolling enemy
327 GOSUB 260                                           ' player collision logic
328 IF LVA(1) < 7 THEN RETURN

' Home sky animation
330 BUF = HEAP()                                        ' free RAM area buffer 
331 CMD VRAMTORAM VRSK, BUF, 192                        ' copy VRAM sky to RAM buffer
332 POKE BUF+192,PEEK(BUF)                              ' copy first buffer tile to buffer's end 
333 CMD RAMTOVRAM BUF+1, VRSK, 192                      ' copy RAM buffer to VRAM sky

' Home special character animation
334 PUT TILE HSCT + HSCS,(24, 10)                       ' home special character tile + step
335 IF HSCS = 0 THEN HSCI = 1 : GOTO 337
336 IF HSCS = 6 THEN HSCI = -1
337 HSCS = HSCS + HSCI
338 RETURN

' Player loses 1 life logic
340 SC = SC + 100                                       ' increment score
341 IF LV > 0 THEN LV = LV - 1                          ' decrement lives
342 RST = 1                                             ' restart level
343 RETURN

' Level data initialization
400 PX = 0 : PY = 111 : PS = 0 : PJ = 0 : PI = 4        ' player x, y, sprite, jumping flag and walking step
401 PT = TIME                                           ' timer for player
402 OT = TIME : OSF = 0                                 ' timer for remaining objects and object step flag
403 HX = 0 : HY = 58                                    ' horizon object position X and Y
404 SX = 200 : SY = 20 : SXI = -8 : SYI = 4             ' sky object position X and Y, and speed
405 FX=150 : FY=90 : FXI= -8-LVA(12) : FYI= 4+LVA(12)   ' flying enemy position X and Y, and speed
406 RST = 0                                             ' restart flag and stage increment
407 HSCN = (STN - 1) MOD 5                              ' home special character related to stage number (0 - 4)
408 HSCT = 129 + HSCN*7                                 ' home special character initial tile
409 HSCS = 0                                            ' home special character tile step
410 HSCI = 1                                            ' home special character tile increment
411 RETURN

' Player jumping button
800 IF LVA(1) = 7 THEN RETURN                           ' ignore if player at home
801 IF PJ <> 0 THEN RETURN                              ' ignore if player is already jumping
802   CMD PLYSOUND 7,2                                  ' player jumping sound effect 7 on channel 2 
803   PJ = -4 : PI = 3                                  ' player jumping and set slow walking step
804   IF PS > 5 THEN PS = 10 ELSE PS = 4                ' player is jumping sprite
805   GOTO 8050                                         ' show player sprite
 
' Player jumping logic
810 PY = PY + PJ
811 IF PY <= 80 THEN PJ = 4                             ' if roof, reverse jumping
812 IF PY >= 111 THEN 820                               ' if floor, end jumping
813 GOSUB 8050                                          ' show player sprite 
814 GOTO 260                                            ' collision logic

' Player stops jumping logic
820 IF PS > 5 THEN PS = 6 ELSE PS = 0                   ' player sprite
821 PJ = 0 : PI = 4                                     ' stop jumping and set normal walking step
822 GOSUB 8050                                          ' show player sprite
823 GOTO 260                                            ' collision logic

' Next stage logic
900 LR = LR + 1 
901 SC = SC + 100
902 GOTO 100                                            ' go to next stage

' Player at home logic
910 FOR I = 1 TO 50                                     ' add 5000 points showing the score
911   SC = SC + 10 
912   GOSUB 8040                                        ' show score
913   IF (I MOD 4) = 0 THEN CMD PLYSOUND 1, 2
914 NEXT
915 I = 3 : GOSUB 9020                                  ' wait 3 seconds
916 CMD PLYMUTE
917 LR = LR + 1
918 GOTO 100

' Game over logic
950 GOSUB 8080                                          ' show player remaining lives
951 GOSUB 8040                                          ' show score
952 GOSUB 9010                                          ' wait for player hit a button
953 GOTO 20                                             ' restart the game

' Player is dead logic
960 IF PS > 5 THEN PS = 11 ELSE PS = 5                  ' player is dead sprite
961 MUS = 5 : GOSUB 9030                                ' player is dead song
962 CMD PLYSOUND 2, 2                                   ' player is dead sound effect on channel 2
963 GOTO 8050                                           ' show player sprite 

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
8030 LOCATE 14,22 : PRINT USING$("###", STN+STI);
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

' get tiles from player sprite edges hot spots 
8060 Y = (PY/8) + 2                                     ' current player position in text coords 
8061 X = PX/8 
8062 PTBL = TILE(X,Y)                                   ' player bottom-left tile
8063 X = (PX+12)/8 
8064 PTBR = TILE(X,Y)                                   ' player bottom-right tile
8065 RETURN

' Show player (3 sprites starting in SS)
8070 PUT SPRITE 0,(PX,PY),1,SS
8071 PUT SPRITE 1,(PX,PY),11,SS+1
8072 PUT SPRITE 2,(PX,PY),4,SS+2
8073 RETURN

' Show lives
8080 X = 1 : Y = 22
8081 FOR I = 2 TO 6
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
8102 FOR I = 0 TO 15
8103   READ LVA(I)
8104 NEXT
8110 STN = LVA(0)                                       ' stage number
8111 SCN = LVA(1)                                       ' scene number
8112 MUS = LVA(2)                                       ' song number
8120 HOS(1) = 33 : HOS(2) = 53                          ' horizon sprite (1=ship, 2=train)
8121 SKS(1) = 37 : SKS(2) = 41 : SKS(3)=45 : SKS(4)=49  ' sky sprite (1=condor, 2=cloud, 3=eagle, 4=sun)
8122 SOT(1,0) =  97 : SOT(1,1) =  97                    ' stationary obstacle tile (1=hydrant)
8123 SOT(2,0) = 101 : SOT(2,1) = 101                    ' stationary obstacle tile (2=flower)
8124 SOT(3,0) = 105 : SOT(3,1) = 109                    ' stationary obstacle tile (3=fountain)
8125 FES(1) = 57 : FES(2) = 59 : FES(3) = 61            ' flying enemy sprite (0=nothing, 1=bird, 2=butterfly, 3=bat)
8126 RET(1) = 113 : RET(2) = 121                        ' rolling enemy tile (0=nothing, 1=barrel, 2=chicken)
8127 RETURN

' Show horizon sprite
8200 IF LVA(3) = 0 THEN RETURN                          ' if no horizon sprite, return
8201   SS = HOS(LVA(3)) + (OSF AND 1)*2
8202   PUT SPRITE 3,(HX,HY),LVA(4),SS
8203   PUT SPRITE 4,(HX+16,HY),LVA(4),SS+1
8204   HX = HX + 4 : IF HX < 228 THEN RETURN
8205   IF HY = 193 THEN HY = 58 : HX = 0 ELSE HY = 193 : HX = 100 + (R MOD 100) 
8206   RETURN

' Show sky sprite
8300 IF LVA(5) = 0 THEN RETURN                          ' if no sky sprite, return
8301   SS = SKS(LVA(5)) + (OSF AND 1)*2
8302   PUT SPRITE 5,(SX,SY),LVA(6),SS
8303   PUT SPRITE 6,(SX+16,SY),LVA(6),SS+1
8304   SX = SX + SXI
8305   SY = SY + SYI
8306   IF SX < 0 THEN SX = 0 : SXI = -SXI ELSE IF SX > 228 THEN SX = 228 : SXI = -SXI
8307   IF SY < 8 THEN SY = 8 : SYI = -SYI ELSE IF SY > 30 THEN SY = 30 : SYI = -SYI
8308   RETURN

' Show bridge
8400 IF LVA(7) = 0 THEN RETURN                          ' if no bridge, return
8401   VRBR1 = VRBR
8402   Y = BRY
8403   FOR I = 0 TO 2
8404     X = VARPTR( BRBUF(0, Y+I) ) 
8405     CMD RAMTOVRAM X, VRBR1, 10                     ' copy ram buffer to vram
8406     VRBR1 = VRBR1 + 32                             ' next line
8407   NEXT
8408   BRY = BRY + BRI
8409   IF BRY < 0 OR BRY > 12 THEN BRI = -BRI : BRY = BRY + BRI
8410   RETURN

' Show stationary obstacle
8500 IF LVA(8)=0 OR LVA(13) > 0 THEN RETURN             ' if no stationary obstacle or rolling enemy, return
8501   X = LVA(9) : Y = 14                              ' stationary obstacle X position
8502   N = SOT(LVA(8), OSF AND 1)                       ' stationary obstacle tile number 
8503   GOTO 8090                                        ' print 2x2 block (horizontal way)

' Show flying enemy
8600 IF LVA(10) = 0 THEN RETURN                         ' if no flying enemy, return
8601   SS = FES(LVA(10)) + (OSF AND 1)
8602   PUT SPRITE 7,(FX,FY),LVA(11),SS
8603   FX = FX + FXI
8604   FY = FY + FYI
8610   IF FXI > 0 THEN 8620                             ' if moving to right, go to moving right logic
8611     IF FX > 80 OR FX < 40 THEN 8630                ' else it's moving left, so if not in first 1/3 of screen go to borders logic
8612       GOTO 8621                                    '   else go to change direction logic
8620     IF FX < 160 OR FX > 210 THEN 8630              ' moving right logic: if not in last 1/3 of screen go to border logic 
8621       GOSUB 9005 : IF R < 10 THEN FXI = -FXI       '   change direction logic: 10% of chance to swap direction  
8630   IF FX < 40 THEN FX = 40 : FXI = -FXI ELSE IF FX > 210 THEN FX = 210 : FXI = -FXI     ' left/right border logic
8631   IF FY < 80 THEN FY = 80 : FYI = -FYI ELSE IF FY > 110 THEN FY = 110 : FYI = -FYI     ' top/bottom border logic
8632   RETURN

' Show rolling enemy
8700 IF LVA(13) = 0 OR LVA(7) = 1 THEN RETURN           ' if no rolling enemy or there's a bridge, return
8701   Y = (OSF AND 1)*2
8702   X = VARPTR( REBUF(0, Y) ) + REX
8703   CMD RAMTOVRAM X, VRRE, 32                        ' copy ram buffer to vram
8704   X = VARPTR( REBUF(0, Y+1) ) + REX
8705   CMD RAMTOVRAM X, VRRE+32, 32
8710   REX = REX + 1 + LVA(14)                          ' rolling enemy speed
8711   IF LVA(15) < 4 THEN DX = 48 ELSE DX = 56
8712   IF REX > DX THEN REX = 0
8713   RETURN

' Populate bridge and rolling enemies buffer 
' --> bridge closed
8800 BRBUF(0, 0) = &h2323 : BRBUF(1, 0) = &h2323 : BRBUF(2, 0) = &h2323 : BRBUF(3, 0) = &h2323 : BRBUF(4, 0) = &h2323
8801 BRBUF(0, 1) = &h2222 : BRBUF(1, 1) = &h2222 : BRBUF(2, 1) = &h2222 : BRBUF(3, 1) = &h2222 : BRBUF(4, 1) = &h2222
8802 BRBUF(0, 2) = &h2222 : BRBUF(1, 2) = &h2525 : BRBUF(2, 2) = &h2424 : BRBUF(3, 2) = &h2525 : BRBUF(4, 2) = &h2222
' --> bridge start to open
8803 BRBUF(0, 3) = &h2323 : BRBUF(1, 3) = &h2323 : BRBUF(2, 3) = &h2424 : BRBUF(3, 3) = &h2323 : BRBUF(4, 3) = &h2323
8804 BRBUF(0, 4) = &h2222 : BRBUF(1, 4) = &h2222 : BRBUF(2, 4) = &h2424 : BRBUF(3, 4) = &h2222 : BRBUF(4, 4) = &h2222
8805 BRBUF(0, 5) = &h2222 : BRBUF(1, 5) = &h2525 : BRBUF(2, 5) = &h2424 : BRBUF(3, 5) = &h2525 : BRBUF(4, 5) = &h2222
' --> bridge mid opened
8806 BRBUF(0, 6) = &h2323 : BRBUF(1, 6) = &h2423 : BRBUF(2, 6) = &h2424 : BRBUF(3, 6) = &h2324 : BRBUF(4, 6) = &h2323
8807 BRBUF(0, 7) = &h2222 : BRBUF(1, 7) = &h2422 : BRBUF(2, 7) = &h2424 : BRBUF(3, 7) = &h2224 : BRBUF(4, 7) = &h2222
8808 BRBUF(0, 8) = &h2522 : BRBUF(1, 8) = &h2424 : BRBUF(2, 8) = &h2424 : BRBUF(3, 8) = &h2424 : BRBUF(4, 8) = &h2225
' --> bridge almost opened
8809 BRBUF(0, 9) = &h2323 : BRBUF(1, 9) = &h2424 : BRBUF(2, 9) = &h2424 : BRBUF(3, 9) = &h2424 : BRBUF(4, 9) = &h2323
8810 BRBUF(0,10) = &h2222 : BRBUF(1,10) = &h2424 : BRBUF(2,10) = &h2424 : BRBUF(3,10) = &h2424 : BRBUF(4,10) = &h2222
8811 BRBUF(0,11) = &h2522 : BRBUF(1,11) = &h2424 : BRBUF(2,11) = &h2424 : BRBUF(3,11) = &h2424 : BRBUF(4,11) = &h2225
' --> bridge almost opened
8812 BRBUF(0,12) = &h2423 : BRBUF(1,12) = &h2424 : BRBUF(2,12) = &h2424 : BRBUF(3,12) = &h2424 : BRBUF(4,12) = &h2324
8813 BRBUF(0,13) = &h2422 : BRBUF(1,13) = &h2424 : BRBUF(2,13) = &h2424 : BRBUF(3,13) = &h2424 : BRBUF(4,13) = &h2224
8814 BRBUF(0,14) = &h2422 : BRBUF(1,14) = &h2424 : BRBUF(2,14) = &h2424 : BRBUF(3,14) = &h2424 : BRBUF(4,14) = &h2224
8815 BRY = 0                                            ' bridge Y offset
8816 BRI = 3                                            ' bridge Y increment
' --> clear rolling enemies buffer
8820 FOR Y = 0 TO 3                                     ' rolling enemies lines
8821   IF (Y AND 1) = 0 THEN C = &h2424 ELSE C = &h2323 ' empty space or floor tile
8822   FOR X = 0 TO 64                                  ' rolling enemies columns
8823     REBUF(X,Y) = C
8824   NEXT
8825 NEXT
' --> populate rolling enemies
8830 X = 16                                             ' 2nd screen position on the buffer
8831 C = RET(LVA(13))                                   ' rolling enemy tile
8832 FOR I = 1 TO LVA(15)                               ' rolling enemies quantity
8833   REBUF(X,0) = ((C+1) SHL 8) OR  C                 ' tile animation 1
8834   REBUF(X,1) = ((C+3) SHL 8) OR (C+2)
8835   REBUF(X,2) = ((C+5) SHL 8) OR (C+4)              ' tile animation 2
8836   REBUF(X,3) = ((C+7) SHL 8) OR (C+6)
8837   X = X + 4                                        ' 6 tiles of space
8838 NEXT
8840 REX = 0                                            ' rolling enemies X offset
8841 RETURN

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


