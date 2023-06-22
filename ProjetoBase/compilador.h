/* -------------------------------------------------------------------
 *            Arquivo: compilador.h
 * -------------------------------------------------------------------
 *              Autor: Bruno Muller Junior
 *               Data: 08/2007
 *      Atualizado em: [09/08/2020, 19h:01m]
 *
 * -------------------------------------------------------------------
 *
 * Tipos, protótipos e variáveis globais do compilador (via extern)
 *
 * ------------------------------------------------------------------- */

#define TAM_TOKEN 16
#define TAM_ATTRS 10
#define TAM_REGRA 20
#define TAM_ROT 10

#define INTEIRO 66
#define BOOLEANO 77

typedef enum simbolos {
  simb_program, simb_label, simb_type, simb_array, simb_of, simb_var, simb_begin, simb_end,
  simb_procedure, simb_function, simb_goto, simb_if, simb_then, simb_else, simb_while, simb_do,
  simb_soma, simb_subtrai, simb_mult, simb_div, simb_and, simb_or, simb_not, 
  simb_igual, simb_difere, simb_menor, simb_menorIgual, simb_maior, simb_maiorIgual,
  simb_identificador, simb_numero,
  simb_ponto, simb_virgula, simb_ponto_e_virgula, simb_dois_pontos,
  simb_atribuicao, simb_abre_parenteses, simb_fecha_parenteses,
} simbolos;

typedef enum tipos{
  t_inteiro, t_booleano
}tipos;

//Estrutura tabela de simbolos
typedef struct tab_simbolos{
  char ident[TAM_TOKEN];
  simbolos categoria;
  int atributos[TAM_ATTRS];
  struct tab_simbolos *prox;
}tab_simbolos;

//Estrutura da pilha de tipos
typedef struct pilha_tipos{
  char regra[TAM_REGRA];
  tipos tipo;
  struct pilha_tipos* prox;
}pilha_tipos;

//Estrutura da pilha de rotulos
typedef struct pilha_rot{
  char rotulo[TAM_ROT];
  struct pilha_rot* prox;
}pilha_rot;

/* -------------------------------------------------------------------
 * variáveis globais
 * ------------------------------------------------------------------- */

extern simbolos simbolo, relacao;
extern char token[TAM_TOKEN];
extern int nivel_lexico;
extern int desloc;
extern int nl;

extern tab_simbolos *topo_TS;
extern int tam_TS;

extern pilha_tipos* topo_tipos;
extern pilha_rot* topo_rot;
extern int next_rot;

/* -------------------------------------------------------------------
 * prototipos globais
 * ------------------------------------------------------------------- */

void geraCodigo (char*, char*);
int yylex();
void yyerror(const char *s);

//Operações básicas para a tabela de símbolos
void init_ts();
void insere_tab(char ident[TAM_TOKEN], simbolos categoria, int attrs[TAM_ATTRS]);
tab_simbolos* busca_tab(char ident[TAM_TOKEN]);
void remove_tab(int n);
void limpa_ts();

//Operações para a pilha de tipos
void empilha(char *new_regra, tipos tipo);
tipos desempilha();

char* geraRotulo();
void empilhaRot(char* rotulo);
char* desempilhaRot();