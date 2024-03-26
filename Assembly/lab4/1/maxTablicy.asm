.686
.model flat

public _szukaj_max
.code

_szukaj_max PROC
	push ebp
	mov ebp, esp
	push ebx
	mov ebx, [ebp+8] ; w EBX mamy teraz adres pierwszego elementu tablicy
	mov ecx, [ebp+12] ; w ECX mamy wielkoœæ tablicy
	mov eax, 0 ; w EAX bêdzie wskaŸnik na element maksymalny
	mov edx, 0 ; w EDX bêdzie aktualna najwiêksza wartoœæ
	cmp ecx, 0 ; sprawdzamy, czy tablica nie jest przypadkiem pusta
	jz koniec
ptl:
	cmp edx, [ebx] ; porównujemy aktualny max z kolejnym elementem tablicy
	jge nie_zmieniamy ; jeœli edx jest wiêkszy lub równy to nie wykonujemy skoku
	mov edx, [ebx] ; jeœli mamy nowego max, kopiujemy go do EDX
	mov eax, ebx ; a do EAX przenosimy adres elementu tablicy
nie_zmieniamy:
	add ebx, 4 ; w EBX w ten sposób mamy kolejnego inta w tablicy
	dec ecx ; zmniejszamy ecx
	cmp ecx, 0 ; jeœli sprawdziliœmy wszystkie elementy tablicy, wychodzimy
	jnz ptl
koniec:
	; teraz w EAX mamy adres elementu
	; tablicy o najwiêkszej wartoœci
	pop ebx
	pop ebp
	ret
_szukaj_max ENDP

_odejmowanie PROC
	push ebp
	mov ebp, esp
	push ebx

	mov ecx, [ebp+8] ; ECX to wskaŸnik na wskaŸnik na liczbê pierwsz¹
	mov ebx, [ecx] ; w EBX wskaŸnik na liczbê pierwsz¹
	mov eax, [ebx] ; EAX z kolei to ju¿ wartoœæ pierwszej liczby
	mov edx, [ebp+12] ; EDX posiada wartoœæ liczby drugiej
	sub eax, [edx] ; odejmowanie l1-l2, wynik w eax

	pop ebx
	pop ebp
	ret
_odejmowanie ENDP

END