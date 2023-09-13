PKG_NAME=ch32v203_blink
BIN_NAME=firmware.bin

SRC=main.zig
INIT=init.S
LINKER_SCRIPT=ch32v.ld

# -flto removes busy loop
all:
	zig build-exe -fstrip -fsingle-threaded \
		-target riscv32-freestanding \
		-mcpu=baseline_rv32-d \
		-Dopitimze=ReleaseSmall \
		--name ${PKG_NAME}.elf \
		--script $(LINKER_SCRIPT) \
		$(SRC) $(INIT) && \
	rm ${PKG_NAME}.elf.o && \
	riscv64-unknown-elf-objcopy -O binary ${PKG_NAME}.elf ${BIN_NAME} && \
	riscv64-unknown-elf-objdump --disassemble-all ${PKG_NAME}.elf > ${PKG_NAME}.s

flash: all
	wchisp flash ${BIN_NAME}

clean:
	rm -r ${BIN_NAME} ${PKG_NAME}.elf
