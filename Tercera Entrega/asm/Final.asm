include number.asm
include macros2.asm

.MODEL LARGE
.386
.STACK 200h

.DATA
@aux dd ?
a dd ?
e dd ?
b dd ?
j dd ?
_0 dd 0.00
A db "A",'$'
B db "B",'$'

.CODE
main PROC
mov AX, @DATA
mov DS, AX

INICIO_IF1:
fld a
fld _0
fxch
fcom
fstsw ax
sahf
JNA ELSE1
SENT
SENT
SENT
INICIO_IF2:
fld a
fld _0
fxch
fcom
fstsw ax
sahf
JNA END_IF2
SENT
END_IF2:
SENT
JMP END_IF1
ELSE1:
SENT
END_IF1:


MOV AX, 4c00h
INT 21h
main ENDP
END main
