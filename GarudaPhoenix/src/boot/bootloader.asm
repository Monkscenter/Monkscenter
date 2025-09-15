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
    
    mov si, tagline_msg
    call print_string
    
    mov si, loading_msg
    call print_string
    
    ; Simple loading animation
    mov cx, 5           ; Show 5 dots
loading_loop:
    mov si, dot_msg
    call print_string
    call delay
    loop loading_loop
    
    mov si, newline
    call print_string
    
    mov si, success_msg
    call print_string
    
    ; System is "running" - infinite loop (for now)
    jmp $

; Function: Print string
; Input: SI = pointer to null-terminated string
print_string:
    pusha               ; Save all registers
.loop:
    lodsb               ; Load byte from SI into AL, increment SI
    cmp al, 0           ; Check if end of string
    je .done
    mov ah, 0x0e        ; BIOS teletype function
    mov bx, 0x0007      ; Page 0, light gray on black
    int 0x10            ; BIOS video interrupt
    jmp .loop
.done:
    popa                ; Restore all registers
    ret

; Simple delay function
delay:
    pusha
    mov cx, 0xffff      ; Delay counter
.delay_loop:
    nop
    loop .delay_loop
    popa
    ret

; Our epic boot messages
welcome_msg db '                    *** GARUDAPHOENIX OS ***', 0x0d, 0x0a
            db '                  Rise. Transform. Soar.', 0x0d, 0x0a, 0x0d, 0x0a, 0

tagline_msg db 'From the ashes of legacy systems, a new OS is born!', 0x0d, 0x0a
            db 'Powered by the wings of Garuda, reborn like the Phoenix.', 0x0d, 0x0a, 0x0d, 0x0a, 0

loading_msg db 'Initializing GarudaPhoenix Core', 0

dot_msg     db '.', 0
newline     db 0x0d, 0x0a, 0
success_msg db 0x0d, 0x0a, 'GarudaPhoenix OS - First Boot Successful! ', 0x0d, 0x0a
            db 'The Phoenix has risen! The Garuda soars!', 0x0d, 0x0a
            db 'System ready for kernel initialization...', 0x0d, 0x0a, 0

; Boot sector signature (REQUIRED - tells BIOS this is bootable)
times 510-($-$$) db 0   ; Pad with zeros to byte 510
dw 0xaa55               ; Boot signature (magic number)