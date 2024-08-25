// Usa Lexico_ClasePractica
//Solo expresiones sin ()
%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
#include "tabla.h"

int yystopparser=0;
FILE  *yyin;
int yyerror();
int yylex();
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
    ID, declaracion | ID : tipo PUNTOCOMA {
		agregarATabla($1,tipo);

		printf("Declaracion correcto\n");}

tipo:
    INT | FLOAT | CHAR | STRING {printf("Tipo correcto\n");}

sentencia:
    asignacion PUNTO_COMA
	| bloque_if
	| bloque_while
	| lectura PUNTO_COMA
	| escritura PUNTO_COMA {printf("Sentencia correcto\n");}

bloque:
    bloque sentencia | sentencia {printf("Bloque correcto\n");}

// ASIGNACIONES
asignacion: //Aca chequear que la variable exista y que sea del tipo de la tabla
    ID OP_AS expresion {printf("Asignacion correcto\n");} 

expresion:
    expresion_string | expresion_aritmetica | expresion_id {printf("Expresion correcto\n");}

expresion_string: 
    CONST_STRING {printf("Expresion_string correcto\n");}

expresion_id:
    ID {printf("Expresion_id correcto\n");}

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
    termino_logico AND termino_logico
    | termino_logico OR termino_logico
    | NOT termino_logico
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

/* Devuleve la posici�n en la que se encuentra el elemento buscado, -1 si no encontr� el elemento */
int buscarEnTabla(char * name){
   int i=0;
   while(i<=fin_tabla){
	   if(strcmp(tabla_simbolo[i].nombre,name) == 0){
		   return i;
	   }
	   i++;
   }
   return -1;
}


//Cuando se declara una variable inserto un campo en la tabla de simbolos
void insertarVarATabla(char *nombre, int tipo){
	if(fin_tabla >= TAMANIO_TABLA - 1){
		printf("Error: me quede sin espacio en la tabla de simbolos. Sori, gordi.\n");
		system("Pause");
		exit(2);
	}
	//Si no hay otra variable con el mismo nombre...
	if(buscarEnTabla(nombre) == -1){
		//Agregar nombre a tabla
		fin_tabla++;
		escribirNombreEnTabla(nombre, fin_tabla);

		//Agregar tipo de dato
		tabla_simbolo[fin_tabla].tipo_dato = tipo;
	}
	else yyerror("Encontre dos declaraciones de variables con el mismo nombre. Decidite."); //Error, ya existe esa variable
}

/** Guarda la tabla de simbolos en un archivo de texto */
void guardarTabla(){
	if(fin_tabla == -1)
		yyerror("No encontre la tabla de simbolos");

	FILE* arch = fopen("ts.txt", "w+");
	if(!arch){
		printf("No pude crear el archivo ts.txt\n");
		return;
	}

	for(int i = 0; i <= fin_tabla; i++){
		fprintf(arch, "%s\t", &(tabla_simbolo[i].nombre) );

		switch (tabla_simbolo[i].tipo_dato){
		case Float:
			fprintf(arch, "FLOAT");
			break;
		case Int:
			fprintf(arch, "INT");
			break;
		case String:
			fprintf(arch, "STRING");
			break;
		case CteFloat:
			fprintf(arch, "CTE_FLOAT\t%f", tabla_simbolo[i].valor_f);
			break;
		case CteInt:
			fprintf(arch, "CTE_INT\t%d", tabla_simbolo[i].valor_i);
			break;
		case CteString:
			fprintf(arch, "CTE_STRING\t%s\t%d", &(tabla_simbolo[i].valor_s), tabla_simbolo[i].longitud);
			break;
		}

		fprintf(arch, "\n");
	}
	fclose(arch);
}

/** Agrega una constante a la tabla de simbolos con el tipo ese*/
void agregarATabla(char* nombre,char* tipo){
	if(cantVarInsertadas >=TAMANIO_TABLA){
		printf("Error: me quede sin espacio.\n");
		system("Pause");
		exit(2);
	}

	//Si no hay otra variable con el mismo nombre...
	if(buscarEnTabla(nombre) == -1){
		//Agregar nombre a tabla
		cantVarInsertadas++;

		//Agregar tipo de dato
		strcpy(tabla[cantVarInsertadas].tipo,tipo);

		//Agregar valor a la tabla
		strcpy(tabla[cantVarInsertadas].nombre,nombre); 

		//Agregar longitud
		tabla[cantVarInsertadas].longitud = strlen(nombre); 
	}
	else{
		printf("no se pueden ingresar variables con nombre repetido.\n");
		system("Pause");
		exit(2);
	}
}

int buscarEnTabla(char* nombre){

	for(i=0;i<cantVarInsertadas,i++){
		for (int i = 0; i < tamaño; i++) {
        if (strcmp(tabla[i].Nombre, nombre) == 0) {
            return i; // Retorna el índice del nombre encontrado
        }
    }
    return -1; // Retorna -1 si el nombre no se encuentra
}

}

void guardarTabla() {
    FILE *archivo = fopen("symbol-table.txt", "wt");
    if (archivo == NULL) {
        printf("Error al abrir el archivo.\n");
        exit(1);
    }

    for (int i = 0; i < cantVarInsertadas; i++) {
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
