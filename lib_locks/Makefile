.SUFFIXES:

TARGET ?= vx4a

.PHONY: liblocks
liblocks: lib/$(TARGET)/liblocks.a

.PHONY: clean
clean:
	rm -rf build

.PHONY: all
all: liblocks

include $(wildcard build/*/*.d)

OBJECTS := \
	hwlock.o \
	swlock.o \
	swlock_asm.o

build/$(TARGET):
	mkdir -p $@

lib/$(TARGET):
	mkdir -p $@

lib/$(TARGET)/liblocks.a : $(addprefix build/$(TARGET)/,$(OBJECTS)) | lib/$(TARGET)
	xmosar rcs $@ $^

.SECONDARY: build/$(TARGET)/%.o
build/$(TARGET)/%.o : src/%.c | build/$(TARGET)
	xcc -c $< -o $@ -march=$(TARGET) -Os -ffunction-sections -Wall -Werror -report -I../lib_locks/api -MD -MF $|/$*.d

.SECONDARY: build/$(TARGET)/%.o
build/$(TARGET)/%.o : src/%.S | build/$(TARGET)
	xcc -c $< -o $@ -march=$(TARGET) -Os -ffunction-sections -Wall -Werror -report -I../lib_locks/api -MD -MF $|/$*.d
