#include <iostream>
#include <string>

extern "C" double manager(void);  // manager returns a floating-point sum in xmm0

using namespace std;

string userName;

int main() 
{
    printf("\n==========================================================================================================="
           "========================\n"
           "\nWelcome to Huron’s Triangles. We take care of all your triangle needs.\n"
           "Please enter your name: \n\n");

    printf("Please enter your name: ");
    getline(cin, userName);  // Use getline for string input
    cout << endl;

    double result = manager();  // Store the return value of manager

    printf("\nThe main function has received this number %lf, and will keep it for a while.\n"
           "Thank you %s. Your patronage is appreciated.\n"
           "A zero will not be returned to the operating system.\n"
           "============================================================================================================"
           "=============================\n", result, userName.c_str());  // Use c_str() for printf

    return 0;
}

