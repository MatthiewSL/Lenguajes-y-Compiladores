#ifndef INCLUDE_GCI_H_
#define INCLUDE_GCI_H_

char vectGCI[500][20];
int pilaGCI[500];
int topeGCI = -1;
int cantItemsGCI = 0;

void insertarEnPolaca(char *valorTerminal);
void insertarEnPolacaInt(int valorTerminal);
void insertarEnPolacaFloat(float valorTerminal);
void escribirEnPolaca(int valorTerminal, int pos);
void apilarGCI(int valor);
void guardarGCI();
void mostrarPila();

#endif // INCLUDE_GCI_H