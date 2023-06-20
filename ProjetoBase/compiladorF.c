
/* -------------------------------------------------------------------
 *            Aquivo: compilador.c
 * -------------------------------------------------------------------
 *              Autor: Bruno Muller Junior
 *               Data: 08/2007
 *      Atualizado em: [09/08/2020, 19h:01m]
 *
 * -------------------------------------------------------------------
 *
 * Funções auxiliares ao compilador
 *
 * ------------------------------------------------------------------- */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "compilador.h"


/* -------------------------------------------------------------------
 *  variáveis globais
 * ------------------------------------------------------------------- */

simbolos simbolo, relacao;
char token[TAM_TOKEN];

FILE* fp=NULL;
void geraCodigo (char* rot, char* comando) {

  if (fp == NULL) {
    fp = fopen ("MEPA", "w");
  }

  if ( rot == NULL ) {
    fprintf(fp, "     %s\n", comando); fflush(fp);
  } else {
    fprintf(fp, "%s: %s \n", rot, comando); fflush(fp);
  }
}

int imprimeErro ( char* erro ) {
  fprintf (stderr, "Erro na linha %d - %s\n", nl, erro);
  exit(-1);
}

void init_ts(){
  topo_TS = NULL;
  cont_TS = 0;
}

void insere_tab(char ident[TAM_TOKEN], simbolos categoria, int attrs[TAM_ATTRS]){
  cont_TS++;
  tab_simbolos *aux = malloc(sizeof(tab_simbolos));
  aux->chave = cont_TS;
  strncpy (aux->ident, ident, TAM_TOKEN);
  aux->categoria = categoria;
  for(int i = 0; i < TAM_ATTRS; i++)
    aux->atributos[i] = attrs[i];
  aux->prox = topo_TS;
  topo_TS = aux;
}

int busca_tab(char ident[TAM_TOKEN]){
  // Procura pelo simbolo com o identificador ident
  for(tab_simbolos *aux = topo_TS; aux != NULL; aux = aux->prox)
    if(strcmp(aux->ident, ident) == 0)
      return aux->chave;
  return 0; //Se não for encontrado retorna zero
}

void remove_tab(int n){
  int aux = n;
  tab_simbolos *aux2 = topo_TS;
  while(aux != 0){
    tab_simbolos *old = aux2;
    aux2 = aux2->prox;
    free(old);
    aux --;
  }
  topo_TS = aux2;
  cont_TS = cont_TS - n;
}

void limpa_ts(){
  tab_simbolos *aux = topo_TS;
  while (aux != NULL){
    tab_simbolos *to_free = aux;
    aux = aux->prox;
    free(to_free);
  }
  topo_TS = NULL;
  cont_TS = 0;
}