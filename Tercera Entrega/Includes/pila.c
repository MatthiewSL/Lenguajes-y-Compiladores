#include "pila.h"

void crearPila(t_pila* p)
{
    *p=NULL;//la pila  apunta a la nada
}

////////////////////////////////////////////////
int pilaVacia(const t_pila* p)
{
    if(*p==NULL)
    {
        return PILA_VACIA;//si esta vacia es verdadero entonces retorna 1
    }

    return PILA_NO_VACIA;//si no esta vacia es falso entonces retorna 0
}
////////////////////////////////////////////////

int pilaLlena(const t_pila*p, unsigned tamDato)
{
    return PILA_NO_LLENA; //tomamos como que nunca se va a llenar por ser memoria dinamica
}

////////////////////////////////////////////////
void vaciarPila(t_pila* p)
{
    t_nodo* elim;
    while(*p)//mientras el puntero sea distinto de null o de 0
    {
        elim=*p;
        *p=elim->sig;
        free(elim->dato);
        free(elim);
    }
}
////////////////////////////////////////////////
int apilar(t_pila* p, unsigned cantBytesDato, const void* dato)
{
    t_nodo* nue;//creo un nood nuevo para almacenar los datos que vienen a la pila desde el main

    if(!(nue = (t_nodo*)malloc(sizeof(t_nodo))) || !(nue->dato = malloc(cantBytesDato)))
    {//pregunto si hay lugar para el nuevo nodo y despues para el dato del main
        free(nue);
        return SIN_MEMORIA;
    }

    memcpy(nue->dato, dato, cantBytesDato);//copio el dato del main en el nuevo nodo con
                                            //el tamanio correspondiente
    nue->tamDato = cantBytesDato;//le asigno al nodo lo que pesa el dato nuevo ingresado
    nue->sig = *p;//el siguiente nodo la primera vez apunta a null

    *p=nue;//luego modifico en el main el valor del nodo siguiente con el valor
            //de donde se guardo el nuevo nodo para que quede unido

    return TODO_BIEN;
}
////////////////////////////////////////////////
int desapilar(t_pila* p, unsigned cantBytesDondeGuardoDato, void* dato)
{
    t_nodo* elim;//creo un nodo en el que se copia todo lo que tiene el ultimo nodo apilado

    if(*p==NULL)//pregunto si esta vacia
    {
        return NO_DESAPILO_PILVACIA;
    }

    memcpy(dato, (*p)->dato, MIN(cantBytesDondeGuardoDato, (*p)->tamDato));//copio los datos a la variable dato del main

    elim = *p;//a eliminar le asigno la direccion de memoria de p

    *p = elim->sig;//a *p le asigno la direccion de memoria del siguiente nodo en la pila

    free(elim->dato);//aca libero el dato guardado del nodo
    free(elim);//aca libero el nodo completo

    return TODO_BIEN;
}
////////////////////////////////////////////////
int verTope(const t_pila* p, unsigned cantBytes, void* dato)
{

    if(*p==NULL)//pregunto si esta vacia
    {
        return NO_HAY_TOPE_PILVACIA;
    }

    memcpy(dato, (*p)->dato, MIN(cantBytes, (*p)->tamDato));

    return TODO_BIEN;
}

