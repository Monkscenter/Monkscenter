#include <stdint.h>

volatile uint16_t *vga = (uint16_t *)0xB8000;

static inline void putchar_at(char c, int pos) {
    vga[pos] = (uint16_t)c | ((uint16_t)0x07 << 8); /* light gray on black */
}

void kmain(void) {
    const char *msg = "Welcome to GarudaPhoenix x86_64 Kernel!";
    for (int i = 0; msg[i]; ++i) putchar_at(msg[i], i);
    /* Halt the CPU in an infinite loop */
    for (;;) __asm__ volatile("hlt");
}