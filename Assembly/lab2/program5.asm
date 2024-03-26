; wczytywanie i wy�wietlanie tekstu wielkimi literami
; (inne znaki si� nie zmieniaj�)
.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkre�lenia)
extern __read : PROC ; (dwa znaki podkre�lenia)
public _main
.data
tekst_pocz db 10, 'Prosz',169,' napisa',134,' jaki',152,' tekst '
	db 'i nacisn',165,134,' Enter', 10
koniec_t db ?
magazyn db 80 dup (?)
nowa_linia db 10
liczba_znakow dd ?
.code
_main PROC
	; wy�wietlenie tekstu informacyjnego
	; liczba znak�w tekstu
	mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz)
	push ecx
	push OFFSET tekst_pocz ; adres tekstu
	push 1 ; nr urz�dzenia (tu: ekran - nr 1)
	call __write ; wy�wietlenie tekstu pocz�tkowego
	add esp, 12 ; usuniecie parametr�w ze stosu
	; czytanie wiersza z klawiatury
	push 80 ; maksymalna liczba znak�w
	push OFFSET magazyn
	push 0 ; nr urz�dzenia (tu: klawiatura - nr 0)
	call __read ; czytanie znak�w z klawiatury
	add esp, 12 ; usuniecie parametr�w ze stosu
	; kody ASCII napisanego tekstu zosta�y wprowadzone
	; do obszaru 'magazyn'
	; funkcja read wpisuje do rejestru EAX liczb�
	; wprowadzonych znak�w
	mov liczba_znakow, eax
	; rejestr ECX pe�ni rol� licznika obieg�w p�tli
	mov ecx, eax
	mov ebx, 0 ; indeks pocz�tkowy
ptl: 
	mov dl, magazyn[ebx] ; pobranie kolejnego znaku
	;ZAMIANA POLSKICH ZNAK�W
	cmp dl, 165;�
	jnz daleja
	mov dl, 164;�
	mov magazyn[ebx], dl
	jp dalej
daleja:

	cmp dl, 134;�
	jnz dalejc
	mov dl, 143;�
	mov magazyn[ebx], dl
	jp dalej

dalejc:
	cmp dl, 169;�
	jnz daleje
	mov dl, 168;�
	mov magazyn[ebx], dl
	jp dalej

daleje:
	cmp dl, 136;�
	jnz dalejl
	mov dl, 157;�
	mov magazyn[ebx], dl
	jp dalej

dalejl:
	cmp dl, 228;�
	jnz dalejn
	mov dl, 227;�
	mov magazyn[ebx], dl
	jp dalej

dalejn:
	cmp dl, 162;�
	jnz dalejo
	mov dl, 224;�
	mov magazyn[ebx], dl
	jp dalej

dalejo:
	cmp dl, 152;�
	jnz dalejs
	mov dl, 151;�
	mov magazyn[ebx], dl
	jp dalej

dalejs:
	cmp dl, 171;�
	jnz dalejx
	mov dl, 141;�
	mov magazyn[ebx], dl
	jp dalej

dalejx:
	cmp dl, 190;�
	jnz dalejz
	mov dl, 189;�
	mov magazyn[ebx], dl
	jp dalej
dalejz:

	cmp dl, 'a'
	jb dalej ; skok, gdy znak nie wymaga zamiany
	cmp dl, 'z'
	ja dalej ; skok, gdy znak nie wymaga zamiany
	sub dl, 20H ; zamiana na wielkie litery
	; odes�anie znaku do pami�ci
	mov magazyn[ebx], dl
dalej: 
	inc ebx ; inkrementacja indeksu
	dec ecx
	jnz ptl; sterowanie p�tl�
	; wy�wietlenie przekszta�conego tekstu
	push liczba_znakow
	push OFFSET magazyn
	push 1
	call __write ; wy�wietlenie przekszta�conego tekstu
	add esp, 12 ; usuniecie parametr�w ze stosu
	push 0
	call _ExitProcess@4 ; zako�czenie programu
_main ENDP
END