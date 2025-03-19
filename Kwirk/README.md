# KWIRK
Game demo source code written in MSX BASIC to be compiled with MSXBAS2ROM compiler

## Game info

* [Kwirk](https://en.wikipedia.org/wiki/Kwirk) is a 1989 game created by Atlus and published by Acclaim for Gameboy (1990);
* Levels adapted from TI89 version created by Ludvig Strigeus and Jordan Clifford (2011);
* Remake to MSX2 created by Amaury Carvalho (2025).

## Source code

### Compiling

````
       msxbas2rom -x kwirk.bas
````

### Running online

* [Game emulation via WebMSX](http://webmsx.org/?rom=https://raw.githubusercontent.com/amaurycarvalho/msxbasic/main/Kwirk/kwirk[KonamiSCC].rom)

### Repository

* [Source code on Github](https://github.com/amaurycarvalho/msxbasic/tree/main/Kwirk)

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


