#include <stdio.h>
#include <locale.h>
void przestaw(int* tab, int size);

int main() {
	// 10 15 100 43 64 23 1 0 63 -5
	setlocale(LC_ALL, "polish");
	int tab[10];

	printf("WprowadŸ 10 liczb do tablicy:\n");
	for (int i = 0; i < 10; i++) {
		scanf_s("%d", &tab[i], 12);
	}

	for (int i = 0; i < 9; i++) {
		przestaw(tab, 10 - i);
	}

	printf("Oto posortowana tablica:\n");
	for (int i = 0; i < 10; i++) {
		printf("%d ", tab[i]);
	}
	printf("\n");
	return 0;
}


//				zadanie 4.3
/*
#include <stdio.h>
#include <locale.h>

void odejmij_jeden(int** a);
int main() {
	setlocale(LC_ALL, "polish");

	int k;
	int* ptr = &k;

	printf("\Proszê napisaæ liczbê: ");
	scanf_s("%d", &k, 12);

	odejmij_jeden(&ptr);

	printf("\nwynik = %d\n", k);
	return 0;
}
*/




//				zadanie4.2
/*
#include <stdio.h>

void plus_jeden(int* a);
void liczba_przeciwna(int* a);

int main() {
	int m = -5;
	printf("Liczba przeciwna do liczby %d: ", m);
	//plus_jeden(&m);
	liczba_przeciwna(&m);
	printf("m = %d\n", m);
	return 0;
}
*/




//				zadanie 4.1
/*
#include <stdio.h>
#include <locale.h>

int szukaj_max(int a, int b, int c, int d);

int main() {
	setlocale(LC_ALL, "polish");
	int w, x, y, z, wynik;

	printf("Proszê podaæ trzy liczby ca³kowite ze znakiem: \n");
	scanf_s("%d %d %d %d", &w, &x, &y, &z, 32);

	wynik = szukaj_max(w, x, y, z);

	printf("\nNajwiêksz¹ liczb¹ spoœród liczb %d, %d, %d, %d jest %d\n", w, x, y, z, wynik);

	return 0;
}
*/