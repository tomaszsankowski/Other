.686
.model flat

extern _wcstoll : PROC

public _add_64
.code
_add_64 PROC
	push ebp
	mov ebp,esp
	push ebx
	push edi
	push esi
	mov ebx, [ebp+8] ; w ebx liczba1
	mov edi, [ebp+12] ; w edi liczba2
	
	push dword ptr 10 ; w kodzie szesnastkowym s¹ liczby
	push dword ptr 0
	push ebx
	call _wcstoll 
	; teraz w eax pierwszy long long
	add esp, 12

	mov ebx, eax ; w ebx mlodsza czesc liczby1
	mov esi, edx ; w esi starsza czesc liczby1
	push dword ptr 10
	push dword ptr 0
	push edi
	call _wcstoll
	add esp, 12
	; w edx starsza czêœæ liczba2, w eax m³odsza czêœæ liczba2
	; w ebx starsza liczba1, w eax liczba2
	; esi:ebx + edx:eax
	add eax, ebx
	jnc dalej
	add edx, 1
dalej:
	add edx, esi
	pop esi
	pop edi
	pop ebx
	pop ebp
	ret
_add_64 ENDP
END