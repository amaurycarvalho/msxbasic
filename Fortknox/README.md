# FORTKNOX
Game demo source code written in MSX BASIC to be compiled with MSXBAS2ROM compiler

## Game info

* [FORT KNOX](https://www.msxdev.org/2025/01/31/msxdev24-30-fort-knox/) is a remake of [Bagman](https://en.wikipedia.org/wiki/Bagman_(video_game)), an arcade video game released in 1982 by the French Valadon;
* It was released as an Open source Freeware License (c) 2025 by [GAMECAST Entertainment for MSXDev24 contest](https://www.msxdev.org/2025/01/31/msxdev24-30-fort-knox/);
* Source code rewritten to be compiled with MSXBAS2ROM by Amaury Carvalho (2025).

## Source code

### Compiling

````
       msxbas2rom -x fortknox.bas
````

### Running online

* [Game emulation via WebMSX](http://webmsx.org/?rom=https://raw.githubusercontent.com/amaurycarvalho/msxbasic/main/Fortknox/fortknox[KonamiSCC].rom)

### Repository

* [Source code on Github](https://github.com/amaurycarvalho/msxbasic/Fortknox)

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


