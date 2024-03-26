.686
.XMM ; zezwolenie na asemblacj� operacji SSE
.model flat

public _sumuj8bit

.code

_sumuj8bit PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi

	mov esi, [ebp+8] ; pierwsza tablica
	mov edi, [ebp+12] ; druga tablica

	; �adowanie do xmm5 oraz xmm6 16 8-bitowych wektor�w
	movups xmm5, [esi]
	movups xmm6, [edi]

	;sumowanie czterech float�w na raz
	paddsb xmm5, xmm6

	; zapisanie wyniku w tablicy wynikowej
	movups [esi], xmm5

	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_sumuj8bit ENDP

END