#ifndef INCLUDE_TABLA_H_
#define INCLUDE_TABLA_H_

#define TAMANIO_TABLA 300

struct CampoTablaSimbolos {
    char* Nombre;
    char* Tipo;
    int Longitud;
    void* valor;
};

CampoTablaSimbolos* tabla;

void nombreRepetido(char* nombre);
void agregarCteATabla(char* nombre,char* tipo);
void guardarTabla();
void insertarVarATabla(char *nombre, int tipo);
int buscarEnTabla(char * name);


#endif // INCLUDE_TABLA_H_