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
_17 dd 17.00
hola db "hola",'$'

.CODE
main PROC
mov AX, @DATA
mov DS, AX

INICIO_IF0:
fld a
fld _0
fxch
fcom
fstsw ax
sahf
JB THEN0
fld a
fld _17
fxch
fcom
fstsw ax
sahf
JNA END_IF0
THEN0:
SENT
INICIO_IF1:
fld a
fld _0
fxch
fcom
fstsw ax
sahf
JB THEN1
fld a
fld _17
fxch
fcom
fstsw ax
sahf
JNA END_IF1
THEN1:
SENT
END_IF1:
INICIO_IF2:
fld a
fld _0
fxch
fcom
fstsw ax
sahf
JNA END_IF2
THEN2:
SENT
END_IF2:
END_IF0:


MOV AX, 4c00h
INT 21h
main ENDP
END main
