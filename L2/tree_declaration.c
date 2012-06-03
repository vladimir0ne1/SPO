typedef struct tree_node
{
    char name[50];
    char operation_name[50];
    int branch_num;
    struct tree_node **branch;
} tree_node;

typedef struct stack
{
	char name[50];
	struct stack* next;
	struct tree_node* branch;
}	stack;

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

void output_tree(tree_node* s)
{
	static int level = 0;
	if(s)
	{
		level++;
		if (s->branch_num != 0)
		{
			output_tree(s->branch[0]);
			int i = 1;
			while(i<(s->branch_num))
			{
				output_tree(s->branch[i]);				
				i++;
			}
		}
		level--;
		//puts(s->name);
		printf("%-20s, operation: %-10s,  level: %-4d\n", s->name, s->operation_name, level);
	}
}


