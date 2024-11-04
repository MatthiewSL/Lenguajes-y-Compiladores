#ifndef BIBLIOTECAS_H_INCLUDED
#define BIBLIOTECAS_H_INCLUDED

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


#define PILA_VACIA 1
#define PILA_NO_VACIA 0
#define PILA_NO_LLENA 0
#define SIN_MEMORIA 0
#define TODO_BIEN 1
#define NO_DESAPILO_PILVACIA 0
#define NO_HAY_TOPE_PILVACIA 0

#define MIN(X,Y) (((X)>(Y))?(Y):(X))

typedef struct s_nodo
{
    unsigned tamDato;
    struct s_nodo* sig;
    void* dato;
}t_nodo;

typedef t_nodo* t_pila;

void crearPila(t_pila* p);///1
int pilaVacia(const t_pila* p);///2
int pilaLlena(const t_pila* p, unsigned tamDato);///3
void vaciarPila(t_pila* p);///4
int apilar(t_pila* p, unsigned tamDato, const void* dato);///5
int desapilar(t_pila* p, unsigned cantBytesDondeGuardoDato, void* dato);///6
int verTope(const t_pila* p, unsigned cantBytesDondeGuardoDato, void* dato);///7


#endif // BIBLIOTECAS_H_INCLUDED
