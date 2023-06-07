
%{
#include <stdio.h>
%}

%token IDENT MAIS MENOS OR AND ASTERISCO DIV

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

int main (int argc, char** argv) {
   yyparse();
   printf("\n");
}

