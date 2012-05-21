%{
#  include <stdio.h>
#include "tree.c"
stack* head = NULL;
tree_node* root = NULL;
int action_num = 0;
int declaration_num = 0;
int function_var_declaration_num = 0;
int function_declaration_num = 0;
int condition_expression_num = 0;
action_num_stack* action_stack_head = NULL;
%}

/* declare tokens */
%token NUMBER
%token ADD SUB MUL DIV ABS MOD
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
%left LEFT_BR RIGHT_BR

%%

program: program_x EOL main { puts("programm");
								tree_node* temp = create_node("PROGRAMM", function_declaration_num, &head);
								add_node_to_stack("PROGRAMM", temp, &head);
								root = temp;
								}
 | main
 ;

program_x:
 | program_x EOL
 | program_x EOL function_declaration { puts("func decl"); function_declaration_num++;}
 | function_declaration { puts("func decl"); function_declaration_num++; }
 ;

function_declaration: type IDENT func_prototype_decl_with_brace function_body_with_brace {
																		
																		create_list_and_add_to_stack("IDENT", &head);
																		output_stack(head);
																		tree_node* temp = create_node("FUNC_DECLAR", 4, &head);
																		add_node_to_stack("FUNC_DECLAR", temp, &head);
																		root = temp;
																		function_var_declaration_num = 0;
																		output_stack(head);
																	}
 | type IDENT func_prototype_decl_with_brace EOL function_body_with_brace {
																		
																		create_list_and_add_to_stack("IDENT", &head);
																		output_stack(head);
																		tree_node* temp = create_node("FUNC_DECLAR", 4, &head);
																		add_node_to_stack("FUNC_DECLAR", temp, &head);
																		root = temp;
																		function_var_declaration_num = 0;
																		output_stack(head);
																	}
	
 ;

func_prototype_decl_with_brace: LEFT_BR func_prototype_decl RIGHT_BR {
																		tree_node* temp = create_node("FUNC_PARAM_DECLAR", function_var_declaration_num, &head);
																		add_node_to_stack("FUNC_VAR_DECLAR", temp, &head);
																		root = temp;
																		function_var_declaration_num = 0;
																	}
																	;

func_prototype_decl:
 | type IDENT								{
												create_list_and_add_to_stack("IDENT", &head);
												tree_node* temp = create_node("FUNC_VAR_DECLAR", 2, &head);
												add_node_to_stack("FUNC_VAR_DECLAR", temp, &head);
												root = temp;
												function_var_declaration_num++;												
											}
 | func_prototype_decl COMMA type IDENT		{
												create_list_and_add_to_stack("IDENT", &head);
												tree_node* temp = create_node("FUNC_VAR_DECLAR", 2, &head);
												add_node_to_stack("FUNC_VAR_DECLAR", temp, &head);
												root = temp;
												function_var_declaration_num++;
											}
 ;

main: type MAIN func_prototype_decl_with_brace function_body_with_brace { puts("main");
																		create_list_and_add_to_stack("MAIN", &head);
																		output_stack(head);
																		tree_node* temp = create_node("FUNC_DECLAR", 4, &head);
																		add_node_to_stack("FUNC_DECLAR", temp, &head);
																		root = temp;
																		function_var_declaration_num = 0;
																		function_declaration_num++;
																		output_stack(head);
																		}
 | type MAIN func_prototype_decl_with_brace EOL function_body_with_brace { puts("main");
																		create_list_and_add_to_stack("MAIN", &head);
																		output_stack(head);
																		tree_node* temp = create_node("FUNC_DECLAR", 4, &head);
																		add_node_to_stack("FUNC_DECLAR", temp, &head);
																		root = temp;
																		function_var_declaration_num = 0;
																		function_declaration_num++;
																		output_stack(head);
																		}
 ;

//===================================================================

function_body_with_brace:
 LEFT_BRACE function_body RIGHT_BRACE {				printf("actions: %d\n", action_num);													
													tree_node* temp = create_node("BODY", action_num, &head);
													add_node_to_stack("BODY", temp, &head);
													root = temp;
													action_num = 0;
													}
 ;

function_body:
 | function_body complited_action
 | function_body EOL
 
 ;

complited_action: action SEMICOLON { action_num++;}
 | condition {action_num++;}
 | error SEMICOLON {printf("ERROR: line: %d: action error\n", @1.first_line); }
 ;

action: function_call { puts("function call"); }
 | assignment_operator { puts("assignment"); }
 | variable_declaration  { puts("declaration"); }
 | loop { puts("do while"); }
 ;

assignment_operator:
 | IDENT ASSIGNMENT function_parameter {
													//output_stack(head);
													create_list_and_add_to_stack("IDENT", &head);
													tree_node* temp = create_node("=", 2, &head);
													add_node_to_stack("ASSIGNMENT", temp, &head);
													root = temp;
													//output_stack(head);													
													}
 | array ASSIGNMENT function_parameter
 ;

variable_declaration: type declaration_list {
												printf("declaration_num = %d\n", declaration_num);
												tree_node* temp = create_node("DECLARATION LIST", declaration_num, &head);
												add_node_to_stack("DECLARATION LIST", temp, &head);												
												root = temp;
												temp = create_node("DECLARATION", 2, &head);
												add_node_to_stack("DECLARATION", temp, &head);
												root = temp;				
												declaration_num = 0;
											}
 ;

type: INT { create_list_and_add_to_stack("INT", &head);}
 | CHAR { create_list_and_add_to_stack("CHAR", &head);}
 | VOID { create_list_and_add_to_stack("VOID", &head);}
 ;

declaration_list: declaration_list COMMA dec_temp {declaration_num++;}
 | dec_temp {declaration_num++;}
 ;

dec_temp: IDENT { create_list_and_add_to_stack("IDENT", &head); }
 | array
 | td_array
 ;
 
//============= FUNCTION ============================

function_parameter: arithmetic_operation {
											puts("function_parametr");
											//tree_node* temp = create_node("FUNCTION_PARAMETR_ARITHMETIC", 1, &head);
											//add_node_to_stack("FUNCTION_PARAMETR_ARITHMETIC", temp, &head);
											//root = temp;
											}
 | function_call
 ;

function_call: IDENT LEFT_BR param_list RIGHT_BR	{ create_list_and_add_to_stack("FUNCTION_CALL", &head); }
 ;
 
param_list:
 | param_list COMMA function_parameter
 | function_parameter
 //| error { puts("param list error"); }
 ;

arithmetic_operation: LEFT_BR arithmetic_operation RIGHT_BR {
													puts("with_brace");
													//create_list_and_add_to_stack("LEFT_BR", &head);
													//create_list_and_add_to_stack("ARITHMETIC_OP", &head);
													//create_list_and_add_to_stack("RIGHT_BR", &head);
													//tree_node* temp = create_node("WITH_BRACE", 3, &head);
													//add_node_to_stack("WITH_BRACE", temp, &head);
													//root = temp;												
																}
 | ABS arithmetic_operation ABS { $$ = $2 >= 0 ? $2 : -$2; puts("abs");}
 | arithmetic_operation SUB arithmetic_operation {
													$$ = $1 - $3; puts("sub");
													tree_node* temp = create_node("SUB", 2, &head);
													add_node_to_stack("SUB", temp, &head);
													root = temp;
													}
 | arithmetic_operation ADD arithmetic_operation {
													$$ = $1 + $3; puts("add");
													tree_node* temp = create_node("ADD", 2, &head);
													add_node_to_stack("ADD", temp, &head);
													root = temp;
												}
 | arithmetic_operation MUL arithmetic_operation {
													$$ = $1*$3; puts("mul");
													tree_node* temp = create_node("MUL", 2, &head);
													add_node_to_stack("MUL", temp, &head);
													root = temp;
												}
 | arithmetic_operation DIV arithmetic_operation {
													$$ = $1/$3; puts("div");
													tree_node* temp = create_node("DIV", 2, &head);
													add_node_to_stack("DIV", temp, &head);
													root = temp;
												}
 | arithmetic_operation MOD arithmetic_operation {
													$$ = $1%$3; puts("mod");
													tree_node* temp = create_node("MOD", 2, &head);
													add_node_to_stack("MOD", temp, &head);
													root = temp;
												}
 | SUB arithmetic_operation %prec UMINUS {
											$$=-$2; puts("uminus");
											tree_node* temp = create_node("UMINUS", 1, &head);
											add_node_to_stack("UMINUS", temp, &head);
											root = temp;
										}
 | NUMBER {
			$$=$1; puts("number");
			char x[5];
			sprintf(x, "%d", $1);
			create_list_and_add_to_stack(x, &head);
			}
 | IDENT {puts("IDENT"); create_list_and_add_to_stack("IDENT", &head);}
 | array {puts("array"); create_list_and_add_to_stack("array", &head);}
 | td_array {puts("td_array");}
 ;

//================= LOOP =======================//

loop: DO function_body_with_brace WHILE LEFT_BR condition_expression_list RIGHT_BR
 ;
//================ CONDITION =====================//

condition: condition_if EOL	{
							puts("=-------------------- condition_if -----------------");
							tree_node* temp = create_node("CONDITION_IF", 1, &head);
							add_node_to_stack("CONDITION", temp, &head);
							root = temp;
							action_num = action_num_stack_pop(&action_stack_head);											
						}
 | condition_if EOL condition_else {
										output_stack(head);
										tree_node* temp = create_node("CONDITION_IF_ELSE", 2, &head);
										add_node_to_stack("CONDITION", temp, &head);
										root = temp;
										output_stack(head);
										action_num = action_num_stack_pop(&action_stack_head);			
									}
 ;
 
condition_if: IF LEFT_BR condition_expression_list RIGHT_BR function_body_with_brace {
													output_stack(head);
													tree_node* temp = create_node("IF", 2, &head);
													add_node_to_stack("IF", temp, &head);
													root = temp;
													output_stack(head);												
												}
 | IF LEFT_BR condition_expression_list RIGHT_BR EOL function_body_with_brace {														
													output_stack(head);
													tree_node* temp = create_node("IF", 2, &head);
													add_node_to_stack("IF", temp, &head);
													root = temp;													output_stack(head);																				
												}
 ;
 
condition_else: ELSE function_body_with_brace	{														
													tree_node* temp = create_node("ELSE", 1, &head);
													add_node_to_stack("ELSE", temp, &head);
													root = temp;													
												}
 | ELSE EOL function_body_with_brace 	{														
											tree_node* temp = create_node("ELSE", 1, &head);
											add_node_to_stack("ELSE", temp, &head);
											root = temp;														
										}
 ;

condition_expression_list: condition_expression OR condition_expression
													{
													output_stack(head);
														action_num_stack_push(action_num, &action_stack_head);
														action_num = 0;
														puts("condition expression list");
														tree_node* temp = create_node("OR", 2, &head);
														add_node_to_stack("OR", temp, &head);
														root = temp;
														output_stack(head);												
													}
 | condition_expression AND condition_expression
													{
														action_num_stack_push(action_num, &action_stack_head);
														puts("condition expression list");
														tree_node* temp = create_node("AND", 2, &head);
														add_node_to_stack("AND", temp, &head);
														root = temp;												
													}
														
 | condition_expression	{
							action_num_stack_push(action_num, &action_stack_head);
							puts("condition expression list");
							//tree_node* temp = create_node("CONDITION_EXPRESSION", 1, &head);
							//add_node_to_stack("CONDITION_EXPRESSION", temp, &head);
							//root = temp;
						}
 ;
 
condition_expression: NOT cond_temp {
										tree_node* temp = create_node("NOT", 1, &head);
										add_node_to_stack("NOT", temp, &head);
										root = temp;
									}
 | cond_temp
 | error {printf("ERROR: line: %d: condition error\n", @1.first_line); }
 ;
 
cond_temp: LEFT_BR cond_temp RIGHT_BR { puts("cond_temp in br"); }
 | function_parameter LESS function_parameter {
												puts("cond_temp");
												output_stack(head);
												tree_node* temp = create_node("LESS", 2, &head);
												add_node_to_stack("LESS", temp, &head);
												root = temp;
												output_stack(head);
											}
 | function_parameter LARGER function_parameter {
												puts("cond_temp");
												tree_node* temp = create_node("LARGER", 2, &head);
												add_node_to_stack("LARGER", temp, &head);
												root = temp;
											}
 | function_parameter LESS_OR_EQUAL function_parameter {
												puts("cond_temp");
												tree_node* temp = create_node("LESS_OR_EQUAL", 2, &head);
												add_node_to_stack("LESS_OR_EQUAL", temp, &head);
												root = temp;
											}
 | function_parameter LARGER_OR_EQUAL function_parameter {
												puts("cond_temp");
												tree_node* temp = create_node("LARGER_OR_EQUAL", 2, &head);
												add_node_to_stack("LARGER_OR_EQUAL", temp, &head);
												root = temp;
											}
 | function_parameter EQUAL function_parameter {
												puts("cond_temp");
												tree_node* temp = create_node("EQUAL", 2, &head);
												add_node_to_stack("EQUAL", temp, &head);
												root = temp;
											}
 | function_parameter NOT_EQUAL function_parameter {
												puts("cond_temp");
												tree_node* temp = create_node("NOT_EQUAL", 2, &head);
												add_node_to_stack("NOT_EQUAL", temp, &head);
												root = temp;
											}
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
	//puts("== stack: ==");
	//output_stack(head);
	puts("== tree: ==");
	tree_node* temp = root;
	output(root);
	puts("== stack: ==");
	output_stack(head);
}

yyerror(char *s)
{
	fprintf(stderr, "error: %s\n", s);
}