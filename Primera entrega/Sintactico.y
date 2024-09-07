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
char tiposVariablesAsignadas[30][30];
int cantVariableAsignadas = 0;
%}

%union {
    int intval;
    float floatval;
    char *strval;
}

//Constantes
%token <intval> CTE
%token <floatval> CONST_REAL
%token <strval> CONST_STRING

//Palabras reservadas
%token INIT
%token MAIN
%token RETURN
%token INT
%token FLOAT
%token STRING
%token SI
%token SINO
%token MIENTRAS
%token LEER
%token TRIANGULO
%token SUMALOSULTIMOS
%token ESCRIBIR

//Operadores
%right OP_AS
%token OP_COMP
%token OP_DIF
%token OP_MAYOR
%token OP_MENOR
%token OP_AND
%token OP_OR
%token OP_NOT
%token OP_INC
%token OP_DEC
%left OP_SUM OP_RES
%left OP_MUL OP_DIV
%right MENOS_UNARIO

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
    INT MAIN PA PC LLA bloque_dec bloque LLC 
    {
        printf("Programa correcto\n"); guardarTabla();
    }
    | INT MAIN PA PC LLA bloque_dec LLC 
    {
        printf("Programa correcto\n");
        guardarTabla();
	}

bloque_dec:
    INIT LLA sentencia_declaracion LLC {printf("Bloque_dec correcto\n");}

sentencia_declaracion:
    declaracion sentencia_declaracion | declaracion {printf("Sentencia_declaracion correcto\n");}

declaracion:
    ID COMA declaracion 
    {
        agregarATabla($1);
    }
    | ID DOSPUNTOS tipo PUNTOCOMA 
    {
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
    | STRING {
                printf("Tipo string correcto\n");
                tipoVariable = String;
             }

sentencia:
    asignacion PUNTOCOMA
	| bloque_if
    | funcion PUNTOCOMA
	| bloque_while
	| lectura PUNTOCOMA
	| escritura PUNTOCOMA {printf("Sentencia correcto\n");}

funcion:
    TRIANGULO PA expresion_aritmetica COMA expresion_aritmetica COMA expresion_aritmetica PC {printf("Funcion correcto\n");}
    | SUMALOSULTIMOS PA CTE PUNTOCOMA CA lista_numeros CC PC {printf("Funcion correcto\n");}

lista_numeros:
    CTE COMA lista_numeros
    | CTE {printf("Lista_numeros correcto\n");}

bloque:
    sentencia bloque | sentencia {printf("Bloque correcto\n");}

// ASIGNACIONES
asignacion: //Aca chequear que la variable exista y que sea del tipo de la tabla
    ID OP_AS expresion_aritmetica 
    {
        int posEnTabla = buscarEnTabla($1);

        if(posEnTabla != -1){
            chequearTipos(posEnTabla);
            cantVariableAsignadas = 0;
            printf("Asignacion correcto\n");
        }else{
            printf("Variable %s no declarada\n",$1);
            exit(-1);
        }
    } 

expresion_aritmetica:
    termino {printf("Expresion_aritmetica correcto\n");}
    | expresion_aritmetica OP_SUM termino {printf("Expresion_aritmetica correcto\n");}
    | expresion_aritmetica OP_RES termino {printf("Expresion_aritmetica correcto\n");}

termino:
    factor {printf("Termino correcto\n");}
    | termino OP_MUL factor {printf("Termino correcto\n");}
    | termino OP_DIV factor  {printf("Termino correcto\n");}

factor:
    ID 
    {
        int pos = buscarEnTabla($1);
        if(pos != -1){
            strcpy(tiposVariablesAsignadas[cantVariableAsignadas], tabla[pos].tipo);
            cantVariableAsignadas++;
            printf("Factor correcto\n");
        }else{
            printf("Variable %s no declarada\n",$1);
            exit(-1);
        }
    }
    | CONST_REAL 
    {
        strcpy(tiposVariablesAsignadas[cantVariableAsignadas], Float);
        cantVariableAsignadas++;
        printf("Factor correcto\n");
    }
    | CONST_STRING
    {
        strcpy(tiposVariablesAsignadas[cantVariableAsignadas], String);
        cantVariableAsignadas++;
        printf("Factor correcto\n");
    }
    | CTE
    {
        strcpy(tiposVariablesAsignadas[cantVariableAsignadas], Int);
        cantVariableAsignadas++;
        printf("Factor correcto\n");
    }
    | OP_RES factor %prec MENOS_UNARIO  // Agrega esta línea para el operador unario negativo
    {
        printf("Factor negativo correcto\n");
    }
    | PA expresion_aritmetica PC {printf("Factor correcto\n");}

//BLOQUES ESPECIALES
bloque_if:
    SI PA expresion_logica PC LLA bloque LLC
    | SI PA expresion_logica PC LLA bloque LLC SINO LLA bloque LLC {printf("Bloque_if correcto\n");}

expresion_logica:
    termino_logico OP_AND termino_logico
    | termino_logico OP_OR termino_logico
    | OP_NOT termino_logico
    | termino_logico {printf("Expresion_logica correcto\n");}

termino_logico:
    expresion_aritmetica comp_bool expresion_aritmetica {printf("Termino_logico correcto\n");}

comp_bool:
    OP_COMP {printf("Comp_bool correcto\n");}
    | OP_DIF {printf("Comp_bool correcto\n");}
    | OP_MAYOR {printf("Comp_bool correcto\n");}
    | OP_MENOR {printf("Comp_bool correcto\n");}

bloque_while:
    MIENTRAS PA expresion_logica PC LLA bloque LLC {printf("Bloque_while correcto\n");}

lectura:
    LEER PA ID PC { buscarEnTabla($3) != -1 ? printf("Lectura correcto\n") : printf("Variable %s no declarada\n",$3); exit(-1);}

escritura:
    ESCRIBIR PA valor_escritura PC { printf("Escritura correcto\n");}

valor_escritura:
    ID {buscarEnTabla($1) != -1 ? printf("Valor_escritura correcto\n") : printf("Variable %s no declarada\n",$1); exit(-1);}
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
        printf("%d", cantVarInsertadas);
		strcpy(tabla[cantVarInsertadas].tipo,tipoVariable);

		//Agregar valor a la tabla
		strcpy(tabla[cantVarInsertadas].nombre,nombre); 

		//Agregar longitud
		tabla[cantVarInsertadas].longitud = strlen(nombre); 
		//Agregar nombre a tabla
		cantVarInsertadas++;
        printf("Variable %s agregada a la tabla\n", nombre);
	}
	else{
		printf("No se pueden ingresar variables con nombre repetido.\n");
		system("Pause");
		exit(2);
	}
}

int buscarEnTabla(char* nombre){
    int i;
	for(i = 0;i<=cantVarInsertadas;i++){
        if (strcmp(tabla[i].nombre, nombre) == 0) {
            return i;
        }
    }
    return -1;
}

int chequearTipos(int posEnTabla){
    int i = 0;
    for(i = 0; i < cantVariableAsignadas; i++){
        if(strcmp(tabla[posEnTabla].tipo, tiposVariablesAsignadas[i]) != 0){
            if(strcmp(tabla[posEnTabla].tipo, Float) == 0 && strcmp(tiposVariablesAsignadas[i], Int) == 0){
                return 0;
            }
            printf("Error: Asignacion de tipos incompatibles\n");
            exit(-1);
        }
    }
    return 0;
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