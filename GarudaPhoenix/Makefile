# GarudaPhoenix OS Build System
# "Rise. Transform. Soar."

# Directories
SRC_DIR := src
KERNEL_DIR := $(SRC_DIR)/kernel
BUILD_DIR := build
ISO_DIR := $(BUILD_DIR)/iso
GRUB_DIR := $(ISO_DIR)/boot/grub

# Tools
CC := gcc
LD := ld
AS := gcc
QEMU := qemu-system-x86_64
GRUB_MKRESCUE := grub-mkrescue
XORRISO := xorriso

# Flags
CFLAGS := -m64 -ffreestanding -O2 -g -fno-builtin -fno-stack-protector -Wall -Wextra
LDFLAGS := -nostdlib
LDF_SCRIPT := $(KERNEL_DIR)/linker.ld

# Targets
KERNEL_OBJ := $(BUILD_DIR)/kernel.o $(BUILD_DIR)/entry.o
KERNEL_ELF := $(BUILD_DIR)/kernel.elf
ISO := $(BUILD_DIR)/garudaphoenix.iso

.PHONY: all clean setup iso run

# Default target
all: setup $(KERNEL_ELF) iso
	@echo "✅ GarudaPhoenix x86_64 built: $(ISO)"

# Create build directories
setup:
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(GRUB_DIR)

$(BUILD_DIR)/kernel.o: $(KERNEL_DIR)/kernel.c
	@echo "🔧 Compiling kernel.c"
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/entry.o: $(KERNEL_DIR)/entry.S
	@echo "🔧 Assembling entry.S"
	$(AS) $(CFLAGS) -c $< -o $@

$(KERNEL_ELF): $(KERNEL_OBJ)
	@echo "🔗 Linking kernel ELF"
	$(LD) $(LDFLAGS) -T $(LDF_SCRIPT) -o $@ $(KERNEL_OBJ)

iso: $(KERNEL_ELF)
	@echo "📦 Building ISO with GRUB"
	cp $(KERNEL_ELF) $(ISO_DIR)/boot/kernel.elf
	cat > $(GRUB_DIR)/grub.cfg <<EOF
set timeout=3
set default=0
menuentry "GarudaPhoenix x86_64" {
    insmod elf
    multiboot2 /boot/kernel.elf
    boot
}
EOF
	$(GRUB_MKRESCUE) -o $(ISO) $(ISO_DIR) 2>/dev/null || (echo "grub-mkrescue failed — ensure grub and xorriso are installed" && false)
	@echo "✅ ISO created: $(ISO)"

# Test in QEMU
run: iso
	@echo "🚀 Booting ISO in QEMU"
	$(QEMU) -cdrom $(ISO) -m 512M

# Clean build files
clean:
	@echo "🧹 Cleaning build"
	rm -rf $(BUILD_DIR)