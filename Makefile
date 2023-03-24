lab1:syntax.y lexical.l syntax.tab.c lex.yy.h main.c ast_tree.c
	bison -d syntax.y
	flex lexical.l
	gcc main.c syntax.tab.c syntax.tab.h ast_tree.c -lfl -ly -o lab1
	# git add . && git commit -m "ok"
