.686
.model flat


; st(0) = e^x
public _edox
.code
_edox PROC
	push ebp
	mov ebp, esp
	fld dword ptr [ebp+8] ; na wierzcho�ek stosu nasze x
	fldl2e ; log 2 e
	fmulp st(1), st(0) ; obliczenie x * log 2 e
	; kopiowanie obliczonej warto�ci do ST(1)
	fst st(1)
	; zaokr�glenie do warto�ci ca�kowitej
	frndint
	fsub st(1), st(0) ; obliczenie cz�ci u�amkowej
	fxch ; zamiana ST(0) i ST(1)
	; po zamianie: ST(0) - cz�� u�amkowa, ST(1) - cz�� ca�kowita
	; obliczenie warto�ci funkcji wyk�adniczej dla cz�ci
	; u�amkowej wyk�adnika
	f2xm1
	fld1 ; liczba 1
	faddp st(1), st(0) ; dodanie 1 do wyniku
	; mno�enie przez 2^(cz�� ca�kowita)
	fscale
	; przes�anie wyniku do ST(1) i usuni�cie warto�ci
	; z wierzcho�ka stosu
	fstp st(1)
	; w rezultacie wynik znajduje si� w ST(0)
	pop ebp
	ret
_edox ENDP
END