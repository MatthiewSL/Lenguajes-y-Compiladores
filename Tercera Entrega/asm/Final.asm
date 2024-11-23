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
d dd ?
w dd ?
c dd ?
_mensaje db "mensaje",'$'
_43_20 dd 43.20
_43 dd 43.00
_7 dd 7.00
_5 dd 5.00
_mayor db "mayor",'$'
_menor db "menor",'$'
_2 dd 2.00
@n1 dd ?
_4 dd 4.00
@n2 dd ?
@n3 dd ?
_equilatero db "equilatero",'$'
_isosceles db "isosceles",'$'
_escaleno db "escaleno",'$'
@temp dd ?
_3 dd 3.00
_6 dd 6.00
_8 dd 8.00
_9 dd 9.00
_10 dd 10.00
_uwu db "uwu",'$'

.CODE
main PROC
mov AX, @DATA
mov DS, AX

INICIO_IF0:
fld a
fld b
fxch
fcom
fstsw ax
sahf
JNA END_IF0
fld c
fld b
fxch
fcom
fstsw ax
sahf
JNA END_IF0
THEN0:
DisplayString _mensaje
END_IF0:
fld _43_20
fstp a
fld _43
fstp a
fld _7
fstp e
fld _5
fstp b
INICIO_IF1:
fld b
fld e
fxch
fcom
fstsw ax
sahf
JNA ELSE1
THEN1:
DisplayString _mayor
JMP END_IF1
ELSE1:
DisplayString _menor
END_IF1:
INICIO_WHILE2:
fld b
fld e
fxch
fcom
fstsw ax
sahf
JNA END_WHILE2
INICIO_IF3:
fld b
fld e
fxch
fcom
fstsw ax
sahf
JNA ELSE3
THEN3:
DisplayString _mayor
JMP END_IF3
ELSE3:
DisplayString _menor
END_IF3:
JMP INICIO_WHILE2
END_WHILE2:
fld b
fld _2
fadd
fstp @aux
fld @aux
fstp @n1
fld e
fld _4
fdiv
fstp @aux
fld @aux
fstp @n2
fld w
fstp @n3
INICIO_TRIANGULO4:
fld @n1
fld @n2
fxch
fcom
fstsw ax
sahf
JNE SALTO24
fld @n2
fld @n3
fxch
fcom
fstsw ax
sahf
JNE SALTO14
lea EAX, _equilatero
mov @temp, EAX
JMP FIN_TRIANGULO4
SALTO14:
lea EAX, _isosceles
mov @temp, EAX
JMP FIN_TRIANGULO4
SALTO24:
fld @n2
fld @n3
fxch
fcom
fstsw ax
sahf
JNE SALTO34
lea EAX, _isosceles
mov @temp, EAX
JMP FIN_TRIANGULO4
SALTO34:
fld @n1
fld @n3
fxch
fcom
fstsw ax
sahf
JNE SALTO44
lea EAX, _isosceles
mov @temp, EAX
JMP FIN_TRIANGULO4
SALTO44:
lea EAX, _escaleno
mov @temp, EAX
FIN_TRIANGULO4:
lea EAX, d
mov @temp, EAX
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
INICIO_IF5:
fld a
fld b
fxch
fcom
fstsw ax
sahf
JA THEN5
fld c
fld b
fxch
fcom
fstsw ax
sahf
JNA END_IF5
THEN5:
DisplayString _uwu
END_IF5:
INICIO_IF6:
fld c
fld b
fxch
fcom
fstsw ax
sahf
JA END_IF6
THEN6:
DisplayString _mensaje
END_IF6:


MOV AX, 4c00h
INT 21h
main ENDP
END main
