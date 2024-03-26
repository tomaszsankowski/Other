.686
.XMM ; zezwolenie na asemblacjê operacji SSE
.model flat

public _int2float, _pm_jeden
.data
jedynki dd 4 dup (-1.0)
.code

_pm_jeden PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi

	mov esi, [ebp+8] ; pierwsza tablica
	mov edi, offset jedynki ; tablica jedynek

	; ³¹dowanie tablic do rejestrów xmm
	movups xmm5, [esi]
	movups xmm6, xmmword ptr jedynki

	; wykonanie tego dziwnego rozkazu który dla indeksó parzystych dodaje
	; a dla nieparzsytych odejmuje
	addsubps xmm5, xmm6
	; zapisanie wyniku w tablicy wynikowej
	movups [esi], xmm5

	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_pm_jeden ENDP

_int2float PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi

	mov esi, [ebp+8] ; pierwsza tablica
	mov edi, [ebp+12] ; druga tablica ( wynikowa )

	; ³adowanie 2 liczb typu int z pierwszej tablicy do rejestru xmm5 od razu
	; z konwersj¹ na typ float
	cvtpi2ps xmm5, qword PTR [esi]

	; zapisanie wyniku w tablicy wynikowej
	movups [edi], xmm5

	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_int2float ENDP

END