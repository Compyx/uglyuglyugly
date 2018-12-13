# vim: set noet ts=8 sw=8 sts=8:
#

ASM = 64tass
AFLAGS = -C -a

TARGET = uglyuglyugly.prg

$(TARGET): main.s sprites3.bin sprites5.bin
	$(ASM) $(AFLAGS) main.s -o $(TARGET)

all: $(TARGET)

