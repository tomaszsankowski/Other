#include <stdio.h>
#include <locale.h>
float single_neuron(float* X, double* wagi, unsigned int n);

int main()
{
	setlocale(LC_ALL, "polish");
	unsigned int n;
	printf("\nPodaj ilo�� neuron�w:\n");
	scanf_s("%u", &n);
	float* X = malloc(sizeof(float) * n);
	double* wagi = malloc(sizeof(double) * (n - 1));
	printf("\nPodaj warto�ci wag(n):\n");
	for (int i = 0; i < n; i++) {
		scanf_s("%f", &X[i]);
	}
	printf("\nPodaj warto�ci warto�ci(n-1):\n");
	for (int i = 0; i < n-1; i++) {
		scanf_s("%lf", &wagi[i]);
	}
	float wynik = single_neuron(X, wagi, n);
	printf("Wyj�cie neuronu to: %f", wynik);
	free(wagi);
	free(X);
	return 0;
}