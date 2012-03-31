%{
#  include <stdio.h>
%}

/* declare tokens */
%token NUMBER
%token ADD SUB MUL DIV ABS
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
%token INT CHAR
%token LEFT_BR RIGHT_BR					//()
%token LEFT_BRACE RIGHT_BRACE 			//{}
%token LEFT_SQBR RIGHT_SQBR				//[]
%token MAIN
%token CONST
%token IDENT
%token COMMA
%token ASSIGNMENT 						// =
%%

condition_operator:	LESS | LARGER | LESS_OR_EQUAL | LARGER_OR_EQUAL
 | EQUAL | NOT_EQUAL
 ;
 
bin_operator: OR | AND
 ;
 
type: INT | CHAR | VOID
 ;
 
param_list: param_list COMMA
 | function_parameter
 ;
 
function_call: identifier LEFT_BR param_list RIGHT_BR
 ;
 
complited_action: action SEMICOLON
 | condition
 ;
 
action: function_call 
 | assignment_operator 
 | variable_declaration
 | loop
 ;
 
assignment_operator:
 | IDENT ASSIGNMENT function_parameter
 ;
 
function_parameter: IDENT | NUMBER
 | function_call
 | arithmetic_operation
 ;
 
variable_declaration: type declaration_list
 ;
 
declaration_list: declaration_list COMMA
 | IDENT
 ;
 
function_prototype: type ident LEFT_BR function_declaration_list RUGHT_BR SEMICOLON
 ;
 
function_declaration_list: function_declaration_list COMMA
 | type IDENT
 ;
 
function_description: function_prototype LEFT_BRACE function_body RIGHT_BRACE
 ;
 
function_body: function_body
 | complited_action
 ;

 
//===== CONDITION ======//

condition: condition_if
 | condition_if condition_else
 ;
 
condition_if: IF LEFT_BR condition_expression_list RIGHT_BR LEFT_BRACE function_body RIGHT_BRACE
 ;
 
condition_else: ELSE LEFT_BRACE function_body RIGHT_BRACE
 ;

condition_expression_list: condition_expression_list bin_operator
 | condition_expression
 ;
 
cond_expression: NOT LEFT_BR cond_temp RIGHT_BR
 | LEFT_BR cond_temp
 | cond_temp
 ;
 
cond_temp: function_parameter condition_operator function_parameter
 ;

//===== LOOP =====//
loop: DO LEFT_BRACE function_body RIGHT_BRACE WHILE LEFT_BR condition_expression_list RIGHT_BR
 ;