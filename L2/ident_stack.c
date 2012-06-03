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
