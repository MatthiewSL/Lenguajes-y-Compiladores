// Usa Lexico_ClasePractica
//Solo expresiones sin ()
%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
#include <string.h>
#include "tabla.h"

#define Int "int"
#define Float "float"
#define String "string"
#define Char "char"

int yystopparser=0;
FILE  *yyin;
int yyerror();
int yylex();
char* tipoVariable;
%}

%union {
    int intval;
    float floatval;
    char charval;
    char *strval;
}

//Constantes
%token <intval> CTE
%token <floatval> CONST_REAL
%token <strval> CONST_STRING
%token <charval> CONST_CHAR

//Palabras reservadas
%token INIT
%token DEFINE
%token INCLUDE
%token INT
%token MAIN
%token RETURN
%token VOID
%token CHAR
%token FLOAT
%token STRING
%token SI
%token SINO
%token MIENTRAS
%token LEER
%token ESCRIBIR
%token TRIANGULO
%token SUMALOSULTIMOS

//Operadores
%right OP_AS
%token OP_COMP
%token OP_DIF
%token OP_MAYOR
%token OP_MENOR
%token OP_MAYORIG
%token OP_MENORIG
%token OP_AND
%token OP_OR
%token OP_NOT
%token OP_MOD
%token OP_INC
%token OP_DEC
%left OP_SUM OP_RES
%left OP_MUL OP_DIV

//Bloques
%token LLA
%token LLC
%token CA
%token CC
%token PA
%token PC

//Otros
%token <strval> ID
%token COMA
%token PUNTOCOMA
%token DOSPUNTOS

%%
programa:
    INT MAIN PA PC LLA bloque_dec instrucciones LLC 
    {
        printf("Programa correcto\n");
        guardarTabla();
	} 

bloque_dec:
    INIT LLA declaracion LLC {printf("Bloque_dec correcto\n");}

declaracion:
    ID COMA declaracion | ID DOSPUNTOS tipo PUNTOCOMA {
		agregarATabla($1);
		printf("Declaracion correcto\n");
    }

tipo:
    INT     {
                printf("Tipo int correcto\n");
                tipoVariable = Int;
            } 
    | FLOAT  {
                printf("Tipo float correcto\n");
                tipoVariable = Float;
             }
    | CHAR   {
                printf("Tipo char correcto\n");
                tipoVariable = Char;
             }
    | STRING {
                printf("Tipo string correcto\n");
                tipoVariable = String;
             }

instrucciones:
    bloque {printf("Instrucciones correcto\n");}

bloque:
    sentencia bloque | sentencia {printf("Bloque correcto\n");}

sentencia:
    asignacion PUNTOCOMA 
    | funcion PUNTOCOMA
	| bloque_if
	| bloque_while
	| lectura PUNTOCOMA
	| escritura PUNTOCOMA {printf("Sentencia correcto\n");}

// ASIGNACIONES
asignacion: //Aca chequear que la variable exista y que sea del tipo de la tabla
    ID OP_AS expresion { buscarEnTabla((char*)$1) == -1 ? yyerror("Variable no declarada") : printf("Asignacion correcto\n");} 

funcion:
    TRIANGULO PA expresion_aritmetica COMA expresion_aritmetica COMA expresion_aritmetica PC {printf("Funcion correcto\n");}
    | SUMALOSULTIMOS PA CTE PUNTOCOMA CA lista_numeros CC PC {printf("Funcion correcto\n");}

lista_numeros:
    CTE COMA lista_numeros
    | CTE {printf("Lista_numeros correcto\n");}

expresion:
    expresion_aritmetica {printf("Expresion correcto\n");}

expresion_aritmetica:
    termino
    | expresion_aritmetica OP_SUM termino
    | expresion_aritmetica OP_RES termino {printf("Expresion_aritmetica correcto\n");}

termino:
    factor
    | termino OP_MUL factor
    | termino OP_DIV factor {printf("Termino correcto\n");}

factor:
    ID {buscarEnTabla((char*)$1) == -1 ? yyerror("Variable no declarada") : printf("Factor correcto\n");}
    | CONST_REAL {printf("Factor correcto\n");}
    | CONST_CHAR {printf("Factor correcto\n");}
    | CONST_STRING {printf("Factor correcto\n");}
    | CTE {printf("Factor correcto\n");}
    | PA expresion_aritmetica PC {printf("Factor correcto\n");}

//BLOQUES ESPECIALES
bloque_if:
    SI PA expresion_logica PC LLA instrucciones LLC
    | SI PA expresion_logica PC LLA instrucciones LLC SINO LLA instrucciones LLC {printf("Bloque_if correcto\n");}

expresion_logica:
    termino_logico OP_AND termino_logico
    | termino_logico OP_OR termino_logico
    | OP_NOT termino_logico
    | termino_logico {printf("Expresion_logica correcto\n");}

termino_logico:
    expresion_aritmetica comp_bool expresion_aritmetica {printf("Termino_logico correcto\n");}

comp_bool:
    OP_COMP
    | OP_DIF
    | OP_MAYOR
    | OP_MENOR
    | OP_MAYORIG
    | OP_MENORIG {printf("Comp_bool correcto\n");}

bloque_while:
    MIENTRAS PA expresion_logica PC LLA instrucciones LLC {printf("Bloque_while correcto\n");}

lectura:
    LEER PA ID PC {buscarEnTabla($3) == -1 ? yyerror("Variable no declarada") : printf("Lectura correcto\n");}

escritura:
    ESCRIBIR PA valor_escritura PC {printf("Escritura correcto\n");}

valor_escritura:
    ID {buscarEnTabla((char*)$1) == -1 ? yyerror("Variable no declarada") : printf("Valor_escritura correcto\n");}
    | CONST_STRING {printf("Valor_escritura correcto\n");}
%%

/** Agrega una constante a la tabla de simbolos con el tipo ese*/
void agregarATabla(char* nombre){
    printf("Agregando a tabla: %s\n", nombre);
	if(cantVarInsertadas >=TAMANIO_TABLA){
		printf("Error: sin espacio en la tabla de simbolos.\n");
		system("Pause");
		exit(2);
	}

	//Si no hay otra variable con el mismo nombre...
	if(buscarEnTabla(nombre) == -1){
		//Agregar tipo de dato
        printf("Insertado en tabla: %s\n", tipoVariable);
		strcpy(tabla[cantVarInsertadas].tipo,tipoVariable);

		//Agregar valor a la tabla
		strcpy(tabla[cantVarInsertadas].nombre,nombre); 

		//Agregar longitud
		tabla[cantVarInsertadas].longitud = strlen(nombre); 
		//Agregar nombre a tabla
		cantVarInsertadas++;
	}
	else{
		printf("No se pueden ingresar variables con nombre repetido.\n");
		system("Pause");
		exit(2);
	}
}

int buscarEnTabla(char* nombre){
    int i;
	for(i = 0;i<cantVarInsertadas;i++){
        if (strcmp(tabla[i].nombre, nombre) == 0) {
            return i;
        }
        return -1;
    }
    return -1;
}

void guardarTabla() {
    FILE *archivo = fopen("symbol-table.txt", "wt");
    int i;
    if (archivo == NULL) {
        printf("Error al abrir el archivo.\n");
        exit(1);
    }

    for (i = 0; i < cantVarInsertadas; i++) {
        fprintf(archivo, "Nombre: %s, Tipo de dato: %s, Longitud: %d\n",
                tabla[i].nombre, tabla[i].tipo, tabla[i].longitud);
    }

    fclose(archivo);
    printf("Informacion guardada en el archivo symbol-table.txt .\n");
}

int main(int argc, char *argv[]){
    if((yyin = fopen(argv[1], "rt"))==NULL){
        printf("\nNo se puede abrir el archivo de prueba: %s\n", argv[1]);
    }else{ 
        yyparse();
    }

	fclose(yyin);
    return 0;
}

int yyerror(char* mensaje){
    extern int yylineno;
    extern char* yytext;
    fprintf(stderr, "Syntax Error (linea %d): %s --> %s\n", yylineno, mensaje, yytext);
	system ("Pause");
	exit (1);
 }
