.686
.model flat

public _nowy_exp
.data
jeden dd 1.0
vx dd ?
.code
_nowy_exp PROC
	push ebp
	mov ebp, esp
	push ebx
	mov ebx, [ebp+8]
	mov vx, ebx ; w vx nasze x
	; 1 + x/1 + x^2/1*2 +...
	fld dword ptr jeden
	fld dword ptr jeden
	fld dword ptr jeden
	 ; st(0) = wynik poœredni, st(1) = counter, st(2) = wynik
	mov ecx, 19
ptl:
	fmul dword ptr vx ; poœredni*=x
	fdiv st(0),st(1) ; poœredni/counter
	fadd st(2), st(0) ; wynik+=poœredni
	fxch st(1)
	fadd dword ptr jeden ; counter+=1
	fxch st(1)
	loop ptl
	fstp st(0) ; pop poœredni
	fstp st(0) ; pop counter
	; w st(0) wynik
	pop ebx
	pop ebp
	ret
_nowy_exp ENDP
END