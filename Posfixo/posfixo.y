
%{
#include <stdio.h>
%}

%token IDENT MAIS MENOS OR ASTERISCO DIV ABRE_PARENTESES FECHA_PARENTESES

%%

expr       : expr MAIS termo {printf ("+"); } |
             expr MENOS termo {printf ("-"); } |
             termo
;

operadores : expr AND termo {printf ("and"); } |
             expr OR termo {printf ("or"); } |

termo      : termo ASTERISCO fator  {printf ("*"); }| 
             termo DIV fator  {printf ("/"); }|
             fator
;

fator      : IDENT {printf ("A"); } |
             IDENT {printf ("B"); }
;

%%

main (int argc, char** argv) {
   yyparse();
   printf("\n");
}

