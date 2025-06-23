# PICKINX
Pickin'X is a MSX clone of the arcade game of similar name developed by Valadon Automation in 1983.

With gameplay loosely based on the original game, with notable changes in sound, graphics, maps and game rules, in this version you are the Picker and you need to get all of the like-colored blocks into their matching places while avoiding hitting the enemys (Transposer and Killer).

If you hit the Transposer, you will be captured by him until you press the joystick button (or space bar).

Hit the Killer and you will get game over immediately.

During the game the Disturber will randomly capture some blocks and move them from their original places.

Hitting the Disturber will not harm you, but it cant be stopped so pay very close attention in its moves.

You have a limited time to complete each stage (named "Act"). Complete it in time and you will get more time for the next round.

Written in MSX Basic from scratch and compiled using MSXBAS2ROM compiler, this is a MSX1 compatible single player game (standard ROM BASIC required). Joysticks are recommended, but not required.

Good Luck and have fun, Pickers!

## Game info

* [PickinX](https://www.arcade-museum.com/Videogame/pickin) is a MSX clone of the arcade game of similar name developed by Valadon Automation in 1983;
* Remake to MSX1 created by Amaury Carvalho (2021);
* Published on [MSXDEV21](https://www.msxdev.org/2021/05/16/msxdev21-15-pickinx/);
* ExecROM is not compatible with this 48kb ROM type, so use SofaRUN or [ODO](http://msxbanzai.tni.nl/dev/software.html) to load this game from MSX-DOS.

## History

* 1.2 Current release;
* 1.1 Bug fix and sound/graphics improvements;
* 1.0 MSXDEV21 release.

## Source code

### Compiling

````
       msxbas2rom pickinx.bas
````

### Running online

* [Game emulation via WebMSX](http://webmsx.org/?rom=https://raw.githubusercontent.com/amaurycarvalho/msxbasic/main/PickinX/pickinx.rom)

### Repository

* [Source code on Github](https://github.com/amaurycarvalho/msxbasic/tree/main/PickinX)

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


