CC=matlab-mex -O

.PHONY : all
all : sfun_time

sfun_time: sfun_time.c
	$(CC) sfun_time.c

.PHONY: clean

clean:
	rm -f $(ODIR)/*.o *~ core $(INCDIR)/*
