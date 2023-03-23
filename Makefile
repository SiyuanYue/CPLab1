lab1:syntax.y lexical.l syntax.tab.c lex.yy.h main.c
	bison -d syntax.y
	flex lexical.l
	gcc main.c syntax.tab.c syntax.tab.h -lfl -ly -o lab1
