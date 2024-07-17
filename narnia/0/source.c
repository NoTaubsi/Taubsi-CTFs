#include <stdio.h>
#include <stdlib.h>

int main(){
    long val=0x41414141;
    char buf[20];

    printf("Correct val's value from 0x41414141 -> 0xdeadbeef!\n");
    printf("Here is your chance: ");
    // % 24bytes asString
    //so we can overflow 4 bytes

    scanf("%24s",&buf);

    //you can send non-printable characters to scanf even before calling the program, by calling:
    //printf "\x05" | ./narnia0
    printf("buf: %s\n",buf);
    printf("val: 0x%08x\n",val);
    
    /*integer:

    de = 222 = Þ
    ad = 173 = 
    be = 190
    ef = 239


    */
    if(val==0xdeadbeef){
        setreuid(geteuid(),geteuid());
        system("/bin/sh");
    }
    else {
        printf("wrong\n");
        exit(1);
    }

    return 0;
}