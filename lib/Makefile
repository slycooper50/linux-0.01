#
# Makefile for some libs needed in the kernel.
#
# Note! Dependencies are done automagically by 'make dep', which also
# removes any old dependencies. DON'T put your own dependencies here
# unless it's something special (ie not a .c file).
#

AR	=/home/slycooper/Desktop/Github/lnx/binutils-1.9/installation/usr/local/gnubin/ar
AS	=/home/slycooper/Desktop/Github/lnx/gas-1.38/installation/gas
LD	=/home/slycooper/Desktop/Github/lnx/binutils-1.9/installation/usr/local/gnubin/ld
GCCLIB	=/home/slycooper/Desktop/Github/lnx/gcc-1.42/installation/usr/local/lib/gcc-
CC	=/home/slycooper/Desktop/Github/lnx/gcc-1.42/installation/usr/local/bin/gcc -B$(GCCLIB)
CFLAGS	=-g -Wall -O -fstrength-reduce -fomit-frame-pointer -fcombine-regs \
	-finline-functions -nostdinc -I../include
CPP	=$(CC) -E -nostdinc -I../include

.c.s:
	$(CC) $(CFLAGS) \
	-S -o $*.s $<
.s.o:
	$(AS) -c -o $*.o $<
.c.o:
	$(CC) $(CFLAGS) \
	-c -o $*.o $<

OBJS  = ctype.o _exit.o open.o close.o errno.o write.o dup.o setsid.o \
	execve.o wait.o string.o

lib.a: $(OBJS)
	$(AR) rcs lib.a $(OBJS)
	sync

clean:
	rm -f core *.o *.a tmp_make
	for i in *.c;do rm -f `basename $$i .c`.s;done

dep:
	sed '/\#\#\# Dependencies/q' < Makefile > tmp_make
	(for i in *.c;do echo -n `echo $$i | sed 's,\.c,\.s,'`" "; \
		$(CPP) -M $$i;done) >> tmp_make
	cp tmp_make Makefile

### Dependencies:
