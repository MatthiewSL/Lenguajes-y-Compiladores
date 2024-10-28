#ifndef INCLUDE_GCI_H_
#define INCLUDE_GCI_H_

typedef struct{
    int valor;
    int posicion;
}valorPilaGci;

char vectGCI[500][20];

int pilaGCI[500];
int topeGCI = -1;
int cantItemsGCI = 0;

valorPilaGci matrizIfAnidados[30][3];
int nroPilaIf = -1;
int topePilaIf[30];
int vectOR[30] = {0};

void insertarEnPolaca(char *valorTerminal);
void insertarEnPolacaInt(int valorTerminal);
void insertarEnPolacaFloat(float valorTerminal);
void escribirEnPolacaPos(int valorTerminal, int pos);
void apilarGCI(int valor,int posicion);
void guardarGCI();
void mostrarPila();
void inicializarTopesPila();

#endif // INCLUDE_GCI_H