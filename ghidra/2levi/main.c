#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>

char CommandString[512];

int main(int argCount, char **argv)
{
    printf("Hello, World!\n");
    if (argCount < 2)
    {
        printf("%s\n\n", argv[1]);

        snprintf(CommandString,511-9,"%s\n\n",argv[1]);
        printf("%s", CommandString);
    }
    else
    {
        puts(argv[1]);
    }
    return 0;
}