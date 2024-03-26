.686
.model flat

extern __read : PROC
extern _malloc : PROC

public _convert_to_array
.data
dziesiec dd 10
sajz dd 0
.code

_convert_to_array PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi
	mov ebx, [ebp+8] ; w ebp adres tablicy
	; teraz policzmy iloœæ liczb do wczytania
	mov ecx, 1 ; liczba liczb = liczba spacji + 1
ptl:
	cmp byte ptr [ebx], 0Ah ; czy enter ( koniec stringa )
	je koniec
	cmp byte ptr [ebx], ' ' ; sprawdzamy czy znak to spacja
	jne dalej
	inc ecx
dalej:
	inc ebx
	jmp ptl
koniec:
	; teraz w ecx mamy iloœæ liczb do wczytania
	mov sajz, ecx
	shl ecx, 2 ; ecx*4
	push ecx ; obszar pamiêci do zaalokowania
	call _malloc ; malloc
	add esp, 4 ; zwalniamy stos, w EAX mamy adres tablicy unsingned intów

	mov esi, 0 ; esi bêdzie indeksem tablicy co jest w EAX
	mov ecx, 0 ; w ecx bêdzie siê kumulowa³a liczba do wczytania
	mov ebx, [ebp+8]
	mov edi, eax
	push edi
	mov eax, 0
ptl2:
	mov dl, [ebx] ; w dl znak ascii kolejnego znaku
	inc ebx
	cmp dl, ' ' ; spacja
	je spacja
	cmp dl, '0'
	jb inna
	cmp dl, '9'
	ja inna
	sub dl, '0' ; w dl teraz mamy wartoœæ liczbow¹
	movzx ecx, dl
	mul dword ptr dziesiec
	add eax, ecx
	jmp ptl2

spacja:
	mov [edi], eax
	xor eax, eax
	add edi, 4
	jmp ptl2
inna:
	cmp dl, 0h ; koniec stringa NULL
	jnz ptl2
	
	mov [edi], eax

	pop edi

	mov ebx, [ebp+12]
	mov ecx, sajz
	mov [ebx], ecx
	mov eax, edi
	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_convert_to_array ENDP
END