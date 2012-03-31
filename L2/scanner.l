%{				// Начало блока, прямо копируемого в результирующий файл
	int symbolCounter = 0;
	int lineCounter = 1;	

	int keyWordsNum = 0;
	int symbolNum = 0;
	int stringNum = 0;
	int identNum = 0;
	int digitNum = 0;
	int commentsNum = 0;
	
	int leftBrNum = 0;
	int rightBrNum = 0;
	int typeNum = 0;
	int forNum = 0;
	int whileNum = 0;
	int doNum = 0;

	int plusNum = 0;
	int minusNum = 0;
	int specNum = 0;

	void func(char* str)
	{	printf("(%d:%d) %s: %s\n", lineCounter, symbolCounter, str, yytext);
			symbolCounter+=yyleng;
	}			
				// Окончание блока, прямо копируемого в результирующий файл
%}

TYPE int|double|void|long|char
LOOP while|do|for
COND if|else|case|switch|default


%%				// Начало секции описания правил

" "		{symbolCounter++;}
"	"	{symbolCounter+=4;}

\n	{lineCounter++; symbolCounter = 0;
			symbolCounter+=yyleng;
			}
{TYPE}		{
			func("Type");
			typeNum++;
		}


{LOOP} 	{
			func("Loop");
			keyWordsNum++;
		}


if 		{
			func("Conditions");
			keyWordsNum++;
		}
else 	{
			func("Conditions");
			keyWordsNum++;
		}
switch 	{
			func("Conditions");
			keyWordsNum++;
		}
case 	{
			func("Conditions");
			keyWordsNum++;
		}
default {
			func("Conditions");
			keyWordsNum++;
		}




\(		{
			func("Symbol");
			symbolNum++;
		}
\)		{
			func("Symbol");
			symbolNum++;
		}

\[		{
			func("Symbol");
			symbolNum++;
		}
\]		{
			func("Symbol");
			symbolNum++;
		}

\}		{
			func("Symbol");
			symbolNum++;
		}
\{		{
			func("Symbol");
			symbolNum++;
		}

\=		{
			func("Symbol");
			symbolNum++;
		}

\-		{
			func("Symbol");
			symbolNum++;
		}

\+		{
			func("Symbol");
			symbolNum++;
		}

\>		{
			func("Symbol");
			symbolNum++;
		}
\<		{
			func("Symbol");
			symbolNum++;
		}
\/		{
			func("Symbol");
			symbolNum++;
		}
\*		{
			func("Symbol");
			symbolNum++;
		}
\%		{
			func("Symbol");
			symbolNum++;
		}
\&		{
			func("Symbol");
			symbolNum++;
		}

#include	{
				func("keyword");
				keyWordsNum++;
			}
#define		{
				func("keyword");
				keyWordsNum++;
			}
struct		{
				func("keyword");
				keyWordsNum++;
			}
#if 		{
				func("keyword");
				keyWordsNum++;
			}
#endif		{
				func("keyword");
				keyWordsNum++;
			}
#ifndef		{
				func("keyword");
				keyWordsNum++;
			}
#else 		{
				func("keyword");
				keyWordsNum++;
			}
typedef		{
				func("keyword");
				keyWordsNum++;
			}
extern		{
				func("keyword");
				keyWordsNum++;
			}

\<.*\>		{
				func("include");
				stringNum++;
			}
\".*\"		{
			func("string");
			stringNum++;
			}

[a-z_A-Z][a-z0-9_A-Z]*	{
							func("Identifier");
							identNum++;
						}
[0-9]*	{
			func("Digit");
			digitNum++;
		}

,		{
			func("Symbol");
			symbolNum++;
		}
;		{
			func("Symbol");
			symbolNum++;
		}


"/""*"		{skipcomments();
				commentsNum++;}
\/{2}(.*)	{func("Comments");
			commentsNum++;}


 
%%				// Секция объявления вспомагательных функций
//		"/""*".*"*""/"	func("Comments");
void skipcomments()
{
	printf("(%d:%d) Comments: ", lineCounter, symbolCounter);
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
			symbolCounter++;
		}
		if (c == '\n')
		{
			lineCounter++;
		}
		if(c == EOF)
		{
			printf("End of comment not found!");
			break;
		}
		if (c == '*')
		{
			symbolCounter++;
			c = input();
			str[i] = c;
			i++;
			if (c != '/')
			{
				symbolCounter++;
				//unput (yytext [yyleng-1]);
			}
			else
			{
				puts(str);
				break;
			}
		}
	}
}

yywrap()			// Функция обработки обнаружения конца файла
{
	printf("\nKeywords: %d\n", keyWordsNum);
	printf("Types: %d\n", typeNum);
	printf("Symbols: %d\n", symbolNum);
	printf("Comments: %d\n", commentsNum);
	printf("Idents: %d\n", identNum);
	printf("Digits: %d\n", digitNum);
	return(1);		// После обнаружения конца файла прекратить парсинг
}