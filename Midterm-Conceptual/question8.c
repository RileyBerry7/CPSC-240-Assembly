#include <stdio.h>

void function1() {
    int local_var1 = 10;
    int local_var2 = 20;
    int local_var3 = 30;
    int local_var4 = 40;
    
    // Print values to observe them while debugging in GDB
    printf("Inside function1\n");
    printf("local_var1 = %d, local_var2 = %d, local_var3 = %d, local_var4 = %d\n",
           local_var1, local_var2, local_var3, local_var4);
}

int main() {
    function1();
    return 0;
}

