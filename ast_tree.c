#include "ast.h"
ast_tree_t *ast_alloc()
{
    return (ast_tree_t *)malloc(sizeof(ast_tree_t));
}

ast_tree_t *new_node_int(char *name,int int_data,int lineno)
{
    ast_tree_t *new_node=ast_alloc();
    new_node->flag=1;
    new_node->lineno=lineno;
    new_node->int_data=int_data;
    new_node->fir=new_node->next=NULL;
    strcpy(new_node->name,name);
}
ast_tree_t *new_node_str(char *name,char* str_data,int lineno)
{
    ast_tree_t *new_node=ast_alloc();
    new_node->flag=3;
    new_node->lineno=lineno;
    strcpy(new_node->str_data,str_data);
    new_node->fir=new_node->next=NULL;
    strcpy(new_node->name,name);
}
ast_tree_t *new_node_float(char *name,float float_data,int lineno){
    ast_tree_t *new_node=ast_alloc();
    new_node->flag=2;
    new_node->lineno=lineno;
    new_node->float_data=float_data;
    new_node->fir=new_node->next=NULL;
    strcpy(new_node->name,name);
}
ast_tree_t *new_node_noval(char *name,int lineno)
{
    ast_tree_t *new_node=ast_alloc();
    new_node->flag=0;
    new_node->lineno=lineno;
    new_node->fir=new_node->next=NULL;
    strcpy(new_node->name,name);
}
ast_tree_t * creatAst(char *name,int len,...)
{
    ast_tree_t *node=ast_alloc();
    strcpy(node->name,name);
    node->flag=0;
    if(len==0)
    {
        node->fir=NULL;
        node->next=NULL;
        return node;
    }
    assert(len>=1);
    va_list valist;
    va_start(valist,len);
    ast_tree_t *temp=va_arg(valist,ast_tree_t *);
    node->fir=temp;
    node->lineno=temp->lineno;
    for (size_t i = 1; i < len; i++)
    {
        temp->next=va_arg(valist,ast_tree_t *);
        temp=temp->next;
    }
    return node;
}
void eval(ast_tree_t *root)
{

}
