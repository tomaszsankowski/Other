.686
.model flat

public _srednia_harm

.data
jeden dd 1.0
liczba_znakow dd ?
.code
_srednia_harm PROC
	push ebp
	mov ebp, esp
	push ebx
	push edi
	push esi
	mov ebx, [ebp+8] ; adres tablicy
	mov ecx, [ebp+12] ; iloœæ elementów
	jecxz koniec
	fldz ; za³adowanie zera na stos
	; st(0) = suma
ptl:
	fld dword ptr jeden
	fld dword ptr [ebx] ; za³adowanie kolejnego elementu tablicy
	add ebx, 4 ; ebx wskazuje na kolejny element tablicy
	; st(0) = an, st(1) = 1, st(2) = suma
	fdivp st(1), st(0) ; 1/an (ostatnecznie w st(0))
	; st(0) = 1/an, st(1) = suma
	faddp st(1), st(0) ; suma += 1/an (ostatecznie w st(0))
	loop ptl
	
	mov ecx, [ebp+12] ; iloœæ elementów
	mov liczba_znakow, ecx
	fild dword ptr liczba_znakow ; na stos koprocesora ³adujemy n
	; st(0) = n, st(1) = suma 1/an
	fxch st(1) ; st(0) <-> st(1)
	; st(0) = suma 1/an, st(1) = n
	fdivp st(1), st(0)
koniec:
	pop esi
	pop edi
	pop ebx
	pop ebp
	ret
_srednia_harm ENDP
END