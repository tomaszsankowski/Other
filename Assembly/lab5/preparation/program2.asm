.686
.model flat


; st(0) = e^x
public _edox
.code
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
END