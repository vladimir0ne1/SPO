%{
#include <stdio.h>
%}

/* declare tokens */
%token NUM
%token ADD SUB MUL DIV ABS
%token EOL
%token IF ELSE
%token LEFT_BRACE RIGHT_BRACE
%token LEFT_BR RIGHT_BR
%token IDENT

%token CHAR INT VOID
%token SEMICOLON

%left ADD SUB
%left MUL DIV MOD
%left UMINUS



%%

//calclist: /* nothing */
// | calclist exp EOL { printf("%d\n", $2); }
// | calclist error EOL { printf("Деление на ноль, l%d,c%d-l%d,c%d\n",
//                         @3.first_line, @3.first_column,
//                         @3.last_line, @3.last_column);}
 //;

calclist: {puts("nothing");}
 | EOL
 | calclist ident EOL {puts("abcd");}
 | calclist condition EOL
 | calclist exp EOL { printf("%d\n", $2); }
 //| calclist error{ puts("calclerr");}
 ;
 
exp: ABS exp ABS { $$ = $2 >= 0 ? $2 : -$2; }
 | exp SUB exp { $$ = $1 - $3; }
 | exp ADD exp { $$ = $1 + $3; }
 | exp MUL exp { $$ = $1*$3; }
 | exp DIV exp { $$ = $1/$3; }
 | exp MOD exp { $$ = $1%$3; }
 | SUB exp %prec UMINUS {$$=-$2;}
 | NUM {$$=$1;}
 ;

condition: cond_if { puts("if"); }
 | cond_if cond_else { puts ("ifelse"); }
 ;

cond_if: IF cond_exp cond_body
 | IF error { puts("if_error");}
 //| IF cond_exp error { puts("cond_body_error");}
 ;

cond_body: LEFT_BRACE IDENT RIGHT_BRACE
	| error;
 //| LEFT_BRACE IDENT error { puts("отсутствует }"); }
 //| error IDENT RIGHT_BRACE { puts("отсутствует {"); }
// | LEFT_BRACE error RIGHT_BRACE { puts("ошибка тела действия условия"); }
// | LEFT_BRACE error {puts ("xxxyyy");}
 ;

cond_exp: LEFT_BR IDENT RIGHT_BR
| LEFT_BR error RIGHT_BR { puts(" ошибка условного выражения "); }
 | error;
 
// | LEFT_BR IDENT error { puts(" отсутствует )"); }
 //| LEFT_BR error { puts("xyxy");}
 ;
 
cond_else: ELSE cond_body
 ;

ident: IDENT{ puts ("ident"); };

%%
main(int argc, char **argv)
{
	yyparse();
}

yyerror(char *s)
{
	fprintf(stderr, "error: %s\n", s);
	//printf("Ошибка: , l%d,c%d-l%d,c%d\n",
     //                   @3.first_line, @3.first_column,
      //                   @3.last_line, @3.last_column);}
}