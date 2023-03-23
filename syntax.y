%{
#include <stdio.h>
#include "lex.yy.c"
void
yyerror(char* msg);
%}
%locations
%union{
    int type_int;
    float type_float;
    char* type_str;
}
/* declared tokens */
%token <type_int> INT
%token <type_float> FLOAT
%token RELOP
%token TYPE
%token ID
%token IF
%token ELSE
%token WHILE
%token STRUCT
%token RETURN
%token PLUS
%token MINUS
%token STAR
%token DIV
%token OR
%token AND
%token NOT
%token LC
%token RC
%token LB
%token RB
%token LP
%token RP
%token COMMA
%token DOT
%token SEMI
%token ASSIGNOP

%%
//HIGH-LEVEL
Program : ExtDefList
;
ExtDefList : ExtDef ExtDefList
|           //空串
;
ExtDef : Specifier ExtDecList SEMI  //Specifier表示类型，ExtDecList表示零个或多个对一个变量的定义VarDec。
| Specifier SEMI
| Specifier FunDec CompSt //Specifier是返回类型，FunDec是函数头，CompSt表示函数体。
;
ExtDecList : VarDec
| VarDec COMMA ExtDecList
;
//Specifiers
Specifier : TYPE             //int or float
| StructSpecifier           //结构体类型
;
StructSpecifier : STRUCT OptTag LC DefList RC
| STRUCT Tag
;
OptTag : ID                 //结构体名称
|
;
Tag : ID
;
//Declarators
VarDec : ID
| VarDec LB INT RB
;
FunDec : ID LP VarList RP           //函数头定义
| ID LP RP
;
VarList : ParamDec COMMA VarList     //形参列表
| ParamDec
;
ParamDec : Specifier VarDec           //一个形参的定义
;
//Statements
CompSt : LC DefList StmtList RC //语块{...}包含局部定义语句和其他语句
;
StmtList : Stmt StmtList //语句们
|
;
Stmt : Exp SEMI //语句定义
| CompSt
| RETURN Exp SEMI
| IF LP Exp RP Stmt
| IF LP Exp RP Stmt ELSE Stmt
| WHILE LP Exp RP Stmt
;
//Local Definitions                     //局部变量定义
DefList : Def DefList
|
;
Def : Specifier DecList SEMI        // int a,b,c ;
;
DecList : Dec                       //a,b,c
| Dec COMMA DecList
;
Dec : VarDec                           //a,b[INT]
| VarDec ASSIGNOP Exp                     // a=10
;
//Expressions                   //表达式
Exp : Exp ASSIGNOP Exp
| Exp AND Exp
| Exp OR Exp
| Exp RELOP Exp                   //关系表达式
| Exp PLUS Exp
| Exp MINUS Exp
| Exp STAR Exp
| Exp DIV Exp
| LP Exp RP
| MINUS Exp
| NOT Exp
| ID LP Args RP                     //函数调用表达式
| ID LP RP                          //函数调用表达式
| Exp LB Exp RB                     //数组访问
| Exp DOT ID
| ID
| INT
| FLOAT
;
Args : Exp COMMA Args           //实参列表
| Exp
;
%%
void
yyerror(char* msg) {
    fprintf(stderr, "suntax error: %s\n", msg);
}
