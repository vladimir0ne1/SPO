//#include "tree.h"
#include "stdio.h"
#include "stdlib.h"

typedef struct tree_node
{
    char name[50];
    char operation_name[50];
    int branch_num;
    struct tree_node **branch;
} tree_node;

typedef struct declarated_ident_stack
{
	char name[50];
	struct declarated_ident_stack* next;
	int value;
}	declarated_ident_stack;

void declarated_ident_set_val(int val, char* id_name, declarated_ident_stack *head)
{
	declarated_ident_stack* temp = head;
	while(temp)
	{
		if (strcmp(id_name, temp->name) == 0)
		{
			temp->value = val;
			return;
		}
		else
			temp = temp->next;
	}	
		printf("ERROR: undeclaratred param: %s\n", id_name);
	return;
}

int declarated_ident_stack_find(char* id_name, declarated_ident_stack* head)
{
	declarated_ident_stack* temp = head;
	while(temp)
	{
		//printf("decl_id_find: name: %s\n", temp->name);
		if (strcmp(id_name, temp->name) == 0)
		{			 
			return temp->value;
		}
		else
			temp = temp->next;
	}	
		printf("ERROR: undeclaratred param: %s\n", id_name);
	return 0;
}

int is_declarated(char* id_name, declarated_ident_stack* head)
{
	declarated_ident_stack* temp = head;
	while(temp)
	{
		if (strcmp(id_name, temp->name) == 0)
		{
			//temp->value = val;
			return 1;
		}
		else
			temp = temp->next;
	}	
		printf("ERROR: undeclaratred param: %s\n", id_name);
	return 0;
}

void declarated_ident_stack_push(char* id_name, declarated_ident_stack **head)
{
	puts(id_name);
	declarated_ident_stack* temp = (*head);
	temp = calloc(1, sizeof(declarated_ident_stack));
	temp->next = (*head);
	temp->value = 0;
	strcpy(temp->name, id_name);
	(*head) = temp;
}

void output_declarated_ident_stack(declarated_ident_stack* head)
{
	puts("==== output_declarated_ident_stack start: ====");
	while(head)
	{
		printf("%s = %d\n", head->name, head->value);
		//puts(head->name);
		head = head->next;
	}
	puts("==== output_declarated_ident_stack end: ====");
}

typedef struct stack
{
	char name[50];
	struct stack* next;
	struct tree_node* branch;
}	stack;

typedef struct action_num_stack
{
	int num;
	struct action_num_stack* next;
}	action_num_stack;

typedef struct ident_stack
{
	char* ident_name;
	struct ident_stack* next;
}	ident_stack;

char* ident_stack_pop(ident_stack **head)
{
	ident_stack* temp = (*head);
	char* x = temp->ident_name;
	(*head) = temp->next;
	free(temp);
	return x;
}

void ident_stack_push(char* ident_nm, ident_stack **head)
{
	ident_stack* temp = (*head);
	temp = calloc(1, sizeof(ident_stack));
	temp->next = (*head);
	temp->ident_name = calloc(50, sizeof(char));
	strcpy(temp->ident_name, ident_nm);
	(*head) = temp;
}

int action_num_stack_pop(action_num_stack **head)
{
	action_num_stack* temp = (*head);
	int x = temp->num;
	(*head) = temp->next;
	free(temp);
	return x;
}

void action_num_stack_push(int x, action_num_stack **head)
{
	action_num_stack* temp = (*head);
	temp = calloc(1, sizeof(action_num_stack));
	temp->next = (*head);
	temp->num = x;
	(*head) = temp;
}

tree_node* create_list_and_add_to_stack(char* node_name, char op_name[50], stack** head)
{
	stack* work = calloc(1, sizeof(stack));
	work->next = *(head);
	(*head) = work;
	tree_node* nd = calloc(1, sizeof(tree_node));
	nd->branch = NULL;
	nd->branch_num = 0;
	strcpy(nd->name, node_name);
	strcpy(nd->operation_name, op_name);
	strcpy((*head)->name, node_name);
	
	(*head)->branch = nd;
	return nd;
}

tree_node* add_node_to_stack(char node_name[20], char temp[20], tree_node* node, stack** head)
{
	stack* work = calloc(1, sizeof(stack));
	work->next = *(head);
	(*head) = work;	
	(*head)->branch = node;
	strcpy((*head)->name, node_name);
	return node;
}

tree_node* create_node(char node_name[20], char op_name[50], int branch_count, stack** head)
{
	stack* work = (*head);
	stack* temp = work;
	tree_node* nd = calloc(1, sizeof(tree_node));
	nd->branch = calloc(branch_count, sizeof(tree_node));
	nd->branch_num = branch_count;
	strcpy(nd->name, node_name);
	strcpy(nd->operation_name, op_name);
	char str[10];
	strcpy(str, "BODY");
	if(strcmp(str, node_name) == 0)
	{
		int i = branch_count;
		while(i>0)		// get list from stack
		{
			nd->branch[i-1] = work->branch;
			temp = work;
			work = work->next;
			free(temp);
			i--;
		}
	}
	else
	{
		int i = 0;
		while(i<branch_count)		// get list from stack
		{
			nd->branch[i] = work->branch;
			temp = work;
			work = work->next;
			free(temp);
			i++;
		}
	}
	(*head) = work; 
	return nd;
}
void output_stack(stack* head)
{
	puts("==== stack start: ====");
	while(head)
	{
		puts(head->name);
		head = head->next;
	}
	puts("==== stack end: ====");
}
void output(tree_node* s)
{
	static int level = 0;
	if(s)
	{
		level++;
		if (s->branch_num != 0)
		{
			output(s->branch[0]);
			int i = 1;
			while(i<(s->branch_num))
			{
				output(s->branch[i]);				
				i++;
			}
		}
		level--;
		//puts(s->name);
		printf("%-20s, operation: %-10s,  level: %-4d\n", s->name, s->operation_name, level);
	}
}


//================================================ Tree Walking ================

typedef struct math_stack
{
    int value;
    struct math_stack *next;
}
math_stack;

void math_stack_push(int x, math_stack **head)
{
	//printf("math_stack_push: %d\n", x);
	math_stack* temp = calloc(1, sizeof(math_stack));
	temp->value = x;
	temp->next = (*head);
	(*head) = temp;
}
void math_stack_calculate(char* op, math_stack **head)
{
	//printf("math_stack_calculate: %s\n", op);
	int x = 0;
	math_stack* temp;
	if(strcmp(op, "SUB") == 0)
	{
		x = (*head)->value - (*head)->next->value;
		(*head)->next->value = x;
		temp = (*head);
		(*head) = (*head)->next;
	}
	if(strcmp(op, "MUL") == 0)
	{
		x = (*head)->value * (*head)->next->value;
		(*head)->next->value = x;
		temp = (*head);
		(*head) = (*head)->next;
	}
	if(strcmp(op, "DIV") == 0)
	{
		x = (*head)->value / (*head)->next->value;
		(*head)->next->value = x;
		temp = (*head);
		(*head) = (*head)->next;
	}
	if(strcmp(op, "ADD") == 0)
	{
		x = (*head)->value + (*head)->next->value;
		(*head)->next->value = x;
		temp = (*head);
		(*head) = (*head)->next;
	}
	free(temp);
}
	
tree_node* find_main(tree_node* s)
{	
	if(s)
	{		
		if (s->branch_num != 0)
		{
			
			find_main(s->branch[0]);
			int i = 1;
			while(i<(s->branch_num))
			{
				find_main(s->branch[i]);				
				i++;
			}
		}
		if(strcmp(s->name, "MAIN") == 0)
			printf("%-20s, main was found\n", s->name);
	}
}

int calculate(tree_node* s, declarated_ident_stack* d_head)
{	
	static op_num = 0;
	static int ident_val = 0;
	//printf("calculation start: level %d\n", op_num);
	static math_stack* head = NULL;
	if(s->branch_num != 0)
	{
		puts(s->name);
		op_num++;
		//printf("op num: %d\n", op_num);
		calculate(s->branch[0], d_head);
		calculate(s->branch[1], d_head);				
			math_stack_calculate(s->name, &head);
		return head->value;		
	}
	if(strcmp(s->operation_name, "NUMBER") == 0)
		math_stack_push(atoi(s->name), &head);
	if(strcmp(s->operation_name, "IDENT") == 0)
	{
		//output_declarated_ident_stack(d_head);
		//printf("calculation: ident name: %s\n", s->name);
		ident_val = declarated_ident_stack_find(s->name, d_head);
		math_stack_push(ident_val, &head);
	}
	op_num--;
}

void start_tree_walking(tree_node* s, declarated_ident_stack* head)
{
	//declarated_ident_stack* declarated_ident_stack_head;
	tree_node* work = s->branch[0]->branch[1];
	tree_node* temp = work;
	int x = work->branch_num;
	printf("branch_num: %d\n", x);
	int i = 0;
	while(x>0)
	{
		work = work->branch[i];		// body branch: 1, 2, 3 action etc.
		puts(work->name);
		if( strcmp(work->name, "=") == 0)
		{
			if(is_declarated(work->branch[1]->name, head) == 0)
			{
				break;
			}
			int z = calculate(work->branch[0], head);
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
				declarated_ident_stack_push(work->branch[0]->branch[j], &head);
				j--;
				//output_declarated_ident_stack(head);
			}
		}
		work = temp;
		
		x--;
		i++;
	}
	output_declarated_ident_stack(head);
}