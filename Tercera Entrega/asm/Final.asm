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
a_es_menor_que_0 db "a_es_menor_que_0",'$'

.CODE
main PROC
mov AX, @DATA
mov DS, AX

INICIO_WHILE1:
fld a
fld _0
fxch
fcom
fstsw ax
sahf
JAE END_WHILE1
SENT
INICIO_WHILE2:
fld a
fld _0
fxch
fcom
fstsw ax
sahf
JAE END_WHILE2
SENT
INICIO_IF1:
fld a
fld _0
fxch
fcom
fstsw ax
sahf
JAE ELSE1
SENT
JMP END_IF1
ELSE1:
SENT
INICIO_IF2:
fld a
fld _0
fxch
fcom
fstsw ax
sahf
JAE END_IF2
SENT
END_IF2:
END_IF1:
JMP INICIO_WHILE2
END_WHILE2:
JMP INICIO_WHILE1
END_WHILE1:


MOV AX, 4c00h
INT 21h
main ENDP
END main
