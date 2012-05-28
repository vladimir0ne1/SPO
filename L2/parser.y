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
char* ident_name = NULL;
action_num_stack* action_stack_head = NULL;
ident_stack* ident_stack_head = NULL;
declarated_ident_stack* declarated_ident_stack_head = NULL;
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

program: program_x EOL main { 
								tree_node* temp = create_node("PROGRAMM", "WORD", function_declaration_num, &head);
								add_node_to_stack("PROGRAMM", "WORD", temp, &head);
								root = temp;
								}
 | main
 ;

program_x:
 | program_x EOL
 | program_x EOL function_declaration { function_declaration_num++;}
 | function_declaration { function_declaration_num++; }
 ;

function_declaration: type ident func_prototype_decl_with_brace function_body_with_brace {
																		ident_name = ident_stack_pop(&ident_stack_head);
																		//create_list_and_add_to_stack(ident_name, &head);
																		free(ident_name);
																		tree_node* temp = create_node("FUNC_DECLAR", "WORD", 4, &head);
																		add_node_to_stack("FUNC_DECLAR", "WORD", temp, &head);
																		root = temp;
																		function_var_declaration_num = 0;
																	}
 | type ident func_prototype_decl_with_brace EOL function_body_with_brace {
																		ident_name = ident_stack_pop(&ident_stack_head);
																		//create_list_and_add_to_stack(ident_name, &head);
																		free(ident_name);
																		tree_node* temp = create_node("FUNC_DECLAR", "WORD", 4, &head);
																		add_node_to_stack("FUNC_DECLAR", "WORD", temp, &head);
																		root = temp;
																		function_var_declaration_num = 0;
																	}	
 ;

func_prototype_decl_with_brace: LEFT_BR func_prototype_decl RIGHT_BR {
																		tree_node* temp = create_node("FUNC_PARAM_DECLAR", "WORD", function_var_declaration_num, &head);
																		add_node_to_stack("FUNC_VAR_DECLAR", "WORD", temp, &head);
																		root = temp;
																		function_var_declaration_num = 0;
																	}
																	;

func_prototype_decl:
 | type ident								{
												
												ident_name = ident_stack_pop(&ident_stack_head);
												declarated_ident_stack_push(ident_name, &declarated_ident_stack_head);
												//create_list_and_add_to_stack(ident_name, &head);
												free(ident_name);
												tree_node* temp = create_node("FUNC_VAR_DECLAR", "WORD", 2, &head);
												add_node_to_stack("FUNC_VAR_DECLAR", "WORD", temp, &head);
												root = temp;
												function_var_declaration_num++;						
											}
 | func_prototype_decl COMMA type ident		{
												ident_name = ident_stack_pop(&ident_stack_head);
												declarated_ident_stack_push(ident_name, &declarated_ident_stack_head);
												//create_list_and_add_to_stack(ident_name, &head);
												free(ident_name);
												tree_node* temp = create_node("FUNC_VAR_DECLAR", "WORD", 2, &head);
												add_node_to_stack("FUNC_VAR_DECLAR", "WORD", temp, &head);
												root = temp;
												function_var_declaration_num++;
											}
 ;

main: type MAIN func_prototype_decl_with_brace function_body_with_brace { 
																		create_list_and_add_to_stack("MAIN", "WORD", &head);
																		tree_node* temp = create_node("FUNC_DECLAR", "WORD", 4, &head);
																		add_node_to_stack("FUNC_DECLAR", "WORD", temp, &head);
																		root = temp;
																		function_var_declaration_num = 0;
																		function_declaration_num++;
																		}
 | type MAIN func_prototype_decl_with_brace EOL function_body_with_brace { 
																		create_list_and_add_to_stack("MAIN", "WORD", &head);
																		tree_node* temp = create_node("FUNC_DECLAR", "WORD", 4, &head);
																		add_node_to_stack("FUNC_DECLAR", "WORD", temp, &head);
																		root = temp;
																		function_var_declaration_num = 0;
																		function_declaration_num++;
																		}
 ;

//===================================================================

function_body_with_brace:
 LEFT_BRACE function_body RIGHT_BRACE {				printf("actions: %d\n", action_num);													
													tree_node* temp = create_node("BODY", "WORD", action_num, &head);
													add_node_to_stack("BODY", "WORD", temp, &head);
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

action: function_call {  }
 | assignment_operator {  }
 | variable_declaration  {  }
 | loop {  }
 ;

assignment_operator:
 | ident ASSIGNMENT function_parameter {
													ident_name = ident_stack_pop(&ident_stack_head);
													//create_list_and_add_to_stack(ident_name, &head);
													free(ident_name);
													tree_node* temp = create_node("=", "=", 2, &head);
													add_node_to_stack("ASSIGNMENT", "WORD", temp, &head);
													root = temp;
																							
													}
 | array ASSIGNMENT function_parameter
 ;

variable_declaration: type declaration_list {
												printf("declaration_num = %d\n", declaration_num);
												tree_node* temp = create_node("DECLARATION LIST", "WORD", declaration_num, &head);
												add_node_to_stack("DECLARATION LIST", "WORD", temp, &head);												
												root = temp;
												temp = create_node("DECLARATION", "WORD", 2, &head);
												add_node_to_stack("DECLARATION", "WORD", temp, &head);
												root = temp;				
												declaration_num = 0;
											}
 ;

type: INT { create_list_and_add_to_stack("INT", "TYPE", &head);}
 | CHAR { create_list_and_add_to_stack("CHAR", "TYPE", &head);}
 | VOID { create_list_and_add_to_stack("VOID", "TYPE", &head);}
 ;

declaration_list: declaration_list COMMA dec_temp {declaration_num++;}
 | dec_temp {declaration_num++;}
 ;

dec_temp: ident { ident_name = ident_stack_pop(&ident_stack_head); /*create_list_and_add_to_stack(ident_name, &head);*/ ; free(ident_name);}
 | array
 | td_array
 ;
 
//============= FUNCTION ============================

function_parameter: arithmetic_operation {
											
											//tree_node* temp = create_node("FUNCTION_PARAMETR_ARITHMETIC", "WORD", 1, &head);
											//add_node_to_stack("FUNCTION_PARAMETR_ARITHMETIC", "WORD", temp, &head);
											//root = temp;
											}
 | function_call
 ;

function_call: ident LEFT_BR param_list RIGHT_BR	{ create_list_and_add_to_stack("FUNCTION_CALL", "WORD", &head); }
 ; //================== Исправить! =============
 
param_list:
 | param_list COMMA function_parameter
 | function_parameter
 //| error { puts("param list error"); }
 ;

arithmetic_operation: LEFT_BR arithmetic_operation RIGHT_BR {
													
													//create_list_and_add_to_stack("LEFT_BR", &head);
													//create_list_and_add_to_stack("ARITHMETIC_OP", &head);
													//create_list_and_add_to_stack("RIGHT_BR", &head);
													//tree_node* temp = create_node("WITH_BRACE", 3, &head);
													//add_node_to_stack("WITH_BRACE", "WORD", temp, &head);
													//root = temp;												
																}
 | ABS arithmetic_operation ABS { $$ = $2 >= 0 ? $2 : -$2; }
 | arithmetic_operation SUB arithmetic_operation {
													$$ = $1 - $3; 
													tree_node* temp = create_node("SUB", "MATH", 2, &head);
													add_node_to_stack("SUB", "MATH", temp, &head);
													root = temp;
													}													
 | arithmetic_operation ADD arithmetic_operation {
													$$ = $1 + $3; 
													tree_node* temp = create_node("ADD", "MATH", 2, &head);
													add_node_to_stack("ADD", "MATH", temp, &head);
													root = temp;
												}
 | arithmetic_operation MUL arithmetic_operation {
													$$ = $1*$3; 
													tree_node* temp = create_node("MUL", "MATH", 2, &head);
													add_node_to_stack("MUL", "MATH", temp, &head);
													root = temp;
												}
 | arithmetic_operation DIV arithmetic_operation {
													$$ = $1/$3; 
													tree_node* temp = create_node("DIV", "MATH", 2, &head);
													add_node_to_stack("DIV", "MATH", temp, &head);
													root = temp;
												}
 | arithmetic_operation MOD arithmetic_operation {
													$$ = $1%$3; 
													tree_node* temp = create_node("MOD", "MATH", 2, &head);
													add_node_to_stack("MOD", "MATH", temp, &head);
													root = temp;
												}
 | SUB arithmetic_operation %prec UMINUS {
											$$=-$2; 
											tree_node* temp = create_node("UMINUS", "MATH", 1, &head);
											add_node_to_stack("UMINUS", "MATH", temp, &head);
											root = temp;
										}
 | NUMBER {
			$$=$1; 
			char x[10];
			sprintf(x, "%d", $1);
			create_list_and_add_to_stack(x, "NUMBER", &head);
			}
 | ident {ident_name = ident_stack_pop(&ident_stack_head);  /*create_list_and_add_to_stack(ident_name, &head);*/ free(ident_name);
}
 | array { create_list_and_add_to_stack("array", "ARRAY", &head);}
 | td_array {}
 ;

ident: IDENT {
				ident_name = calloc(40, sizeof(char));
				strcpy(ident_name, $1);
				ident_stack_push(ident_name, &ident_stack_head);
				create_list_and_add_to_stack(ident_name, "IDENT", &head);
				
				free(ident_name);
			};

//================= LOOP =======================//

loop: loop2 function_body_with_brace WHILE LEFT_BR condition_expression_list RIGHT_BR {
																						create_list_and_add_to_stack("DO", "WORD", &head);
																						create_list_and_add_to_stack("WHILE", "WORD", &head);
																						tree_node* temp = create_node("DO_WHILE", "WORD",4, &head);
																						add_node_to_stack("DO_WHILE", "WORD", temp, &head);
																						root = temp;
																						action_num = action_num_stack_pop(&action_stack_head);
																						}
 ;

 loop2: DO {
			puts("-------- DO ------");
			 action_num_stack_push(action_num, &action_stack_head);
			 action_num = 0;
		}
//================ CONDITION =====================//

condition: condition_if EOL	{
							puts("=-------------------- condition_if -----------------");
							tree_node* temp = create_node("CONDITION_IF", "WORD", 1, &head);
							add_node_to_stack("CONDITION", "WORD", temp, &head);
							root = temp;
							action_num = action_num_stack_pop(&action_stack_head);											
						}
 | condition_if EOL condition_else {
										output_stack(head);
										tree_node* temp = create_node("CONDITION_IF_ELSE", "WORD", 2, &head);
										add_node_to_stack("CONDITION", "WORD", temp, &head);
										root = temp;
										output_stack(head);
										action_num = action_num_stack_pop(&action_stack_head);			
									}
 ;


if_temp: IF LEFT_BR {action_num_stack_push(action_num, &action_stack_head); puts("IF LEFT_BR -----------------------------");
														action_num = 0;}
 
condition_if: if_temp condition_expression_list RIGHT_BR function_body_with_brace {
													output_stack(head);
													tree_node* temp = create_node("IF", "WORD", 2, &head);
													add_node_to_stack("IF", "WORD", temp, &head);
													root = temp;
													output_stack(head);												
												}
 | if_temp condition_expression_list RIGHT_BR EOL function_body_with_brace {														
													output_stack(head);
													tree_node* temp = create_node("IF", "WORD", 2, &head);
													add_node_to_stack("IF", "WORD", temp, &head);
													root = temp;													output_stack(head);																				
												}
 ;
 
condition_else: ELSE function_body_with_brace	{														
													tree_node* temp = create_node("ELSE", "WORD", 1, &head);
													add_node_to_stack("ELSE", "WORD", temp, &head);
													root = temp;													
												}
 | ELSE EOL function_body_with_brace 	{														
											tree_node* temp = create_node("ELSE", "WORD", 1, &head);
											add_node_to_stack("ELSE", "WORD", temp, &head);
											root = temp;														
										}
 ;

condition_expression_list: condition_expression OR condition_expression
													{
													output_stack(head);
														
														puts("condition expression list");
														tree_node* temp = create_node("OR", "BOOL", 2, &head);
														add_node_to_stack("OR", "BOOL", temp, &head);
														root = temp;
														output_stack(head);												
													}
 | condition_expression AND condition_expression
													{
														//action_num_stack_push(action_num, &action_stack_head);
														//action_num = 0;
														puts("condition expression list");
														tree_node* temp = create_node("AND", "BOOL", 2, &head);
														add_node_to_stack("AND", "BOOL", temp, &head);
														root = temp;												
													}
														
 | condition_expression	{
							//action_num_stack_push(action_num, &action_stack_head);
							//action_num = 0;
							puts("condition expression list + push");
							//tree_node* temp = create_node("CONDITION_EXPRESSION", "WORD", 1, &head);
							//add_node_to_stack("CONDITION_EXPRESSION", "WORD", temp, &head);
							//root = temp;
						}
 ;
 
condition_expression: NOT cond_temp {
										tree_node* temp = create_node("NOT", "BOOL", 1, &head);
										add_node_to_stack("NOT", "BOOL", temp, &head);
										root = temp;
									}
 | cond_temp
 | error {printf("ERROR: line: %d: condition error\n", @1.first_line); }
 ;
 
cond_temp: LEFT_BR cond_temp RIGHT_BR { puts("cond_temp in br"); }
 | function_parameter LESS function_parameter {
												puts("cond_temp");
												output_stack(head);
												tree_node* temp = create_node("LESS", "BOOL", 2, &head);
												add_node_to_stack("LESS", "BOOL", temp, &head);
												root = temp;
												output_stack(head);
											}
 | function_parameter LARGER function_parameter {
												puts("cond_temp");
												tree_node* temp = create_node("LARGER", "BOOL", 2, &head);
												add_node_to_stack("LARGER", "BOOL", temp, &head);
												root = temp;
											}
 | function_parameter LESS_OR_EQUAL function_parameter {
												puts("cond_temp");
												tree_node* temp = create_node("LESS_OR_EQUAL", "BOOL", 2, &head);
												add_node_to_stack("LESS_OR_EQUAL", "BOOL", temp, &head);
												root = temp;
											}
 | function_parameter LARGER_OR_EQUAL function_parameter {
												puts("cond_temp");
												tree_node* temp = create_node("LARGER_OR_EQUAL", "BOOL", 2, &head);
												add_node_to_stack("LARGER_OR_EQUAL", "BOOL", temp, &head);
												root = temp;
											}
 | function_parameter EQUAL function_parameter {
												puts("cond_temp");
												tree_node* temp = create_node("EQUAL", "BOOL", 2, &head);
												add_node_to_stack("EQUAL", "BOOL", temp, &head);
												root = temp;
											}
 | function_parameter NOT_EQUAL function_parameter {
												puts("cond_temp");
												tree_node* temp = create_node("NOT_EQUAL", "BOOL", 2, &head);
												add_node_to_stack("NOT_EQUAL", "BOOL", temp, &head);
												root = temp;
											}
 ;

//================= ARRAY ================

array: ident index
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
	output_stack(head);
	output_declarated_ident_stack(declarated_ident_stack_head);
	//find_main(root);
	start_tree_walking(root);
}

yyerror(char *s)
{
	fprintf(stderr, "error: %s\n", s);
}