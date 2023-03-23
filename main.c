#include "lex.yy.h"
#include "syntax.tab.h"
#include <stdio.h>
int main(int argc, char **argv)
{
    int i, totchars = 0, totwords = 0, totlines = 0;
    if (argc < 2)
    {
        yyparse();
        return 0;
    }
    for (i = 1; i < argc; i++)
    {
        FILE *f = fopen(argv[i], "r");
        if (!f)
        {
            perror(argv[i]);
            return 1;
        }
        yyrestart(f);
        yyparse();
        fclose(f);
    }
    return 0;
}
