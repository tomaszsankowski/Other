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
	mov ecx, [ebp+12] ; liczba element�w w tablicy
	dec ecx

ptl:
	mov eax, [ebx] ; w eax element tablicy tab[i]
	cmp eax, [ebx+4] ; por�wnujemy z tab[i+1]
	jle gotowe ; je�li tab[i+1]<=tab[i] to ko�czymy podprogram

	; swap(tab[i],tab[i+1])
	mov edx, [ebx+4]
	mov [ebx], edx
	mov [ebx+4], eax

gotowe:
	add ebx, 4 ; wyznaczenie adresu kolejnego elementu (i++)
	loop ptl ; p�tlowy mnemonik

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

	mov ebx, [ebp+8] ; w EBX jest wska�nik na wska�nik liczb� m
	mov esi, [ebx] ; i teraz w ESI mamy wska�nik na m

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

; do EBX wpisujemy warto�� zmiennej przekazywanej jako parametr funkcji
	mov ebx, [ebp+8]

	inc dword ptr [ebx]
	;mov eax, [ebx] ; odczytanie warto�ci zmiennej
	;inc eax ; m++
	;mov [ebx], eax ; odes�anie wyniku do zmiennej

	pop ebx
	pop ebp
	ret
_plus_jeden ENDP

END

;				zadanie 4.1;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
public _szukaj_max

.code

_szukaj_max PROC
	push ebp ; zapisanie zawarto�ci EBP na stosie
	mov ebp, esp ; kopiowanie zawarto��i ESP do EBP

	mov eax, [ebp+8] ; liczba a w EAX
	cmp eax, [ebp+12] ; por�wnanie liczb a i b
	jge a_wieksza ; skok gdy a >= b

	mov eax, [ebp+16] ; liczba c w EAX
	cmp eax, [ebp+20] ; por�wnanie liczb c i d
	jge c_wieksza_b ; skok, gdy c >= d

	mov eax, [ebp+20] ; liczba d w EAX
	cmp eax, [ebp+12] ; por�wnanie liczb b i d
	jge koniec ; skok, gdy d jest najwi�ksza
	mov eax, [ebp+12] ; je�li b jest najwi�ksza, to przenosimy j� do EAX i skaczemy do ret
	jmp koniec
c_wieksza_b: ; liczba c w EAX
	cmp eax, [ebp+12] ; por�wnanie liczb b i c
	jge koniec ; skok gdy c jest najwi�ksza
	mov eax, [ebp+12] ; je�li b jest najwi�ksza to przenosimy j� do EAX i skaczemy do ret
	jmp koniec


a_wieksza:
	mov eax, [ebp+16] ; liczba c w EAX
	cmp eax, [ebp+20] ; por�wnanie liczb c i d
	jge c_wieksza_a ; skok, gdy c >= d

	mov eax, [ebp+20] ; liczba d w EAX
	cmp eax, [ebp+8] ; por�wnanie liczb a i d
	jge koniec ; skok, gdy d jest najwi�ksza
	mov eax, [ebp+8] ; je�li a jest najwi�ksza, to przenosimy j� do EAX i skaczemy do ret
	jmp koniec
c_wieksza_a: ; liczba c w EAX
	cmp eax, [ebp+8] ; por�wnanie liczb a i c
	jge koniec ; skok gdy c jest najwi�ksza
	mov eax, [ebp+8] ; je�li a jest najwi�ksza to przenosimy j� do EAX i skaczemy do ret
	jmp koniec

koniec: 
	pop ebp
	ret ; wracamy (w EAX znajduje si� najwi�ksza liczba)
_szukaj_max ENDP
END