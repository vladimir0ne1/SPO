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
	