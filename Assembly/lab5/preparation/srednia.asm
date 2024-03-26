.686
.model flat

public _progowanie_sredniej_kroczacej
.code
_progowanie_sredniej_kroczacej proc
	push ebp
	mov ebp,esp
	push ebx
	push edi
	push esi
	
	mov ebx, [ebp+8] ; w ebx tablica wejsciowa ( float )
	mov ecx, [ebp+12] ; w ecx wielkoœæ paczki liczb ( k )
	mov esi, [ebp+16] ; w esi wielkoœæ tablicy ( m )
	mov edx, esi
	sub edx, ecx ; w edx m-k czyli maksymalny indeks od którego mo¿emy zaczynaæ liczyæ œredni¹ ( czyli iloœæ razy kiedy mo¿emy policzyæ kolejn¹ œredni¹ )
	; pobieramy pierwsz¹ œredni¹
	mov edi, 0 ; indeks tablicy float
	fldz ; st(0) = 0
ptl1:
	fadd dword ptr [ebx+4*edi] ; st(0) += tablica[i]
	inc edi
	cmp edi, ecx
	jne ptl1

	; w st(0) mamy sumê k kolejnych elementów
	push ecx
	fild dword ptr [esp] ; st(0) = k
	fdiv ; ¿eby dostaæ œredni¹ trzeba podzieliæ st(1) przez st(0)
	add esp, 4
	; w st(0) mamy pierwsz¹ œredni¹ z k elementów

	dec edx
	jz koniec ; k = m, nie mo¿emy wywo³aæ wiêcej œrednich

	; teraz g³ówna pêtla licz¹ca kolejne œrednie
	; w st(0) mamy nasz¹ poprzedni¹ œredni¹
ptl2:
	add ebx, 4 ; i++
	fldz ; st(0) = 0 czyli nasza nowa œrednia
	mov edi, 0 ; indeks
ptl_wewn:
	fadd dword ptr [ebx+4*edi] ; st(0) += tablica [i]
	inc edi
	cmp edi, ecx
	jne ptl_wewn
	; w st(0) nasza suma k elementów, w st(1) poprzednia œrednia
	push ecx
	fild dword ptr [esp] ; st(0) = k
	fdiv ; ¿eby dostaæ œredni¹ trzeba podzieliæ st(1) przez st(0)
	add esp, 4
	; w st(0) mamy ostatni¹ œredni¹ z k elementów, w st(1) poprzedni¹ œredni¹

	; przetrzymujemy na stosie nasz¹ œredni¹ ostatni¹
	sub esp, 4
	fstp dword ptr [esp]

	; sprawdzamy, czy |st(1)-st(0)|<0.6
	fsub ; fsubp st(1), st(0) obliczamy ró¿nicê œrednich
	; w st(0) ró¿nica st(1)-st(0)
	fabs ; st(0) = abs(st(1)-st(0))
	push 6
	fild dword ptr [esp]
	push 10
	fild dword ptr [esp]
	fdivp
	add esp, 8
	; st(0) = 0.6, st(1) = delta
	fxch ; st(1) <-> st(0)
	fcomi st(0), st(1) ; cmp abs(delta), 0.6f
	jl wyjscie_z_petli ; abs(delta)<0.6f czyli koñczymy program

	; mo¿emy przejœæ do kolejnej œredniej
	fstp st(0) ; usuwamy te niepotrzebne st(1) i st(0)
	fstp st(0)
	fld dword ptr [esp]
	add esp, 4
	dec edx
	jnz ptl2 ; nie mo¿na pobraæ wiêcej paczek k elementowych -> wyjdŸ z pêtli
	jmp koniec 

wyjscie_z_petli:
	fstp st(0)
	fstp st(0) ; usuwamy to co jest na stosie koprocesora
	fld dword ptr [esp] ; i ustawiamy przechowywan¹ ostatni¹ œredni¹
	add esp, 4

koniec:
	; na wierzcho³ku stosu koprocesora mamy nasz¹ œredni¹ któr¹ zwracamy, nie musimy ju¿ nic robiæ
	pop esi
	pop edi
	pop ebx
	pop ebp
	ret
_progowanie_sredniej_kroczacej endp
end