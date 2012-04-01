%{
#  include <stdio.h>
%}

/* declare tokens */
%token NUMBER
%token ADD SUB MUL DIV ABS MOD
%token OP CP	
%token EOL								// end of line
%token IF ELSE
%token DO WHILE
%token NOT AND OR						// ! && ||
%token EQUAL NOT_EQUAL					// == !=
%token LESS LARGER						// < >
%token LESS_OR_EQUAL LARGER_OR_EQUAL	// <= >=
%token GOTO BREAK CONTINUE
%token COMMENTS
%token INT CHAR VOID
%token LEFT_BR RIGHT_BR					//()
%token LEFT_BRACE RIGHT_BRACE 			//{}
%token LEFT_SQBR RIGHT_SQBR				//[]
%token MAIN
%token CONST
%token IDENT
%token COMMA SEMICOLON
%token ASSIGNMENT 						// =

%left ASSIGNMENT
%left ADD SUB
%left MUL DIV MOD
%left UMINUS

%%

function_body:
 | function_body complited_action
 | function_body EOL
 ;

complited_action: action SEMICOLON {puts("action!");}
 //| condition
 ;

action: function_call { puts("function call"); }
 | assignment_operator { puts("assignment"); }
 | variable_declaration  { puts("declaration"); }
 //| loop
 ;

assignment_operator:
 | IDENT ASSIGNMENT function_parameter
 ;

variable_declaration: type declaration_list
 ;

type: INT { puts("type int"); }
 | CHAR | VOID 
 ;

declaration_list: declaration_list COMMA IDENT { puts("ident,"); }
 | IDENT { puts("ident"); }
 ;
 
//=========================================


function_parameter: arithmetic_operation { puts("arifmetic");}
 | function_call
 ;

function_call: IDENT LEFT_BR param_list RIGHT_BR { puts("func_call");}
 ;
 
param_list: param_list COMMA function_parameter { puts("function_parameter , ");}
 | function_parameter { puts("function_parameter");}
 ;

arithmetic_operation: ABS arithmetic_operation ABS { $$ = $2 >= 0 ? $2 : -$2; }
 | arithmetic_operation SUB arithmetic_operation { $$ = $1 - $3; }
 | arithmetic_operation ADD arithmetic_operation { $$ = $1 + $3; }
 | arithmetic_operation MUL arithmetic_operation { $$ = $1*$3; }
 | arithmetic_operation DIV arithmetic_operation { $$ = $1/$3; }
 | arithmetic_operation MOD arithmetic_operation { $$ = $1%$3; }
 | SUB arithmetic_operation %prec UMINUS {$$=-$2;}
 | NUMBER {$$=$1;}
 | IDENT { puts("arithmetic ident"); }
 ;

//========================= END ==============================

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