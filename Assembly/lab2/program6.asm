; wczytywanie i wyúwietlanie tekstu wielkimi literami
; (inne znaki siÍ nie zmieniajπ)
.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkreúlenia)
extern __read : PROC ; (dwa znaki podkreúlenia)
extern _MessageBoxA@16 : PROC
public _main
.data
tekst_pocz db 10, 'Prosz',169,' napisa',134,' jaki',152,' tekst '
	db 'i nacisn',165,134,' Enter', 10
koniec_t db ?
magazyn db 80 dup (?)
nowa_linia db 10
magazyn2 db 200 dup (?)
nowa_linia2 db 10
liczba_znakow dd ?
tytul db 'Znaki napisane du',191,'ymi literami',0
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
	mov esi, 0
	mov edi, 0
ptl: 
	mov dl, magazyn[ebx] ; pobranie kolejnego znaku
	;ZAMIANA POLSKICH ZNAK”W
	cmp dl, 165;π
	jnz daleja
	mov dl, 165;•
	jp dalej
daleja:

	cmp dl, 134;Ê
	jnz dalejc
	mov dl, 198;∆
	jp dalej

dalejc:
	cmp dl, 169;Í
	jnz daleje
	mov dl, 202; 
	jp dalej

daleje:
	cmp dl, 136;≥
	jnz dalejl
	mov dl, 163;£
	jp dalej

dalejl:
	cmp dl, 228;Ò
	jnz dalejn
	mov dl, 209;—
	jp dalej

dalejn:
	cmp dl, 162;Û
	jnz dalejo
	mov dl, 211;”
	jp dalej

dalejo:
	cmp dl, 152;ú
	jnz dalejs
	mov dl, 140;å
	jp dalej

dalejs:
	cmp dl, 171;ü
	jnz dalejx
	mov dl, 143;è
	jp dalej

dalejx:
	cmp dl, 190;ø
	jnz dalejz
	mov dl, 175;Ø
	jp dalej
dalejz:

	cmp dl, '\';czy znak jest slashem
	jne nieslash
	dec eax
	cmp edi, 0;czy znak jest kolejnym slashem z kolei
	jne dalejkolejnyslash
minusznak:
	mov DWORD PTR magazyn2[esi], '    '
	add esi,3
	mov edi, 1
	add eax, 4
	jmp dalejslash
nieslash:
	cmp dl, 'a'
	jb dalej ; skok, gdy znak nie wymaga zamiany
	cmp dl, 'z'
	ja dalej ; skok, gdy znak nie wymaga zamiany
	sub dl, 20H ; zamiana na wielkie litery
	; odes≥anie znaku do pamiÍci
dalej: 
	mov magazyn2[esi], dl
	mov edi, 0
dalejslash:
	inc esi
dalejkolejnyslash:
	inc ebx ; inkrementacja indeksu
	dec ecx
	jnz ptl; sterowanie pÍtlπ
	; wyúwietlenie przekszta≥conego tekstu w MessageBox
	push eax
	push OFFSET magazyn2
	push 1
	call __write
	add esp, 12
	push 0
	call _ExitProcess@4 ; zakoÒczenie programu
_main ENDP
END