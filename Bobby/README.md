# BOBBY IS STILL GOING HOME
Game demo source code written in MSX BASIC to be compiled with MSXBAS2ROM compiler

## Game info

* Bobby is Going Home is a platform game released for the Atari 2600 console in 1983;
* This remake for MSX systems was developed by Amaury Carvalho (2025);

### References

* [Wikipedia](https://en.wikipedia.org/wiki/Bobby_is_Going_Home);
* [Game Review](https://www.rfgeneration.com/news/2600/Banana-s-Rotten-Reviews-Bobby-Is-Going-Home-3473.php);
* [Original Atari 2600 version emulation](https://www.retrogames.cz/play_192-Atari2600.php).

## Source code

### Compiling

````
       msxbas2rom -x bobby.bas
````

### Running online

* [Game emulation via WebMSX](http://webmsx.org/?rom=https://raw.githubusercontent.com/amaurycarvalho/msxbasic/main/Bobby/bobby%5BKonamiSCC%5D.rom)

### Repository

* [Source code on Github](https://github.com/amaurycarvalho/msxbasic/tree/main/Bobby)

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


