typedef struct bool_op_stack
{
    int value;
    struct bool_op_stack *next;
}
bool_op_stack;

typedef struct bool_res_stack
{
    char res_name[10];
    struct bool_res_stack *next;
}
bool_res_stack;

void output_bool_res_stack(bool_res_stack *head)
{
	puts("==== output_bool_res_stack start: ====");
	while(head)
	{
		puts(head->res_name);
		head = head->next;
	}
	puts("==== output_bool_res_stack end: ====");
}	

void bool_op_stack_push(int x, bool_op_stack **head)
{
	bool_op_stack* temp = calloc(1, sizeof(bool_res_stack));
	temp->value = x;
	temp->next = (*head);
	(*head) = temp;
}

void bool_res_stack_push(int x, bool_res_stack **head)
{
	bool_res_stack* temp = calloc(1, sizeof(bool_res_stack));
	if(x == 0)	
		strcpy(temp->res_name, "FALSE");
	else
		strcpy(temp->res_name, "TRUE");
	temp->next = (*head);
	(*head) = temp;
}

bool_op_stack* bool_op_stack_calculate(char* op, bool_op_stack **head)
{
	
	static bool_res_stack *res_head = NULL;
	puts("bool_op_stack_calc_start");
	puts(op);
	int x = 0;
	bool_op_stack* temp;
	bool_res_stack* res_temp;
	if(strcmp(op, "LESS") == 0)
	{
		if((*head)->value < (*head)->next->value)
		{
			bool_res_stack_push(1, &res_head);
		}
		else
		{
			bool_res_stack_push(0, &res_head);
		}
		temp = (*head);
		(*head) = (*head)->next->next;
		free(temp->next);
		free(temp);
		return res_head;
	}
	if(strcmp(op, "LARGER") == 0)
	{
		if((*head)->value > (*head)->next->value)
		{
			bool_res_stack_push(1, &res_head);
		}
		else
		{
			bool_res_stack_push(0, &res_head);
		}
		temp = (*head);
		(*head) = (*head)->next->next;
		free(temp->next);
		free(temp);		
		return res_head;
	}
	if(strcmp(op, "EQUAL") == 0)
	{
		if((*head)->value == (*head)->next->value)
		{
			bool_res_stack_push(1, &res_head);
		}
		else
		{
			bool_res_stack_push(0, &res_head);
		}
		temp = (*head);
		(*head) = (*head)->next->next;
		free(temp->next);
		free(temp);
		return res_head;
	}
	if(strcmp(op, "NOT_EQUAL") == 0)
	{
		if((*head)->value != (*head)->next->value)
		{
			bool_res_stack_push(1, &res_head);
		}
		else
		{
			bool_res_stack_push(0, &res_head);
		}
		temp = (*head);
		(*head) = (*head)->next->next;
		free(temp->next);
		free(temp);
		return res_head;
	}
	if(strcmp(op, "LESS_OR_EQUAL") == 0)
	{
		if((*head)->value <= (*head)->next->value)
		{
			bool_res_stack_push(1, &res_head);
		}
		else
		{
			bool_res_stack_push(0, &res_head);
		}
		temp = (*head);
		(*head) = (*head)->next->next;
		free(temp->next);
		free(temp);
		return res_head;
	}
	if(strcmp(op, "LARGER_OR_EQUAL") == 0)
	{
		if((*head)->value >= (*head)->next->value)
		{
			bool_res_stack_push(1, &res_head);
		}
		else
		{
			bool_res_stack_push(0, &res_head);
		}
		temp = (*head);
		(*head) = (*head)->next->next;
		free(temp->next);
		free(temp);
		return res_head;
	}
//=====================
	if(strcmp(op, "OR") == 0)
	{
		if((strcmp((res_head)->res_name, "TRUE") == 0) || (strcmp((res_head)->next->res_name, "TRUE") == 0))
		{
			strcpy(res_head->next->res_name, "TRUE");
			res_temp = res_head;
			res_head = res_head->next;
			free(res_temp);
			return res_head;		
		}
		if((strcmp((res_head)->res_name, "FALSE") == 0) && (strcmp((res_head)->next->res_name, "FALSE") == 0))
		{
			strcpy(res_head->next->res_name, "FALSE");
			res_temp = res_head;
			res_head = res_head->next;
			free(res_temp);
			return res_head;
		}
	}
	if(strcmp(op, "AND") == 0)
	{
		if((strcmp((res_head)->res_name, "TRUE") == 0) && (strcmp((res_head)->next->res_name, "TRUE") == 0))
		{
			strcpy(res_head->next->res_name, "TRUE");
			res_temp = res_head;
			res_head = res_head->next;
			free(res_temp);
			return res_head;		
		}
		if((strcmp((res_head)->res_name, "FALSE") == 0) || (strcmp((res_head)->next->res_name, "FALSE") == 0))
		{
			strcpy(res_head->next->res_name, "FALSE");
			res_temp = res_head;
			res_head = res_head->next;
			free(res_temp);
		}
		return res_head;
	}	
}
	