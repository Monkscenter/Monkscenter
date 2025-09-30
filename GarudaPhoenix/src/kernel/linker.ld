ENTRY(_start)

SECTIONS
{
  /* Link the kernel at 1 MiB */
  . = 0x00100000;

  .text :
  {
    *(.text*)
    *(.rodata*)
  }

  .data :
  {
    *(.data*)
  }

  .bss :
  {
    __bss_start = .;
    *(.bss*)
    __bss_end = .;
  }

  /DISCARD/ : { *(.eh_frame) }
}