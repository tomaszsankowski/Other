.686
.model flat

public _szukaj_max
.code

_szukaj_max PROC
	push ebp
	mov ebp, esp
	push ebx
	mov ebx, [ebp+8] ; w EBX mamy teraz adres pierwszego elementu tablicy
	mov ecx, [ebp+12] ; w ECX mamy wielko�� tablicy
	mov eax, 0 ; w EAX b�dzie wska�nik na element maksymalny
	mov edx, 0 ; w EDX b�dzie aktualna najwi�ksza warto��
	cmp ecx, 0 ; sprawdzamy, czy tablica nie jest przypadkiem pusta
	jz koniec
ptl:
	cmp edx, [ebx] ; por�wnujemy aktualny max z kolejnym elementem tablicy
	jge nie_zmieniamy ; je�li edx jest wi�kszy lub r�wny to nie wykonujemy skoku
	mov edx, [ebx] ; je�li mamy nowego max, kopiujemy go do EDX
	mov eax, ebx ; a do EAX przenosimy adres elementu tablicy
nie_zmieniamy:
	add ebx, 4 ; w EBX w ten spos�b mamy kolejnego inta w tablicy
	dec ecx ; zmniejszamy ecx
	cmp ecx, 0 ; je�li sprawdzili�my wszystkie elementy tablicy, wychodzimy
	jnz ptl
koniec:
	; teraz w EAX mamy adres elementu
	; tablicy o najwi�kszej warto�ci
	pop ebx
	pop ebp
	ret
_szukaj_max ENDP

_odejmowanie PROC
	push ebp
	mov ebp, esp
	push ebx

	mov ecx, [ebp+8] ; ECX to wska�nik na wska�nik na liczb� pierwsz�
	mov ebx, [ecx] ; w EBX wska�nik na liczb� pierwsz�
	mov eax, [ebx] ; EAX z kolei to ju� warto�� pierwszej liczby
	mov edx, [ebp+12] ; EDX posiada warto�� liczby drugiej
	sub eax, [edx] ; odejmowanie l1-l2, wynik w eax

	pop ebx
	pop ebp
	ret
_odejmowanie ENDP

END