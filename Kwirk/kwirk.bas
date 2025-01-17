'-----------------------------------------------------------------
' KWIRK - MSXBAS2ROM DEMO
'-----------------------------------------------------------------
' Game Info:
'   Kwirk is a 1989 game created by Atlus and published by Acclaim for Gameboy (1990)
'   Levels adapted from TI89 version created by Ludvig Strigeus and Jordan Clifford (2011)
'   Remake to MSX2 created by Amaury Carvalho (2025):
'     https://github.com/amaurycarvalho/msxbasic/kwirk
'-----------------------------------------------------------------
' Stack:
'   https://github.com/amaurycarvalho/msxbas2rom/
'   https://julien-nevo.com/at3test/index.php/download/
'   https://msx.jannone.org/conv/
'-----------------------------------------------------------------
' Compile:
'   msxbas2rom -x kwirk.bas
'-----------------------------------------------------------------

' Resources (when compiling on Windows, change slashs to backslashs: / to \ ) 
FILE "music/kwirk.akm"                                  ' 0 - songs exported from ArkosTracker 3 (Music.aks)
FILE "music/effects.akx"                                ' 1 - sound effects exported from ArkosTracker 3 (SoundEffects.aks)
FILE "levels/kEasy.89s"                                 ' 2 - levels easy
FILE "levels/kMed.89s"                                  ' 3 - levels medium
FILE "levels/kHard.89s"                                 ' 4 - levels hard
FILE "img/splash.SC5"                                   ' 5 - splash screen
FILE "img/skill.SC5"                                    ' 6 - skill screen
FILE "img/floor.SC5"                                    ' 7 - floor screen
FILE "img/start.SC5"                                    ' 8 - start screen
FILE "img/wall.SC5"                                     ' 9 - wall screen
FILE "img/abandon.SC5"                                  ' 10 - abandon screen
FILE "img/finish.SC5"                                   ' 11 - finish screen
FILE "img/tiles.SC5"                                    ' 12 - tiles

' Initialization
1 DEFINT A-Z 
2 DIM MAZE(24,32)
3 IF MSX() = 0 THEN PRINT "Sorry, not for MSX1 machines" : END
4 CMD PLYLOAD 0, 1                                      ' load music and effects from resources 0/1
5 SCREEN 5,,0 
6 COLOR 4,0,0 

' Intro screen
10 CLS 
11 COPY(0,0)-(255,212),0 TO (0,0),1
12 SC = 5 : GOSUB 9020                                  ' show splash screen
13 MU = 0 : GOSUB 9030                                  ' play intro song
14 GOSUB 9010                                           ' wait for player hit a button
15 CMD PLYMUTE                                          ' stops song

' Skill screen
20 SC = 6 : GOSUB 9020                                  ' show skill screen
21 MU = 1 : GOSUB 9030                                  ' play parameters screen song
22 GOSUB 9010                                           ' wait for player hit a button

' Floor screen
30 SC = 7 : GOSUB 9021                                  ' show floor screen
31 GOSUB 9010                                           ' wait for player hit a button

' Start screen
40 SC = 8 : GOSUB 9021                                  ' show start screen
41 GOSUB 9010                                           ' wait for player hit a button
42 CMD PLYMUTE

' Wall screen
50 SC = 9 : GOSUB 9020                                  ' show wall screen
51 MU = 2 : GOSUB 9030                                  ' maze song
52 GOSUB 9010                                           ' wait for player hit a button

' Abandon screen
60 SC = 10 : GOSUB 9020                                 ' show abandon screen
61 MU = 2 : GOSUB 9030                                  ' maze song
62 GOSUB 9010                                           ' wait for player hit a button

' Finish screen
70 SC = 11 : GOSUB 9020                                 ' show finish screen
71 MU = 2 : GOSUB 9030                                  ' maze song
72 GOSUB 9010                                           ' wait for player hit a button

' Tiles screen
80 GOSUB 8000
81 SET PAGE 1,1
82 GOSUB 9010

' End demo
90 SCREEN 0 : PRINT "GAME FINISHED" : END

' Load tiles on page 1
8000 SET PAGE 0,1
8001 SC = 12 : GOSUB 9021
8002 RETURN

' Print tile N on X, Y

' Build level maze

' Show level maze

'-------------------------------------------
' SUPPORT ROUTINES
'-------------------------------------------

' Get player input (out: K, J)
9000 K = STRIG(0) OR STRIG(1)
9001 J = STICK(0) OR STICK(1)
9002 RETURN

' Wait for player hit a button
9010 GOSUB 9000                                         ' get player input
9011 IF K=0 THEN 9010
9012 RETURN

' Load resource screen (in: SC)
9020 SET PAGE 1,0 
9021 SCREEN LOAD SC
9022 SET PAGE 0,0
9023 RETURN 

' Play song (in: MU)
9030 CMD PLYSONG MU 
9031 CMD PLYPLAY
9032 RETURN


