%{
#include "lex.yy.h"
#include <stdlib.h>
#include <string.h>
#include "syntax.tab.h"
int yycolumn = 1;
#define YY_USER_ACTION yylloc.first_line = yylloc.last_line = yylineno; \
yylloc.first_column = yycolumn; \
yylloc.last_column = yycolumn + yyleng - 1; \
yycolumn += yyleng;

%}
%option yylineno
TYPE int|float
digit [0-9]
letter_ [a-zA-Z]|_
digits {digit}+
ID {letter_}({letter_}|digit)*
INT 0|[1-9]{digit}*
INT_HEX [0][Xx]([1-9A-Fa-f][0-9A-Fa-f]*|[0])
INT_OCT [0]([1-7][0-7]*)|0
FLOAT {digits}\.{digits}|{digits}[.]{digit}*[e|E][+/-]?{digits}|{digit}*[.]{digits}[e|E][+/-]?{digits}
PLUS "+"
MINUS "-"
STAR "*"
DIV "/"
OR "||"
AND "&&"
NOT !
LC "{"
RC "}"
LB "["
RB "]"
LP "("
RP ")"
COMMA ","
DOT "."
SEMI ";"
IF "if"
ELSE "else"
WHILE "while"
STRUCT "struct"
RETURN "return"
ASSIGNOP "="
RELOP >|<|>=|<=|==|!=
SPACE [ \t]

%%
{TYPE} {
    //strcpy(yylval.type_str,yytext);
    yylval.tree_node=new_node_str("TYPE",yytext,yylineno);
    return TYPE;
}
{IF} {yylval.tree_node=new_node_noval("IF",yylineno);return IF;}
{INT}|{INT_HEX}|{INT_OCT} {
    //yylval.type_int=atoi(yytext);
    yylval.tree_node=new_node_int("INT",atoi(yytext),yylineno);
    return INT;
}
{FLOAT} {
    //yylval.type_float=atof(yytext);
    yylval.tree_node=new_node_float("TYPE",atof(yytext),yylineno);
    return FLOAT;
}
{ELSE} {yylval.tree_node=new_node_noval("ELSE",yylineno);return ELSE;}
{WHILE} {yylval.tree_node=new_node_noval("WHILE",yylineno);return WHILE;}
{STRUCT} {yylval.tree_node=new_node_noval("STRUCT",yylineno);return STRUCT;}
{RETURN} {yylval.tree_node=new_node_noval("RETURN",yylineno);return RETURN;}
{PLUS} {yylval.tree_node=new_node_noval("PLUS",yylineno);return PLUS;}
{MINUS} {yylval.tree_node=new_node_noval("MINUS",yylineno);return MINUS;}
{STAR} {yylval.tree_node=new_node_noval("STAR",yylineno);return STAR;}
{DIV} {yylval.tree_node=new_node_noval("DIV",yylineno);return DIV;}
{OR} {yylval.tree_node=new_node_noval("OR",yylineno);return OR;}
{AND} {yylval.tree_node=new_node_noval("AND",yylineno);return AND;}
{NOT} {yylval.tree_node=new_node_noval("NOT",yylineno);return NOT;}
{LC} {yylval.tree_node=new_node_noval("LC",yylineno);return LC;}
{RC} {yylval.tree_node=new_node_noval("RC",yylineno);return RC;}
{LB} {yylval.tree_node=new_node_noval("LB",yylineno);return LB;}
{RB} {yylval.tree_node=new_node_noval("RB",yylineno);return RB;}
{COMMA} {yylval.tree_node=new_node_noval("COMMA",yylineno);return COMMA;}
{DOT} {yylval.tree_node=new_node_noval("DOT",yylineno);return DOT;}
{SEMI} {yylval.tree_node=new_node_noval("SEMI",yylineno);return SEMI;}
{LP} {yylval.tree_node=new_node_noval("LP",yylineno);return LP;}
{RP} {yylval.tree_node=new_node_noval("RP",yylineno);return RP;}
{ASSIGNOP} {yylval.tree_node=new_node_noval("ASSIGNOP",yylineno);return ASSIGNOP;}
{RELOP} {
    //strcpy(yylval.type_str,yytext);
    yylval.tree_node=new_node_str("RELOP",yytext,yylineno);
    return RELOP;
}
{ID} {
    //strcpy(yylval.type_str,yytext);
    yylval.tree_node=new_node_str("ID",yytext,yylineno);
    return ID;
}
{SPACE} {/*do nothing */ }
"\n" {
    yycolumn=1;
}
. {
    printf("Error type A at Line %d: Mysterious characters \"%s\".\n",yylineno,yytext);
    exit(1);
}
%%

