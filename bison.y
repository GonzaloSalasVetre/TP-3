%{
#include <stdio.h>
#include <stdlib.h> 
#include <math.h>
#include <string.h>
#define TAM_TS 150
extern char *yytext;
extern int yylex(void);
extern FILE* yyin;

void yyerror(char *s);
void guardarValor(char* id, int valor);
int valorId(char* id);
int indiceId(char* id);

int tamTS = TAM_TS;

typedef struct {
   char* id;
   int valor;
} s;

s ts[TAM_TS];

%}
%union{
   char* id;
   int num;
} 
%token ASIGNACION PYCOMA SUMA RESTA PARENIZQUIERDO PARENDERECHO INICIO FIN ESCRIBIR LEER COMA
%token <id> ID
%token <num> CONSTANTE

%type <num> expresion primaria
%%

programa: INICIO listaSentencias FIN {exit(0);}
;

listaSentencias: listaSentencias sentencia 
|sentencia
;

sentencia: ID ASIGNACION expresion PYCOMA {
   guardarValor($1, $3);
   printf("El valor de %s es: %d\n", $1, $3);
}
| LEER PARENIZQUIERDO listaIdentificadores PARENDERECHO PYCOMA
| ESCRIBIR PARENIZQUIERDO listaExpresiones PARENDERECHO PYCOMA
;

listaIdentificadores: ID
| listaIdentificadores COMA ID
;

listaExpresiones: expresion
| listaExpresiones COMA expresion
;

expresion: primaria {$$ = $1;}
|expresion SUMA primaria {$$ = $1 + $3;}
|expresion RESTA primaria {$$ = $1 - $3;}
; 

primaria: ID {
   if(indiceId($1) != -1)
      $$ = valorId($1);
   else {
      char msg[50] = "No existe la variable ";
      strcat(msg, $1);
      yyerror(msg);
      YYABORT;
   }
      
}
|CONSTANTE {$$ = $1;}
|PARENIZQUIERDO expresion PARENDERECHO {$$ = $2;}
;

%%
int main(int argc, char** argv) {
   
   s sInicial = {"$", -1};

   ts[0] = sInicial;

   if (argc == 2) {
      yyin = fopen(argv[1],"r");
   }

   yyparse();
}
void yyerror (char *s){
   printf ("%s\n",s);
}
int yywrap()  {
   return 1;  
}

int indiceId(char* id) {
   for(int i = 0; i<tamTS && strcmp(ts[i].id, "$"); i++) {
      if (!strcmp(id, ts[i].id))
         return i;
   }
   return -1;
}

int valorId(char* id) {
   if(indiceId(id) == -1) {
      printf("No existe ese id");
      return -1;
   }
   return ts[indiceId(id)].valor;
}

void guardarValor(char* id, int valor) {
   if(indiceId(id) != -1)
      ts[indiceId(id)].valor = valor;
   int i = 0;
   for(i; strcmp(ts[i].id, "$"); i++);
   if (i<tamTS-1) {
      s s1 = {id, valor};
      ts[i] = s1;
      s s2 = {"$", -1};
      ts[i+1] = s2;
   }
}