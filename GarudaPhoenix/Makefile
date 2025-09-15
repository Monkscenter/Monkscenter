# GarudaPhoenix OS Build System
# "Rise. Transform. Soar."

# Directories
SRC_DIR = src
BOOT_DIR = $(SRC_DIR)/boot
BUILD_DIR = build
ISO_DIR = $(BUILD_DIR)/iso

# Tools
ASM = nasm
QEMU = qemu-system-x86_64

# Flags
ASM_FLAGS = -f bin

# Targets
BOOTLOADER = $(BUILD_DIR)/bootloader.bin
FLOPPY_IMG = $(BUILD_DIR)/garudaphoenix.img

# Colors for output
RED = \033[0;31m
GREEN = \033[0;32m
YELLOW = \033[1;33m
BLUE = \033[0;34m
PURPLE = \033[0;35m
CYAN = \033[0;36m
NC = \033[0m # No Color

.PHONY: all clean run setup test info

# Default target
all: info setup $(BOOTLOADER) $(FLOPPY_IMG)
	@echo "$(GREEN)🔥 GarudaPhoenix OS built successfully! The Phoenix is ready to rise! 🦅$(NC)"

# Show project info
info:
	@echo "$(PURPLE)╔════════════════════════════════════════╗$(NC)"
	@echo "$(PURPLE)║        GARUDAPHOENIX OS BUILD          ║$(NC)"
	@echo "$(PURPLE)║      Rise. Transform. Soar.            ║$(NC)"
	@echo "$(PURPLE)╚════════════════════════════════════════╝$(NC)"
	@echo ""

# Create build directories
setup:
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(ISO_DIR)
	@echo "$(YELLOW)📁 Build directories created$(NC)"

# Build bootloader
$(BOOTLOADER): $(BOOT_DIR)/bootloader.asm
	@echo "$(BLUE)🔧 Assembling GarudaPhoenix bootloader...$(NC)"
	$(ASM) $(ASM_FLAGS) $< -o $@
	@echo "$(GREEN)✅ Bootloader compiled: $(BOOTLOADER)$(NC)"

# Create bootable floppy image
$(FLOPPY_IMG): $(BOOTLOADER)
	@echo "$(BLUE)💾 Creating bootable floppy image...$(NC)"
	dd if=/dev/zero of=$@ bs=1024 count=1440 2>/dev/null || echo "" > $@ && truncate -s 1440K $@
	dd if=$(BOOTLOADER) of=$@ conv=notrunc 2>/dev/null
	@echo "$(GREEN)✅ Bootable image created: $(FLOPPY_IMG)$(NC)"

# Test in QEMU
run: $(FLOPPY_IMG)
	@echo "$(CYAN)🚀 Starting GarudaPhoenix in QEMU...$(NC)"
	@echo "$(YELLOW)Press Ctrl+Alt+G to release mouse, Ctrl+C to quit$(NC)"
	$(QEMU) -fda $(FLOPPY_IMG) -boot a

# Quick test (no GUI)
test: $(FLOPPY_IMG)
	@echo "$(CYAN)🧪 Testing GarudaPhoenix (no GUI)...$(NC)"
	$(QEMU) -fda $(FLOPPY_IMG) -boot a -nographic -monitor none -serial stdio

# Clean build files
clean:
	@echo "$(RED)🧹 Cleaning build files...$(NC)"
	rm -rf $(BUILD_DIR)
	@echo "$(GREEN)✅ Build directory cleaned$(NC)"

# Help target
help:
	@echo "$(PURPLE)GarudaPhoenix OS - Available targets:$(NC)"
	@echo "  $(GREEN)all$(NC)     - Build everything"
	@echo "  $(GREEN)run$(NC)     - Build and run in QEMU (with GUI)"
	@echo "  $(GREEN)test$(NC)    - Build and run in QEMU (no GUI)"
	@echo "  $(GREEN)clean$(NC)   - Clean all build files"
	@echo "  $(GREEN)help$(NC)    - Show this help"