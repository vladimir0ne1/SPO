#include "tree.h"


tree_node* create_list_and_add_to_stack(char node_name[20], stack** head)
{
	stack* work = calloc(1, sizeof(stack));
	work->next = *(head);
	(*head) = work;
	tree_node* nd = calloc(1, sizeof(tree_node));
	nd->branch = NULL;
	nd->branch_num = 0;
	strcpy(nd->name, node_name);
	(*head)->branch = nd;
	return nd;
}

tree_node* add_node_to_stack(char node_name[20], tree_node* node, stack** head)
{
	stack* work = calloc(1, sizeof(stack));
	work->next = *(head);
	(*head) = work;	
	(*head)->branch = node;
	return node;
}

tree_node* create_node(char node_name[20], int branch_count, stack** head)
{
	stack* work = (*head);
	stack* temp = work;
	tree_node* nd = calloc(1, sizeof(tree_node));
	nd->branch = calloc(branch_count, sizeof(tree_node));
	nd->branch_num = branch_count;
	strcpy(nd->name, node_name);
	int i = 0;
	while(i<branch_count)		// get list from stack
	{
		nd->branch[i] = work->branch;
		temp = work;
		work = work->next;
		free(temp);
		i++;
	}
	(*head) = work; 
	return nd;
}
	
void main()
{
	
}