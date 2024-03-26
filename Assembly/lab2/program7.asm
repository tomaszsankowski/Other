; wczytywanie i wy�wietlanie tekstu wielkimi literami
; (inne znaki si� nie zmieniaj�)
.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkre�lenia)
extern __read : PROC ; (dwa znaki podkre�lenia)
extern _MessageBoxW@16 : PROC
public _main
.data
tekst_pocz db 10, 'P','r','o','s','z',169,' ','n','a','p','i','s','a',134,' ','j','a','k','i',152,' ','t','e','k','s','t',' '
	db 'i',' ','n','a','c','i','s','n',165,134,' ','E','n','t','e','r', 10
koniec_t db ?
magazyn db 80 dup (?)
nowa_linia db 10
magazyn2 dw 80 dup (?)
nowa_linia2 db 10
liczba_znakow dd ?
tytul dw 'Z','n','a','k','i',' ','n','a','p','i','s','a','n','e',' ','d','u',191,'y','m','i',' ','l','i','t','e','r','a','m','i',0
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
	mov dx, 0104H;�
	mov magazyn2[ebx*2], dx
	jp dalej
daleja:

	cmp dl, 134;�
	jnz dalejc
	mov dx, 0106H;�
	mov magazyn2[ebx*2], dx
	jp dalej

dalejc:
	cmp dl, 169;�
	jnz daleje
	mov dx, 0118H;�
	mov magazyn2[ebx*2], dx
	jp dalej

daleje:
	cmp dl, 136;�
	jnz dalejl
	mov dx, 0141H;�
	mov magazyn2[ebx*2], dx
	jp dalej

dalejl:
	cmp dl, 228;�
	jnz dalejn
	mov dx, 0143H;�
	mov magazyn2[ebx*2], dx
	jp dalej

dalejn:
	cmp dl, 162;�
	jnz dalejo
	mov dx, 00D3H;�
	mov magazyn2[ebx*2], dx
	jp dalej

dalejo:
	cmp dl, 152;�
	jnz dalejs
	mov dx, 015AH;�
	mov magazyn2[ebx*2], dx
	jp dalej

dalejs:
	cmp dl, 171;�
	jnz dalejx
	mov dx, 0179H;�
	mov magazyn2[ebx*2], dx
	jp dalej

dalejx:
	cmp dl, 190;�
	jnz dalejz
	mov dx, 017BH;�
	mov magazyn2[ebx*2], dx
	jp dalej
dalejz:

	cmp dl, 127
	ja dalej
	mov dh, 0
	mov magazyn2[ebx*2], dx
	cmp dl, 'a'
	jb dalej ; skok, gdy znak nie wymaga zamiany
	cmp dl, 'z'
	ja dalej ; skok, gdy znak nie wymaga zamiany
	sub dl, 20H ; zamiana na wielkie litery
	; odes�anie znaku do pami�ci
	mov magazyn2[ebx*2], dx
dalej: 
	inc ebx ; inkrementacja indeksu
	dec ecx
	jnz ptl; sterowanie p�tl�
	; wy�wietlenie przekszta�conego tekstu w MessageBox
	push 0
	push OFFSET tytul
	push OFFSET magazyn2
	push 0
	call _MessageBoxW@16
	add esp, 16
	push 0
	call _ExitProcess@4 ; zako�czenie programu
_main ENDP
END