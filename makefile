ifeq ($(TARGET),)
TARGET=cuda
endif

LIBS=-lm
ifeq ($(TARGET),cuda)
CC=nvcc
CFLAGS=-Xptxas -O3
LIBS+=-lcuda -lcudart -lnvrtc
else
CC=gcc
CFLAGS=-std=gnu11 -O3 -Wall -Wextra -g -fsanitize=leak -fsanitize=undefined
ifeq ($(TARGET),opencl)
	LIBS+=-lOpenCL 
endif
endif

.PHONY=sync clean 

example: Ciphers/example.o Ciphers/ciphers.o
	$(CC) $(CFLAGS) $(notdir $^) -o $@ $(LIBS)

sync:
	#futhark pkg sync

%.c: %.fut sync
	futhark $(TARGET) --library $< -o $(@:%.c=%)

%.o: %.c
	$(CC) -c $(CFLAGS) $^


clean:
	rm -vf *.o Ciphers/ciphers.c test_aes