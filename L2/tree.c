//#include "tree.h"
#include "stdio.h"
#include "stdlib.h"
#include "func_call_param_stack.c"
#include "ident_stack.c"
#include "action_num_stack.c"
#include "math_stack.c"
#include "declarated_ident_stack.c"
#include "tree_declaration.c"
#include "bool_stack.c"

//================================================ Tree Walking ================

tree_node* find_func(tree_node* s, char* func_name)
{
	static tree_node* temp = NULL;
	if(s)
	{
		
		if (s->branch_num != 0)
		{			
			find_func(s->branch[0], func_name);
			int i = 1;
			while(i<(s->branch_num))
			{
				find_func(s->branch[i], func_name);				
				i++;
			}
		}
		if(strcmp(s->name, "FUNC_DECLAR") == 0 && strcmp(s->branch[2]->name, func_name) == 0)
		{
			printf("%-20s, Func was found\n", s->branch[2]->name);
			puts(s->branch[0]->name);
			puts(s->branch[1]->name);
			puts(s->branch[3]->name);
			temp = s;
		}
	}
	return temp;
}

int calculate(tree_node* s, declarated_ident_stack* d_head)
{	
	static op_num = 0;
	static int ident_val = 0;
	static math_stack* head = NULL;	
	if(s->branch_num != 0)
	{
		puts(s->name);
		op_num++;
		calculate(s->branch[0], d_head);
		calculate(s->branch[1], d_head);				
			math_stack_calculate(s->name, &head);
		return head->value;		
	}
	if(strcmp(s->operation_name, "NUMBER") == 0)
		math_stack_push(atoi(s->name), &head);
	if(strcmp(s->operation_name, "IDENT") == 0)
	{
		ident_val = declarated_ident_stack_find(s->name, d_head);
		math_stack_push(ident_val, &head);
	}
	op_num--;
}

int bool_calculate(tree_node* s, declarated_ident_stack* d_head)
{
	static op_num = 0;
	static int ident_val = 0;
	static bool_op_stack* head = NULL;
	bool_res_stack* res_head = NULL;
	//puts("bool_calc_start");
	//printf("name = %s, branch = %d\n", s->name, s->branch_num);
	if(s->branch_num != 0)
	{
		//puts(s->name);
		bool_calculate(s->branch[0], d_head);
		bool_calculate(s->branch[1], d_head);				
			res_head = bool_op_stack_calculate(s->name, &head);

		if(strcmp(res_head->res_name, "TRUE") == 0)
			return 1;
		else
			return 0;
	}
	if(strcmp(s->operation_name, "NUMBER") == 0)
		bool_op_stack_push(atoi(s->name), &head);
	if(strcmp(s->operation_name, "IDENT") == 0)
	{
		ident_val = declarated_ident_stack_find(s->name, d_head);
		bool_op_stack_push(ident_val, &head);
	}
}

int start_tree_walking(tree_node* s, tree_node* root , declarated_ident_stack* head, int flag, function_call_param_stack* param_stack_head)
{
	tree_node* work = NULL;
	if(flag == 0)
	{
		head = NULL;
		work = s->branch[0]->branch[1];
		int zz = 0;
		zz = s->branch[0]->branch[2]->branch_num;
		while(zz)
		{
			declarated_ident_stack_push(s->branch[0]->branch[2]->branch[zz-1]->branch[0]->name, &head);	declarated_ident_set_val(function_call_param_stack_pop(&param_stack_head), s->branch[0]->branch[2]->branch[zz-1]->branch[0]->name, head);
			zz--;
		}
	}
	if(flag == 1)
	{
		head = NULL;		
		puts(s->name);
		work = s->branch[0];
		int zz = 0;
		zz = s->branch[1]->branch_num;
		while(zz)
		{
			declarated_ident_stack_push(s->branch[1]->branch[zz-1]->branch[0]->name, &head);
			puts("decl_ident_s_push_OK");
			//puts(s->branch[1]->branch[zz-1]->branch[0]->name);
			int par = function_call_param_stack_pop(&param_stack_head);
			printf("param_pop_OK, param = %d\n", par);
			
			declarated_ident_set_val(par, s->branch[1]->branch[zz-1]->branch[0]->name, head);
			zz--;
		}
	}
	if(flag == 2)
	{
		//head = NULL;
		work = s;
	}
	tree_node* temp = work;
	declarated_ident_stack* head_2;	
	int x = work->branch_num;
	printf("branch_num: %d\n", x);
	int i = 0;
	while(x>0)
	{
		work = work->branch[i];		// body branch: 1, 2, 3 action etc.
		puts(work->name);
		if( strcmp(work->name, "FUNCTION_CALL") == 0)
		{
			int p_num = work->branch[0]->branch_num;
			while(p_num)
			{
				puts("function_call!!");
				printf("p_num = %d\n", p_num);
				if(strcmp(work->branch[0]->branch[p_num-1]->operation_name, "NUMBER") == 0)
					function_call_param_stack_push(atoi(work->branch[0]->branch[p_num-1]->name), &param_stack_head);
				else
					function_call_param_stack_push(declarated_ident_stack_find(work->branch[0]->branch[p_num-1]->name, head), &param_stack_head);
				p_num--;
			}
			head_2 = NULL;
			puts("Func Call -> start!");

			output_function_call_param_stack(param_stack_head);
			
			start_tree_walking(find_func(root, work->branch[1]->name), root, head_2, 1, param_stack_head);
		}
		if( strcmp(work->name, "=") == 0)
		{
			int z;
			if(is_declarated(work->branch[1]->name, head) == 0)
			{
				break;
			}
			
			if(work->branch[0]->branch_num == 0)
			{
				if(strcmp(work->branch[0]->operation_name, "NUMBER") == 0)
					z = atoi(work->branch[0]->name);
				
				if(strcmp(work->branch[0]->operation_name, "IDENT") == 0)
					z = declarated_ident_stack_find(work->branch[0]->name, head);			
			}
			else
			{
				if(strcmp(work->branch[0]->name, "FUNCTION_CALL") == 0)
				{
					puts("= function_call!!");

					int p_num = work->branch[0]->branch[0]->branch_num;
					while(p_num)
					{
						puts("=function_call 2");
						printf("p_num = %d\n", p_num);
						if(strcmp(work->branch[0]->branch[0]->branch[p_num-1]->operation_name, "NUMBER") == 0)
							function_call_param_stack_push(atoi(work->branch[0]->branch[0]->branch[p_num-1]->name), &param_stack_head);
						else
							function_call_param_stack_push(declarated_ident_stack_find(work->branch[0]->branch[0]->branch[p_num-1]->name, head), &param_stack_head);
						p_num--;
					}
					head_2 = NULL;
					puts("Func Call -> start!");
					
					output_function_call_param_stack(param_stack_head);
					
					puts(work->branch[0]->branch[1]->name);
					z = start_tree_walking(find_func(root, work->branch[0]->branch[1]->name), root, head_2, 1, param_stack_head);
				}
				else				
					z = calculate(work->branch[0], head);
			}
			printf(" value: %d\n", z);			
			declarated_ident_set_val(z, work->branch[1]->name, head);
			output_declarated_ident_stack(head);	
		}
		if( strcmp(work->name, "DECLARATION") == 0)
		{
			int j = work->branch[0]->branch_num-1;
			//printf("decl: i = %d, j = %d\n", i, j);
			while(j>-1)
			{
				declarated_ident_stack_push(work->branch[0]->branch[j]->name, &head);
				j--;
				output_declarated_ident_stack(head);
			}
		}
		if( strcmp(work->name, "RETURN") == 0)
		{
			int ret_val = 0;
			if(strcmp(work->branch[0]->operation_name, "NUMBER") == 0)
				{
					ret_val = atoi(work->branch[0]->name);
					printf("ret_val = %d\n", ret_val);
				}
			else
				{
					ret_val = declarated_ident_stack_find(work->branch[0]->name, head);
					printf("ret_val = %d\n", ret_val);
				}
				return ret_val;
		}
		if( strcmp(work->name, "CONDITION_IF_ELSE") == 0)
		{
			puts("condition if_else");
			int cond = 3;
			cond = bool_calculate(work->branch[1]->branch[1], head);
			printf("cond = %d\n", cond);
			if(cond == 0)
			{
				puts("condition = 0");
				puts(work->branch[0]->name);
				puts(work->branch[1]->name);
				start_tree_walking(work->branch[0]->branch[0], root, head, 2, param_stack_head);
			}
			else
			{
				puts("condition = 1");
				puts(work->branch[0]->name);
				puts(work->branch[1]->name);
				puts(work->branch[0]->branch[0]->name);
				puts(work->branch[1]->branch[0]->name);
				printf("branch num = %d\n", work->branch[1]->branch[0]->branch_num);
				start_tree_walking(work->branch[1]->branch[0], root, head, 2, param_stack_head);
			}
		}
		if( strcmp(work->name, "CONDITION_IF") == 0)
		{
			puts("condition if");
			int cond = 3;
			cond = bool_calculate(work->branch[0]->branch[1], head);
			printf("cond = %d\n", cond);
			if(cond == 1)
			{						
				//printf("branch num = %d\n", work->branch[0]->branch[0]->branch_num);
				start_tree_walking(work->branch[0]->branch[0], root, head, 2, param_stack_head);
			}
		}
		if( strcmp(work->name, "DO_WHILE") == 0)
		{
			puts("Do-while!");
			int cond = 3;						
			start_tree_walking(work->branch[3], root, head, 2, param_stack_head);
			cond = bool_calculate(work->branch[2], head);
			printf("cond = %d\n", cond);
			while(cond == 1)
			{					
				start_tree_walking(work->branch[3], root, head, 2, param_stack_head);
				cond = bool_calculate(work->branch[2], head);
				printf("cond = %d\n", cond);
			}
		}
			
		work = temp;
		
		x--;
		i++;
	}
	output_declarated_ident_stack(head);
}