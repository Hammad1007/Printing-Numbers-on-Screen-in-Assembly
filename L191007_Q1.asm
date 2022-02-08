; Lab 13
; Task 1
; Printing numbers in the center
[org 0x0100]
;------------------------------------------------------------
n: dw 0x0001
            ;------------------------------------
jmp main
;------------------------------------------------------------
clrscr: 
    push es
    push ax
    push di
    mov ax, 0xb800
    mov es, ax               ; point es to video base
    mov di, 0                ; point di to top left column
nextloc: 
    mov word [es:di], 0x0720 ; clear next char on screen
    add di, 2                ; move to next screen location
    cmp di, 4000             ; has the whole screen cleared
    jne nextloc              ; if no clear next position
    pop di
    pop ax
    pop es
    ret 
;------------------------------------------------------------
delay:
    push cx
    mov cx, 0xFFFF
loop1:
    loop loop1
    pop cx
    ret
;------------------------------------------------------------
printnum: 
    push bp
    mov bp, sp
    push es
    push ax
    push bx
    push cx
    push dx
    push di
    mov ax, 0xb800
    mov es, ax              ; point es to video base
    mov ax, [bp + 4]        ; load number in ax
	mov cx, 0               ; initialize count of digits
    mov bx, 10              ; use base 10 for division
    
	        ;------------------------------------
nextdigit: 
    mov dx, 0               ; upper half of dividend
    div bx                  ; ax = ax / bx 
    add dl, 0x30            ; convert digit into ASCI value
    push dx                 ; save ASCI value on stack
    add cx, 1               ; add in cx register cx = cx + 1
    cmp ax, 0               ; check if it is 0
    jne nextdigit           ; if no divide it again
    mov di, 1960            ; point di to the position where we want to print the numbers
            ;------------------------------------
nextpos: 
    pop dx                  ; pop from stack
    mov dh, 0x07            ; use normal attribute
    mov [es:di], dx         ; print on screen
    add di, 2               ; di = di + 2
    loop nextpos 
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    pop es
    pop bp
    ret 2                   ; returns the memory of 2 bytes
;-----------------------------------------------------------
main: 
	call clrscr             ; clears the screen
	mov ax, [n]
	push ax 
	call printnum           ; call the printnum function
	mov ax, 1
	call delay              ; prints after a delay 
	add [n], ax             ; [n] = ax + 1
	jmp main                ; goes back to main
	mov ax, 0x4c00          ; terminate program
	int 0x21 
;-----------------------------------------------------------