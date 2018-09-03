# To build pydcall:
#
#   make
#
# run with
#
#   ./build/pydcall

D_COMPILER=ldc2

LDMD=ldmd2

DUB_LIBS =

DFLAGS = -wi -I./source $(DUB_INCLUDE)
RPATH  =
LIBS   =
SRC    = $(wildcard source/pydcall/*.d  source/test/*.d)
IR     = $(wildcard source/pydcall/*.ll source/test/*.ll)
BC     = $(wildcard source/pydcall/*.bc source/test/*.bc)
OBJ    = $(SRC:.d=.o)
OUT    = build/pydcall

debug: DFLAGS += -O0 -g -d-debug $(RPATH) -link-debuglib $(BACKEND_FLAG) -unittest
release: DFLAGS += -O -release $(RPATH)

.PHONY:test

all: debug

build-setup:
	mkdir -p build/

ifeq ($(FORCE_DUPLICATE),1)
  DFLAGS += -d-version=FORCE_DUPLICATE
endif


default debug release profile getIR getBC gperf: $(OUT)

# ---- Compile step
%.o: %.d
	$(D_COMPILER) -shared -m64 -relocation-model=pic $(DFLAGS) -c $< -od=$(dir $@) $(BACKEND_FLAG)

# ---- Link step
$(OUT): build-setup $(OBJ)
	$(D_COMPILER) -of=build/pydcall.so -shared -m64 -relocation-model=pic $(DFLAGS)  $(OBJ) $(LIBS   =) $(DUB_LIBS) $(BACKEND_FLAG)

test:
	chmod 755 build/pydcall
	./run_tests.sh

debug-strip: debug

clean:
	rm -rf build/*
	rm -f $(OBJ) $(OUT) trace.{def,log}
