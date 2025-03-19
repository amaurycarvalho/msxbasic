'-----------------------------------------------------------------
' SPIDER - MSXBAS2ROM DEMO (v.1.0)
'-----------------------------------------------------------------
' Game Info:
'   Shoot the spider !
'   By Amaury Carvalho (2022-2025):
'     https://github.com/amaurycarvalho/msxbasic/Spider
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
'   msxbas2rom spider.bas
'-----------------------------------------------------------------

' Resources
FILE "music/spider.akm"         ' 0 - Music (exported from Arkos Tracker 3)
FILE "music/effects.akx"        ' 1 - Sound Effects (exported from Arkos Tracker 3)
FILE "img/spider.SC2"           ' 2 - Game screen (exported from nMSXTiles, same as BSAVE "filename",S)
FILE "img/spider.spr"           ' 3 - Sprites (exported from TinySprite)

' Game initialization
05 DEFINT A-Z                   ' All variables are integers 
10 SCREEN 2, 2, 0               ' Screen mode 2
11 COLOR 15, 0, 0               ' Set screen front, back and border colors

' Screen initialization
20 SCREEN OFF                   ' Disable screen
21 SET TILE ON                  ' Activate tiled text mode (print text in the same way SCREEN modes 0 and 1 do)
22 SCREEN LOAD 2                ' Load game screen resource (similar to BLOAD "file.SC2",S, created with NMSXTILES)
23 SPRITE LOAD 3                ' Load game sprites (TXT file created with TinySprite) 
24 SET FONT 0                   ' Load system default font 

30 CMD PLYLOAD 0, 1             ' load music and effects from resources 0 and 1 (Arkos Tracker exported files)
31 CMD PLYSONG 0                ' Load game song theme (Bach Invention 14)
32 CMD PLYPLAY                  ' Play theme

40 LOCATE 00, 00 : PRINT "SHOOT THE SPIDER!";
41 LOCATE 22, 00 : PRINT "HITS:";
42 SCREEN ON                                ' Enable screen

' Player start position and score
50 PX = 8
51 PY = 24
52 PP = 0

' Show Spider
60 SX = RND(1) * 100 MOD 192 + 32           ' Select a random X position to spider
61 SY = RND(1) * 100 MOD 128 + 32           ' Select a random Y position to spier
62 PUT SPRITE 1, (SX, SY), 8                

' Show player / Game loop
70 PUT SPRITE 0, (PX, PY), 15, 0

' Get player input
80 PS = STICK(0) OR STICK(1)                ' Keyboard or Joystick movement
81 PB = STRIG(0) OR STRIG(1)                ' Keyboard or Joystick trigger

' Check for trigger
90 IF PB = 0 THEN 200                       ' Player not press the trigger? So, check for movement
91     PUT SPRITE 0,,,2                     ' else, change player's sprite pattern 
92     IF COLLISION(0, 1) < 0 THEN 110      ' Sprite 0 not collided with sprite 1? So, do miss the spider logic 
                                            ' else, do hit the spider logic

' Player hit the spider
100 CMD PLYSOUND 2                          ' Play sound effect from instrument 2
101 PP = PP + 1
102 LOCATE 28, 00 : PRINT PP;
103 PB = STRIG(0) OR STRIG(1) 
104 IF PB <> 0 THEN 103
105 GOTO 60

' Player miss the spider
110 CMD PLYSOUND 3                          ' Play sound effect from instrument 3
111 PB = STRIG(0) OR STRIG(1) 
112 IF PB <> 0 THEN 111
113 GOTO 70

' Player movement logic 
200 IF PS = 0 THEN 80
201   DX = 0 : DY = 0

210   IF PS = 1 THEN DY = -1 : GOTO 220
211   IF PS = 2 THEN DX = 1 : DY = -1 : GOTO 220
212   IF PS = 3 THEN DX = 1 : GOTO 220
213   IF PS = 4 THEN DX = 1 : DY = 1 : GOTO 220
214   IF PS = 5 THEN DY = 1 : GOTO 220
215   IF PS = 6 THEN DX = -1 : DY = 1 : GOTO 220
216   IF PS = 7 THEN DX = -1 : GOTO 220
217   IF PS = 8 THEN DX = -1 : DY = -1 

220 DX = DX + PX
221 DY = DY + PY
222 IF DX < 8 OR DX > 232 OR DY < 24 OR DY > 160 THEN 80

230 PX = DX
231 PY = DY
232 GOTO 70                                 ' Repeat game loop


