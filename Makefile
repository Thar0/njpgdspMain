COMPARE ?= 1

ARMIPS = armips

OBJCOPY := objcopy

CXX := g++
CXXFLAGS := -Wall -Wextra -pedantic -Wno-unused-parameter -I. -O2 -g -s -std=c++17 -fno-rtti -pipe
LDFLAGS := -pthread

all: $(ARMIPS) njpgdspMain.o
.PHONY: clean distclean

clean:
	$(RM) njpgdspMain.text.bin njpgdspMain.rodata.bin njpgdspMain.o

distclean: clean
	$(RM) $(ARMIPS)

$(ARMIPS): armips.cpp
	$(CXX) $(CXXFLAGS) $< -o $@ $(LDFLAGS)

njpgdspMain.o: njpgdspMain.s | $(ARMIPS)
# assemble to .text and .rodata binaries
	./$(ARMIPS) -strequ CODE_FILE $(@:.o=.text.bin) -strequ DATA_FILE $(@:.o=.rodata.bin) $<
# make non-empty file
	echo \0 > $@
# convert to elf
	$(OBJCOPY) -I binary -O elf32-big $@
# add text and rodata sections
	$(OBJCOPY) -I elf32-big -O elf32-big --add-section .text=$(@:.o=.text.bin) --set-section-flags .text=alloc,code,contents,load,readonly $@
	$(OBJCOPY) -I elf32-big -O elf32-big --add-section .rodata=$(@:.o=.rodata.bin) --set-section-flags .rodata=alloc,contents,load,readonly $@
# remove dummy data section and symbol
	$(OBJCOPY) -I elf32-big -O elf32-big --remove-section .data --strip-symbol _binary_$(@:.o=)_o_size $@
# add start/end symbols
	$(OBJCOPY) -I elf32-big -O elf32-big --add-symbol $(@:.o=)TextStart=.text:0,global $@
	$(OBJCOPY) -I elf32-big -O elf32-big --add-symbol $(@:.o=)TextEnd=.text:$$(du -b $(@:.o=.text.bin) | cut -f1),global $@
	$(OBJCOPY) -I elf32-big -O elf32-big --add-symbol $(@:.o=)DataStart=.rodata:0,global $@
	$(OBJCOPY) -I elf32-big -O elf32-big --add-symbol $(@:.o=)DataEnd=.rodata:$$(du -b $(@:.o=.rodata.bin) | cut -f1),global $@
ifeq ($(COMPARE),1)
	@md5sum $(@:.o=.text.bin)
	@md5sum -c $(@:.o=.text.md5)
	@md5sum $(@:.o=.rodata.bin)
	@md5sum -c $(@:.o=.rodata.md5)
endif
