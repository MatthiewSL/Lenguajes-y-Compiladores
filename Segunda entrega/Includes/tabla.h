#ifndef INCLUDE_TABLA_H_
#define INCLUDE_TABLA_H_

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
int agregarCteIntATabla(int valor, char* tipo);
int agregarCteFloatATabla(float valor, char* tipo);
int agregarCteStringATabla(char* valor, char* tipo);
int buscarEnTabla(char * name);
int chequearTipos(int posEnTabla);


#endif // INCLUDE_TABLA_H