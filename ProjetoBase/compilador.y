
// Testar se funciona corretamente o empilhamento de par�metros
// passados por valor ou por refer�ncia.


%{
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>
#include "compilador.h"

int cont_amem;
int nivel_lexico = 0;
int desloc;
int tam_TS;
tab_simbolos* topo_TS;  // Ponteiro para o topo da tabela de simbolos
tab_simbolos* var_attr; // Ponteiro para a variável que receberá valor

%}

%token PROGRAM LABEL ABRE_PARENTESES FECHA_PARENTESES
%token TYPE ARRAY OF PROCEDURE FUNCTION GOTO
%token IF THEN ELSE WHILE DO
%token SOMA SUBTRAI MULT DIV AND OR NOT
%token IGUAL DIFERE MENOR MENOR_IGUAL MAIOR MAIOR_IGUAL
%token VIRGULA PONTO_E_VIRGULA DOIS_PONTOS PONTO
%token T_BEGIN T_END VAR IDENT ATRIBUICAO NUM

%%

programa    : {geraCodigo (NULL, "INPP");}
              PROGRAM IDENT
              ABRE_PARENTESES lista_idents FECHA_PARENTESES PONTO_E_VIRGULA
              bloco PONTO {geraCodigo (NULL, "PARA");}
;

bloco       : parte_declara_vars
              {}
              comando_composto
;

parte_declara_vars:  var
;

var         : {desloc = -1;} VAR declara_vars
            |
;

declara_vars: declara_vars declara_var
            | declara_var
;

declara_var : { cont_amem = 0;}
              lista_id_var DOIS_PONTOS
              tipo
              {
               char amem[] = "AMEM ";
               int size = snprintf(NULL, 0, "%d", cont_amem);
               char* n_amem = malloc( size + 1 );
               snprintf(n_amem, size +1, "%d", cont_amem); //Converts int to string
               strcat (amem, n_amem); 
               geraCodigo(NULL, amem);
               cont_amem = 0;
              }
              PONTO_E_VIRGULA
;

tipo        : IDENT
              {
               int aux = cont_amem;
               tab_simbolos* walker = topo_TS;
               while(aux != 0){
                  if(strcmp(token, "integer") == 0)
                     walker->atributos[2] = INTEIRO;
                  else
                     if(strcmp(token, "boolean") == 0)
                        walker->atributos[2] = BOOLEANO;
                     else{
                        printf("Tipo %s inválido\n", token);
                        exit (0);
                     }
                  aux--;
                  walker = walker->prox;
               }
              }
;

lista_id_var: lista_id_var VIRGULA IDENT
              {
               desloc ++;
               cont_amem++;
               int attrs[TAM_ATTRS];
               attrs[0] = nivel_lexico;
               attrs[1] = desloc;
               insere_tab(token, simb_var, attrs);
              }
            | IDENT
              {
               desloc ++;
               cont_amem++;
               int attrs[TAM_ATTRS];
               attrs[0] = nivel_lexico;
               attrs[1] = desloc;
               insere_tab(token, simb_var, attrs);
              }
;

lista_idents: lista_idents VIRGULA IDENT
            | IDENT
;


comando_composto: T_BEGIN comandos T_END
;

comandos: comandos comando 
        | comando
;

comando: NUM DOIS_PONTOS comando_sem_rotulo
       | comando_sem_rotulo
;

comando_sem_rotulo: atribuicao
                  //| chama_proc
                  //| desvio
                  //| com_composto
                  //| com_condicional
                  //| com_repetitivo
;

atribuicao: IDENT
            {  
               var_attr = busca_tab(token);
               if (var_attr == NULL){
                  printf("Erro: variavel %s nao foi declarada\n", token);
                  exit(0);
               }
               else{
                  if (var_attr->categoria != simb_var){
                     if (var_attr->categoria != simb_function){
                        if (var_attr->categoria != simb_function){
                           printf("Erro: Atribuicao somente para variaveis simples, parametros formais ou funcoes\n");
                           exit(0);
                        }
                     }
                  }
               }
            }
            ATRIBUICAO expressao 
            {
               char armz[100];
               sprintf(armz, "ARMZ %d,%d", var_attr->atributos[0], var_attr->atributos[1]);
               geraCodigo(NULL, armz); // ARMZ nl,desloc
               var_attr = NULL;  
            }   
            PONTO_E_VIRGULA
;

lista_expressoes: lista_expressoes VIRGULA expressao
                | expressao
;

expressao: expressao_simples
         | expressao_simples relacao expressao_simples
;

expressao_simples: termos_encadeados
                 | SOMA termos_encadeados
                 | SUBTRAI termos_encadeados
;

termos_encadeados: termos_encadeados SOMA termo
                 | termos_encadeados SUBTRAI termo
                 | termos_encadeados OR termo
                 | termo
;

termo: termo MULT fator
     | termo DIV fator
     | termo AND fator
     | fator
;

fator: variavel
     | numero
;

variavel :  IDENT
            {
               tab_simbolos* var_tmp = busca_tab(token);
               if (var_tmp == NULL){
                  printf("Erro: variavel %s nao foi declarada\n", token);
                  exit(0);
               }
               char crvl[100];
               sprintf(crvl, "CRVL %d,%d", var_tmp->atributos[0], var_tmp->atributos[1]);
               geraCodigo(NULL, crvl); // CRVL nl,desloc
               var_tmp = NULL;
            }
         //|  IDENT lista_expressoes
;

numero:  NUM
         {
            char crct[] = "CRCT ";
            strcat(crct, token);
            geraCodigo(NULL, crct); // CRCT n
         }
;

relacao: IGUAL {
            geraCodigo(NULL, "CMIG");
         }
       | DIFERE{
            geraCodigo(NULL, "CMDG");
         }
       | MENOR{
            geraCodigo(NULL, "CMME");
         }
       | MENOR_IGUAL{
            geraCodigo(NULL, "CMEG");
         }
       | MAIOR{
            geraCodigo(NULL, "CMMA");
         }
       | MAIOR_IGUAL{
            geraCodigo(NULL, "CMAG");
         }
;

chama_proc:
;

desvio:
;

com_composto:
;

com_condicional:
;

com_repetitivo:
;

%%

int main (int argc, char** argv) {
   FILE* fp;
   extern FILE* yyin;

   if (argc<2 || argc>2) {
         printf("usage compilador <arq>a %d\n", argc);
         return(-1);
      }

   fp=fopen (argv[1], "r");
   if (fp == NULL) {
      printf("usage compilador <arq>b\n");
      return(-1);
   }


/* -------------------------------------------------------------------
 *  Inicia a Tabela de S�mbolos
 * ------------------------------------------------------------------- */
   init_ts();

   yyin=fp;
   yyparse();

   limpa_ts();

   return 0;
}
