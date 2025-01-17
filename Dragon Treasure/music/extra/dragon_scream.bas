1 REM https://marmsx.msxall.com/projetos/dsg/index.php

5 SOUND 7,184
6 SOUND 8, 15
7 SOUND 9, 15
8 SOUND 10, 15
10 C% = 0
20 FOR I = 100 TO 800 STEP 100
30     F = 1789772 / (16 * I)
40     L% = F AND 255
50     H% = F MOD 255
60     SOUND C%*2, L% 
70     SOUND C%*2+1, H%
80     T = TIME
90     IF (TIME - T) < 5 THEN 90
100    C% = C% + 1
110    IF C% > 2 THEN C% = 0
120 NEXT
121     T = TIME
122     IF (TIME - T) < 60 THEN 122
130 FOR I = 0 TO 5
140    SOUND I,0
150 NEXT

