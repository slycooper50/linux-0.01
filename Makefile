#
# Makefile for linux.
# If you don't have '-mstring-insns' in your gcc (and nobody but me has :-)
# remove them from the CFLAGS defines.
#

AS86	=/home/slycooper/Desktop/Github/lnx/dev86/installation/bin/as86 -a -0 
CC86	=/home/slycooper/Desktop/Github/lnx/dev86/installation/bin/bcc -0
LD86	=/home/slycooper/Desktop/Github/lnx/dev86/installation/bin/ld86 -s -0

AS	=/home/slycooper/Desktop/Github/lnx/gas-1.38/installation/gas
LD	=/home/slycooper/Desktop/Github/lnx/binutils-1.9/installation/usr/local/gnubin/ld
LDFLAGS	=-M
GCCLIB	=/home/slycooper/Desktop/Github/lnx/gcc-1.42/installation/usr/local/lib/gcc-
CC	=/home/slycooper/Desktop/Github/lnx/gcc-1.42/installation/usr/local/bin/gcc -B$(GCCLIB)
CFLAGS	= -g -Wall -O -fstrength-reduce -fomit-frame-pointer -fcombine-regs
CPP	=$(CC) -E -nostdinc -Iinclude
HOSTCC = gcc -m32

ARCHIVES=kernel/kernel.o mm/mm.o fs/fs.o
LIBS	=lib/lib.a

.c.s:
	$(CC) $(CFLAGS) \
	-nostdinc -Iinclude -S -o $*.s $<
.s.o:
	$(AS) -c -o $*.o $<
.c.o:
	$(CC) $(CFLAGS) \
	-nostdinc -Iinclude -c -o $*.o $<

all:	Image

Image: boot/boot tools/system tools/build
	tools/build boot/boot tools/system > Image
	sync

tools/build: tools/build.c
	$(HOSTCC) \
	-o tools/build tools/build.c

boot/head.o: boot/head.s

tools/system:	boot/head.o init/main.o \
		$(ARCHIVES) $(LIBS)
	$(LD) $(LDFLAGS) boot/head.o init/main.o \
	$(ARCHIVES) \
	$(LIBS) \
	-o tools/system > System.map

kernel/kernel.o:
	(cd kernel; make)

mm/mm.o:
	(cd mm; make)

fs/fs.o:
	(cd fs; make)

lib/lib.a:
	(cd lib; make)

boot/boot:	boot/boot.s tools/system
	(echo -n "SYSSIZE=[";stat -c %s tools/system \
		 | tr -d '\012';  echo "+15]/16") > tmp.s
	sed -e 's/|/!/g' -e '/\/\*/,/\*\//d' boot/boot.s >> tmp.s
	$(AS86) -o boot/boot.o tmp.s
	rm -f tmp.s
	$(LD86) -o boot/boot boot/boot.o

clean:
	rm -f Image System.map tmp_make boot/boot core
	rm -f init/*.o boot/*.o tools/system tools/build
	(cd mm;make clean)
	(cd fs;make clean)
	(cd kernel;make clean)
	(cd lib;make clean)

backup: clean
	(cd .. ; tar cf - linux | compress16 - > backup.Z)
	sync

dep:
	sed '/\#\#\# Dependencies/q' < Makefile > tmp_make
	(for i in init/*.c;do echo -n "init/";$(CPP) -M $$i;done) >> tmp_make
	cp tmp_make Makefile
	(cd fs; make dep)
	(cd kernel; make dep)
	(cd mm; make dep)

### Dependencies:
init/main.o : init/main.c include/unistd.h include/sys/stat.h \
  include/sys/types.h include/sys/times.h include/sys/utsname.h \
  include/utime.h include/time.h include/linux/tty.h include/termios.h \
  include/linux/sched.h include/linux/head.h include/linux/fs.h \
  include/linux/mm.h include/asm/system.h include/asm/io.h include/stddef.h \
  include/stdarg.h include/fcntl.h 
