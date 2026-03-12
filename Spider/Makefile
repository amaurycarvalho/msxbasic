# MSXBAS2ROM Project Makefile

BAS := $(firstword $(wildcard *.bas))
BASE := $(basename $(BAS))

COMPILER := msxbas2rom
EMULATOR := openmsx

ROM := $(firstword $(wildcard $(BASE)*.rom))
NOI := $(BASE).noi

.PHONY: all clean test

all:
	$(COMPILER) $(BAS) -x -s

test:
	@ROM_FILE=$$(ls $(BASE)*.rom | head -n 1); \
	echo "Running $$ROM_FILE"; \
	$(EMULATOR) -cart $$ROM_FILE -script debug.tcl

clean:
	rm -f *.rom *.noi *.omds *.symbol *.cdb