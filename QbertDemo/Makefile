# MSXBAS2ROM Project Makefile

BAS := $(firstword $(wildcard *.bas))
BASE := $(basename $(BAS))

COMPILER := msxbas2rom
EMULATOR := flatpak run org.openmsx.openMSX

ROM := $(firstword $(wildcard $(BASE)*.rom))
NOI := $(BASE).noi

.PHONY: all clean run test

all:
	$(COMPILER) $(BAS) -x -s

run: all 
	@ROM_FILE=$$(ls $(BASE)*.rom | head -n 1); \
	echo "Running $$ROM_FILE"; \
	exec $(EMULATOR) -cart $$ROM_FILE

test: all
	@ROM_FILE=$$(ls $(BASE)*.rom | head -n 1); \
	echo "Debugging $$ROM_FILE"; \
	exec $(EMULATOR) -cart $$ROM_FILE -script debug.tcl

clean:
	rm -f *.rom *.noi *.omds *.symbol *.cdb