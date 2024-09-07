:: Script para windows
flex Lexico.l
bison -dyv Sintactico.y

gcc.exe lex.yy.c y.tab.c -o lyc-compiler-1.0.0.exe

lyc-compiler-1.0.0.exe prueba.txt

pause