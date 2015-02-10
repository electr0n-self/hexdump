BUFSIZE equ 16

section	.text
	global _start       ;must be declared for using gcc
_start: ;tell linker entry point

ReadBuff:
	mov	edx, BUFSIZE    ;message length
	mov	ecx, Buff    ;message to write
	mov	ebx, 0	    ;file descriptor (stdout)
	mov	eax, 3	    ;system call number (sys_write)
	int	0x80        ;call kernel
    
    mov edx, eax    ; number of chars read
    cmp edx, 0  ; EOF
    JE EndProgram
    
ConvLine:
   xor edi, edi ; reset buffer index
   xor esi, esi ; reset hexline index
    
CharToHex:   
    xor eax, eax    ; zero-fill eax
    mov al, byte [Buff+edi]
    mov ebx, eax    ; copy char to ebx
    and al, 0FH     ; mask out LSBs
    mov al, [HexChars+eax]
    mov [HexLine+1+esi], al
    
    and bl, 0F0H    ; mask out MSBs
    shr ebx, 4
    mov bl , [HexChars+ebx]
    mov [HexLine+esi], bl 
    
    inc edi     ; next Buff char
    add esi, 3  ; next HexLine char
    cmp edi, edx ; test if last char was reached
    JB CharToHex    ; convert next char

PrintLine:
	mov	edx, 48    ;message length
	mov	ecx, HexLine    ;message to write
	mov	ebx, 1	    ;file descriptor (stdout)
	mov	eax, 4	    ;system call number (sys_write)
	int	0x80        ;call kernel
    
    jmp ReadBuff

EndProgram:
	mov	eax, 1	    ;system call number (sys_exit)
	int	0x80        ;call kernel




section .data

HexChars db "0123456789ABCDEF"
HexLine db "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00", 0AH

section	.bss

Buff: resb BUFSIZE  ;our dear string

