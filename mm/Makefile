GCCLIB	=/home/slycooper/Desktop/Github/lnx/gcc-1.42/installation/usr/local/lib/gcc-
CC	=/home/slycooper/Desktop/Github/lnx/gcc-1.42/installation/usr/local/bin/gcc -B$(GCCLIB)
CFLAGS	=-g -O -Wall -fstrength-reduce -fcombine-regs -fomit-frame-pointer \
	-finline-functions -nostdinc -I../include
AS	=/home/slycooper/Desktop/Github/lnx/gas-1.38/installation/gas
AR	=/home/slycooper/Desktop/Github/lnx/binutils-1.9/installation/usr/local/gnubin/ar
LD	=/home/slycooper/Desktop/Github/lnx/binutils-1.9/installation/usr/local/gnubin/ld
CPP	=$(CC) -E -nostdinc -I../include

.c.o:
	$(CC) $(CFLAGS) \
	-c -o $*.o $<
.s.o:
	$(AS) -o $*.o $<
.c.s:
	$(CC) $(CFLAGS) \
	-S -o $*.s $<

OBJS	= memory.o page.o

all: mm.o

mm.o: $(OBJS)
	$(LD) -r -o mm.o $(OBJS)

clean:
	rm -f core *.o *.a tmp_make
	for i in *.c;do rm -f `basename $$i .c`.s;done

dep:
	sed '/\#\#\# Dependencies/q' < Makefile > tmp_make
	(for i in *.c;do $(CPP) -M $$i;done) >> tmp_make
	cp tmp_make Makefile

### Dependencies:
memory.o : memory.c ../include/signal.h ../include/sys/types.h \
  ../include/linux/config.h ../include/linux/head.h ../include/linux/kernel.h \
  ../include/asm/system.h 
