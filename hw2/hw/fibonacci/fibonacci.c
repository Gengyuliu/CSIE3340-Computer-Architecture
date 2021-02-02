#include <stdio.h>

unsigned long long int fibonacci(unsigned long long (*), int);
int main () {
    unsigned long long int ret;

    unsigned long long int memo[94] = {0};

    for (int i = 0; i < 94; ++i) {
    	ret = fibonacci(memo, i);
    	printf("%llu\n", ret);
    }
    return 0;
}
