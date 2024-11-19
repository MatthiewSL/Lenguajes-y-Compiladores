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
_43.20 dd 43.20
_43 dd 43.00
_7 dd 7.00
_5 dd 5.00
_ctecadena db "ctecadena",'$'
_b_>_e db "b_>_e",'$'
_b_<=_e db "b_<=_e",'$'
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
_Mensaje db "Mensaje",'$'
_uwu db "uwu",'$'
_mensaje db "mensaje",'$'

.CODE
main PROC
mov AX, @DATA
mov DS, AX

fld _43.20
fstp a
fld _43
fstp a
fld _7
fstp e
fld _5
fstp b
lea EAX, d
mov _ctecadena, EAX
INICIO_IF0:
fld b
fld e
fxch
fcom
fstsw ax
sahf
JNA ELSE0
THEN0:
DisplayString _b_>_e
JMP END_IF0
ELSE0:
DisplayString _b_<=_e
END_IF0:
INICIO_WHILE1:
fld b
fld e
fxch
fcom
fstsw ax
sahf
JNA END_WHILE1
INICIO_IF2:
fld b
fld e
fxch
fcom
fstsw ax
sahf
JNA ELSE2
THEN2:
DisplayString _b_>_e
JMP END_IF2
ELSE2:
DisplayString _b_<=_e
END_IF2:
JMP INICIO_WHILE1
END_WHILE1:
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
INICIO_TRIANGULO3:
fld @n1
fld @n2
fxch
fcom
fstsw ax
sahf
JNE SALTO23
fld @n2
fld @n3
fxch
fcom
fstsw ax
sahf
JNE SALTO13
lea EAX, _equilatero
mov temp, EAX
JMP FIN_TRIANGULO3
SALTO13:
lea EAX, _isosceles
mov temp, EAX
JMP FIN_TRIANGULO3
SALTO23:
fld @n2
fld @n3
fxch
fcom
fstsw ax
sahf
JNE SALTO33
lea EAX, _isosceles
mov temp, EAX
JMP FIN_TRIANGULO3
SALTO33:
fld @n1
fld @n3
fxch
fcom
fstsw ax
sahf
JNE SALTO43
lea EAX, _isosceles
mov temp, EAX
JMP FIN_TRIANGULO3
SALTO43:
lea EAX, _escaleno
mov temp, EAX
FIN_TRIANGULO3:
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
INICIO_IF4:
fld a
fld b
fxch
fcom
fstsw ax
sahf
JNA END_IF4
fld c
fld b
fxch
fcom
fstsw ax
sahf
JNA END_IF4
THEN4:
DisplayString _Mensaje
END_IF4:
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
