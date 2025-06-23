# FLUBBER IN THE UPSIDE DOWN WORLD (v1.2)
Flubber is a side-scrolling bouncing ball game where the goal is to get through an obstacle course and reach the finish flag in less than a minute.

You can jump over obstacles by pressing up (small jump) or space (big jump). There is an inverted version of flubber that will mirror all movements of the original with a slight delay. Furthermore, the lower world will have a different path than the upper one.

You will earn 10 points for every second remaining at the end of each successfully completed level. For every 1000 points earned, you will gain 1 new life. Also, when time runs out or you touch a blade, you will lose 1 life.

While playing the game, you can also press ESC to PAUSE/EXIT the game or press "M" to turn the music on/off.

There are a total of 15 fixed levels in the game, each with increasing difficulty from the previous one.

Written in MSX Basic from scratch (~587 lines of code) and compiled using MSXBAS2ROM compiler, this is a MSX1 compatible single player game (standard ROM BASIC required). Joysticks are recommended, but not required.

Good Luck!

## Game info

* Created by Amaury Carvalho (2021-2023);
* All songs are variations of Perez Prado's Mambos;
* Published on [MSXDEV23](https://www.msxdev.org/2023/06/07/msxdev23-08-flubber-in-the-upside-down-world/);
* ExecROM is not compatible with this 48kb ROM type, so use SofaRUN or [ODO](http://msxbanzai.tni.nl/dev/software.html) to load this game from MSX-DOS.

## History

* 1.2 Speed fix on 50hz machines;
* 1.1 Graphics and game over mechanics improvements;
* 1.0 Initial release.

## Source code

### Compiling

````
       msxbas2rom flubber.bas
````

### Running online

* [Game emulation via WebMSX](http://webmsx.org/?rom=https://raw.githubusercontent.com/amaurycarvalho/msxbasic/main/Flubber/flubber.rom)

### Repository

* [Source code on Github](https://github.com/amaurycarvalho/msxbasic/tree/main/Flubber)

## Development tools

* [MSXBAS2ROM](https://github.com/amaurycarvalho/msxbas2rom/)
* [Arkos Tracker 3](https://julien-nevo.com/at3test/index.php/download/)
* [MSX Screen Converter](https://msx.jannone.org/conv/)
* [MSX Tiny Sprite](https://msx.jannone.org/tinysprite/tinysprite.html)
* [nMSXTiles for Linux](https://launchpad.net/nmsxtiles)
* [nMSXTiles for Windows](https://github.com/pipagerardo/nMSXtiles)

### Footnotes

* MSXBAS2ROM is a command line tool, so you need to use a terminal shell on your PC to compile these projects;
* All .BAS files are in plain text format, so they can be opened by any text editor;
* .SCn are MSX BASIC "BSAVE,S" native binary format screen files exported from [MSX Screen Converter](https://msx.jannone.org/conv/);
* .SPR files are in plain text format and can be opened by any text editor and edited by [Tiny Sprite](https://msx.jannone.org/tinysprite/tinysprite.html) as well;
* .AKS files are [Arkos Tracker 3](https://julien-nevo.com/at3test/index.php/download/) projects;
* .AKM files are songs exported by Arkos Tracker 3 in minimalist format;
* .AKX files are sound effects exported by Arkos Tracker 3;
* You can find a MSXBAS2ROM reference guide [here](https://github.com/amaurycarvalho/msxbas2rom/wiki).


