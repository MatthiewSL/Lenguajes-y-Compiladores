include number.asm
include macros2.asm

.MODEL LARGE
.386
.STACK 200h

.DATA
@aux dd ?
a dd ?
_1 dd 1.00
_4 dd 4.00
_2 dd 2.00
_3 dd 3.00
_5 dd 5.00
_6 dd 6.00
_7 dd 7.00
_8 dd 8.00
_9 dd 9.00
_10 dd 10.00

.CODE
main PROC
mov AX, @DATA
mov DS, AX

fld _1
fld _1
fadd
fstp @aux
fld @aux
fstp a
SUMALOSULTIMOS:
fld _5.00
fld _6.00
fadd
fstp @aux
fld @aux
fld _7.00
fadd
fstp @aux
fld @aux
fld _8.00
fadd
fstp @aux
fld @aux
fld _9.00
fadd
fstp @aux
fld @aux
fld _10.00
fadd
fstp @aux
FIN_SUMALOSULTIMOS:
fld @aux
fstp a

DisplayFloat a,2


MOV AX, 4c00h
INT 21h
main ENDP
END main
