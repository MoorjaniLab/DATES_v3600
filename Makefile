HOMEL=$(PWD)    
BIN=$(HOMEL)//bin
IDIR=-I.   -Inicksrc

ND = ./nicksrc
NLIB = $(ND)/libnick.a

override LDLIBS +=  -lm -lgsl -lopenblas -lfftw3 $(NLIB)  
override CFLAGS += -c -g -p -Wimplicit  $(IDIR)  

## Harvard O2 
ifdef SLURM_CONF
override CFLAGS += -I/user/bin/openblas/0.2.19/include -I/user/bin/gsl/2.3/include -I/user/bin/fftw/3.3.7/include
override LDFLAGS += -L/user/bin/openblas/0.2.19/lib -L/user/bin/gsl/2.3/lib/  -L/user/bin/fftw/3.3.7/lib
endif

override CFLAGS += -DHAVE_CONFIG_H -Wimplicit-int -D_IOLIB=2

all:   dates_expfit dates simpjack2 dowtjack grabpars

$(NLIB): 
	$(MAKE) -C $(ND) 

dates_expfit:    $(NLIB) dates_expfit.o   regsubs.o  fitexp.o   gslfit.o
dates: $(NLIB) dates.o qpsubs.o mcio.o ldsubs.o admutils.o egsubs.o regsubs.o fftsubs.o
dowtjack: $(NLIB) dowtjack.o
simpjack2: $(NLIB) simpjack2.o 
grabpars: $(NLIB) grabpars.o 

clean:  
	rm -f  *.o  nicksrc/*.o nicklib

clobber:  clean
	rm -f  dates_expfit dates simpjack2 dowtjack nicksrc/libnick.a bin/*

install: all
	cp dates_expfit dates grabpars simpjack2 dowtjack perlsrc/*  ./bin/.

