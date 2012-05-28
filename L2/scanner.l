%{				// Начало блока, прямо копируемого в результирующий файл
#include "parser.tab.h"
				// Окончание блока, прямо копируемого в результирующий файл
%}

%%				// Начало секции описания правил

int { return INT; }
char { return CHAR; }
void { return VOID; }
main { return MAIN; }
\n	{ yylloc.first_line++; return EOL; }

if { return IF; }
else { return ELSE; }

do { return DO; }
while { return WHILE; }

\( { return LEFT_BR; }
\) { return RIGHT_BR; }

\[ { return LEFT_SQBR; }
\] { return RIGHT_SQBR; }

"{" { return LEFT_BRACE; }
"}" { return RIGHT_BRACE; }

"=" { return ASSIGNMENT; }

\- { return SUB; }
\+ { return ADD; }

\> { return LARGER; }
\< { return LESS; }
\<= {return LESS_OR_EQUAL; }
\>= {return LARGER_OR_EQUAL; }
\/ { return DIV; }
\* { return MUL; }
\% { return MOD; }
"!" { return NOT; }
"&&" { return AND; }
"||" { return OR; }

[a-z_A-Z][a-z0-9_A-Z]* { yylval = yytext; return IDENT; }
[0-9]* { yylval = atoi(yytext); return NUMBER; }

"," { return COMMA; }
; { return SEMICOLON; }


"/""*"		{ skipcomments(); }
\/{2}(.*)	{ puts("comments"); }

[ \t]	{ /* ignore whitespace */}
.	{ printf("Mystery character %s\n", yytext);}
 
%%				// Секция объявления вспомагательных функций
//		"/""*".*"*""/"	func("Comments");

void skipcomments()
{
	//printf("(%d:%d) Comments: ", lineCounter, symbolCounter);
	char* str = calloc(sizeof(char), 500);
	str[0] = '/';
	str[1] = '*';
	int c;
	int i = 2;
	while(1)
	{		
		c = input();
		str[i] = c;
		i++;
		if (c==' ')
		{
		//	symbolCounter++;
		}
		if (c == '\n')
		{
			yylloc.first_line++;
		//	lineCounter++;
		}
		if(c == EOF)
		{
			printf("End of comment not found!");
			break;
		}
		if (c == '*')
		{
			//symbolCounter++;
			c = input();
			str[i] = c;
			i++;
			if (c != '/')
			{
			//	symbolCounter++;
				//unput (yytext [yyleng-1]);
			}
			else
			{
				//puts(str);
				break;
			}
		}
	}
	puts("comments");
}

yywrap()			// Функция обработки обнаружения конца файла
{
	//printf("\nKeywords: %d\n", keyWordsNum);
	//printf("Types: %d\n", typeNum);
	//printf("Symbols: %d\n", symbolNum);
	//printf("Comments: %d\n", commentsNum);
	//printf("Idents: %d\n", identNum);
	//printf("Digits: %d\n", digitNum);
	return(1);		// После обнаружения конца файла прекратить парсинг
}