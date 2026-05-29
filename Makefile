AS=nasm
LD=ld

ASMFLAGS=-f elf64

SRC := $(wildcard *.asm)
OBJ := $(SRC:.asm=.o)
OUT=aed

all: build

%.o: %.asm
	@$(AS) $(ASMFLAGS) $< -o $@
	@echo Compiled ASM files.

$(OUT): $(OBJ)
	@$(LD) $(OBJ) -o $(OUT)

build: $(OUT)
	@echo Compiled with success.

run: $(OUT)
	@echo Starting program...
	@./$(OUT)

clean:
	@rm -rf $(OBJ) $(OUT)
	@echo Cleaned all output files.
