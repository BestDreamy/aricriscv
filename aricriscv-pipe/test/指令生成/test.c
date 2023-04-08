#include <stdio.h>

int f(int x)
{
	return x + 3;
}

int g(int x)
{
	return f(x) + f(x);
}

int main()
{
	return g(3);
}