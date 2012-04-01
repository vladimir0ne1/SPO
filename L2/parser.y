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


%left AND
%left OR
%left NOT
%left LESS LARGER LESS_OR_EQUAL LARGER_OR_EQUAL
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
 | condition
 ;

action: function_call { puts("function call"); }
 | assignment_operator { puts("assignment"); }
 | variable_declaration  { puts("declaration"); }
 | loop { puts("do while"); }
 ;

assignment_operator:
 | IDENT ASSIGNMENT function_parameter
 | array ASSIGNMENT function_parameter
 ;

variable_declaration: type declaration_list
 ;

type: INT { puts("type int"); }
 | CHAR | VOID 
 ;

declaration_list: declaration_list COMMA dec_temp { puts("ident,"); }
 | dec_temp
 ;

dec_temp: IDENT { puts("ident"); }
 | assignment_operator
 | array
 | td_array
 ;
 
//============= FUNCTION ============================

function_parameter: arithmetic_operation { puts("arifmetic");}
 | function_call
 ;

function_call: IDENT LEFT_BR param_list RIGHT_BR { puts("func_call");}
 ;
 
param_list:
 //| param_list COMMA EOL function_parameter { puts("function_parameter eol, ");}
 | param_list COMMA function_parameter { puts("function_parameter , ");}
 | function_parameter { puts("function_parameter");}
 ;

arithmetic_operation: LEFT_BR arithmetic_operation RIGHT_BR
 | ABS arithmetic_operation ABS { $$ = $2 >= 0 ? $2 : -$2; }
 | arithmetic_operation SUB arithmetic_operation { $$ = $1 - $3; }
 | arithmetic_operation ADD arithmetic_operation { $$ = $1 + $3; }
 | arithmetic_operation MUL arithmetic_operation { $$ = $1*$3; }
 | arithmetic_operation DIV arithmetic_operation { $$ = $1/$3; }
 | arithmetic_operation MOD arithmetic_operation { $$ = $1%$3; }
 | SUB arithmetic_operation %prec UMINUS {$$=-$2;}
 | NUMBER {$$=$1;}
 | IDENT { puts("arithmetic ident"); }
 | array
 | td_array
 ;

//================= LOOP =======================//

loop: DO LEFT_BRACE function_body RIGHT_BRACE WHILE LEFT_BR condition_expression_list RIGHT_BR
 ;
//================ CONDITION =====================//

condition: condition_if	{ puts("condition if"); }
 //| condition_if condition_else { puts("condition if else"); }
 | condition_if EOL condition_else { puts("condition if else"); }
 ;
 
condition_if: IF LEFT_BR condition_expression_list RIGHT_BR LEFT_BRACE function_body RIGHT_BRACE
 | IF LEFT_BR condition_expression_list RIGHT_BR EOL LEFT_BRACE function_body RIGHT_BRACE
 ;
 
condition_else: ELSE LEFT_BRACE function_body RIGHT_BRACE
 | ELSE EOL LEFT_BRACE function_body RIGHT_BRACE 
 ;

condition_expression_list: condition_expression_list bin_operator condition_expression { puts("condition expression list"); }
 | condition_expression
 ;
 
condition_expression: NOT cond_temp 
 | cond_temp
 ;
 
cond_temp: LEFT_BR cond_temp RIGHT_BR { puts("cond_temp in br"); }
 | function_parameter condition_operator function_parameter { puts("cond_temp"); }
 ;

condition_operator:	LESS | LARGER | LESS_OR_EQUAL | LARGER_OR_EQUAL
 | EQUAL | NOT_EQUAL
 ;
 
bin_operator: OR | AND
 ;

//================= ARRAY ================

array: IDENT index
 ;
 
index: LEFT_SQBR function_parameter RIGHT_SQBR

td_array: array index
 ;

//array_declaration: type array
// | type td_array
// ;
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