; GarudaPhoenix OS Bootloader
; The first code that runs when the system starts
; "From ashes of old systems, GarudaPhoenix rises!"

[org 0x7c00]        ; BIOS loads us at memory address 0x7c00
[bits 16]           ; Start in 16-bit real mode (legacy compatibility)

start:
    ; Clear the screen first
    mov ax, 0x0003      ; Set video mode (clear screen)
    int 0x10            ; BIOS video interrupt
    
    ; Set up segments (memory organization)
    mov ax, 0x0000
    mov ds, ax          ; Data segment
    mov es, ax          ; Extra segment
    mov ss, ax          ; Stack segment
    mov sp, 0x7c00      ; Stack pointer (grows downward from bootloader)
    
    ; Display our epic boot message
    mov si, welcome_msg
    call print_string
    
    ; Load kernel into memory
    mov ah, 0x02        ; BIOS disk service - read sectors
    mov al, 1           ; Number of sectors to read
    mov ch, 0           ; Cylinder number (0 for first cylinder)
    mov cl, 2           ; Sector number (2, as 1 is used by the bootloader)
    mov dh, 0           ; Head number (0 for first head)
    mov dl, 0x00        ; Drive number (0x00 for first floppy disk)
    mov bx, 0x1000      ; Load address for the kernel
    int 0x13            ; Call BIOS disk service
    jc error            ; Jump to error handler if carry flag is set

    ; Transition to protected mode
    call enable_protected_mode

    ; Transition to long mode
    call enable_long_mode

    ; Jump to kernel
    jmp 0x1000

error:
    mov si, error_msg
    call print_string
    hlt

; Function: Print string
; Input: SI = pointer to null-terminated string
print_string:
    pusha               ; Save all registers
.loop:
    lodsb               ; Load byte from SI into AL, increment SI
    cmp al, 0           ; Check if end of string
    je .done
    mov ah, 0x0e        ; BIOS teletype function
    int 0x10            ; BIOS video interrupt
    jmp .loop
.done:
    popa                ; Restore all registers
    ret

enable_protected_mode:
    ; Set up GDT and enable protected mode
    ret

enable_long_mode:
    ; Set up paging and enable long mode
    ret

; Our epic boot messages
welcome_msg db '                    *** GARUDAPHOENIX OS ***', 0x0d, 0x0a
            db '                  Rise. Transform. Soar.', 0x0d, 0x0a, 0x0d, 0x0a, 0

error_msg   db 'Error: Failed to load kernel!', 0x0d, 0x0a, 0

; Boot sector signature (REQUIRED - tells BIOS this is bootable)
times 510-($-$$) db 0   ; Pad with zeros to byte 510
dw 0xaa55               ; Boot signature (magic number)

; Kernel main function (placeholder)
section .text
kernel_main:
    ; Welcome message in kernel
    mov si, kernel_msg
    call print_string
    
    ; Infinite loop (hang the system - no kernel yet)
    jmp $

; Kernel message
kernel_msg db 'Welcome to GarudaPhoenix Kernel!', 0x0d, 0x0a, 0
