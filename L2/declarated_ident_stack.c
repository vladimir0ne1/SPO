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
	puts("declarated_ident_func");
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

