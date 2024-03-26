; program ilustruj�cy operacje SSE procesora

.686
.XMM ; zezwolenie na asemblacj� operacji SSE
.model flat

public _dodaj_SSE, _pierwiastek_SSE, _odwrotnosc_SSE

.code

_dodaj_SSE PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi

	mov esi, [ebp+8] ; pierwsza tablica
	mov edi, [ebp+12] ; druga tablica
	mov ebx, [ebp+16] ; trzecia tablica (wynikowa)

	; �adowanie do xmm5 czterech liczb typu float
	; liczby zostaj� podane w tablicy z rejestru ESI

	; movups: mov-przes�anie, u-unaligned(adres nie jest podzielny przez 16)
	;		  p-packed(od razu cztery liczby �adujemy), s-short(float=32-bitowe liczby zmiennoprzecinkowe)
	movups xmm5, [esi]
	movups xmm6, [edi]

	;sumowanie czterech float�w na raz
	addps xmm5, xmm6

	; zapisanie wyniku w tablicy wynikowej
	movups [ebx], xmm5

	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_dodaj_SSE ENDP

;===================================================================
_pierwiastek_SSE PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	mov esi, [ebp+8] ; pierwsza tablica
	mov ebx, [ebp+12] ; druga tablica

	; �adowanie do xmm6 liczb z pierwszej tablicy
	movups xmm6, [esi]

	; pierwiastkowanie czterech liczb typu float na raz
	sqrtps xmm5, xmm6

	; zapisanie wyniku do tablicy drugiej (wynikowej)
	movups [ebx], xmm5

	pop esi
	pop ebx
	pop ebp
	ret
_pierwiastek_SSE ENDP

;===================================================================

; rozkas RCPPS wykonuje obliczenia na 12-bitowej mantysie ( a nie
; na 24-bitowej, przez co obliczenia s� szybsze, ale mnie dok�adne

_odwrotnosc_SSE PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi

	mov esi, [ebp+8] ; pierwsza tablica
	mov ebx, [ebp+12] ; druga tablica (wynikowa)

	; �adowanie do xmm5 pierwszej tablicy czterech float�w
	movups xmm5, [esi]

	; obliczanie odwrotno�ci czterech float�w
	rcpps xmm6, xmm5

	; zapisanie wyniku sumowania w tablicy w pami�ci
	movups [ebx], xmm6

	pop esi
	pop ebx
	pop ebp
	ret
_odwrotnosc_SSE ENDP

END