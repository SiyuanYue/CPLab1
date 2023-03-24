#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <stdarg.h>
void yyerror(char* msg);
typedef struct AST_tree_t
{
    int lineno;
    int flag;
    struct AST_tree_t *child,*next; //第一个子节点 和 下一个兄弟节点
    char name[50];
    union
    {
        char str_data[20];
        int int_data;
        float float_data;
    };
}ast_tree_t;

ast_tree_t *ast_alloc();
ast_tree_t *new_node_int(char *name,int int_data,int lineno);
ast_tree_t *new_node_str(char *name,char* str_data,int lineno);
ast_tree_t *new_node_float(char *name,float float_data,int lineno);
ast_tree_t *new_node_noval(char *name,int lineno);
ast_tree_t * creatAst(char *name,int len,...);

void printAst(ast_tree_t *root,int depth);
