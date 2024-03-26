.686
.model flat

public _single_neuron
.code



;================ funkcja ta zwraca e^x
_edox PROC
	push ebp
	mov ebp, esp
	fld dword ptr [ebp+8] ; na wierzcho³ek stosu nasze x
	fldl2e ; log 2 e
	fmulp st(1), st(0) ; obliczenie x * log 2 e
	; kopiowanie obliczonej wartoœci do ST(1)
	fst st(1)
	; zaokr¹glenie do wartoœci ca³kowitej
	frndint
	fsub st(1), st(0) ; obliczenie czêœci u³amkowej
	fxch ; zamiana ST(0) i ST(1)
	; po zamianie: ST(0) - czêœæ u³amkowa, ST(1) - czêœæ ca³kowita
	; obliczenie wartoœci funkcji wyk³adniczej dla czêœci
	; u³amkowej wyk³adnika
	f2xm1
	fld1 ; liczba 1
	faddp st(1), st(0) ; dodanie 1 do wyniku
	; mno¿enie przez 2^(czêœæ ca³kowita)
	fscale
	; przes³anie wyniku do ST(1) i usuniêcie wartoœci
	; z wierzcho³ka stosu
	fstp st(1)
	; w rezultacie wynik znajduje siê w ST(0)
	pop ebp
	ret
_edox ENDP

_single_neuron PROC
	push ebp
	mov ebp, esp
	push ebx
	push edi
	push esi

	mov esi, [ebp+8] ; w esi tablica X ( float )
	mov ebx, [ebp+12] ; w ebx tablica wag ( double )
	mov ecx, [ebp+16] ; w ecx iloœc elementó tablicy X

	; obliczamy najpierw sumê pierwszej sk³adowej
	fldz ; st(0) = 0 -> nasza suma
	dec ecx ; i--
	fld dword ptr [esi] ; st(0) = X[0]
	add esi, 4 ; X[1] teraz esi wskazuje
	fld1 ; st(0) = 1, st(1) = X[0], st(2)=suma
	fmulp ; st(1)*st(0) 
	; st(0) -> X[0]*1, st(1) -> suma
	faddp ; st(0) = X[0] czyli nasza aktualna suma

	jecxz koniec
ptl:
	fld dword ptr [esi] ; X[i+1] na stos
	fld qword ptr [ebx] ; wagi[i] na stos
	add ebx, 8 ; += sizeof(double)
	add esi, 4 ; += sizeof(float)
	fmulp
	faddp
	; teraz w st(0) mamy aktualn¹ sumê
	loop ptl

koniec:
	; st(0) -> nasza suma któr¹ musimy poddaæ naszej funkcji sigmoid(x)
	fstp dword ptr [esp] ; odk³adamy na stos sumê
	call _edox
	add esp, 4
	; w st(0) mamy teraz e^suma
	; obliczamy 1/e^suma = e^-suma
	; 1 na stos
	mov eax, 1
	sub esp, 4
	push eax
	fild dword ptr [esp]
	add esp, 4

	fxch ; st(0) = exp, st(1)=1.0
	fdivp ; 1.0/exp
	; st(0) = e^-suma
	fld1 ; st(0) = 1
	faddp ; st(0) = 1 + e^-suma
	fld1
	fxch
	fdivp ; st(1)/st(0) == 1/(1+e^-suma)

	; na wierzcho³ku stosu koprocesora jest nasza odpowiedŸ

	pop esi
	pop edi
	pop ebx
	pop ebp
	ret
_single_neuron ENDP
END