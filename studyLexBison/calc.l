
%{
#include "calc.tab.h"
int column = 0;
%}

%%
int {return INT;}
char {return CHAR;}
void {return VOID;}
";" {return SEMICOLON;}
if { return IF; }
else { return ELSE; }
"{" { return LEFT_BRACE; }
"}" { return RIGHT_BRACE; }
"(" { return LEFT_BR; }
")" { return RIGHT_BR; }
"+"	{ column++; return ADD; }
"-"	{ column++; return SUB; }
"*"	{ column++; return MUL; }
"/"	{ column++; return DIV; }
"|"	{ column++; return ABS; }
"%" { column++; return MOD; }
[0-9]+	{ column++; yylval = atoi(yytext); return NUM; }
[a-z_A-Z][a-z0-9_A-Z]* { return IDENT; }
\n		{ return EOL; }
[ \t]	{ column++; /* ignore whitespace */}
.		{column++; printf("Mystery character %s\n", yytext);}

%%