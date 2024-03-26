#include <stdio.h>
#include <locale.h>

void dodaj_SSE(float*, float*, float*);
void pierwiastek_SSE(float*, float*);
void odwrotnosc_SSE(float*, float*);
void sumuj8bit(char*, char*);
void int2float(int*, float*);
void pm_jeden(float*);
void dodawanie_SSE(float*);
float* Matmul(float* A, int* B, unsigned int k, unsigned int l, unsigned int m);
float* single_neuron(double* x, float* w, unsigned int n);
float progowanie_sredniej_kroczacej(float* tablica, unsigned int k, unsigned int m);
int main()
{
	setlocale(LC_ALL, "polish");
	unsigned int m, k;
	printf("\nPodaj wielkoœæ tablicy wejœciowej:\n");
	scanf_s("%u", &m);
	printf("\nPodaj po ile mamy pakowaæ kolejne œrednie:\n");
	scanf_s("%u", &k);
	float* tablica = malloc(sizeof(float) * m);
	printf("\nPodaj dane dla tablicy wejœciowej:\n");
	for(int i=0;i<m;i++)
		scanf_s("%f", &tablica[i]);
	float wynik = progowanie_sredniej_kroczacej(tablica, k, m);
	printf("wynik: %f\n", wynik);

	return 0;
}

/*
	double liczby[5] = { 0.5f, 1.5f, 1.5f, 10.0f, 2.5f };
	float wagi[5] = { 1.0f, 2.0f, 1.0f, -2.0f, 1.0f };
	unsigned int n = 5;
	float* wynikptr = single_neuron(liczby, wagi, n);
	float wynik = *wynikptr;
	printf("%f", wynik);
	free(wynikptr);
*/
/*

	printf("Podaj rozmiary macierzy (k, l, m):\n");
	unsigned int k, l, m;
	scanf_s("%u %u %u", &k, &l, &m);
	float* A = malloc(sizeof(float) * k * l);
	int* B = malloc(sizeof(int) * l * m);
	printf("\nPodaj wartoœci macierzy %u na %u (chodzi o float):\n", k, l);
	for (int i = 0; i < k * l; i++)
		scanf_s("%f", &A[i]);
	printf("\nPodaj wartoœci macierzy %u na %u (chodzi o int):\n", l, m);
	for (int i = 0; i < m * l; i++)
		scanf_s("%d", &B[i]);
	float* output = Matmul(A, B, k, l, m);
	for (int i = 0; i < k * m; i++) {
		if (i % 3 == 0)
			printf("\n");
		printf("%f ", output[i]);
	}
	free(output);
	free(A);
	free(B);
*/

/*

	float wyniki[4];
	dodawanie_SSE(wyniki);
	printf("\nWyniki = %f %f %f %f\n",
	wyniki[0], wyniki[1], wyniki[2], wyniki[3]);
*/
/*
float tablica[4] = { 27.5,143.57,2100.0, -3.51 };
	printf("\n%f %f %f %f\n", tablica[0],
		tablica[1], tablica[2], tablica[3]);
	pm_jeden(tablica);
	printf("\n%f %f %f %f\n", tablica[0],
		tablica[1], tablica[2], tablica[3]);
*/
/*
	int a[2] = { -17, 24 };
	float r[4];
	int2float(a, r);
	printf("Konwersja = %f %f\n", r[0], r[1]);
*/

/*
char liczby_A[16] = { -128, -127, -126, -125, -124, -123, -122,
	-121, 120, 121, 122, 123, 124, 125, 126, 127 };
	char liczby_B[16] = { -3, -3, -3, -3, -3, -3, -3, -3,
	3, 3, 3, 3, 3, 3, 3, 3 };
	sumuj8bit(liczby_A, liczby_B);
	printf("Zsumowana tablica: \n");
	for (int i = 0; i < 16; i++)
	{
		printf("%d ", liczby_A[i]);
	}
	printf("\n");
*/
/*
float p[4] = { 1.0, 1.5, 2.0, 2.5 };
	float q[4] = { 0.25, -0.5, 1.0, -1.75 };
	float r[4];
	dodaj_SSE(p, q, r);
	printf("\n%f %f %f %f", p[0], p[1], p[2], p[3]);
	printf("\n%f %f %f %f", q[0], q[1], q[2], q[3]);
	printf("\n%f %f %f %f", r[0], r[1], r[2], r[3]);
	printf("\n\nObliczanie pierwiastka");
	pierwiastek_SSE(p, r);
	printf("\n%f %f %f %f", p[0], p[1], p[2], p[3]);
	printf("\n%f %f %f %f", r[0], r[1], r[2], r[3]);
	printf("\n\nObliczanie odwrotnoœci - ze wzglêdu na \
stosowanie");
	printf("\n12-bitowej mantysy obliczenia s¹ ma³o dok³adne");
	odwrotnosc_SSE(p, r);
	printf("\n%f %f %f %f", p[0], p[1], p[2], p[3]);
	printf("\n%f %f %f %f", r[0], r[1], r[2], r[3]);
*/
/*

#include <stdio.h>

extern float srednia_harm(float* tablica, unsigned int n);
extern float edox(float wykladnik);
extern float nowy_exp(float x);
int main()
{
	float liczba = 2.0f;
	float wynik = nowy_exp(liczba);
	float wzorcowy = 1;
	float gora = liczba;
	float dol = 1;
	for (int i = 0; i < 19; i++)
	{
		gora /= dol;
		wzorcowy += gora;
		dol++;
		gora *= liczba;
	}
	printf("%f ?= %f", wynik, wzorcowy);
	return 0;
}
*/

/*float tablica[5] = { 0.5f, 1.2f, -1.5f, -0.5f, 54.423f };
	float srednia = srednia_harm(tablica, 5);
	float suma = 0;
	for (int i = 0; i < 5; i++) {
		suma += 1 / tablica[i];
	}
	float wynik = 5 / suma;
	printf("Srednia harmoniczna: %f (wzorcowo: %f)\n", srednia, wynik);
	float wykladnik = 1.0f;
	wynik = edox(wykladnik);
	printf("e^%f = %f", wykladnik, wynik);*/