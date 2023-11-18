%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"


extern int yyleng;

void yyerror(char* s);
%}
DIGITO [0-9]

LETRA [a-zA-Z]

IDENTIFICADOR {LETRA}({LETRA}|{DIGITO})*

CONSTANTE {DIGITO}({DIGITO})*
%%
"inicio"|"INICIO" {return INICIO;}
"fin"|"FIN" {return FIN;}
"escribir"|"ESCRIBIR" {return ESCRIBIR;}
"leer"|"LEER" {return LEER;}

{CONSTANTE} {yylval.num=atoi(yytext);return CONSTANTE;}
{IDENTIFICADOR} {if(yyleng<5){yylval.id=strdup(yytext);return ID;}else yyerror("Max de caracteres para id es 32");}

";" {return PYCOMA;}
"(" {return PARENIZQUIERDO;}
")" {return PARENDERECHO;}
"+" {return SUMA;}
"-" {return RESTA;}
":=" {return ASIGNACION;}
"," {return COMA;}
"\n"|" " ;
. {yyerror("Error Lexico");}

%%