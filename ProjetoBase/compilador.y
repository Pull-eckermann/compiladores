
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
int desloc = 0;
tab_simbolos *topo_TS;
int cont_TS;

%}

%token PROGRAM ABRE_PARENTESES FECHA_PARENTESES
%token LABEL TYPE ARRAY OF PROCEDURE FUNCTION GOTO
%token IF THEN ELSE WHILE DO
%token SOMA SUBTRAI MULT DIV AND OR NOT
%token VIRGULA PONTO_E_VIRGULA DOIS_PONTOS PONTO
%token T_BEGIN T_END VAR IDENT ATRIBUICAO

%%

programa    :{geraCodigo (NULL, "INPP");}
             PROGRAM IDENT
             ABRE_PARENTESES lista_idents FECHA_PARENTESES PONTO_E_VIRGULA
             bloco PONTO {geraCodigo (NULL, "PARA");}
;

bloco       :
              parte_declara_vars
              {
              }

              comando_composto
;

parte_declara_vars:  var
;


var         : { } VAR declara_vars
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
;

lista_id_var: lista_id_var VIRGULA IDENT
              {
               desloc ++;
               int attrs[TAM_ATTRS];
               attrs[0] = nivel_lexico;
               attrs[1] = desloc;
               attrs[2] = INTEIRO;
               insere_tab(token, simb_var, attrs);
               cont_amem++;
              }
            | IDENT
              {
               desloc ++;
               int attrs[TAM_ATTRS];
               attrs[0] = nivel_lexico;
               attrs[1] = desloc;
               attrs[2] = INTEIRO;
               insere_tab(token, simb_var, attrs);
               cont_amem++;
              }
;

lista_idents: lista_idents VIRGULA IDENT
            | IDENT
;


comando_composto: T_BEGIN comandos T_END

comandos:
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
