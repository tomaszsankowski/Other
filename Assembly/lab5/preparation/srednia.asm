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
	mov ecx, [ebp+12] ; w ecx wielko�� paczki liczb ( k )
	mov esi, [ebp+16] ; w esi wielko�� tablicy ( m )
	mov edx, esi
	sub edx, ecx ; w edx m-k czyli maksymalny indeks od kt�rego mo�emy zaczyna� liczy� �redni� ( czyli ilo�� razy kiedy mo�emy policzy� kolejn� �redni� )
	; pobieramy pierwsz� �redni�
	mov edi, 0 ; indeks tablicy float
	fldz ; st(0) = 0
ptl1:
	fadd dword ptr [ebx+4*edi] ; st(0) += tablica[i]
	inc edi
	cmp edi, ecx
	jne ptl1

	; w st(0) mamy sum� k kolejnych element�w
	push ecx
	fild dword ptr [esp] ; st(0) = k
	fdiv ; �eby dosta� �redni� trzeba podzieli� st(1) przez st(0)
	add esp, 4
	; w st(0) mamy pierwsz� �redni� z k element�w

	dec edx
	jz koniec ; k = m, nie mo�emy wywo�a� wi�cej �rednich

	; teraz g��wna p�tla licz�ca kolejne �rednie
	; w st(0) mamy nasz� poprzedni� �redni�
ptl2:
	add ebx, 4 ; i++
	fldz ; st(0) = 0 czyli nasza nowa �rednia
	mov edi, 0 ; indeks
ptl_wewn:
	fadd dword ptr [ebx+4*edi] ; st(0) += tablica [i]
	inc edi
	cmp edi, ecx
	jne ptl_wewn
	; w st(0) nasza suma k element�w, w st(1) poprzednia �rednia
	push ecx
	fild dword ptr [esp] ; st(0) = k
	fdiv ; �eby dosta� �redni� trzeba podzieli� st(1) przez st(0)
	add esp, 4
	; w st(0) mamy ostatni� �redni� z k element�w, w st(1) poprzedni� �redni�

	; przetrzymujemy na stosie nasz� �redni� ostatni�
	sub esp, 4
	fstp dword ptr [esp]

	; sprawdzamy, czy |st(1)-st(0)|<0.6
	fsub ; fsubp st(1), st(0) obliczamy r�nic� �rednich
	; w st(0) r�nica st(1)-st(0)
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
	jl wyjscie_z_petli ; abs(delta)<0.6f czyli ko�czymy program

	; mo�emy przej�� do kolejnej �redniej
	fstp st(0) ; usuwamy te niepotrzebne st(1) i st(0)
	fstp st(0)
	fld dword ptr [esp]
	add esp, 4
	dec edx
	jnz ptl2 ; nie mo�na pobra� wi�cej paczek k elementowych -> wyjd� z p�tli
	jmp koniec 

wyjscie_z_petli:
	fstp st(0)
	fstp st(0) ; usuwamy to co jest na stosie koprocesora
	fld dword ptr [esp] ; i ustawiamy przechowywan� ostatni� �redni�
	add esp, 4

koniec:
	; na wierzcho�ku stosu koprocesora mamy nasz� �redni� kt�r� zwracamy, nie musimy ju� nic robi�
	pop esi
	pop edi
	pop ebx
	pop ebp
	ret
_progowanie_sredniej_kroczacej endp
end