#ifndef INCLUDE_TABLA_H_
#define INCLUDE_TABLA_H_

#define TAMANIO_TABLA 300
#define Int "int"
#define Float "float"
#define String "string"
#define Char "char"
#define CTE_STRNG "CTE_STRING"
#define CTE_INT "CTE_INTEGER"
#define CTE_FLOAT "CTE_FLOAT"

typedef struct  {
    char nombre[30];
    char tipo[15];
    int longitud;
}CampoTablaSimbolos;

CampoTablaSimbolos tabla[TAMANIO_TABLA];
int cantVarInsertadas=0;

void guardarTabla();
void agregarATabla(char* nombre);
int agregarCteIntATabla(int valor, char* tipo);
int agregarCteFloatATabla(float valor, char* tipo);
int agregarCteStringATabla(char* valor, char* tipo);
int buscarEnTabla(char * name);
int chequearTipos(int posEnTabla);
int chequearTiposComp();


#endif // INCLUDE_TABLA_H