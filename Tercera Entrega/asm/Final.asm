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

.CODE
main PROC
mov AX, @DATA
mov DS, AX

fld a
fld _0
fxch
fcom
fstsw ax
sahf
JNA else1
then1:
SENNNNNN
else1:
end_if1:
SENNNNNN


MOV AX, 4c00h
INT 21h
main ENDP
END main
