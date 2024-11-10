:: Script para windows
flex Lexico.l
bison -dyv Sintactico.y

gcc lex.yy.c y.tab.c Includes/pila.c -o LyC-Compiler-3.0.0.exe

LyC-Compiler-3.0.0.exe prueba.txt

@echo off
del lex.yy.c
del y.tab.c
del y.tab.h
del y.output

pause