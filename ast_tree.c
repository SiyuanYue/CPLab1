#include "ast.h"
ast_tree_t *ast_alloc()
{
    return (ast_tree_t *)malloc(sizeof(ast_tree_t));
}

ast_tree_t *new_node_int(char *name,int int_data,int lineno)
{
    ast_tree_t *new_node=ast_alloc();
    assert(new_node);
    new_node->flag=1;
    new_node->lineno=lineno;
    new_node->int_data=int_data;
    new_node->fir=new_node->next=NULL;
    strcpy(new_node->name,name);
    return new_node;
}
ast_tree_t *new_node_str(char *name,char* str_data,int lineno)
{
    ast_tree_t *new_node=ast_alloc();
    assert(new_node);
    new_node->flag=3;
    new_node->lineno=lineno;
    strcpy(new_node->str_data,str_data);
    strcpy(new_node->name,name);
    new_node->fir=new_node->next=NULL;
    return new_node;
}
ast_tree_t *new_node_float(char *name,float float_data,int lineno){
    ast_tree_t *new_node=ast_alloc();
    assert(new_node);
    new_node->flag=2;
    new_node->lineno=lineno;
    new_node->float_data=float_data;
    new_node->fir=new_node->next=NULL;
    strcpy(new_node->name,name);
    return new_node;
}
ast_tree_t *new_node_noval(char *name,int lineno)//建立没有属性值的词法单元
{
    ast_tree_t *new_node=ast_alloc();
    assert(new_node);
    new_node->flag=0;
    new_node->lineno=lineno;
    new_node->fir=new_node->next=NULL;
    strcpy(new_node->name,name);
    return new_node;
}
static ast_tree_t *new_node_syn(char *name) //建立非终结符（语法单元）
{
    ast_tree_t *new_node=ast_alloc();
    assert(new_node);
    new_node->flag=4;
    new_node->lineno=0;
    new_node->fir=NULL;
    new_node->next=NULL;
    strcpy(new_node->name,name);
    return new_node;
}
ast_tree_t * creatAst(char *name,int len,...)
{
    ast_tree_t *node=new_node_syn(name); // 建立一个语法单元（产生式左部）
    if(len==0)
        return node;
    //printf("%s\n",name);
    assert(len>=1);
    va_list valist;
    va_start(valist,len);
    ast_tree_t *temp=va_arg(valist,ast_tree_t *);
    assert(temp);
    node->fir=temp;
    node->lineno=temp->lineno;
    for (size_t i = 1; i < len; i++)
    {
        temp->next=va_arg(valist,ast_tree_t *);
        temp=temp->next;
    }
    return node;
}
void printAst(ast_tree_t *root,int depth)
{
    if(root==NULL)
        return;

    if(!(root->flag==4&&root->fir==NULL)) //当是产生空串的产生式，不要打印一堆空格
        for (size_t i = 0; i < depth; i++)  printf(" "); //根据当前语法节点所在深度打印对应的空格数（缩进）

    if(root->flag==4&&root->fir!=NULL) //当前结点是一个语法单元并且该语法单元没有产生空串
        printf("%s (%d)\n",root->name,root->lineno);
    else if(root->flag==0) //无属性值的词法单元
    {
        printf("%s\n",root->name);
    }
    else if(root->flag==1) //属性值是int类型的词法
    {
        printf("%s: %d\n",root->name,root->int_data);
    }
    else if(root->flag==2)//float
    {
        printf("%s: %f\n",root->name,root->float_data);
    }
    else if(root->flag==3)
    {
        printf("%s %s\n",root->name,root->str_data);
    }
    printAst(root->fir,depth+1);
    printAst(root->next,depth);
}
