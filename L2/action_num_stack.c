typedef struct action_num_stack
{
	int num;
	struct action_num_stack* next;
}	action_num_stack;

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
