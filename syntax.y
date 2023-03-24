%{
#include "ast.h"
#include <stdio.h>
#include "lex.yy.c"

%}
%locations
%union{
    struct AST_tree_t *tree_node;
}
/* declared tokens */
%token <tree_node>INT
%token <tree_node>FLOAT
%token <tree_node>RELOP
%token <tree_node>TYPE
%token <tree_node>ID
%token <tree_node>IF
%token <tree_node>ELSE
%token <tree_node>WHILE
%token <tree_node>STRUCT
%token <tree_node>RETURN
%token <tree_node>PLUS
%token <tree_node>MINUS
%token <tree_node>STAR
%token <tree_node>DIV
%token <tree_node>OR
%token <tree_node>AND
%token <tree_node>NOT
%token <tree_node>LC
%token <tree_node>RC
%token <tree_node>LB
%token <tree_node>RB
%token <tree_node>LP
%token <tree_node>RP
%token <tree_node>COMMA
%token <tree_node>DOT
%token <tree_node>SEMI
%token <tree_node>ASSIGNOP
%type  <tree_node> Program ExtDefList ExtDef ExtDecList
Specifier StructSpecifier OptTag Tag VarDec FunDec VarList ParamDec
CompSt StmtList Stmt DefList Def DecList Dec Exp Args


%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%right ASSIGNOP
%left OR
%left AND
%left RELOP
%left PLUS MINUS
%left STAR DIV
%right UNIT
%left LP RP LB RB DOT
%%
//ERROR HADLING TODO
// Stmt : error SEMI
// CompSt : error RC
// Exp : error RP
//HIGH-LEVEL
Program : ExtDefList {$$=creatAst("Program",1,$1);printAst($$,0);}
;
ExtDefList : ExtDef ExtDefList {$$=creatAst("ExtDefList",2,$1,$2);}
|   {$$=creatAst("ExtDefList",0,NULL);}        //空串
;
ExtDef : Specifier ExtDecList SEMI  {$$=creatAst("ExtDef",3,$1,$2,$3);}  //Specifier表示类型，ExtDecList表示零个或多个对一个变量的定义VarDec。
| Specifier SEMI   {$$=creatAst("ExtDef",2,$1,$2);}
| Specifier FunDec CompSt  {$$=creatAst("ExtDef",3,$1,$2,$3);}  //Specifier是返回类型，FunDec是函数头，CompSt表示函数体。
;
ExtDecList : VarDec {$$=creatAst("ExtDecList",1,$1);}
| VarDec COMMA ExtDecList   {$$=creatAst("ExtDecList",3,$1,$2,$3);}
;
//Specifiers
Specifier : TYPE     {$$=creatAst("Specifier",1,$1);}         //int or float
| StructSpecifier     {$$=creatAst("Specifier",1,$1);}       //结构体类型
;
StructSpecifier : STRUCT OptTag LC DefList RC {$$=creatAst("StructSpecifier",5,$1,$2,$3,$4,$5);}
| STRUCT Tag    {$$=creatAst("StructSpecifier",2,$1,$2);}
;
OptTag : ID    {$$=creatAst("OptTag",1,$1);}               //结构体名称
|   {$$=creatAst("OptTag",0,NULL);}
;
Tag : ID    {$$=creatAst("Tag",1,$1);}
;
//Declarators
VarDec : ID {$$=creatAst("VarDec",1,$1);}
| VarDec LB INT RB  {$$=creatAst("VarDec",4,$1,$2,$3,$4);}
;
FunDec : ID LP VarList RP   {$$=creatAst("FunDec",4,$1,$2,$3,$4);}       //函数头定义
| ID LP RP  {$$=creatAst("FunDec",3,$1,$2,$3);}
;
VarList : ParamDec COMMA VarList   {$$=creatAst("VarList",3,$1,$2,$3);}  //形参列表
| ParamDec {$$=creatAst("VarList",1,$1);}
;
ParamDec : Specifier VarDec {$$=creatAst("ParamDec",2,$1,$2);}           //一个形参的定义
;
//Statements
CompSt : LC DefList StmtList RC {$$=creatAst("CompSt",4,$1,$2,$3,$4);} //语块{...}包含局部定义语句和其他语句
;
StmtList : Stmt StmtList {$$=creatAst("StmtList",2,$1,$2);} //语句们
|   {$$=creatAst("StmtList",0,NULL);}
;
Stmt : Exp SEMI {$$=creatAst("Stmt",2,$1,$2);}//语句定义
| CompSt    {$$=creatAst("Stmt",1,$1);}
| RETURN Exp SEMI   {$$=creatAst("Stmt",3,$1,$2,$3);}
| IF LP Exp RP Stmt {$$=creatAst("Stmt",5,$1,$2,$3,$4,$5);} %prec LOWER_THAN_ELSE
| IF LP Exp RP Stmt ELSE Stmt   {$$=creatAst("Stmt",7,$1,$2,$3,$4,$5,$6,$7);}
| WHILE LP Exp RP Stmt  {$$=creatAst("Stmt",5,$1,$2,$3,$4,$5);}
;
//Local Definitions                     //局部变量定义
DefList : Def DefList   {$$=creatAst("DefList",2,$1,$2);}
|   {$$=creatAst("DefList",0,NULL);}
;
Def : Specifier DecList SEMI {$$=creatAst("Def",3,$1,$2,$3);}        // int a,b,c ;
;
DecList : Dec   {$$=creatAst("DecList",1,$1);}                    //a,b,c
| Dec COMMA DecList {$$=creatAst("DecList",3,$1,$2,$3);}
;
Dec : VarDec     {$$=creatAst("Dec",1,$1);}     //a,b[INT]
| VarDec ASSIGNOP Exp {$$=creatAst("Dec",3,$1,$2,$3);}                           // a=10
;
//Expressions                   //表达式
Exp : Exp ASSIGNOP Exp {$$=creatAst("Exp",3,$1,$2,$3);}
| Exp AND Exp   {$$=creatAst("Exp",3,$1,$2,$3);}
| Exp OR Exp    {$$=creatAst("Exp",3,$1,$2,$3);}
| Exp RELOP Exp         {$$=creatAst("Exp",3,$1,$2,$3);}             //关系表达式
| Exp PLUS Exp  {$$=creatAst("Exp",3,$1,$2,$3);}
| Exp MINUS Exp {$$=creatAst("Exp",3,$1,$2,$3);}
| Exp STAR Exp  {$$=creatAst("Exp",3,$1,$2,$3);}
| Exp DIV Exp   {$$=creatAst("Exp",3,$1,$2,$3);}
| LP Exp RP {$$=creatAst("Exp",3,$1,$2,$3);}
| MINUS Exp    {$$=creatAst("Exp",2,$1,$2);} %prec UNIT
| NOT Exp {$$=creatAst("Exp",2,$1,$2);}  %prec UNIT
| ID LP Args RP {$$=creatAst("Exp",4,$1,$2,$3,$4);}                    //函数调用表达式
| ID LP RP  {$$=creatAst("Exp",3,$1,$2,$3);}                          //函数调用表达式
| Exp LB Exp RB  {$$=creatAst("Exp",4,$1,$2,$3,$4);}                     //数组访问
| Exp DOT ID  {$$=creatAst("Exp",3,$1,$2,$3);}
| ID     {$$=creatAst("Exp",1,$1);}
| INT    {$$=creatAst("Exp",1,$1);}
| FLOAT  {$$=creatAst("Exp",1,$1);}
;
Args : Exp COMMA Args   {$$=creatAst("Args",3,$1,$2,$3);}         //实参列表
| Exp    {$$=creatAst("Args",1,$1);}
;
%%
void
yyerror(char* msg) {
    //fprintf(stderr, "suntax error: %s\n", msg);
    printf("Error type B at Line %d: Missing \"%s\".\n",yylineno,yytext);
}
