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
int tipoVariable;
%}

//Constantes
%token CTE
%token CONST_REAL
%token CONST_STRING
%token CONST_CHAR

//Palabras reservadas
%token INIT
%token DEFINE
%token INCLUDE
%token MAIN
%token RETURN
%token VOID
%token CHAR
%token INT
%token FLOAT
%token STRING
%token SI
%token SINO
%token MIENTRAS
%token LEER
%token ESCRIBIR

//Operadores
%token OP_AS
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
%token OP_SUM
%token OP_MUL
%token OP_RES
%token OP_DIV

//Bloques
%token LLA
%token LLC
%token CA
%token CC
%token PA
%token PC

//Otros
%token ID
%token COMA
%token PUNTOCOMA
%token DOSPUNTOS



%%
programa:
    INT MAIN PA PC LLA instrucciones LLC {
        printf("Programa correcto\n");
        guardarTabla();
		}

instrucciones:
    bloque_dec bloque | bloque {printf("Instrucciones correcto\n");}

bloque_dec:
    INIT LLA declaracion LLC {printf("Bloque_dec correcto\n");}

declaracion:
    ID COMA declaracion | ID DOSPUNTOS tipo PUNTOCOMA {
		agregarATabla(yylval.string_val);
		printf("Declaracion correcto\n");
    }

tipo:
    INT     {
                printf("Tipo int correcto\n");
                tipoVariable = INT;
            } 
    | FLOAT  {
                printf("Tipo float correcto\n");
                tipoVariable = FLOAT;
             }
    | CHAR   {
                printf("Tipo char correcto\n");
                tipoVariable = CHAR;
             }
    | STRING {
                printf("Tipo string correcto\n");
                tipoVariable = STRING;
             }

sentencia:
    asignacion PUNTOCOMA
	| bloque_if
	| bloque_while
	| lectura PUNTOCOMA
	| escritura PUNTOCOMA {printf("Sentencia correcto\n");}

bloque:
    sentencia bloque | sentencia {printf("Bloque correcto\n");}

// ASIGNACIONES
asignacion: //Aca chequear que la variable exista y que sea del tipo de la tabla
    ID OP_AS expresion {printf("Asignacion correcto\n");} 

expresion:
    factor | expresion_aritmetica {printf("Expresion correcto\n");}

expresion_aritmetica: 
    termino 
    | expresion_aritmetica OP_SUM termino
    | expresion_aritmetica OP_RES termino {printf("Expresion_aritmetica correcto\n");}

termino:
    factor
    | termino OP_MUL factor
    | termino OP_DIV factor {printf("Termino correcto\n");}	

factor:
    ID
    | CONST_REAL
    | CONST_CHAR
    | CONST_STRING
    | CTE
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
    LEER PA ID PC {printf("Lectura correcto\n");}

escritura:
    ESCRIBIR PA valor_escritura PC {printf("Escritura correcto\n");}

valor_escritura:
    ID
    | CONST_STRING {printf("Valor_escritura correcto\n");}
%%

/** Agrega una constante a la tabla de simbolos con el tipo ese*/
void agregarATabla(char* nombre){
	if(cantVarInsertadas >=TAMANIO_TABLA){
		printf("Error: sin espacio en la tabla de simbolos.\n");
		system("Pause");
		exit(2);
	}

	//Si no hay otra variable con el mismo nombre...
	if(buscarEnTabla(nombre) == -1){
		//Agregar nombre a tabla
		cantVarInsertadas++;

		//Agregar tipo de dato
		strcpy(tabla[cantVarInsertadas].tipo,tipoVariable);

		//Agregar valor a la tabla
		strcpy(tabla[cantVarInsertadas].nombre,nombre); 

		//Agregar longitud
		tabla[cantVarInsertadas].longitud = strlen(nombre); 
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



int main(int argc, char *argv[])
{
    if((yyin = fopen(argv[1], "rt"))==NULL)
    {
        printf("\nNo se puede abrir el archivo de prueba: %s\n", argv[1]);
       
    }
    else
    { 
        
        yyparse();
        
    }
	fclose(yyin);
        return 0;
}
int yyerror(void)
     {
       printf("Error Sintactico\n");
	 exit (1);
     }
