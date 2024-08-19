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
//CARACESP [@#$%&_]

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
DEFINE "define"		
INCLUDE "include"		
MAIN "main"			
RETURN "return"		
VOID "void"			
FLOAT "float"			
CHAR "char"			
INT "int"			
STRING "string"		
IF "if"			
ELSE "else"   		
FOR "for"			
DO "do"	        
ENDFOR "endfor"		
WHILE "while"	        
IN "in"	        
ENDWHILE "endwhile"		
SWITCH "switch"		
CASE "case"			
DEFAULT "default"		
BREAK "break"			
CONTINUE "continue"		
GOTO "goto"			




%%

{CTE}	        {printf("\nConstante: %s\n", yytext);return CTE;}
{CONST_REAL}    {printf("\nConstanteReal: %s\n", yytext);return CONST_REAL;}
{CONST_CHAR}    {printf("\nConstanteChar: %s\n", yytext);return CONST_CHAR;}
{CONST_STRING}  {printf("\nConstanteString: %s\n", yytext);return CONST_STRING;}
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
{DEFINE}		{printf("\nDefine: %s\n", yytext);return DEFINE;}
{INCLUDE}		{printf("\nInclude: %s\n", yytext);return INCLUDE;}
{MAIN}			{printf("\nMain: %s\n", yytext);return MAIN;}
{RETURN}		{printf("\nReturn: %s\n", yytext);return RETURN;}
{VOID}			{printf("\nVoid: %s\n", yytext);return VOID;}
{FLOAT}			{printf("\nFloat: %s\n", yytext);return FLOAT;}
{CHAR}			{printf("\nChar: %s\n", yytext);return CHAR;}
{INT}			{printf("\nInt: %s\n", yytext);return INT;}
{STRING}		{printf("\nString: %s\n", yytext);return STRING;}
{IF}			{printf("\nIf: %s\n", yytext);return IF;}
{ELSE}   		{printf("\nElse: %s\n", yytext);return ELSE;}
{FOR}			{printf("\nFor: %s\n", yytext);return FOR;}
{DO}	        {printf("\nDo: %s\n", yytext);return DO;}
{ENDFOR}		{printf("\nEndfor: %s\n", yytext);return ENDFOR;}
{WHILE}	        {printf("\nWhile: %s\n", yytext);return WHILE;}
{IN}	        {printf("\nIn: %s\n", yytext);return IN;}
{ENDWHILE}		{printf("\nEndwhile: %s\n", yytext);return ENDWHILE;}
{SWITCH}		{printf("\nSwitch: %s\n", yytext);return SWITCH;}
{CASE}			{printf("\nCase: %s\n", yytext);return CASE;}
{DEFAULT}		{printf("\nDefault: %s\n", yytext);return DEFAULT;}
{BREAK}			{printf("\nBreak: %s\n", yytext);return BREAK;}
{CONTINUE}		{printf("\nContinue: %s\n", yytext);return CONTINUE;}
{GOTO}			{printf("\nGoto: %s\n", yytext);return GOTO;}
{COMA}	        {printf("\nComa: %s\n", yytext);return COMA;}
{PUNTOCOMA}	    {printf("\nPuntoComa: %s\n", yytext);return PUNTOCOMA;}
{LLA}	        {printf("\nLlaveAbre: %s\n", yytext);return LLA;}
{LLC}	        {printf("\nLlaveCierra: %s\n", yytext);return LLC;}
{CA}	        {printf("\nCorcheteAbre: %s\n", yytext);return CA;}
{CC}	        {printf("\nCorcheteCierra: %s\n", yytext);return CC;}
.			 { printf( "ERROR LEXICO : Caracter no reconocido: %s\n", yytext ); exit (0);}

%%

"\n"
"\t"

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

