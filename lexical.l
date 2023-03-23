%{
#include "lex.yy.h"
#include <stdlib.h>
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
    yylval.type_str=yytext;
    return TYPE;
}
{IF} {return IF;}
{INT}|{INT_HEX}|{INT_OCT} {
    yylval.type_int=atoi(yytext);
    return INT;
}
{FLOAT} {
    yylval.type_float=atof(yytext);
    return FLOAT;
}
{ELSE} {return ELSE;}
{WHILE} {return WHILE;}
{STRUCT} {return STRUCT;}
{RETURN} {return RETURN;}
{PLUS} {return PLUS;}
{MINUS} {return MINUS;}
{STAR} {return STAR;}
{DIV} {return DIV;}
{OR} {return OR;}
{AND} {return AND;}
{NOT} {return NOT;}
{LC} {return LC;}
{RC} {return RC;}
{LB} {return LB;}
{RB} {return RB;}
{COMMA} {return COMMA;}
{DOT} {return DOT;}
{SEMI} {return SEMI;}
{LP} {return LP;}
{RP} {return RP;}
{ASSIGNOP} {return ASSIGNOP;}
{RELOP} {
    yylval.type_str=yytext;
    return RELOP;
}
{ID} {
    yylval.type_str=yytext;
    return ID;
}
{SPACE} {/*do nothing */ }
"\n" {
    yycolumn=1;
}
. {
    printf("Error type A at Line %d: Mysterious characters \'%s\'\n",yylineno,yytext);
}
%%
// int main(int argc, char **argv)
// {
//     int i, totchars = 0, totwords = 0, totlines = 0;
//     if (argc < 2)
//     {
//         yylex();
//         return 0;
//     }
//     for (i = 1; i < argc; i++)
//     {
//         FILE *f = fopen(argv[i], "r");
//         if (!f)
//         {
//             perror(argv[i]);
//             return 1;
//         }
//         yyrestart(f);
//         yylex();
//         fclose(f);
//         printf("\n");
//     }
//     return 0;
// }

