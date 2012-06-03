typedef struct function_call_param_stack
{
    int value;
    struct function_call_param_stack *next;
} function_call_param_stack;

void function_call_param_stack_push(int val, function_call_param_stack **head)
{
	puts("function_call_param_stack_push");
	function_call_param_stack* temp = (*head);
	temp = calloc(1, sizeof(function_call_param_stack));
	temp->next = (*head);
	temp->value = val;
	(*head) = temp;
}

int function_call_param_stack_pop(function_call_param_stack **head)
{
	puts("f_c_p_s_pop!");
	function_call_param_stack* temp = (*head);
	int x = temp->value;
	(*head) = temp->next;
	free(temp);
	printf("ret_val = %d\n", x);
	return x;
}

void output_function_call_param_stack(function_call_param_stack* head)
{
	puts("==== function_call_param_stack start: ====");
	while(head)
	{
		printf("param = %d\n", head->value);
		head = head->next;
	}
	puts("==== function_call_param_stack end: ====");
}
