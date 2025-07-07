.model small
.stack 100h
.data
    prevSec db 0
    time db '      00:00:00      $'

.code
main:
    mov ax, @data
    mov ds, ax

get_time:

wait_next:
    mov ah, 2Ch
    int 21h
    mov bl, dh
    cmp bl, prevSec
    je wait_next

    mov prevSec, bl

    mov ah, 01h
    int 16h
    jz continue_loop

    mov ah, 4Ch
    xor al, al
    int 21h

continue_loop:
    push cx
    push dx

    mov ax, 0600h
    mov bh, 07h
    mov cx, 0000h
    mov dx, 184Fh
    int 10h

    pop dx 
    pop cx

    mov al, ch  
    call ConvertToAscii
    mov [timeStr], ah
    mov [timeStr+1], al

    mov al, cl 
    call ConvertToAscii
    mov [timeStr+3], ah
    mov [timeStr+4], al

    mov al, dh
    call ConvertToAscii
    mov [timeStr+6], ah
    mov [timeStr+7], al

    mov ah, 02h
    mov bh, 0
    mov dh, 12
    mov dl, 30
    int 10h

    mov ah, 09h
    lea dx, timeStr
    int 21h

    jmp get_time

ConvertToAscii:
    xor ah, ah
    mov bl, 10
    div bl   
    xchg al, ah
    add al, '0'
    add ah, '0'
    ret

end main
