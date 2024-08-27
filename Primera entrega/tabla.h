#ifndef INCLUDE_TABLA_H_
#define INCLUDE_TABLA_H_
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


#endif // INCLUDE_TABLA_H