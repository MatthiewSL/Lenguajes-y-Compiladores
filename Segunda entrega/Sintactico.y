// Usa Lexico_ClasePractica
//Solo expresiones sin ()
%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
#include <string.h>
#include "./Includes/tabla.h"
#include "./includes/gci.h"
#include "./includes/gciFunciones.h"

#define Int "int"
#define Float "float"
#define String "string"
#define Char "char"
#define CTE_STRNG "CTE_STRING"
#define CTE_INT "CTE_INTEGER"
#define CTE_FLOAT "CTE_FLOAT"

int yystopparser=0;
FILE  *yyin;
int yyerror();
int yylex();
char* tipoVariable;
char tiposVariablesAsignadas[30][30];
int cantVariableAsignadas = 0;
char branchActual[4];
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
%right <strval> OP_AS
%token OP_COMP
%token OP_DIF
%token OP_MAYOR
%token OP_MENOR
%token OP_AND
%token OP_OR
%token OP_NOT
%token OP_INC
%token OP_DEC
%left <strval> OP_SUM OP_RES
%left <strval> OP_MUL OP_DIV
%right MENOS_UNARIO

//Bloques
%token <strval> LLA
%token <strval> LLC
%token <strval> CA
%token <strval> CC
%token <strval> PA
%token <strval> PC

//Otros
%token <strval> ID
%token COMA
%token PUNTOCOMA
%token DOSPUNTOS

%%
programa:
    INT MAIN PA PC LLA bloque_dec bloque LLC 
    {
        printf("Programa correcto\n");
        guardarGCI();
        guardarTabla();
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
    asignacion PUNTOCOMA {insertarEnPolaca("SEN ASIG"); printf("Sentencia correcto\n");}
	| bloque_if {insertarEnPolaca("SEN IF") ;printf("Sentencia correcto\n");}
    | ID OP_AS funcion PUNTOCOMA 
        {
            int pos = buscarEnTabla($1);
            if(pos != -1){
                strcpy(tiposVariablesAsignadas[cantVariableAsignadas], tabla[pos].tipo);
                cantVariableAsignadas++;
                insertarEnPolaca($1);
            }else{
                printf("Variable %s no declarada\n",$1);
                exit(-1);
            }
            insertarEnPolaca($2); 
            printf("Sentencia correcto\n");    
        }
	| bloque_while {insertarEnPolaca("SEN WHILE") ;printf("Sentencia correcto\n");}
	| lectura PUNTOCOMA {insertarEnPolaca("SEN LEC") ;printf("Sentencia correcto\n");}
	| escritura PUNTOCOMA {insertarEnPolaca("SEN ESC") ;printf("Sentencia correcto\n");}

funcion:
    TRIANGULO PA expresion_aritmetica comaN1 expresion_aritmetica comaN2 expresion_aritmetica n3 PC {calcularTipoTriangulo() ;printf("Funcion correcto\n");}
    | SUMALOSULTIMOS PA pivot PUNTOCOMA CA lista_numeros CC PC 
    {
        finalizarSumaLosUltimos();
        printf("Funcion correcto\n");
    }

comaN1:
    COMA {
        insertarEnPolaca("@n1");
        insertarEnPolaca(":=");
        printf("ComaN1 correcto\n");
    }


comaN2:
    COMA {
        insertarEnPolaca("@n2");
        insertarEnPolaca(":=");
        printf("ComaN2 correcto\n");
    }

n3:
    {
        insertarEnPolaca("@n3");
        insertarEnPolaca(":=");
        printf("N3 correcto\n");
    }

pivot:
 CTE {
    pivotito = $1-1;
    printf("Pivot correcto\n");
    }
 | OP_RES pivot %prec MENOS_UNARIO  // Agrega esta línea para el operador unario negativo
    {
        banderaTerminar = 1;
        printf("Pivot negativo correcto\n");
    }

lista_numeros:
    valor_lista {printf("Lista_numeros correcto\n");}
    | lista_numeros COMA valor_lista 

valor_lista:
    CTE {insertarSumaLosUltimos($1);printf("Valor_lista correcto\n");}
    | CONST_REAL {insertarSumaLosUltimos($1);printf("Valor_lista correcto\n");}

bloque:
    sentencia bloque | sentencia {printf("Bloque correcto\n");}

asignacion:
    ID OP_AS expresion_aritmetica 
    {
        int posEnTabla = buscarEnTabla($1);

        if(posEnTabla != -1){
            chequearTipos(posEnTabla);
            cantVariableAsignadas = 0;
            insertarEnPolaca($1);
            insertarEnPolaca($2);
            printf("Asignacion correcto\n");
        }else{
            printf("Variable %s no declarada\n",$1);
            exit(-1);
        }
    } 

expresion_aritmetica:
    termino {printf("Expresion_aritmetica correcto\n");}
    | expresion_aritmetica OP_SUM termino 
    {
        insertarEnPolaca($2);
        printf("Expresion_aritmetica correcto\n");
    }
    | expresion_aritmetica OP_RES termino 
    {
        insertarEnPolaca($2);
        printf("Expresion_aritmetica correcto\n");
    }

termino:
    factor {printf("Termino correcto\n");}
    | termino OP_MUL factor 
    {
        insertarEnPolaca($2);
        printf("Termino correcto\n");    
    }
    | termino OP_DIV factor  
    {
        insertarEnPolaca($2);
        printf("Termino correcto\n");
    }

factor:
    ID 
    {
        int pos = buscarEnTabla($1);
        if(pos != -1){
            strcpy(tiposVariablesAsignadas[cantVariableAsignadas], tabla[pos].tipo);
            cantVariableAsignadas++;
            insertarEnPolaca($1);
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
        insertarEnPolacaFloat($1);
        agregarCteFloatATabla($1, CTE_FLOAT);
        printf("Factor correcto\n");
    }
    | CONST_STRING
    {
        strcpy(tiposVariablesAsignadas[cantVariableAsignadas], String);
        cantVariableAsignadas++;
        insertarEnPolaca($1);
        agregarCteStringATabla($1, CTE_STRNG);
        printf("Factor correcto\n");
    }
    | CTE
    {
        strcpy(tiposVariablesAsignadas[cantVariableAsignadas], Int);
        cantVariableAsignadas++;
        insertarEnPolacaInt($1);
        agregarCteIntATabla($1, CTE_INT);
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
    {
        escribirEnPolaca(cantItemsGCI+1, pilaGCI[topeGCI]); 
        topeGCI--;
        printf("Bloque_if correcto\n");
    }
    | SI PA expresion_logica PC LLA bloque LLC SINO inicio_else bloque LLC 
    {
        escribirEnPolaca(cantItemsGCI+1, pilaGCI[topeGCI]);
        topeGCI--;
        printf("Bloque_if correcto\n");
    }

inicio_else:
    LLA {
        insertarEnPolaca("BI");
        int auxBI = cantItemsGCI;
        insertarEnPolaca("BLANCO");
        escribirEnPolaca(cantItemsGCI, pilaGCI[topeGCI]);
        topeGCI--;
        apilarGCI(auxBI);
        printf("Inicio_else correcto\n");
    }

expresion_logica:
    termino_logico OP_AND termino_logico 
        {
            insertarEnPolaca("BLANCO");
            printf("Expresion_logica correcto\n");
        }
    | termino_logico OP_OR termino_logico 
        {
            insertarEnPolaca("BLANCO"); 
            printf("Expresion_logica correcto\n");
        }
    | OP_NOT termino_logico 
        {
            insertarEnPolaca("BLANCO");
            printf("Expresion_logica correcto\n");
        }
    | termino_logico 
        {
            insertarEnPolaca("BLANCO"); 
            printf("Expresion_logica correcto\n");
        }

termino_logico:
    expresion_aritmetica comp_bool expresion_aritmetica 
    {
        insertarEnPolaca("CMP"); 
        insertarEnPolaca(branchActual);
        apilarGCI(cantItemsGCI);
        printf("Termino_logico correcto\n");
    }

comp_bool:
    OP_COMP {
        strcpy(branchActual, "BNE");
        printf("Comp_bool correcto\n"); 
    }
    | OP_DIF {
        strcpy(branchActual, "BEQ");
        printf("Comp_bool correcto\n"); 
    }
    | OP_MAYOR {
        strcpy(branchActual, "BLE");
        printf("Comp_bool correcto\n"); 
    }
    | OP_MENOR {
        strcpy(branchActual, "BGE");
        printf("Comp_bool correcto\n"); 
    }

bloque_while:
    MIENTRAS inicio_parent expresion_logica PC LLA bloque LLC 
    {
        mostrarPila();
        insertarEnPolaca("BI");
        escribirEnPolaca(cantItemsGCI+2, pilaGCI[topeGCI]); //Es mas 2 porque me tengo que parar en la que le sigue al while y tener en cuenta la que le sigue al BI
        topeGCI--;
        escribirEnPolaca(pilaGCI[topeGCI], cantItemsGCI);
        cantItemsGCI++;
        topeGCI--;
        printf("Bloque_while correcto\n");
    }

inicio_parent:
    PA {
        apilarGCI(cantItemsGCI);
        mostrarPila();
    }

lectura:
    LEER PA ID PC { buscarEnTabla($3) != -1 ? printf("Lectura correcto\n") : printf("Variable %s no declarada\n",$3); exit(-1);}

escritura:
    ESCRIBIR PA valor_escritura PC { printf("Escritura correcto\n");}

valor_escritura:
    ID {buscarEnTabla($1) != -1 ? printf("Valor_escritura correcto\n") : printf("Variable %s no declarada\n",$1); exit(-1);}
    | CONST_STRING 
    {
        agregarCteStringATabla($1, CTE_STRNG);
        printf("Valor_escritura correcto\n");
    }
%%

int agregarCteIntATabla(int valor, char* tipo){
    if(cantVarInsertadas >=TAMANIO_TABLA){
        printf("Error: sin espacio en la tabla de simbolos.\n");
        system("Pause");
        exit(2);
    }

    char valorStr[20];
    sprintf(valorStr, "%d", valor);

    //Si no hay otra cte con el mismo valor...
    printf("Agregando a tabla: %s\n", valorStr);

    if(buscarEnTabla(valorStr) == -1){
        //Agregar tipo de dato
        strcpy(tabla[cantVarInsertadas].tipo,tipo);

        //Agregar valor a la tabla
        strcpy(tabla[cantVarInsertadas].nombre,valorStr); 

        //Agregar longitud
        tabla[cantVarInsertadas].longitud = strlen(valorStr);
        //Agregar nombre a tabla
        cantVarInsertadas++;
    }
}

int agregarCteFloatATabla(float valor, char* tipo){
    if(cantVarInsertadas >=TAMANIO_TABLA){
        printf("Error: sin espacio en la tabla de simbolos.\n");
        system("Pause");
        exit(2);
    }
    //Si no hay otra cte con el mismo valor...
    char valorStr[20];
    sprintf(valorStr, "%.2f", valor);
    printf("Agregando a tabla: %s\n", valorStr);

    if(buscarEnTabla(valorStr) == -1){
        //Agregar tipo de dato
        strcpy(tabla[cantVarInsertadas].tipo,tipo);

        //Agregar valor a la tabla
        strcpy(tabla[cantVarInsertadas].nombre,valorStr); 

        //Agregar longitud
        tabla[cantVarInsertadas].longitud = strlen(valorStr);
        //Agregar nombre a tabla
        cantVarInsertadas++;
    }
}


int agregarCteStringATabla(char* valor, char* tipo){
    if(cantVarInsertadas >=TAMANIO_TABLA){
        printf("Error: sin espacio en la tabla de simbolos.\n");
        system("Pause");
        exit(2);
    }

    printf("Agregando a tabla: %s\n", valor);

    if(buscarEnTabla(valor) == -1){
        //Agregar tipo de dato
        strcpy(tabla[cantVarInsertadas].tipo,tipo);

        //Agregar valor a la tabla
        strcpy(tabla[cantVarInsertadas].nombre,valor); 

        //Agregar longitud
        tabla[cantVarInsertadas].longitud = strlen(valor)-2;
        //Agregar nombre a tabla
        cantVarInsertadas++;
    }
}

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

void insertarEnPolaca(char *valorTerminal){
    strcpy(vectGCI[cantItemsGCI], valorTerminal);
    cantItemsGCI++;
}

void insertarEnPolacaInt(int valorTerminal){
    char valorStr[20];
    sprintf(valorStr, "%d", valorTerminal);
    strcpy(vectGCI[cantItemsGCI], valorStr);
    cantItemsGCI++;
}

void insertarEnPolacaFloat(float valorTerminal){
    char valorStr[20];
    sprintf(valorStr, "%.2f", valorTerminal);
    strcpy(vectGCI[cantItemsGCI], valorStr);
    cantItemsGCI++;
    printf("Insertando en polaca: %.2f\n", valorTerminal);
}


void apilarGCI(int valor){
    topeGCI++;
    pilaGCI[topeGCI] = valor;
    printf("TOPE: %d\n", topeGCI);
}

void escribirEnPolaca(int valorTerminal, int pos){
    char valorStr[20];
    printf("%d %d\n", pos, valorTerminal);
    sprintf(valorStr, "%d", valorTerminal);
    strcpy(vectGCI[pos], valorStr);
}

void guardarGCI(){
    FILE *archivo = fopen("gci.txt", "wt");
    int i;
    if (archivo == NULL) {
        printf("Error al abrir el archivo.\n");
        exit(1);
    }

    for (i = 0; i < cantItemsGCI; i++) {
        printf("Guardando GCI: %s\n", vectGCI[i]);
        fprintf(archivo, "%s\n", vectGCI[i]);
    }

    fclose(archivo);
    printf("Informacion guardada en el archivo gci.txt .\n");
}

void insertarSumaLosUltimos(float valor){
   sumaLosUltimos[cantElementos] = valor;
   cantElementos++;
}

void finalizarSumaLosUltimos(){
    if(cantElementos < pivotito || banderaTerminar == 1){
        insertarEnPolacaInt(0);
        return;
    }
 //P:4 E:6
    int i = pivotito,bandPrimeraVez = 0;

    for(i; i < cantElementos; i++){
        if(bandPrimeraVez == 0){
            insertarEnPolacaFloat(sumaLosUltimos[i]);
            bandPrimeraVez = 1;
        }else{
            insertarEnPolacaFloat(sumaLosUltimos[i]);
            insertarEnPolaca("+");
        }
    }
}

// if (a == b) { //BNE 2
//     if (b == c) { //BNE 1
//         BRANCH EQUI;
//     } else { // 1
//         BRANCH ISOCELES;
//     }
// } else { //2 
//     if (b == c) { //BNE 3
//         BRANCH ISOCELES;
//     } else{ // 3
//         if (a == c) {//BNE 4
//             BRANCH ISOCELES;
//         }else{//4
//             BRANCH ESCALENO;
//         }
//     }
// }

void calcularTipoTriangulo(){
    insertarEnPolaca("@n1");
    insertarEnPolaca("@n2");
    insertarEnPolaca("CMP");
    insertarEnPolaca("BNE");
    insertarEnPolacaInt(cantItemsGCI+12);
    insertarEnPolaca("@n2");
    insertarEnPolaca("@n3");
    insertarEnPolaca("CMP");
    insertarEnPolaca("BNE");
    insertarEnPolacaInt(cantItemsGCI+4);
    insertarEnPolaca("EQUILATERO");
    insertarEnPolaca("BI");
    insertarEnPolacaInt(cantItemsGCI+21);
    insertarEnPolaca("ISOSCELES");
    insertarEnPolaca("BI");
    insertarEnPolacaInt(cantItemsGCI+18);
    insertarEnPolaca("@n2");
    insertarEnPolaca("@n3");
    insertarEnPolaca("CMP");
    insertarEnPolaca("BNE");
    insertarEnPolacaInt(cantItemsGCI+4);
    insertarEnPolaca("ISOSCELES");
    insertarEnPolaca("BI");
    insertarEnPolacaInt(cantItemsGCI+10);
    insertarEnPolaca("@n1");
    insertarEnPolaca("@n3");
    insertarEnPolaca("CMP");
    insertarEnPolaca("BNE");
    insertarEnPolacaInt(cantItemsGCI+5);
    insertarEnPolaca("ISOSCELES");
    insertarEnPolaca("BI");
    insertarEnPolacaInt(cantItemsGCI+2);
    insertarEnPolaca("ESCALENO");
}

void mostrarPila(){
    int i;
    for(i = 0; i <= topeGCI; i++){
        printf("%d\n", pilaGCI[i]);
    }
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