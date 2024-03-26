.686
.model flat
extern _malloc : PROC
public _Matmul
.data
cztery dd 4
vk dd ?
vl dd ?
vm dd ?
wierszA dd 0
kolumnaB dd 0
bufor_na_float dd ?
tablica_ptr dd ?
.code
_Matmul proc
	push ebp
	mov ebp, esp
	push ebx
	push edi
	push esi
	mov ebx, [ebp+16] ; k, l, m WARTOŒÆ
	mov dword ptr vk, ebx
	mov ebx, [ebp+20]
	mov dword ptr vl, ebx
	mov ebx, [ebp+24]
	mov dword ptr vm, ebx
	mov ebx, [ebp+16]
	mov esi, [ebp+8] ; tablica A (float) ADRES
	mov edi, [ebp+12] ; tablica B (int) ADRES
	xor edx, edx ; edx = 0
	mov eax, dword ptr [ebp+24] ; w eax liczba m
	mul dword ptr ebx ; k*m do malloca
	mov ecx, eax ; w ecx iloœæ komórek macierzy wynikowej
	push ecx
	mul dword ptr cztery ; iloœæ floatów *4 bo to wielkoœæ jego w bajtach
	push eax
	call _malloc
	add esp, 4
	mov tablica_ptr, eax
	pop ecx
	; teraz w eax mamy adres tablicy wynikowej
	; w ecx iloœæ komórek wynikowej macierzy
	mov edx, vm ; w edx szerekoœc wynikowej macierzy
	jecxz koniec
ptl:
	mov ebx, [ebp+20] ; w ebx iloœæ mno¿eñ
	fldz ; st(0) = wynik
mult:
	fld dword ptr [esi] ; z pierwszej macierzy
	fild dword ptr [edi] ; z drugiej macierzy
	fmulp st(1), st(0) ; st(0): wynik cz¹stkowy, st(1) wynik
	faddp st(1), st(0) ; st(0) wynik
	add esi, 4 ; kolejna kolumna A
	push eax
	mov eax, vm
	lea edi, [edi+4*eax] ; kolejny wiersz B
	pop eax
	dec ebx
	jnz mult
	dec edx
	jnz nie_przenosimy
	mov edx, vm
	push eax
	mov eax, vl
	lea esi, [esi+4*eax]
	pop eax
	mov edi,[ebp+12] ; a B wraca na swoje miejsce
	mov kolumnaB, -1
nie_przenosimy:
	add kolumnaB, 1
	fstp dword ptr [eax] ; dodawanie kolejnego elementu macierzy
	add eax, 4
	; wskaznik na tablice A wraca do poprzedniego wiersza
	push eax
	mov eax, vl
	neg eax
	lea esi, [esi+4*eax]
	; wskaznik na tablice B idzie do kolejnej kolumny
	mov edi, [ebp+12]
	mov eax, kolumnaB ; w eax numer kolumny
	lea edi, [edi+4*eax]
	pop eax

	dec ecx
	jnz ptl
koniec:
	mov eax, tablica_ptr
	pop esi
	pop edi
	pop ebx
	pop ebp
	ret
_Matmul endp

END