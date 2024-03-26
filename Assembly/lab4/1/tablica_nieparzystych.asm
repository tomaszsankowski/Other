.686
.model flat
extern _malloc : PROC

public _tablica_nieparzystych
.code
_tablica_nieparzystych PROC
	push ebp
	mov ebp, esp
	push ebx
	push edi
	push esi

	mov ebx, [ebp+8] ; w ebx adres elementu tablicy
	mov edx, [ebp+12] ; w edx adres liczby elementów tablicy
	mov ecx, [edx] ; ecx iloœæ elementów tablicy
	mov edx, 0 ; edx = 0 nasz counter nieparzystych
	; liczymy wielkoœæ tablicy do zaalakowania
ptl:
	mov eax, [ebx] ; w EAX element tablicy
	bt eax, 0 ; w CF bêdzie bit zerowy EAX
	jnc parzysta ; bit zerowy EAX = 0 (w edx liczba parzysta)
	inc edx ; iloœæ liczb nieparzystych ++
parzysta:
	add ebx, 4 ; i++ dla inta
	loop ptl ; pêtla
	
	mov eax, edx
	mov esi, edx
	shl eax, 2 ; l. nieparzystych * 4 bajty
	push eax ; wielkoœæ obszaru do zaalokowania
	call _malloc ; teraz w eax mamy zaalokowany obszar
	add esp, 4 ; uzywa standardu C czyli my zwalniamy stos
	cmp eax, 0 ; czy eax = NULLPTR
	jz koniec


	mov ebx, [ebp+8]
	mov edi, [ebp+12] ; w edi adres size
	mov ecx, [edi] ; w ecx wartoœæ size
	push eax
ptl2:
	mov edi, [ebx] ; w edi kolejne liczby tablicy ponownie
	bt edi, 0 ; sprawdzanie, czy edi jest parzyste
	jnc parzysta2 ; skok gdy edi parzzysta
	mov [eax], edi ; do nowa_tablica kolejna liczba nieparzsyta
	add eax, 4 ; nowa_tablica ++
parzysta2:
	add ebx, 4 ; i++
	loop ptl2

	pop eax

koniec:
	; w eax mamy adres naszej nowej tablicy
	; teraz trzeba przenieœæ pod adres drugiego parametru liczbê liczb parzystych
	mov ecx, [ebp+12]
	sub [ecx], esi ; size - l.parzystych
	pop esi
	pop edi
	pop ebx
	pop ebp
	ret
_tablica_nieparzystych ENDP
END