.686
.model flat
extern _malloc : PROC
extern __write : PROC
extern _free : PROC
public _maloc
.data
tekst db 10, 'Alokacja si� nie uda�a...', 10
koniec_t db ?
h dd 0
i dd ?
.code
_maloc PROC
	push ebp
	mov ebp, esp
	push ebx
	mov ebx, [ebp+8] ; w ebx mamy teraz nasz parametr
	shl ebx, 2 ; mno�ymy ebx razy 4 ( size inta )
	push ebx ; i dajemy obszar do zaalokowania na stos
	call _malloc ; wywo�anie malloc, adres do tablicy znajduje si� w EAX
	add esp, 4

	cmp eax, 0 ; sprzawdzamy czy alokacja si� uda�a
	je nie_udalo_sie
	mov i, eax ; teraz w i mamy nasz pointer na pierwszy element tablicy

	mov ecx, [ebp+8] ; teraz w ecx mamy nasz parametr e jako ilo�� iteracji p�tli
	cmp ecx, 0
	je koniec
ptl:
	mov edx, h
	shl edx, 1 ; h*2
	add edx, h ; edx = h + 2h = 3h
	sub edx, 1 ; edx = 3h - 1
	mov ebx, [i]
	mov [ebx], edx ; (* i) = 3 * h - 1
	add i, 4 ; i++ ( ale zwi�kszamy o 4 bo to wielko�� inta )
	inc h
	loop ptl
	
	push eax ; na stos adres pierwszej kom�rki tablicy
	call _free ; free wywo�ujemy tylko kiedy alokacja si� uda
	add esp, 4

	jmp koniec
nie_udalo_sie:
	mov ecx, (offset koniec_t) - (offset tekst) ; d�ugo�� tekstu
	push dword ptr ecx
	push dword ptr offset tekst
	push dword ptr 1
	call __write ; wy�wietl komunikat b��du
	add esp,12

koniec:
	mov eax, [ebp+8] ; zwracamy nasz parametr porzez rejestr EAX
	pop ebx
	pop ebp
	ret
_maloc ENDP
END