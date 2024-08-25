#ifndef INCLUDE_TABLA_H_
#define INCLUDE_TABLA_H_
#define TIPO_STRING STRING
#define TIPO_INT    INT
#define TIPO_FLOAT  FLOAT
#define TIPO_CHAR   CHAR
//CAPAZ TENEMOS QUE CREAR LOS TIPOS CONST PARA CADA UNO, PREGUNTAR
#define TAMANIO_TABLA 300

typedef struct  {
    char* nombre;
    char* tipo;
    int longitud;
}CampoTablaSimbolos;

CampoTablaSimbolos* tabla;
int cantVarInsertadas=0;

void guardarTabla();
void agregarATabla(char* nombre,char* tipo);
int buscarEnTabla(char * name);


#endif // INCLUDE_TABLA_H_