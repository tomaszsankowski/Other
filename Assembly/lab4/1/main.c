#include <stdio.h>
#include <locale.h>
#include <Windows.h>
int zamien_znaki(char* slowo, char n1, char n2); // zamienia każde wystąpienie znaku n1 na znak n2 i zwraca ilość zastąpień
int* szukaj_max(int tablica[], int size); // zwraca wskaźnik na największy element tablicy
int odejmowanie(int** odjemna, int* odjemnik); // zwraca wynik odjemowania
int czas(); // zwraca liczbe minut aktualną
int maloc(int e);
int iloczyn_skalarny(int tab1[], int tab2[], int size);
int* merge(int tab1[], int tab2[], int n);
int wyszukaj_znak(wchar_t* tablica, unsigned int znak);
int* tablica_nieparzystych(int tablica[], unsigned int* n);
wchar_t* convert_to_bin(unsigned long long liczba);
unsigned int* convert_to_array(char* tekst,int* size);
int main()
{
	setlocale(LC_ALL, "polish");
	char tekst[256];
	scanf_s("%254[^\n]", tekst, 255);
	tekst[255] = '\n';
	int size = 0;
	unsigned int* tablica = convert_to_array(tekst,&size);
	for (int i = 0; i < size; i++) {
		printf("\n%d", tablica[i]);
	}
	free(tablica);
	return 0;
}

//				dectobin+MsgBoxWinC
/*

	unsigned long long liczba = 4000000000;
	wchar_t* tablica = convert_to_bin(liczba);
	int msgbox = MessageBox(NULL, tablica, L"Hejka", MB_OK);
	free(tablica);
*/

//				tablica_nieparzystych
/*
	int tablica[10] = { 1, 2, 3, 4, 5, 100, 105, 112, 119, 189 };
	int size = 10;
	int ptr = &size;
	int* nowa_tablica = tablica_nieparzystych(tablica, ptr);
	printf("Nowa tablica: \n");

	for (int i = 0; i < 10 - size; i++) {
		printf("%d ", nowa_tablica[i]);
	}
	printf("\nIlość elementow parzystych w poprzedniej tablicy: %d.", size);
	free(nowa_tablica);
	*/


//				utf16
/*

	wchar_t utf16[13] = L"Hello, 世世世界!\n";

	unsigned int znak = L'世';
	wchar_t* ptr = utf16;
	int ile = wyszukaj_znak(ptr, &znak);
	printf("\nZnaleziono %d znaków o kodzie Unicode %d.\nAdres pierwszego znalezienia: %p.", ile, znak, (void*)ptr);

*/
//				łączenie tablic
/*
	int tab1[5] = { 1, 2, 3, 4, 5 };
	int tab2[5] = { 6, 7, 8, 9, 10 };
	int* tablica = merge(tab1, tab2, 5);
	if (tablica == NULL) {
		printf("Za duże tablice!\n");
	}
	else {
		printf("\nNowa tablica: { ");
		for (int i = 0; i < 10; i++) {
			printf("%d ", tablica[i]);
		}
		printf("}\n");
	}
	*/
//				iloczynSkalarny
/*
int n;
	int skalar = 0;
	scanf_s("%d", &n, 8);
	if (n > 0) {
		int* tab1 = malloc(n * sizeof(int));
		for (int i = 0; i < n; i++) {
			scanf_s("%d", &tab1[i], 8);
		}
		int* tab2 = malloc(n * sizeof(int));
		for (int i = 0; i < n; i++) {
			scanf_s("%d", &tab2[i], 8);
		}
		skalar = iloczyn_skalarny(tab1, tab2, n);
		free(tab1);
		free(tab2);
	}
	printf("\nIloczyn skalarny: %d\n", skalar);
*/
//				pointerToPointer
/*
	int a = 9999;
	int b = 707;
	int* ptr = &a;
	int wynik = odejmowanie(&ptr, &b);
	printf("\nWynikiem odejmowanie liczb %d oraz %d jest %d", a, b, wynik);
*/

//				maxTablicy
/*
	int tablica[10] = { -1, -125, 435, 234, 543, 64444, 100000, 0, -100000, 53543 };
	int* ptr = szukaj_max(tablica, 10);
	printf("\nNajwiększy element tablicy to %d\n", *ptr);
*/

//				funkcja1
/*
	char tab[32] = "bannana\0";
	printf("Aktualny string: %s\n", tab);
	char l1 = 'a';
	char l2 = 'n';
	int zmienione = zamien_znaki(tab, l1, l2);
	printf("Zmodyfikowany string: %s\n", tab);
	printf("Zmieniono %d znaków.\n", zmienione);
	*/