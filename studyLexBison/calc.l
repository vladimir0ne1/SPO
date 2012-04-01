
%{
#include "calc.tab.h"
int column = 0;
%}

%%
"+"	{ column++; return ADD; }
"-"	{ column++; return SUB; }
"*"	{ column++; return MUL; }
"/"	{ column++; return DIV; }
"|"	{ column++; return ABS; }
"%" { column++; return MOD; }
[0-9]+	{ column++; yylval = atoi(yytext); return NUM; }
\n		{ return EOL; }
[ \t]	{ column++; /* ignore whitespace */}
.		{column++; printf("Mystery character %s\n", yytext);}

%%