.686
.model flat

extern _malloc : PROC

public _convert_to_bin
.code
_convert_to_bin PROC
	push ebp
	mov ebp, esp
	push edi
	mov edi, 32 ; edi to indeks tablicy
	push 66 
	call _malloc
	add esp, 4
	; w eax mamy adres naszej tablicy
	mov edx, [ebp+8] ; w eax nasza long long liczba

ptl:
	dec edi
	rcr edx, 1
	jnc daj_zero

	mov word ptr [eax+2*edi], '1'
	jmp dalej
daj_zero:
	mov word ptr [eax+2*edi], '0'
dalej:
	cmp edi, 0
	jne ptl

koniec:
	mov word ptr [eax+64], 0
	pop edi
	pop ebp
	ret
_convert_to_bin ENDP

END