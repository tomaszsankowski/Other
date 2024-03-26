; wczytywanie i wyúwietlanie tekstu wielkimi literami
; (inne znaki siÍ nie zmieniajπ)
.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkreúlenia)
extern __read : PROC ; (dwa znaki podkreúlenia)
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
	; wyúwietlenie tekstu informacyjnego
	; liczba znakÛw tekstu
	mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz)
	push ecx
	push OFFSET tekst_pocz ; adres tekstu
	push 1 ; nr urzπdzenia (tu: ekran - nr 1)
	call __write ; wyúwietlenie tekstu poczπtkowego
	add esp, 12 ; usuniecie parametrÛw ze stosu
	; czytanie wiersza z klawiatury
	push 80 ; maksymalna liczba znakÛw
	push OFFSET magazyn
	push 0 ; nr urzπdzenia (tu: klawiatura - nr 0)
	call __read ; czytanie znakÛw z klawiatury
	add esp, 12 ; usuniecie parametrÛw ze stosu
	; kody ASCII napisanego tekstu zosta≥y wprowadzone
	; do obszaru 'magazyn'
	; funkcja read wpisuje do rejestru EAX liczbÍ
	; wprowadzonych znakÛw
	mov liczba_znakow, eax
	; rejestr ECX pe≥ni rolÍ licznika obiegÛw pÍtli
	mov ecx, eax
	mov ebx, 0 ; indeks poczπtkowy
ptl: 
	mov dl, magazyn[ebx] ; pobranie kolejnego znaku
	;ZAMIANA POLSKICH ZNAK”W
	cmp dl, 165;π
	jnz daleja
	mov dl, 164;•
	mov magazyn[ebx], dl
	jp dalej
daleja:

	cmp dl, 134;Ê
	jnz dalejc
	mov dl, 143;∆
	mov magazyn[ebx], dl
	jp dalej

dalejc:
	cmp dl, 169;Í
	jnz daleje
	mov dl, 168; 
	mov magazyn[ebx], dl
	jp dalej

daleje:
	cmp dl, 136;≥
	jnz dalejl
	mov dl, 157;£
	mov magazyn[ebx], dl
	jp dalej

dalejl:
	cmp dl, 228;Ò
	jnz dalejn
	mov dl, 227;—
	mov magazyn[ebx], dl
	jp dalej

dalejn:
	cmp dl, 162;Û
	jnz dalejo
	mov dl, 224;”
	mov magazyn[ebx], dl
	jp dalej

dalejo:
	cmp dl, 152;ú
	jnz dalejs
	mov dl, 151;å
	mov magazyn[ebx], dl
	jp dalej

dalejs:
	cmp dl, 171;ü
	jnz dalejx
	mov dl, 141;è
	mov magazyn[ebx], dl
	jp dalej

dalejx:
	cmp dl, 190;ø
	jnz dalejz
	mov dl, 189;Ø
	mov magazyn[ebx], dl
	jp dalej
dalejz:

	cmp dl, 'a'
	jb dalej ; skok, gdy znak nie wymaga zamiany
	cmp dl, 'z'
	ja dalej ; skok, gdy znak nie wymaga zamiany
	sub dl, 20H ; zamiana na wielkie litery
	; odes≥anie znaku do pamiÍci
	mov magazyn[ebx], dl
dalej: 
	inc ebx ; inkrementacja indeksu
	dec ecx
	jnz ptl; sterowanie pÍtlπ
	; wyúwietlenie przekszta≥conego tekstu
	push liczba_znakow
	push OFFSET magazyn
	push 1
	call __write ; wyúwietlenie przekszta≥conego tekstu
	add esp, 12 ; usuniecie parametrÛw ze stosu
	push 0
	call _ExitProcess@4 ; zakoÒczenie programu
_main ENDP
END