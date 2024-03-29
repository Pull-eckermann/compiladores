
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
  tam_TS = 0;
}

//Operações básicas para a tabela de símbolos
void insere_tab(char ident[TAM_TOKEN], simbolos categoria, int attrs[TAM_ATTRS]){
  tab_simbolos *aux = malloc(sizeof(tab_simbolos));
  strncpy (aux->ident, ident, TAM_TOKEN);
  aux->categoria = categoria;
  for(int i = 0; i < TAM_ATTRS; i++)
    aux->atributos[i] = attrs[i];
  aux->prox = topo_TS;
  topo_TS = aux;
  tam_TS++;
}

tab_simbolos* busca_tab(char ident[TAM_TOKEN]){
  // Procura pelo simbolo com o identificador ident
  for(tab_simbolos *aux = topo_TS; aux != NULL; aux = aux->prox)
    if(strcmp(aux->ident, ident) == 0)
      return aux;
  return NULL; //Se não for encontrado retorna NULL
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
  tam_TS -= n;
}

void limpa_ts(){
  tab_simbolos *aux = topo_TS;
  while (aux != NULL){
    tab_simbolos *to_free = aux;
    aux = aux->prox;
    free(to_free);
  }
  topo_TS = NULL;
}

//Operações para a pilha de tipos
void empilha(char *new_regra, tipos tipo){
  pilha_tipos* aux = malloc(sizeof(pilha_tipos));
  strncpy (aux->regra, new_regra, TAM_REGRA);
  aux->tipo = tipo;
  aux->prox = topo_tipos;
  topo_tipos = aux;
}

tipos desempilha(){
  tipos retorno = 0;
  if(topo_tipos == NULL)
    printf("A pilha de tipos esta vazia\n");
  else{
    pilha_tipos *aux = topo_tipos;
    topo_tipos = aux->prox;
    retorno = aux->tipo;
    free(aux);
  }
  return retorno;
}

char* geraRotulo(){
  char * rot = malloc(sizeof(TAM_ROT));
  sprintf(rot, "R%d", next_rot);
  next_rot++;
  return rot;
}

void empilhaRot(char* rotulo){
  pilha_rot* aux = malloc(sizeof(pilha_rot));
  strncpy (aux->rotulo, rotulo, TAM_ROT);
  aux->prox = topo_rot;
  topo_rot = aux;
}

char* desempilhaRot(){
  if(topo_rot == NULL)
    printf("A pilha de rótulos esta vazia\n");
  else{
    pilha_rot *aux = topo_rot;
    topo_rot = aux->prox;
    char *retorno = malloc(sizeof(TAM_ROT));
    strncpy(retorno, aux->rotulo, TAM_ROT);
    free(aux);
    return retorno;
  }
  return 0;
}