#ifndef INCLUDE_GCI_H_
#define INCLUDE_GCI_H_

char vectGCI[500][20];
int cantItemsGCI = 0;

void insertarEnPolaca(char *valorTerminal);
void insertarEnPolacaInt(int valorTerminal);
void insertarEnPolacaFloat(float valorTerminal);
void guardarGCI();

#endif // INCLUDE_GCI_H