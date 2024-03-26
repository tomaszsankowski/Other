.686
.model flat


;				zadanie 4.4;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
public _przestaw
.code

_przestaw PROC
	push ebp
	mov ebp, esp
	push ebx

	mov ebx, [ebp+8] ; adres tablicy
	mov ecx, [ebp+12] ; liczba elementów w tablicy
	dec ecx

ptl:
	mov eax, [ebx] ; w eax element tablicy tab[i]
	cmp eax, [ebx+4] ; porównujemy z tab[i+1]
	jle gotowe ; jeœli tab[i+1]<=tab[i] to koñczymy podprogram

	; swap(tab[i],tab[i+1])
	mov edx, [ebx+4]
	mov [ebx], edx
	mov [ebx+4], eax

gotowe:
	add ebx, 4 ; wyznaczenie adresu kolejnego elementu (i++)
	loop ptl ; pêtlowy mnemonik

	pop ebx
	pop ebp
	ret
_przestaw ENDP
END
;				zadanie 4.3;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
public _odejmij_jeden
.code
_odejmij_jeden PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi

	mov ebx, [ebp+8] ; w EBX jest wskaŸnik na wskaŸnik liczbê m
	mov esi, [ebx] ; i teraz w ESI mamy wskaŸnik na m

	dec dword ptr [esi]

	pop esi
	pop ebx
	pop ebp
	ret
_odejmij_jeden ENDP
END




;				zadanie 4.2;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
public _liczba_przeciwna
.code
_liczba_przeciwna PROC
	push ebp
	mov ebp,esp
	push ebx

	mov ebx, [ebp+8]

	neg dword ptr [ebx]

	pop ebx
	pop ebp
	ret
_liczba_przeciwna ENDP
END

public _plus_jeden

.code
_plus_jeden PROC
	push ebp ; przechowywanie EBP
	mov ebp,esp ; kopiowanie rejestru ESP do EBP
	push ebx ; przechowywanie EBX

; do EBX wpisujemy wartoœæ zmiennej przekazywanej jako parametr funkcji
	mov ebx, [ebp+8]

	inc dword ptr [ebx]
	;mov eax, [ebx] ; odczytanie wartoœci zmiennej
	;inc eax ; m++
	;mov [ebx], eax ; odes³anie wyniku do zmiennej

	pop ebx
	pop ebp
	ret
_plus_jeden ENDP

END

;				zadanie 4.1;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
public _szukaj_max

.code

_szukaj_max PROC
	push ebp ; zapisanie zawartoœci EBP na stosie
	mov ebp, esp ; kopiowanie zawartoœæi ESP do EBP

	mov eax, [ebp+8] ; liczba a w EAX
	cmp eax, [ebp+12] ; porównanie liczb a i b
	jge a_wieksza ; skok gdy a >= b

	mov eax, [ebp+16] ; liczba c w EAX
	cmp eax, [ebp+20] ; porównanie liczb c i d
	jge c_wieksza_b ; skok, gdy c >= d

	mov eax, [ebp+20] ; liczba d w EAX
	cmp eax, [ebp+12] ; porównanie liczb b i d
	jge koniec ; skok, gdy d jest najwiêksza
	mov eax, [ebp+12] ; jeœli b jest najwiêksza, to przenosimy j¹ do EAX i skaczemy do ret
	jmp koniec
c_wieksza_b: ; liczba c w EAX
	cmp eax, [ebp+12] ; porównanie liczb b i c
	jge koniec ; skok gdy c jest najwiêksza
	mov eax, [ebp+12] ; jeœli b jest najwiêksza to przenosimy j¹ do EAX i skaczemy do ret
	jmp koniec


a_wieksza:
	mov eax, [ebp+16] ; liczba c w EAX
	cmp eax, [ebp+20] ; porównanie liczb c i d
	jge c_wieksza_a ; skok, gdy c >= d

	mov eax, [ebp+20] ; liczba d w EAX
	cmp eax, [ebp+8] ; porównanie liczb a i d
	jge koniec ; skok, gdy d jest najwiêksza
	mov eax, [ebp+8] ; jeœli a jest najwiêksza, to przenosimy j¹ do EAX i skaczemy do ret
	jmp koniec
c_wieksza_a: ; liczba c w EAX
	cmp eax, [ebp+8] ; porównanie liczb a i c
	jge koniec ; skok gdy c jest najwiêksza
	mov eax, [ebp+8] ; jeœli a jest najwiêksza to przenosimy j¹ do EAX i skaczemy do ret
	jmp koniec

koniec: 
	pop ebp
	ret ; wracamy (w EAX znajduje siê najwiêksza liczba)
_szukaj_max ENDP
END