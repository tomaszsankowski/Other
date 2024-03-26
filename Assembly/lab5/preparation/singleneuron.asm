.686
.model flat

extern _malloc : proc
public _single_neuron
.code
_single_neuron proc
	push ebp
	mov ebp, esp
	push ebx
	push edi
	push esi
	mov edi, [ebp+8] ; tablica liczb ( double )
	mov esi, [ebp+12] ; tablica wag ( float )
	mov ecx, [ebp+16] ; iloœæ elementów w tablicy
	jecxz koniec
	fldz ; st(0) = 0
ptl:
	fld qword ptr [edi] ; liczba typu double z edi
	fld dword ptr [esi] ; liczba typu float z esi
	add edi, 8
	add esi, 4
	fmul ; równowa¿ne fmulp st(1), st(0)
	fadd ; równowa¿ne faddp st(1), st(0)
	; na wierzcho³ku stosu zostaje tylko nasza suma
	loop ptl
	; na wierzcho³ku stosu zostaje tylko nasza suma
	push dword ptr [ebp+16]
	call _malloc
	add esp, 4
	; w eax adres naszego floata, teraz trzeba tylko go tam wpisaæ
	fldz ; st(0) = 0, st(1) = wynik
	fcomi st(0), st(1)
	jl wieksze_niz_0
	fxch ; st(0) = wynik ale jest ujemny, st(0) = 0
	fstp st(0); st(0) = 0
wieksze_niz_0:
	fst dword ptr [eax]
koniec:
	pop esi
	pop edi
	pop ebx
	pop ebp
	ret
_single_neuron endp
end