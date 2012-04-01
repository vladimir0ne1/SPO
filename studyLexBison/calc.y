%{
#include <stdio.h>
%}

/* declare tokens */
%token NUM
%token ADD SUB MUL DIV ABS
%token EOL

%left ADD SUB
%left MUL DIV MOD
%left UMINUS

%%

calclist: /* nothing */
 | calclist exp EOL { printf("%d\n", $2); }
 | calclist error EOL { printf("Деление на ноль, l%d,c%d-l%d,c%d\n",
                         @3.first_line, @3.first_column,
                         @3.last_line, @3.last_column);}
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

%%
main(int argc, char **argv)
{
	yyparse();
}

yyerror(char *s)
{
	fprintf(stderr, "error: %s\n", s);
}