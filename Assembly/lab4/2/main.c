#include <stdio.h>

long long add_64(wchar_t* liczba1, wchar_t* liczba2);

int main()
{

	wchar_t liczba1[20];
	wchar_t* liczba2[20];
	fgetws(liczba1, 20, stdin);
	fgetws(liczba2, 20, stdin);
	long long suma = add_64(liczba1, liczba2);
	printf("\nSuma liczb wynosi %lld\n",suma);
	return 0;
}