<<<<<<< HEAD
#ifndef INCLUDE_TABLA_H_
#define INCLUDE_TABLA_H_
#define TIPO_STRING STRING
#define TIPO_INT    INT
#define TIPO_FLOAT  FLOAT
#define TIPO_CHAR   CHAR
//CAPAZ TENEMOS QUE CREAR LOS TIPOS CONST PARA CADA UNO, PREGUNTAR
#define TAMANIO_TABLA 300

typedef struct  {
    char nombre[30];
    char tipo[15];
    int longitud;
}CampoTablaSimbolos;

CampoTablaSimbolos tabla[TAMANIO_TABLA];
int cantVarInsertadas=0;

void guardarTabla();
void agregarATabla(char* nombre);
int buscarEnTabla(char * name);


=======
#ifndef INCLUDE_TABLA_H_
#define INCLUDE_TABLA_H_
#define TIPO_STRING STRING
#define TIPO_INT    INT
#define TIPO_FLOAT  FLOAT
#define TIPO_CHAR   CHAR
//CAPAZ TENEMOS QUE CREAR LOS TIPOS CONST PARA CADA UNO, PREGUNTAR
#define TAMANIO_TABLA 300

typedef struct  {
    char nombre[30];
    char tipo[15];
    int longitud;
}CampoTablaSimbolos;

CampoTablaSimbolos tabla[TAMANIO_TABLA];
int cantVarInsertadas=0;

void guardarTabla();
void agregarATabla(char* nombre);
int buscarEnTabla(char * name);


>>>>>>> d5ece5ad09c6c415d2e8f1bd04fc5beb26e72680
#endif // INCLUDE_TABLA_H