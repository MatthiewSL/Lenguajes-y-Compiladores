%{
#include <stdio.h>
#include <stdlib.h>
#include <float.h> /*tiene el maximo de tamaño de reales de 32 bits*/
#include <limits.h> /*tiene el maximo de tamaño de enteros de 16 bits*/
#include <string.h>
#include "y.tab.h"
FILE *yyin;
char *yyltext;

int yyerror(void);

%}

%option noyywrap  
%option yylineno 

DIGITO	[0-9]
LETRA   [a-zA-Z]
CARACESP [@|#|$|%|&|_]
ESPACIO " "

COMENTARIO \*-[^\n]*-\*
CTE {DIGITO}+
<<<<<<< HEAD
CONST_REAL {DIGITO}+"."{DIGITO}+|{DIGITO}+"."{DIGITO}*|{DIGITO}*"."{DIGITO}+
CONST_STRING \"([^\"\\\\]|\\\\.)*\"
=======
CONST_REAL {DIGITO}+"."{DIGITO}+
CONST_STRING "\""{LETRA}+|{CARACESP}+({LETRA}|{DIGITO})*{0,40}"\""
>>>>>>> 04ea6637272c09a9fcbcc3395790f26820f48fc5
ID {LETRA}({LETRA}|{DIGITO})*

OP_AS ":="
OP_COMP "=="
OP_DIF "!="
OP_MAYOR ">"
OP_MENOR "<"
OP_AND "AND"
OP_OR "OR"
OP_NOT "NOT"
OP_INC "++"
OP_DEC "--"
OP_SUM "+"
OP_MUL "*"
OP_RES "-"
OP_DIV "/"

PA "("
PC ")"
CA "["
CC "]"
LLA "{"
LLC "}"

MIENTRAS "mientras"
SI "si"
SINO "sino"
INIT "init"
MAIN "main"
RETURN "return"
FLOAT "float"
INT "int"
STRING "string"
LEER "leer"
ESCRIBIR "escribir"
TRIANGULO "triangulo"
SUMALOSULTIMOS "sumaLosUltimos"

<<<<<<< HEAD
=======


>>>>>>> 04ea6637272c09a9fcbcc3395790f26820f48fc5
COMA ","
PUNTOCOMA ";"
DOSPUNTOS ":"

%%
{COMENTARIO}	{printf("\nComentario: %s\n", yytext);}
{CTE}	        { 
                long value = atol(yytext); 
                if (value < SHRT_MIN || value > SHRT_MAX) { 
                    printf("ERROR: Constante entera fuera del rango de 16 bits: %s\n", yytext); 
                    exit(1); 
                } 
                printf("\nConstante: %s\n", yytext); 
                return CTE; 
}
{CONST_REAL}    {
                float valor = atof(yytext);
                if (valor < 0 || valor > FLT_MAX) {
                    printf("ERROR LEXICO: Constante real fuera de rango: %s\n", yytext);
                    exit(0);
                }
                printf("\nConstanteReal: %s\n", yytext);
                return CONST_REAL;
                }
{CONST_STRING}  { 
                if (strlen(yytext) - 2 > 40) {  // -2 para ignorar las comillas
                    printf("ERROR: String supera los 40 caracteres: %s\n", yytext); 
                    exit(1); 
                }
                printf("\nConstanteString: %s\n", yytext); 
                return CONST_STRING; 
}

{INIT}          {printf("\nInit: %s\n", yytext);return INIT;}
{MAIN}			{printf("\nMain: %s\n", yytext);return MAIN;}
{RETURN}		{printf("\nReturn: %s\n", yytext);return RETURN;}
{FLOAT}			{printf("\nFloat: %s\n", yytext);return FLOAT;}
{INT}			{printf("\nInt: %s\n", yytext);return INT;}
{STRING}		{printf("\nString: %s\n", yytext);return STRING;}
{SI}			{printf("\nSi: %s\n", yytext);return SI;}
{SINO}   		{printf("\nSino: %s\n", yytext);return SINO;}
{MIENTRAS}	    {printf("\nMientras: %s\n", yytext);return MIENTRAS;}
{LEER}	        {printf("\nLeer: %s\n", yytext);return LEER;}
{ESCRIBIR}	    {printf("\nEscribir: %s\n", yytext);return ESCRIBIR;}
{TRIANGULO}	    {printf("\nTriangulo: %s\n", yytext);return TRIANGULO;}
{SUMALOSULTIMOS}	{printf("\nSumaLosUltimos: %s\n", yytext);return SUMALOSULTIMOS;}
{TRIANGULO}	    {printf("\nTriangulo: %s\n", yytext);return TRIANGULO;}
{SUMALOSULTIMOS}	{printf("\nSumaLosUltimos: %s\n", yytext);return SUMALOSULTIMOS;}
{ID}	        {
                    printf("\nIdentificador: %s\n", yytext);
                    yylval.strval = strdup(yytext);
                    return ID; 
                }


{OP_AS}	        {printf("\nAsignacion: %s\n", yytext);return OP_AS;}
{OP_COMP}       {printf("\nComparacion: %s\n", yytext);return OP_COMP;}
{OP_DIF}        {printf("\nDiferenteDe: %s\n", yytext);return OP_DIF;}
{OP_MAYOR}      {printf("\nMayorQue: %s\n", yytext);return OP_MAYOR;}
{OP_MENOR}      {printf("\nMenorQue: %s\n", yytext);return OP_MENOR;}
{OP_AND}        {printf("\nOperadorY: %s\n", yytext);return OP_AND;}
{OP_OR}         {printf("\nOperadorO: %s\n", yytext);return OP_OR;}
{OP_NOT}        {printf("\nOperadorNot: %s\n", yytext);return OP_NOT;}
{OP_INC}        {printf("\nOperadorInc: %s\n", yytext);return OP_INC;}
{OP_DEC}        {printf("\nOperadorDec: %s\n", yytext);return OP_DEC;}
{OP_SUM}        {printf("\nSuma: %s\n", yytext);return OP_SUM;}
{OP_MUL}        {printf("\nMultiplicacion: %s\n", yytext);return OP_MUL;}
{OP_RES}        {printf("\nResta: %s\n", yytext);return OP_RES;}
{OP_DIV}        {printf("\nDivision: %s\n", yytext);return OP_DIV;}


{PA}	        {printf("\nParAbre: %s\n", yytext);return PA;}
{PC}	        {printf("\nParCierra: %s\n", yytext);return PC;}
{LLA}	        {printf("\nLlaveAbre: %s\n", yytext);return LLA;}
{LLC}	        {printf("\nLlaveCierra: %s\n", yytext);return LLC;}
{CA}	        {printf("\nCorcheteAbre: %s\n", yytext);return CA;}
{CC}	        {printf("\nCorcheteCierra: %s\n", yytext);return CC;}


{COMA}	        {printf("\nComa: %s\n", yytext);return COMA;}
{PUNTOCOMA}	    {printf("\nPuntoComa: %s\n", yytext);return PUNTOCOMA;}
{DOSPUNTOS}     {printf("\nDos Puntos: %s\n", yytext);return DOSPUNTOS;}

"\n"      		
"\t"
"\n\t"
" "             		
"\r\n"
"\n"      		
"\t"
"\n\t"
" "             		
"\r\n"
.			     { printf("ERROR LEXICO: Caracter no reconocido: %s\n", yytext); exit(0);}

%%