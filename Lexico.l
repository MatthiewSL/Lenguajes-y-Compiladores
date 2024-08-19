%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
FILE *yyin;
int yylval;
char *yyltext;


int yyerror(void);

%}

%option noyywrap  
%option yylineno 

DIGITO	[0-9]
LETRA   [a-zA-Z]

CTE {DIGITO}+
CONST_REAL {DIGITO}+"."{DIGITO}+
CONST_CHAR "'"{LETRA}"'"
CONST_STRING {LETRA}+({LETRA}|{DIGITO})*
ID	{LETRA}({LETRA}|{DIGITO})*
COMENTARIO "//"({LETRA}|{DIGITO})*"//"

OP_AS "="
OP_COMP "=="
OP_DIF "!="
OP_MAYOR ">"
OP_MENOR "<"
OP_MAYORIG ">="
OP_MENORIG "<="
OP_AND "&&"
OP_OR "||"
OP_NOT "!"
OP_MOD "%"
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
COMA ","
PUNTOCOMA ";"



%%

{CTE}	        {printf("\nConstante: %s\n", yytext);return CTE;}
{CONST_REAL}    {printf("\nConstanteReal: %s\n", yytext);return CONST_REAL;}
{CONST_CHAR}    {printf("\nConstanteChar: %s\n", yytext);return CONST_CHAR;}
{CONST_STRING}    {printf("\nConstanteString: %s\n", yytext);return CONST_STRING;}
{COMENTARIO}	{printf("\nComentario: %s\n", yytext);return COMENTARIO;}
{ID}	        {printf("\nIdentificador: %s\n", yytext);return ID;}
{OP_AS}	        {printf("\nAsignacion: %s\n", yytext);return OP_AS;}
{OP_COMP}       {printf("\nComparacion: %s\n", yytext);return OP_COMP;}
{OP_DIF}        {printf("\nDiferenteDe: %s\n", yytext);return OP_DIF;}
{OP_MAYOR}      {printf("\nMayorQue: %s\n", yytext);return OP_MAYOR;}
{OP_MENOR}      {printf("\nMenorQue: %s\n", yytext);return OP_MENOR;}
{OP_MAYORIG}    {printf("\nMayorIgual: %s\n", yytext);return OP_MAYORIG;}
{OP_MENORIG}    {printf("\nMenorIgual: %s\n", yytext);return OP_MENORIG;}
{OP_AND}        {printf("\nOperadorY: %s\n", yytext);return OP_AND;}
{OP_OR}         {printf("\nOperadorO: %s\n", yytext);return OP_OR;}
{OP_NOT}        {printf("\nOperadorNot: %s\n", yytext);return OP_NOT;}
{OP_MOD}        {printf("\nOperadorMod: %s\n", yytext);return OP_MOD;}
{OP_INC}        {printf("\nOperadorInc: %s\n", yytext);return OP_INC;}
{OP_DEC}        {printf("\nOperadorDec: %s\n", yytext);return OP_DEC;}
{OP_SUM}        {printf("\nSuma: %s\n", yytext);return OP_SUM;}
{OP_MUL}        {printf("\nMultiplicacion: %s\n", yytext);return OP_MUL;}
{OP_RES}        {printf("\nResta: %s\n", yytext);return OP_RES;}
{OP_DIV}        {printf("\nDivision: %s\n", yytext);return OP_DIV;}
{PA}	        {printf("\nParAbre: %s\n", yytext);return PA;}
{PC}	        {printf("\nParCierra: %s\n", yytext);return PC;}

"define"		{return DEFINE;}
"integer"		{return INTEGER;}
"string"		{return STRING;}
"if"			{return IF;}
"else"   		{return ELSE;}
"for"			{return FOR;}
"do"	        {return DO;}
"endfor"		{return ENDFOR;}
"while"	        {return WHILE;}
"in"	        {return IN;}

%%

"\n"
"\t"

.			 { printf( "ERROR LEXICO : Caracter no reconocido: %s\n", yytext ); exit (0);}

int main(int argc,char *argv[])
{
if ((yyin = fopen(argv[1], "rt")) == NULL)
{
printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
}
else
{
yylex();
}
fclose(yyin);
return 0;
}

preguntar si conviene hacer java o c
preguntar si conviene cerrar cada fc cerrandola y abrindola
centro de que falta
si masomenos esta bien

