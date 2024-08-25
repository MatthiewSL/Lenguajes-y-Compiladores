:: Script para windows
flex Lexico.l
bison -dyv Sintactico.y

gcc.exe lex.yy.c y.tab.c -o compilador.exe

@echo off
del lex.yy.c
del y.tab.c
del y.tab.h
del y.output

pause