.global _start
.global kmain

.section .text
.align 16
_start:
    /* GRUB should already be in long mode when loading a 64-bit ELF.
       We simply call the C kernel entry. */
    call kmain

/* If kmain returns (it shouldn't), hang */
cli
.hang:
    hlt
    jmp .hang