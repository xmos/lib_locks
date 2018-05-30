TARGET ?= xs2a

CFLAGS = -Iapi -Os -Wall -march=$(TARGET)
LIBLOCKS_OBJ = $(TARGET)/hwlock.o $(TARGET)/swlock_asm.o $(TARGET)/swlock.o

VPATH = src

all: $(TARGET) $(TARGET)/liblocks.a

$(TARGET)/%.o : %.c
	xcc $(CFLAGS) -c $< -o $@

$(TARGET)/%.o : %.xc
	xcc $(CFLAGS) -c $< -o $@

$(TARGET)/%.o : %.s
	xcc $(CFLAGS) -c $< -o $@

$(TARGET)/%.o : %.S
	xcc $(CFLAGS) -c $< -o $@

$(TARGET)/liblocks.a : $(LIBLOCKS_OBJ)
	ar rvu $(TARGET)/liblocks.a $(LIBLOCKS_OBJ)

clean:
	rm -f $(TARGET)/*.o $(TARGET)/*.a

$(TARGET):
	mkdir $(TARGET)
