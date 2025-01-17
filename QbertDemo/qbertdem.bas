'-----------------------------------------------------------------
' QBERT - MSXBAS2ROM DEMO
'-----------------------------------------------------------------
' Game Info:
'   Q*bert (also known as Qbert) is an arcade video game released by Gottlieb in 1982
'   Ported to MSX2 by Jelle Roggen (2024): 
'     https://www.msxdev.org/2025/01/11/msxdev24-21-qbert/
'   MSXBAS2ROM rough draft adaptation by Amaury Carvalho from Roggen original code (2025):
'     https://github.com/amaurycarvalho/msxbasic/QbertDemo
'-----------------------------------------------------------------
' Stack:
'   https://github.com/amaurycarvalho/msxbas2rom/
'   https://julien-nevo.com/at3test/index.php/download/
'-----------------------------------------------------------------
' Compile:
'   msxbas2rom -x qbertdem.bas
'-----------------------------------------------------------------

' Resources (when compiling on Windows, change slashs to backslashs: / to \ ) 
FILE "music/qbert.akm"                          ' 0 - songs exported from ArkosTracker 3 (Music.aks)
FILE "music/effects.akx"                        ' 1 - sound effects exported from ArkosTracker 3 (SoundEffects.aks)
FILE "levels/Q-BERT1.STA"                       ' 2 - stages
FILE "img/INTRO.SC5"                            ' 3 - intro screen
FILE "img/TILES.SC5"                            ' 4 - tiles

' Initialization
1 DEFINT A-Z 
2 DIM A(63,2), J(10), Q(7,3), M(6,12), S(11,8), P(12,3), B(3), D(1,7)
3 IF MSX() = 0 THEN PRINT "Sorry, not for MSX1 machines" : END
4 CMD PLYLOAD 0, 1                              ' load music and effects from resources 0/1

' Intro screen
10 SCREEN 5,,0
11 SET PAGE 0,1
12 SCREEN LOAD 3                                ' load screen from resource 3 (INTRO.SC5)
13 FOR AA=0 TO 15 : COLOR=(AA,0,0,0) : NEXT AA
14 SET PAGE 1,1
15 PP=0 : GOSUB 40                              ' screen fade in
16 CMD PLYSONG 0 : CMD PLYPLAY                  ' play intro song
17 IF MSX() < 3 THEN GOSUB 32 ELSE GOSUB 60     ' wave effect or Turbo R special effect

' Game start
20 CMD PLYMUTE                                  ' stops song
21 PP=1 : GOSUB 40                              ' screen fade out
22 GOSUB 100                                    ' level initialization
23 GOSUB 200                                    ' stage screen
27 GOSUB 30 : IF K=0 THEN 27
28 CMD PLYSOUND 1                               ' play sound effect 1
29 SCREEN 0 : PRINT "GAME FINISHED" : END

' Get trigger status
30 K = STRIG(0) OR STRIG(1) OR STRIG(2)
31 RETURN

' Screen wave effect
32 COPY(0,0)-(255,212),1 TO (1,1),0
33 CMD PAGE 1,1                                 ' enable wave effect (cadari bit)
34 GOSUB 30 : IF K=0 THEN 34
35 CMD PAGE 0,0                                 ' disable wave effect
36 RETURN

' Screen fade in/out (PP=0 or PP=1)
39 DATA 0,0,4,0,0,0,0,0,5,0,0,6,1,1,7,2,1,7,7,0,0,2,2,7,7,2,2,7,3,3,7,4,2,6,6,3,5,3,3,5,3,5,5,5,5,7,7,7
40 IF PP=0 THEN R=0 : R1=7 : R2=1 ELSE R=7 : R1=0 : R2=-1
41 RESTORE 39 
42 FOR AA=0 TO 15 
43   FOR BB=0 TO 2 
44     READ A(AA,BB) 
45   NEXT BB
46 NEXT AA
50 FOR BB=R TO R1 STEP R2
51   E=0
52   FOR AA=0 TO 15
53     RED=INT(((A(AA,0)/7.0)*BB))*16 : GREEN=(A(AA,1)/7.0)*BB : BLUE=(A(AA,2)/7.0)*BB
54     VPOKE &H7680+E,RED+BLUE : VPOKE &H7681+E,GREEN : E=E+2
55   NEXT AA
56   COLOR=RESTORE
57 NEXT BB
58 RETURN

' Turbo R special effect
60 CMD TURBO 1                                                      ' activate Turbo R mode
61 FOR AA=0 TO 2 STEP 2
62   COPY(0,0)-(255,212),1 TO (0,0),AA
63 NEXT AA
64 P1=0 : P2=2 : SET PAGE P1,P2
70 F=F+1 : DD=50.0*SIN(F/10.0) 
71 GOSUB 80 : IF K<>0 AND DD > -4 AND DD < 4 THEN RETURN
72 GOTO 70
80 C=0 : GOSUB 90
81 FOR AA=62 TO 0 STEP -1
82   GOSUB 30 : IF K<>0 THEN RETURN
83   A(AA,P1/2)=DD*SIN(C/10.0)+59
84   COPY (59,AA)-(205,AA),1 TO (A(AA,P1/2),AA) 
85   C=C+1
86 NEXT AA 
87 SET PAGE P1,P2 : SWAP P1,P2
88 RETURN
90 FOR AA=0 TO 62
91   LINE(A(AA,P1/2),AA)-STEP(205-61+10,0),0
92 NEXT AA
93 RETURN

' level initialization
100 PP=50*RND(-TIME)
101 SCREEN 5 : COLOR=(3,0,3,6) : COLOR=(7,6,1,1) : COLOR=(14,0,3,6)
102 FOR AA=0 TO 3 : COPY(0,0)-STEP(255,44),0 TO (0,213),AA : NEXT AA  ' clear screen pages 
103 SET PAGE 0, 1 : SCREEN LOAD 4 : SET PAGE 0, 0                     ' load sprites map on page 1
104 RESTORE 104 : FOR C=0 TO 10 : READ BB : J(C)=BB : NEXT C : DATA 0,3,5,8,9,9,9,8,5,3,0
105 FOR AA=0 TO 7 : FOR BB=0 TO 3: READ C : Q(AA,BB)=C : NEXT BB,AA : DATA0,76,12,18,13,76,12,20,26,76,14,18,41,76,14,20,56,76,14,20,71,76,14,20,86,76,12,20,99,76,12,20
106 RETURN

' build stage screen
200 FOR AA=0 TO PP : BB=RND(1) : NEXT AA                                ' randomize
201 P1=0 : P2=2 : L=3 
202 CMD RESTORE 2                                                       ' load binary DATA on resource 2 (stage data)
203 IRESTORE 7                                                          ' set binary DATA initial read position to byte 7
210 H=4 : T=0 : T1=0 
211 FOR Y=0 TO 8                                                        ' read stage data
212   IREAD BB                                                          ' read next integer data
213   W = ((BB SHR 8) AND &h0F) OR ((BB SHL 4) AND &h0FF0)              ' reverse it to a modified big endian
214   FOR X=11 TO 0 STEP -1
215     S(X,Y)= W AND 1
216     W = W SHR 1
217   NEXT
218 NEXT 
220 SET PAGE ,3 : CLS
221 FOR Y=0 TO 8
222   FOR X=0 TO 11
223     IF S(X,Y)=1 THEN COPY(0,0)-(20,34),1 TO (X*20+(Y AND 1)*10,2+Y*24),,TPSET : T=T+1
224   NEXT
225 NEXT
230 FOR BB=0 TO 2 STEP 2
231   SET PAGE ,BB : CLS
232   COPY(0,0)-(255,212),3 TO (0,0),BB
233 NEXT
234 SET PAGE P1,P2
'235 GOSUB 300 : GOTO 305
290 CMD PLYSONG 1 : CMD PLYPLAY                                         ' play level song
291 RETURN


'50 W=&H8000
'51 DEFUSR=&HD000:A=USR(0):DEFUSR=&HD200:DEFUSR1=&HFA88
'52 IFPEEK(&HCF80)=0ANDPEEK(&HCF81)=1ANDPEEK(&HCF82)=2THENPRINTELSEBEEP:BEEP:SCREEN0:PRINT"Program is too big, risk of crashing !!!!!!!!!!!!!!!!":END
'60 FORA=0TOP:B=RND(1):NEXTA:P1=0:P2=2:L=3
'70 H=4:T=0:T1=0:POKE&HFAA0,5:FORY=0TO8:W5=USR1(W):A$=RIGHT$("00000000"+BIN$(W5),8):W5=USR1(W+1):B$=RIGHT$("0000"+BIN$(W5),4):W=W+2:A$=A$+B$:FORX=0TO11:S(X,Y)=VAL(MID$(A$,X+1,1)):NEXTX,Y
'80 SETPAGE,3:CLS:FORY=0TO8:FORX=0TO11:IFS(X,Y)=1THENCOPY(0,0)-(20,34),1TO(X*20+(Y-(INT(Y/2)*2))*10,2+Y*24),,TPSET:T=T+1:NEXTX,Y:ELSENEXTX,Y
'90 FORB=0TO2STEP2:SETPAGE,B:CLS:COPY(0,0)-(255,212),3TO(0,0),B:NEXTB:SETPAGEP1,P2
'-----> GOSUB100:GOTO105
'100 A=0:D=0:X=USR1(W):X2=X:Y=USR1(W+1):Y2=Y:GOSUB135:W=W+2
'101 FORS=0TO5:M(S,7)=0:GOSUB104:M(S,2)=300*RND(1)+100:M(S,3)=0:M(S,8)=1:NEXTS:RETURN
'104 M(S,1)=48:M(S,0)=INT(12*RND(1))+2:IFS(M(S,0),2)=0THENGOTO104ELSEM(S,0)=(M(S,0)*20)+5:RETURN:
'105 FORB=0TO1:D(B,0)=USR1(W):D(B,5)=D(B,0):D(B,1)=USR1(W+1):D(B,6)=D(B,1):D(B,2)=USR1(W+2):D(B,3)=USR1(W+3):D(B,4)=0:D(B,7)=20*RND(1)+20:W=W+4:NEXTB:W=W+2
'110 IFZ>0THENGOSUB145:GOSUB150:GOSUB355:FORB=0TO1:GOSUB410:NEXTB:GOSUB470:FORP=0TO500*(PEEK(&H2D)-1):NEXTP:SWAPP1,P2:GOSUB134:SETPAGEP1,P2:GOTO110
'115 IFD<10THEND=STICK(0)+PEEK(&HCFFF-4):ONDGOSUB140,170,140,170,140,170,140,170
'120 GOSUB145:GOSUB150:FORS=0TO5:GOSUB230:NEXTS:FORB=0TO1:GOSUB410:NEXTB:GOSUB180:FORS=0TO5:GOSUB231:GOSUB360:NEXTS:GOSUB470:SWAPP1,P2:GOSUB135:SETPAGEP1,P2
'130 GOTO110
'134 IF(Z>0ANDZ<100)THENRETURN
'135 IFTIME<4THEN135ELSETIME=0:T8=130+Y+J(A):IFT8<203THENT8=203
'136 T7=X+127:IFT7<200THENT7=200ELSEIFT7>280THENT7=280
'137 VDP(24)=T8:VDP(27)=T7\8:VDP(28)=7-(T7AND7):RETURN
'140 RETURN
'145 IFB(2)=0THENRETURNELSEB1=P2:FORB=0TO1:COPY(21,0)-(41,34),1TO(B(0),B(1)),B1,TPSET:B1=3:NEXTB:B(2)=B(2)-1:RETURN
'150 COPY(P(0,P1),P(0,P1+1))-STEP(14,20),3TO(P(0,P1),P(0,P1+1)):FORS=1TO6:IFP(S,P1)=0THENNEXTSELSECOPY(P(S,P1),P(S,P1+1))-STEP(13,11),3TO(P(S,P1),P(S,P1+1)):P(S,P1)=0:NEXTS
'154 FORB=0TO1:IFP(9+B,P1)=0THENNEXTBELSECOPY(P(9+B,P1),P(9+B,P1+1))-STEP(13,14),3TO(P(9+B,P1),P(9+B,P1+1)):P(9+B,P1)=0:NEXTB
'155 COPY(P(11,P1),P(11,P1+1))-STEP(32,26),3TO(P(11,P1),P(11,P1+1)):IFP(12,P1)=0THENRETURNELSECOPY(P(12,P1),P(12,P1+1))-STEP(44,21),3TO(P(12,P1),P(12,P1+1)):P(12,P1)=0:RETURN
'160 ' Q-BERT MOVEMENT
'170 XX=USR(6):X1=(D>5)-(D<5):Y1=(D=2ORD=8)-(D=4ORD=6):H=D:X2=X:Y2=Y:D=10:RETURN
'180 IFD=10THENA=A+1:X=X+X1:Y=-J(A)+Y2+Y1*(24/10)*A:GOSUB190:IFA=10THENGOSUB340:D=-(D=11)*11:A=0:X2=X:Y2=Y:RETURNELSERETURNELSEGOSUB190:RETURN
'190 IFY>190THENRETURNELSEK=(H-2)-(D=10):COPY(Q(K,0),Q(K,1))-STEP(Q(K,2),Q(K,3)),1TO(X-2,(Y-3)*-(Y-3>0)),,TPSET:P(0,P1)=X-2:P(0,P1+1)=(Y-3)*-(Y-3>0):RETURN
'200 COPY(0,35)-STEP(12,15),1TO(X,Y),,TPSET:P(0,P1)=X:P(0,P1+1)=Y:RETURN
'210 COPY((-(Q=5)*14)-((M(S,7)=5)*28),51)-STEP(13,11),1TO(M(S,0),M(S,1)+2),,TPSET:P(S+1,P1)=M(S,0):P(S+1,P1+1)=M(S,1)+2:Q=0:RETURN
'220 ' MONSTERS MOVEMENT
'230 IFD(0,4)>0ORD(1,4)>0ORY>M(S,1)ORM(S,12)=6THENM(S,12)=5:GOTO232ELSEM(S,12)=0:RETURN
'231 IF M(S,12)=5ORM(S,12)=6THENRETURN
'232 ONM(S,3)+1GOTO235,240,250,260,280,265
'235 IFM(S,2)=0THENGOTO236ELSEM(S,2)=M(S,2)-1:IFM(S,2)<30THENM(S,12)=6:COPY(16,98)-STEP(7,5),1TO(M(S,0)+2,M(S,1)+10),,TPSET:P(S+1,P1)=M(S,0)+2:P(S+1,P1+1)=M(S,1)+10:M(S,11)=M(S,1):IFM(S,2)=0THENXX=USR(2):RETURNELSERETURNELSERETURN
'236 M(S,1)=M(S,1)-M(S,11):GOSUB210:M(S,1)=M(S,1)+M(S,11):M(S,11)=M(S,11)-2:IFM(S,11)<0THENM(S,3)=2:RETURNELSERETURN
'240 ' m(s,2)=1  lege sprong regel
'250 B=INT(2*RND(1)):M(S,4)=(B=0)-(B>0):M(S,5)=1:M(S,6)=M(S,1):M(S,3)=3:M(S,2)=0:IFS(((M(S,0)+M(S,4)*10)-5)/20,((M(S,1)+24))/24)=0THENM(S,4)=M(S,4)*-1:IFS(((M(S,0)+M(S,4)*10)-5)/20,(M(S,1)+24)/24)=0THENIFS=0THENM(S,7)=5:GOTO280:'ELSERETURNELSERETURN
'260 M(S,2)=M(S,2)+1:M(S,0)=M(S,0)+M(S,4):M(S,1)=-J(M(S,2))+M(S,6)+M(S,5)*(24/10)*M(S,2):GOSUB210:IFM(S,2)=10THENIFM(S,7)=5THENGOSUB261:M(S,3)=5:M(S,2)=2:RETURNELSE270ELSERETURN
'261 IFP5=-1THENCOLOR=(0,7,7,7):W=W-10:GOSUB101:W=W+10:XX=USR(1):COLOR=(0,0,0,0):RETURNELSERETURN
'265 M(S,2)=M(S,2)-1:Q=5:GOSUB210:IFM(S,2)>0THENRETURNELSEIFM(S,7)=5THENM(S,3)=4:RETURNELSEM(S,3)=2:RETURN:'wacht pauze
'270 IFS((M(S,0)-5)/20,(M(S,1))/24)>0THENM(S,3)=5:RETURNELSEGOSUB104:M(S,2)=500*RND(1):M(S,3)=0:RETURN:'m volgt q-bert>>>
'280 M(S,2)=0:M(S,3)=3:M(S,6)=M(S,1):IFX2>M(S,0)THENM(S,4)=1ELSEM(S,4)=-1
'290 IF Y2>M(S,1)THENM(S,5)=1ELSEM(S,5)=-1
'291 X3=M(S,0)+(10*M(S,4)):Y3=M(S,1)+(24*M(S,5)):IF(D(0,4)>1ORD(1,4)>1)ANDX2-9<X3ANDX2+9>X3ANDY2-9<Y3ANDY2+9>Y3THENP5=-1ELSEP5=0
'292 IFM(S,8)=1THENGOSUB311ELSEGOSUB320:IFP=0THENM(S,5)=M(S,5)*-1:GOSUB320:IFP=0THENM(S,5)=M(S,5)*-1:M(S,4)=M(S,4)*-1:GOSUB320:IFP=0THENM(S,5)=M(S,5)*-1
'293 IFM(S,4)=M(S,9)*-1ANDM(S,5)=M(S,10)*-1THENM(S,8)=M(S,8)*-1ELSEM(S,9)=M(S,4):M(S,10)=M(S,5)
'310 RETURN
'311 GOSUB320:IFP=0THENM(S,4)=M(S,4)*-1:GOSUB320:IFP=0THENM(S,4)=M(S,4)*-1:M(S,5)=M(S,5)*-1:GOSUB320:IFP=0THENM(S,4)=M(S,4)*-1
'312 RETURN
'320 IFP5=-1THENP=5:RETURNELSEIFM(S,1)+(M(S,5)*24)<0THENP=0:RETURNELSEP=S(((M(S,0)+M(S,4)*10)-5)/20,((M(S,1)+M(S,5)*24))/24):RETURN
'330 ' Check routines
'340 S1=(X-5)/20:S2=(Y)/24:IFS(S1,S2)=1THENB(0)=X-5:B(1)=Y+2:B(2)=2:S(S1,S2)=2:T1=T1+1:IFT=T1THENZ=1:Y1=Y:RETURN:ELSERETURN
'350 IF S(S1,S2)=0THENFORB=0TO1:IFD(B,0)-10<XANDD(B,0)+10>XANDD(B,1)-10<YANDD(B,1)+10>YANDD(B,4)<>-1THEND(B,4)=D(B,7):D=11:XX=USR(10):RETURNELSENEXTB:L=L-1:Z=150:XX=USR(8):RETURNELSERETURN
'355 IFZ>99THEN356ELSED=10:Z=Z+1:Y=(-J(ZMOD10)*2)+Y1:D=10*-(Z<50):GOSUB190:IFZ=51THENZ=0:RETURN70ELSERETURN:'als alles gesprongen is.
'356 IFZ=150THENGOTO358ELSEGOSUB190:GOSUB357:Z=Z+1:IFZ=105THENXX=USR(255):RETURNELSEIFZ=125THENW=W-10:GOSUB101:W=W+10:Z=0:X=X2:Y=Y2:D=0:A=0:RETURNELSERETURN
'357 COPY(0,151)-STEP(44,21),1TO(X-20,Y-22),,TPSET:P(12,P1)=X-20:P(12,P1+1)=Y-22:RETURN
'358 Y=Y+5:X=X+X1:D=10:GOSUB190:COPY(X-2,Y-3)-STEP(30,30),3TO(X-2,Y-3),,TPSET:IFY>190THENZ=0:W=W-12:GOSUB100:W=W+10:RETURNELSERETURN
'360 ' Check Hit q-bert with monster
'370 IFZ=0ANDD(0,4)<1ANDD(1,4)<1ANDM(S,3)>0ANDX-5<M(S,0)ANDX+5>M(S,0)ANDY-5<M(S,1)ANDY+5>M(S,1)THENL=L-1:Z=100:RETURNELSERETURN
'399 '
'400 '                               Disk
'401 '
'410 IFD(B,4)=-1THENRETURNELSEIFD(B,4)=0THENGOSUB430:RETURNELSED=11:D(B,5)=(((D(B,7)+1-D(B,4))/D(B,7))*(D(B,2)-D(B,0)))+D(B,0):D(B,6)=(((D(B,7)+1-D(B,4))/D(B,7))*(D(B,3)-D(B,1)))+D(B,1):D(B,4)=D(B,4)-1
'420 GOSUB430:X=D(B,5):Y=D(B,6):GOSUB190:IFD(B,4)=0THENX2=X:Y2=Y:D=0:D(B,4)=-1:GOTO340ELSERETURN
'430 POKE&HFAA0,3:Y9=(USR1(&HB900+Y8)-5)*-(D(B,4)=0)*((B=0)+B):POKE&HFAA0,5:Y8=(Y8+1)MOD32:COPY(0,95)-STEP(13,13),1TO(D(B,5)-2,D(B,6)+7+Y9),,TPSET:P(9+B,P1)=D(B,5)-2:P(9+B,P1+1)=D(B,6)+7+Y9:RETURN
'440 '
'450 '                     Amount of life remaining
'460 '
'470 L=L*-(L>0):COPY(0,120)-STEP(22,16),1TO(20+T7-100,T8-127),,TPSET:COPY(L*8,109)-STEP(7,10),1TO(45+T7-100,T8-127+5),,TPSET:P(11,P1)=20+T7-100:P(11,P1+1)=T8-127:RETURN


