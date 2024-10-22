#ifndef INCLUDE_ASSEMBLER_H
#define INCLUDE_ASSEMBLER_H

void generarAssembler();
void escribirInicio(FILE* arch);
void escribirTabla(FILE* arch);
// void escribirInicioCodigo(FILE* arch);
// void escribirFinal(FILE *arch);

// void escribirEtiqueta(FILE* arch, char* etiqueta, int n);
// void escribirSalto(FILE* arch, char* salto, int tercetoDestino);
// void asignacion(FILE* arch, int terceto);
// void comparacion(FILE* arch, int terceto);
// void suma(FILE* arch, int terceto);
// void resta(FILE* arch, int terceto);
// void multiplicacion(FILE* arch, int terceto);
// void division(FILE* arch, int terceto);
// void levantarEnPila(FILE* arch, const int ind);
// void write(FILE* arch, int ind);
// void read(FILE* arch, int ind);

//Variables externas
extern CampoTablaSimbolos tabla[TAMANIO_TABLA];
extern int cantVarInsertadas;

#endif