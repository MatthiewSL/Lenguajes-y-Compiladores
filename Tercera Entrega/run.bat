:: Script para windows
flex Lexico.l
bison -dyv Sintactico.y

gcc.exe lex.yy.c y.tab.c -o lyc-compiler-2.0.0.exe

compilador.exe prueba.txt

pause