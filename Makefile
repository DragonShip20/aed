AS=nasm
LD=ld

ASMFLAGS=-f elf64

SRC=aed.asm
OBJ=aed.o
OUT=aed

$(OBJ): $(SRC)
	@$(AS) $(ASMFLAGS) $(SRC) -o $(OBJ)
	@echo Compiled ASM files.

$(OUT): $(OBJ)
	@$(LD) $(OBJ) -o $(OUT)
	@echo Compiled with success.

run: $(OUT)
	@echo Starting program.
	@./$(OUT)

clean:
	@rm -rf $(OBJ) $(OUT)
	@echo Cleaned all output files.
