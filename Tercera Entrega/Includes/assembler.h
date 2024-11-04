#ifndef INCLUDE_ASSEMBLER_H
#define INCLUDE_ASSEMBLER_H

void generarAssembler();
void escribirInicio(FILE* arch);
void escribirTabla(FILE* arch);
void escribirInicioCodigo(FILE* arch);
void escribirFinalCodigo(FILE* arch);
void recorrerGci(FILE* archAsm);

#endif