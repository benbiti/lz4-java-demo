CC=gcc
CFLAGS=-I. -std=c99 -Wall -W -Wundef -Wno-implicit-function-declaration

OS := $(shell uname)
ifeq ($(OS),Linux)
EXT =
else
EXT =.exe
endif

# Version numbers

DESTDIR?=
PREFIX ?= .
CFLAGS ?= -O3
CFLAGS += -I. -std=c99 -Wall -Wextra -Wundef -Wshadow -Wcast-align -Wcast-qual -Wstrict-prototypes -pedantic -DXXH_NAMESPACE=LZ4_

LIBDIR?= $(PREFIX)/lib
INCLUDEDIR=$(PREFIX)/include


# OS X linker doesn't support -soname, and use different extension
# see : https://developer.apple.com/library/mac/documentation/DeveloperTools/Conceptual/DynamicLibraries/100-Articles/DynamicLibraryDesignGuidelines.html
ifeq ($(shell uname), Darwin)
	SHARED_EXT = dylib
	SHARED_EXT_MAJOR = $(SHARED_EXT)
	SHARED_EXT_VER = $(SHARED_EXT)
	SONAME_FLAGS = -install_name $(PREFIX)/lib/liblz4.$(SHARED_EXT_MAJOR)
else
	SONAME_FLAGS = -Wl,-soname=liblz4.$(SHARED_EXT)
	SHARED_EXT = so
	SHARED_EXT_MAJOR = $(SHARED_EXT)
	SHARED_EXT_VER = $(SHARED_EXT)
endif

default: liblz4

all: liblz4

liblz4: lz4.c
	@echo compiling static library
	@$(CC) $(CPPFLAGS) $(CFLAGS) -c $^
	@$(AR) rcs liblz4.a lz4.o
	@echo compiling dynamic library $(LIBVER)
	@$(CC) $(CPPFLAGS) $(CFLAGS) $(LDFLAGS) -shared $^ -fPIC $(SONAME_FLAGS) -o $@.$(SHARED_EXT_VER)
	
clean:
	rm -f  *.o liblz4.*
