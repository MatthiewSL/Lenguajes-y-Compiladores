%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
#include <string.h>
#include "./Includes/tabla.h"
#include "./Includes/gci.h"
#include "./Includes/gciFunciones.h"
#include "./Includes/assembler.h"
#include "./Includes/pila.h"

int yystopparser=0;
FILE  *yyin;
int yyerror();
int yylex();
char* tipoVariable;
char tiposVariablesAsignadas[30][30];
int cantVariableAsignadas = 0;
char branchActual[4];

void eliminarComillas(char* cadena);
void reemplazarEspaciosConGuion(char* cadena);
void eliminarGuion(char *cadena);
int esSimboloBinario(char* simbolo);
char* getSymbolIns(char* simbolo);
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
        generarAssembler();
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
	| bloque_if {insertarEnPolaca("END_IF") ;printf("Sentencia correcto\n");}
    | ID OP_AS funcion PUNTOCOMA 
        {
            int pos = buscarEnTabla($1);
            if(pos != -1){
                int tipoValido = chequearTipos(pos);
                if(tipoValido != 0){
                    printf("Error: Asignacion de tipos incompatibles\n");
                    exit(-1);
                }
                strcpy(tiposVariablesAsignadas[cantVariableAsignadas], tabla[pos].tipo);
                insertarEnPolaca($1);
            }else{
                printf("Variable %s no declarada\n",$1);
                exit(-1);
            }
            insertarEnPolaca($2); 
            cantVariableAsignadas = 0;
            printf("Sentencia correcto\n");    
        }
	| bloque_while {insertarEnPolaca("END_WHILE") ;printf("Sentencia correcto\n");}
	| lectura PUNTOCOMA {
        insertarEnPolaca("LEER"); 
        printf("Sentencia correcto\n");
    }
	| escritura PUNTOCOMA {insertarEnPolaca("ESCRIBIR") ;printf("Sentencia correcto\n");}

funcion:
    TRIANGULO PA expresion_aritmetica comaN1 expresion_aritmetica comaN2 expresion_aritmetica n3 PC 
    {
        agregarCteStringATabla("_equilatero", CTE_STRNG);
        agregarCteStringATabla("_isosceles", CTE_STRNG);
        agregarCteStringATabla("_escaleno", CTE_STRNG);
        tipoVariable = String;
        agregarATabla("@temp");
        calcularTipoTriangulo();
        cantVariableAsignadas = 1;
        strcpy(tiposVariablesAsignadas[0], String);
        printf("Funcion correcto\n");
    }
    | sumaUltimos PA pivot PUNTOCOMA CA lista_numeros CC PC
    {
        finalizarSumaLosUltimos();
        cantVariableAsignadas = 1;
        strcpy(tiposVariablesAsignadas[0], Float);
        insertarEnPolaca("FIN_SUMALOSULTIMOS");
        printf("Funcion correcto\n");
    }

sumaUltimos:
    SUMALOSULTIMOS {
        insertarEnPolaca("SUMALOSULTIMOS");
        printf("SumaUltimos correcto\n");
    }

comaN1:
    COMA {
        insertarEnPolaca("@n1");
        tipoVariable = Float;
        agregarATabla("@n1");
        insertarEnPolaca(":=");
        printf("ComaN1 correcto\n");
    }


comaN2:
    COMA {
        insertarEnPolaca("@n2");
        tipoVariable = Float;
        agregarATabla("@n2");
        insertarEnPolaca(":=");
        printf("ComaN2 correcto\n");
    }

n3:
    {
        insertarEnPolaca("@n3");
        tipoVariable = Float;
        agregarATabla("@n3");
        insertarEnPolaca(":=");
        printf("N3 correcto\n");
    }

pivot:
 CTE {
    agregarCteIntATabla($1,CTE_INT);
    pivotito = $1-1;
    printf("Pivot correcto\n");
    }
 | OP_RES pivot %prec MENOS_UNARIO  // Agrega esta línea para el operador unario negativo
    {
        banderaTerminar = 1;
        printf("Pivot negativo correcto\n");
    }

lista_numeros:
    valor_lista {
        printf("Lista_numeros correcto\n");
    }
    | lista_numeros COMA valor_lista {
        printf("Lista_numeros correcto\n");
    }

valor_lista:
    CTE {
        agregarCteIntATabla($1,CTE_INT);
        insertarSumaLosUltimos($1);
        printf("Valor_lista correcto\n");
    }
    | CONST_REAL {
        agregarCteFloatATabla($1,CTE_FLOAT);
        insertarSumaLosUltimos($1);
        printf("Valor_lista correcto\n");
    }

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
        char nuevoValor[100];
        sprintf(nuevoValor, "_%.2f", $1);
        strcpy(tiposVariablesAsignadas[cantVariableAsignadas], Float);
        cantVariableAsignadas++;
        insertarEnPolaca(nuevoValor);
        agregarCteFloatATabla($1, CTE_FLOAT);
        printf("Factor correcto\n");
    }
    | CONST_STRING
    {
        char nuevoValor[100];
        sprintf(nuevoValor, "_%s", $1);
        strcpy(tiposVariablesAsignadas[cantVariableAsignadas], String);
        cantVariableAsignadas++;
        insertarEnPolaca(nuevoValor);
        reemplazarEspaciosConGuion($1);
        agregarCteStringATabla(nuevoValor, CTE_STRNG);
        printf("Factor correcto\n");
    }
    | CTE
    {
        char nuevoValor[100];
        sprintf(nuevoValor, "_%d", $1);
        strcpy(tiposVariablesAsignadas[cantVariableAsignadas], Int);
        cantVariableAsignadas++;
        insertarEnPolaca(nuevoValor);
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
    si PA expresion_logica PC lla_If bloque LLC 
    {
        escribirEnPolacaPosString("INICIO_IF",posInicioBloque[nroPilaAnidado]);
        while(topePilaAnidado[nroPilaAnidado] >= 0){
            valorPilaGci valorAct = matrizAnidados[nroPilaAnidado][topePilaAnidado[nroPilaAnidado]];
            escribirEnPolacaPos(valorAct.valor == -1 ? cantItemsGCI : valorAct.valor, valorAct.posicion);
            topePilaAnidado[nroPilaAnidado]--;
        }
        vectOR[nroPilaAnidado] = 0;
        nroPilaAnidado--;
        printf("Bloque_if correcto\n");
    }
    | si PA expresion_logica PC lla_If bloque LLC SINO inicio_else bloque LLC 
    {
        escribirEnPolacaPosString("INICIO_IFELSE",posInicioBloque[nroPilaAnidado]);
        while(topePilaAnidado[nroPilaAnidado] >= 0){
            valorPilaGci valorAct = matrizAnidados[nroPilaAnidado][topePilaAnidado[nroPilaAnidado]];
            escribirEnPolacaPos(valorAct.valor == -1 ? cantItemsGCI : valorAct.valor, valorAct.posicion);
            topePilaAnidado[nroPilaAnidado]--;
        }
        vectOR[nroPilaAnidado] = 0;
        nroPilaAnidado--;
        printf("Bloque_if correcto\n");
    }

lla_If:
    LLA {
        if(vectOR[nroPilaAnidado] == 1){
            matrizAnidados[nroPilaAnidado][0].valor = cantItemsGCI;
        }
        insertarEnPolaca("THEN");
        printf("Lla_If correcto\n");
    }

si:
    SI {
        nroPilaAnidado++;
        posInicioBloque[nroPilaAnidado] = cantItemsGCI;
        insertarEnPolaca("BLANCO");
    }

inicio_else:
    LLA {
        insertarEnPolaca("BI");
        int auxBI = cantItemsGCI;
        insertarEnPolaca("BLANCO");

        if(vectOR[nroPilaAnidado] != 1 && topePilaAnidado[nroPilaAnidado] > 0){
            matrizAnidados[nroPilaAnidado][0].valor = cantItemsGCI;
            matrizAnidados[nroPilaAnidado][1].valor = cantItemsGCI;
        }else{
            escribirEnPolacaPos(cantItemsGCI, matrizAnidados[nroPilaAnidado][topePilaAnidado[nroPilaAnidado]].posicion);
            topePilaAnidado[nroPilaAnidado]--;
        }

        apilarGCI(-1,auxBI);
        insertarEnPolaca("ELSE");
        printf("Inicio_else correcto\n");
    }

expresion_logica:
    termino_logico op_and termino_logico 
        {
            insertarEnPolaca("BLANCO");
            printf("Expresion_logica correcto\n");
        }
    | termino_logico op_or termino_logico
        {
            insertarEnPolaca("BLANCO");
            printf("Expresion_logica correcto\n");
        } 
    | OP_NOT termino_logico 
        {
            int cambio = 0;

            if(strcmp(vectGCI[cantItemsGCI-1],"BNE") == 0){
                strcpy(vectGCI[cantItemsGCI-1], "BEQ");
                cambio = 1;
            }
    
            if(strcmp(vectGCI[cantItemsGCI-1],"BEQ") == 0 && cambio == 0){
                strcpy(vectGCI[cantItemsGCI-1], "BNE");
                cambio = 1;
            }
    
            if(strcmp(vectGCI[cantItemsGCI-1],"BLE") == 0 && cambio == 0){
                strcpy(vectGCI[cantItemsGCI-1], "BGT");
                cambio = 1;
            }
    
            if(strcmp(vectGCI[cantItemsGCI-1],"BGE") == 0 && cambio == 0){
                strcpy(vectGCI[cantItemsGCI-1], "BLT");
            }
    
            insertarEnPolaca("BLANCO");
            printf("Expresion_logica correcto\n");
        }
    | termino_logico
        {
            insertarEnPolaca("BLANCO");
            printf("Expresion_logica correcto\n");
        }

op_and:
    OP_AND {
        insertarEnPolaca("BLANCO");
        printf("Op_and correcto\n");
    }

op_or:
    OP_OR {
        int cambio = 0;
        vectOR[nroPilaAnidado] = 1;

        if(strcmp(vectGCI[cantItemsGCI-1],"BNE") == 0){
            strcpy(vectGCI[cantItemsGCI-1], "BEQ");
            cambio = 1;
        }

        if(strcmp(vectGCI[cantItemsGCI-1],"BEQ") == 0 && cambio == 0){
            strcpy(vectGCI[cantItemsGCI-1], "BNE");
            cambio = 1;
        }

        if(strcmp(vectGCI[cantItemsGCI-1],"BLE") == 0 && cambio == 0){
            strcpy(vectGCI[cantItemsGCI-1], "BGT");
            cambio = 1;
        }

        if(strcmp(vectGCI[cantItemsGCI-1],"BGE") == 0 && cambio == 0){
            strcpy(vectGCI[cantItemsGCI-1], "BLT");
        }

        insertarEnPolaca("BLANCO");
        printf("Op_or correcto\n");
    }

termino_logico:
    expresion_aritmetica comp_bool expresion_aritmetica 
    {
        chequearTiposComp();
        cantVariableAsignadas = 0;

        insertarEnPolaca("CMP"); 
        insertarEnPolaca(branchActual);
        apilarGCI(-1,cantItemsGCI);
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
    mientras inicio_parent expresion_logica PC lla_while bloque LLC 
    {
        insertarEnPolaca("BI");
        while(topePilaAnidado[nroPilaAnidado] > 0){
            valorPilaGci valorAct = matrizAnidados[nroPilaAnidado][topePilaAnidado[nroPilaAnidado]];
            escribirEnPolacaPos(valorAct.valor == -1 ? cantItemsGCI+1 : valorAct.valor, valorAct.posicion);
            topePilaAnidado[nroPilaAnidado]--;
        }
        insertarEnPolacaInt(matrizAnidados[nroPilaAnidado][topePilaAnidado[nroPilaAnidado]].valor-1);
        topePilaAnidado[nroPilaAnidado]--;
        nroPilaAnidado--;
        printf("Bloque_while correcto\n");
    }

lla_while:
    LLA {
        if(vectOR[nroPilaAnidado] == 1){
            matrizAnidados[nroPilaAnidado][1].valor = cantItemsGCI;
        }
        printf("Lla_If correcto\n");
    }

mientras:
    MIENTRAS {
        insertarEnPolaca("INICIO_WHILE");
        nroPilaAnidado++;
        printf("Mientras correcto\n");
    }

inicio_parent:
    PA {
        apilarGCI(cantItemsGCI,-1);
    }

lectura:
    LEER PA ID PC { 
        int pos = buscarEnTabla($3);
        if(pos == -1){
            printf("Variable %s no declarada\n",$3); 
            exit(-1);
        }

        insertarEnPolaca($3);
        printf("Lectura correcto\n");
    }

escritura:
    ESCRIBIR PA valor_escritura PC { printf("Escritura correcto\n");}

valor_escritura:
    ID {
        int pos = buscarEnTabla($1);  

        if(pos == -1 ){
            printf("Variable %s no declarada\n",$1);
            exit(-1);
        }

        insertarEnPolaca($1);
        printf("Valor_escritura correcto\n");
    }
    | CONST_STRING 
    {
        char nuevoValor[100];
        sprintf(nuevoValor, "_%s", $1);
        reemplazarEspaciosConGuion(nuevoValor);
        insertarEnPolaca(nuevoValor);
        agregarCteStringATabla(nuevoValor, CTE_STRNG);
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
    sprintf(valorStr, "_%d", valor);

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

    char valorStr[20];
    sprintf(valorStr, "_%.2f", valor);
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
        if(strstr(nombre, "@") != NULL){
            return;
        }
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
            
            if((strcmp(tabla[posEnTabla].tipo, Float) == 0 && 
               strcmp(tiposVariablesAsignadas[i], Int) == 0) ||
               (strcmp(tabla[posEnTabla].tipo, Int) == 0 && 
               strcmp(tiposVariablesAsignadas[i], Float) == 0)
               ){
                return 0;
            }

            printf("Error: Asignacion de tipos incompatibles\n");
            exit(-1);
        }
    }
    return 0;
}

int chequearTiposComp(){
    if(cantVariableAsignadas == 1){
        return 0;
    }

    printf("Comparando tipos %s %s\n", tiposVariablesAsignadas[0], tiposVariablesAsignadas[1]);

    if(strcmp(tiposVariablesAsignadas[0], tiposVariablesAsignadas[1]) != 0){
        if((strcmp(tiposVariablesAsignadas[0], Float) == 0 && 
           strcmp(tiposVariablesAsignadas[1], Int) == 0) ||
           (strcmp(tiposVariablesAsignadas[0], Int) == 0 && 
           strcmp(tiposVariablesAsignadas[1], Float) == 0)
           ){
            return 0;
        }

        printf("Error: Comparacion de tipos incompatibles\n");
        exit(-1);
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
}

void apilarGCI(int valor,int posicion){
    topePilaAnidado[nroPilaAnidado]++;
    matrizAnidados[nroPilaAnidado][topePilaAnidado[nroPilaAnidado]].valor = valor;
    matrizAnidados[nroPilaAnidado][topePilaAnidado[nroPilaAnidado]].posicion = posicion;
}

void escribirEnPolacaPosString(char* valorTerminal, int pos){
    printf("Escribiendo en polaca: %s %d\n", valorTerminal, pos);
    strcpy(vectGCI[pos], valorTerminal);
}

void escribirEnPolacaPos(int valorTerminal, int pos){
    printf("Escribiendo en polaca: %d %d\n", valorTerminal, pos);
    char valorStr[20];
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

    int i = pivotito,bandPrimeraVez = 0;
    char nuevoValor[100];

    for(i; i < cantElementos; i++){
        if(bandPrimeraVez == 0){
            sprintf(nuevoValor, "_%.2f", sumaLosUltimos[i]);
            insertarEnPolaca(nuevoValor);
            bandPrimeraVez = 1;
        }else{
            sprintf(nuevoValor, "_%.2f", sumaLosUltimos[i]);
            insertarEnPolaca(nuevoValor);
            insertarEnPolaca("+");
        }
    }
}

void calcularTipoTriangulo(){
    insertarEnPolaca("INICIO_TRIANGULO");
    insertarEnPolaca("@n1");
    insertarEnPolaca("@n2");
    insertarEnPolaca("CMP");
    insertarEnPolaca("BNE");
    insertarEnPolacaInt(cantItemsGCI+14);
    insertarEnPolaca("@n2");
    insertarEnPolaca("@n3");
    insertarEnPolaca("CMP");
    insertarEnPolaca("BNE");
    insertarEnPolacaInt(cantItemsGCI+4);
    insertarEnPolaca("equilatero");
    insertarEnPolaca("BI");
    insertarEnPolacaInt(cantItemsGCI+25);
    insertarEnPolaca("SALTO1");
    insertarEnPolaca("isosceles");
    insertarEnPolaca("BI");
    insertarEnPolacaInt(cantItemsGCI+21);
    insertarEnPolaca("SALTO2");
    insertarEnPolaca("@n2");
    insertarEnPolaca("@n3");
    insertarEnPolaca("CMP");
    insertarEnPolaca("BNE");
    insertarEnPolacaInt(cantItemsGCI+4);
    insertarEnPolaca("isosceles");
    insertarEnPolaca("BI");
    insertarEnPolacaInt(cantItemsGCI+12);
    insertarEnPolaca("SALTO3");
    insertarEnPolaca("@n1");
    insertarEnPolaca("@n3");
    insertarEnPolaca("CMP");
    insertarEnPolaca("BNE");
    insertarEnPolacaInt(cantItemsGCI+4);
    insertarEnPolaca("isosceles");
    insertarEnPolaca("BI");
    insertarEnPolacaInt(cantItemsGCI+3);
    insertarEnPolaca("SALTO4");
    insertarEnPolaca("escaleno");
    insertarEnPolaca("FIN_TRIANGULO");
    insertarEnPolaca("@temp");
}

void mostrarPila(){
    int i;
    for(i = 0; i <= topeGCI; i++){
        printf("%d\n", pilaGCI[i]);
    }
}

void mostrarPilaGCI(){
    int i;
    for(i = 0; i < cantItemsGCI; i++){
        printf("%s\n", vectGCI[i]);
    }
}

void eliminarComillas(char* cadena) {
    int i = 0, j = 0;

    while (cadena[i]) {
        if (cadena[i] != '"') {
            cadena[j] = cadena[i];
            j++;
        }
        i++;
    }

    cadena[j] = '\0';
}

void reemplazarEspaciosConGuion(char* cadena) {
    int i = 0;
    
    // Recorremos la cadena
    while (cadena[i]) {
        // Si encontramos un espacio, lo reemplazamos por '_'
        if (cadena[i] == ' ') {
            cadena[i] = '_';
        }
        i++;
    }
}

void generarAssembler(){
    FILE* arch = fopen("asm/Final.asm", "wt");

    if(!arch){
		printf("No pude crear el archivo assembler\n");
		return;
	}

    escribirInicio(arch);

    escribirTabla(arch);

    escribirInicioCodigo(arch);

    recorrerGci(arch);

    escribirFinalCodigo(arch);

    fclose(arch);
}


void escribirInicio(FILE* arch){
    fprintf(arch, "include number.asm\ninclude macros2.asm\n\n.MODEL LARGE\n.386\n.STACK 200h\n\n");
}

void escribirTabla(FILE* arch){
    fprintf(arch, ".DATA\n@aux dd ?\n");
    int i;

    for(i=0; i<cantVarInsertadas; i++){
        eliminarComillas(tabla[i].nombre);
        char valorVariable[100];
        strcpy(valorVariable,tabla[i].nombre);
        eliminarGuion(valorVariable);

        if (strcmp(tabla[i].tipo, CTE_INT) == 0) {
            fprintf(arch, "%s ", tabla[i].nombre);
            fprintf(arch, "dd %.2f\n", atof(valorVariable));
        }

        if (strcmp(tabla[i].tipo, CTE_FLOAT) == 0) {
            fprintf(arch, "%s ", tabla[i].nombre);
            fprintf(arch, "dd %.2f\n", atof(valorVariable));
        }

        if (strcmp(tabla[i].tipo, CTE_STRNG) == 0) {
            fprintf(arch, "%s ", tabla[i].nombre);
            fprintf(arch, "db \"%s\",'$'\n", valorVariable);
        }

        if (strcmp(tabla[i].tipo, String) == 0) {
            fprintf(arch, "%s ", tabla[i].nombre);
            fprintf(arch, "dd ?\n");
        }

        if (strcmp(tabla[i].tipo, Int) == 0 || strcmp(tabla[i].tipo, Float) == 0) {
            fprintf(arch, "%s ", tabla[i].nombre);
            fprintf(arch, "dd ?\n");
        }
    }
}

void escribirInicioCodigo(FILE* arch){
    fprintf(arch, "\n.CODE\nmain PROC\nmov AX, @DATA\nmov DS, AX\n\n");
}

int esSimboloBinario(char* simbolo){
    return strcmp(simbolo, "+") == 0 || strcmp(simbolo, "-") == 0 || strcmp(simbolo, "*") == 0 || strcmp(simbolo, "/") == 0;
}

void recorrerGci(FILE* archAsm){
    int i;
    t_pila pila;
    t_pila pilaCondicionales;
    crearPila(&pila);
    crearPila(&pilaCondicionales);
    int saltoActual = 0;
    int varPila;

    int contSaltoTriangulo = 1;

    for(i = 0; i < cantItemsGCI; i++){
        if(strstr(vectGCI[i], "SEN") != NULL){
            continue;
        }

        if(strstr(vectGCI[i], "SALTO") != NULL){
            verTope(&pilaCondicionales, sizeof(int), &varPila);
            fprintf(archAsm, "%s%d:\n", vectGCI[i],varPila);
            continue;
        }

        if(!esSimboloBinario(vectGCI[i]) && strcmp(vectGCI[i], ":=") != 0 && strcmp(vectGCI[i], "CMP") != 0 && strcmp(vectGCI[i], "BI") != 0 && strcmp(vectGCI[i], "END_IF") != 0 && strcmp(vectGCI[i], "END_WHILE") != 0 && strcmp(vectGCI[i], "INICIO_IF") != 0 && strcmp(vectGCI[i], "INICIO_WHILE") != 0 && strcmp(vectGCI[i], "INICIO_IFELSE") != 0 && strcmp(vectGCI[i], "ELSE") != 0 && strcmp(vectGCI[i], "FIN_TRIANGULO") != 0 && strcmp(vectGCI[i], "INICIO_TRIANGULO") != 0 && strcmp(vectGCI[i], "equilatero") != 0 && strcmp(vectGCI[i], "isosceles") != 0 && strcmp(vectGCI[i], "escaleno") != 0 && strcmp(vectGCI[i], "THEN") != 0 && strcmp(vectGCI[i], "LEER") != 0 && strcmp(vectGCI[i], "ESCRIBIR") != 0 && strcmp(vectGCI[i], "FIN_SUMALOSULTIMOS") != 0 && strcmp(vectGCI[i], "SUMALOSULTIMOS") != 0){  

            apilar(&pila, sizeof(vectGCI[i]), vectGCI[i]);

        }else{
            if(esSimboloBinario(vectGCI[i])){
                char op2[100],op1[100];

                desapilar(&pila,sizeof(op2),&op2);

                desapilar(&pila,sizeof(op1),&op1);

                fprintf(archAsm, "fld %s\n", op1);
                fprintf(archAsm, "fld %s\n",op2);

                fprintf(archAsm, "%s\n",getSymbolIns(vectGCI[i]));

                char resultadoTemporal[100];
                sprintf(resultadoTemporal, "@aux"); // Etiqueta temporal única
                fprintf(archAsm, "fstp %s\n", resultadoTemporal); // Guardar el resultado en la etiqueta temporal
                apilar(&pila, sizeof(resultadoTemporal), resultadoTemporal);
            }

            if(strcmp(vectGCI[i], "ESCRIBIR") == 0){
                char op1[100];
                desapilar(&pila,sizeof(op1),&op1);

                int pos = buscarEnTabla(op1);

                if(strcmp(tabla[pos].tipo, Int) == 0 || strcmp(tabla[pos].tipo, Float) == 0 || strcmp(tabla[pos].tipo, CTE_INT) == 0 || strcmp(tabla[pos].tipo, CTE_FLOAT) == 0){
                    fprintf(archAsm, "DisplayFloat %s\n",op1);
                }else{
                    fprintf(archAsm, "DisplayString %s\n",op1);
                }

            }

            if(strcmp(vectGCI[i], "LEER") == 0){
                char op1[100];
                desapilar(&pila,sizeof(op1),&op1);

                int pos = buscarEnTabla(op1);

                if(strcmp(tabla[pos].tipo, Int) == 0 || strcmp(tabla[pos].tipo, Float) == 0){
                    fprintf(archAsm, "GetFloat %s\n",op1);
                }else{
                    fprintf(archAsm, "getString %s\n",op1);
                }
            }

            if(strcmp(vectGCI[i], ":=") == 0){
                char op2[100],op1[100];
                desapilar(&pila,sizeof(op2),&op2);
                desapilar(&pila,sizeof(op1),&op1);

                int pos = buscarEnTabla(op2);

                if(strcmp(tabla[pos].tipo, Int) == 0 || strcmp(tabla[pos].tipo, Float) == 0){
                    fprintf(archAsm, "fld %s\n",op1);
                    fprintf(archAsm, "fstp %s\n",op2);
                }else{
                    fprintf(archAsm, "lea EAX, %s\n",op2);
                    fprintf(archAsm, "mov %s, EAX\n",op1);
                }

            }

            if(strcmp(vectGCI[i],"INICIO_IF") == 0){
                apilar(&pilaCondicionales, sizeof(int), &saltoActual);
                fprintf(archAsm, "INICIO_IF%d:\n",saltoActual);
                saltoActual++;
            }

            if(strcmp(vectGCI[i],"INICIO_IFELSE") == 0){
                apilar(&pilaCondicionales, sizeof(int), &saltoActual);
                fprintf(archAsm, "INICIO_IF%d:\n",saltoActual);
                saltoActual++;
            }

            if(strcmp(vectGCI[i],"INICIO_WHILE") == 0){
                apilar(&pilaCondicionales, sizeof(int), &saltoActual);
                fprintf(archAsm, "INICIO_WHILE%d:\n",saltoActual);
                saltoActual++;
            }

            if(strcmp(vectGCI[i],"INICIO_TRIANGULO") == 0){
                fprintf(archAsm, "INICIO_TRIANGULO%d:\n",saltoActual);
                apilar(&pilaCondicionales, sizeof(int), &saltoActual);
                saltoActual++;
            }

            if(strcmp(vectGCI[i],"CMP") == 0){
                char op2[100],op1[100];
                desapilar(&pila,sizeof(op2),&op2);
                desapilar(&pila,sizeof(op1),&op1);

                fprintf(archAsm, "fld %s\n",op1);
                fprintf(archAsm, "fld %s\n",op2);
                fprintf(archAsm, "fxch\n");
                fprintf(archAsm, "fcom\n");
                fprintf(archAsm, "fstsw ax\n");
                fprintf(archAsm, "sahf\n");

                int posSalto = atoi(vectGCI[i+2]);
                verTope(&pilaCondicionales,sizeof(int),&varPila);

                fprintf(archAsm, "%s %s%d\n",getSymbolIns(vectGCI[i+1]),vectGCI[posSalto],varPila);
            }

            if(strcmp(vectGCI[i],"BI") == 0){
                int posSalto = atoi(vectGCI[i+1]);
                verTope(&pilaCondicionales,sizeof(int),&varPila);
                fprintf(archAsm, "JMP %s%d\n",vectGCI[posSalto],varPila);
            }

            if(strcmp(vectGCI[i],"ELSE") == 0){
                verTope(&pilaCondicionales,sizeof(int),&varPila);
                fprintf(archAsm, "ELSE%d:\n",varPila);
            }

            if(strcmp(vectGCI[i],"THEN") == 0){
                verTope(&pilaCondicionales,sizeof(int),&varPila);
                fprintf(archAsm, "THEN%d:\n",varPila);
            }

            if(strcmp(vectGCI[i],"END_IF") == 0){
                desapilar(&pilaCondicionales,sizeof(int),&varPila);
                fprintf(archAsm, "END_IF%d:\n",varPila);
            }

            if(strcmp(vectGCI[i],"END_WHILE") == 0){
                desapilar(&pilaCondicionales,sizeof(int),&varPila);
                fprintf(archAsm, "END_WHILE%d:\n",varPila);
            }

            if(strcmp(vectGCI[i],"FIN_TRIANGULO") == 0){
                desapilar(&pilaCondicionales,sizeof(int),&varPila);
                fprintf(archAsm, "FIN_TRIANGULO%d:\n",varPila);
            }

            if(strcmp(vectGCI[i],"equilatero") == 0 || strcmp(vectGCI[i],"isosceles") == 0 || strcmp(vectGCI[i],"escaleno") == 0){
                fprintf(archAsm, "lea EAX, _%s\n",vectGCI[i]);
                fprintf(archAsm, "mov temp, EAX\n");
            }

            if(strcmp(vectGCI[i],"SUMALOSULTIMOS") == 0){
                fprintf(archAsm, "%s:\n",vectGCI[i]);
            }

            if(strcmp(vectGCI[i],"FIN_SUMALOSULTIMOS") == 0){
                fprintf(archAsm, "%s:\n",vectGCI[i]);
            }

        }
        
    }
}

char* getSymbolIns(char* simbolo){
    if(strcmp(simbolo,"+") == 0){
        return "fadd";
    }

    if(strcmp(simbolo,"-") == 0){
        return "fsub";
    }

    if(strcmp(simbolo,"*") == 0){
        return "fmul";
    }

    if(strcmp(simbolo,"/") == 0){
        return "fdiv";
    }
    
    if(strcmp(simbolo,"BNE") == 0){
        return "JNE";
    }

    if(strcmp(simbolo,"BEQ") == 0){
        return "JE";
    }

    if(strcmp(simbolo,"BLE") == 0){
        return "JNA";
    }

    if(strcmp(simbolo,"BGE") == 0){
        return "JAE";
    }

    if(strcmp(simbolo,"BGT") == 0){
        return "JA";
    }

    if(strcmp(simbolo,"BLT") == 0){
        return "JB";
    }

}


escribirFinalCodigo(FILE* arch){
    fprintf(arch, "\n\nMOV AX, 4c00h\nINT 21h\nmain ENDP\nEND main\n");
}

void eliminarGuion(char *cadena) {
    if (cadena[0] == '_') {
        memmove(cadena, cadena + 1, strlen(cadena));
    }
}


void inicializarTopesPila(){
    int i;
    for(i = 0; i < 30; i++){
        topePilaAnidado[i] = -1;
    }
}

int main(int argc, char *argv[]){
    if((yyin = fopen(argv[1], "rt"))==NULL){
        printf("\nNo se puede abrir el archivo de prueba: %s\n", argv[1]);
    }else{
        inicializarTopesPila();
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