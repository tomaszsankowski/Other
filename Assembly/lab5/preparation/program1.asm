.686
.model flat ; model p³aski

public _main
.data
; 2x^2 - x - 15 = 0
wsp_a dd 2.0
wsp_b dd -1.0
wsp_c dd -15.0

dwa dd 2.0
cztery dd 4.0
x1 dd ?
x2 dd ?

.code
	
_main proc
	finit
	fld wsp_a ; za³¹dowania wspó³czynnika a
	fld wsp_b ; za³adowanie wspó³czynnika b
	fst st(2) ; kopiowanie b
	; st(0) = b, st(1) = a, st(2) = b
	fmul st(0),st(0) ; b^2
	fld cztery
	; st(0) = 4.0, st(1) = b^2, st(2) = a, st(3) = b
	fmul st(0), st(2) ; obliczenie 4*a
	fmul wsp_c ; 4*a*c
	fsubp st(1), st(0) ; obliczenie b^2 - 4*a*b
	; st(0) = b^2-4*a*c, st(1) = a, st(2) = b
	fldz ; zaladowanie 0
	; st(0) = 0, st(1) = b^2-4*a*c, st(2) = a, st(3) = b
	fcomi st(0), st(1); porównanie, oba operandy musz¹ byæ podane na stosie koprocesora
	fstp st(0) ; usuniêcie 0
	ja delta_ujemna ; skok, gdy delta ujemna

	; nie zak³ada siê, ¿e delta = 0
 
	; st(0) = b^2-4*a*c, st(1) = a, st(2) = b
	fxch st(1) ; zamiana st(0) z st(1)
	
	; st(0) = a, st(1) = b^2-4*a*c, st(2) = b
	fadd st(0), st(0) ; 2*a
	
	; st(0) = b^2-4*a*c, st(1) = b, st(2) = 2*a
	fsqrt ; pierwiastek kwadratowy z delty
	fst st(3) ; przechowanie wyniku
	
	; st(0) = sqrt(delta), st(1) = b, st(2) = 2*a, sqrt(delta)
	fchs ; zmiana znaku
	fsub st(0), st(1) ; -b -sqrt(delta)
	fdiv st(0), st(2) ; obliczenie x1
	fstp x1 ; x1 w pamiêci zapisane

	; st() - b, st(1) = 2*a, st(2) = sqrt(delta)

	fchs ; zmiana znaku
	fadd st(0), st(2)
	fdiv st(0), st(1)
	fstp x2

	fstp st(0) ; oczyszczanie stosu
	fstp st(0)
delta_ujemna:
_main endp
end