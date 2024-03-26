.686
.model flat

public _wyszukaj_znak

.code

_wyszukaj_znak PROC
	push ebp
	mov ebp, esp ; prolog

	push ebx
	push esi
	push edi

	mov ebx,[ebp+8] ; adres pierwszego znaku
	mov edi,[ebp+12] ; szukany znak

	mov edx,0 ; tu wpiszemy adres pierwszego wystapienia znaku
	mov eax,0 ; tu zapiszemy ilosc wystapien znaku

ptl:
	mov si, [ebx] ; przenosimy kolejny znak
	cmp si, 0Ah ; czy znak nowej linii
	je koniec
	cmp si,di ; porownujemy 
	jne dalej

	inc eax ; zwiekszamy ilosc wystapien
	cmp edx,0 ; jesli nie przypisano adresu to pierwsze wystapienie
	jne dalej
	mov edx,ebx ; przypisujemy adres

dalej:
	add ebx,2 ; zwiekszamy indeks
	jmp ptl

koniec:
	; w eax iloœæ wyst¹pieñ
	mov ebx,[ebp+8]
	mov [ebx], edx ; to pointera dajemy adres
	pop edi
	pop esi
	pop ebx

	pop ebp
	ret
_wyszukaj_znak ENDP

END