	; wypisywanie liczby dwunastkowej z eax na ekran konsoli
.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC
extern __read : PROC
public _main
.data
	dziesiec dd 10 ; mno¿nik
	dwanascie dd 12 ; mno¿nik
	bufor db 12 dup (?) ; bufor na znaki
	db 10 ; znak nowego wiersza
	wyjscie db 18 dup (?) ; bufor na wyjscie
	db 10 ; znak nowego wiersza
	dekoder db '0123456789AB'
	zlaLiczba db 0 ; flaga
	czyOdjac db 1 ; flaga
.code

wyswietl_EAX_12 PROC
	pusha

	; wyswietlamie liczby w eax w systemie dwunastkowym

	mov esi, 18 ; ilosc znakow w buforze wyjsciowym
kolejna_litera:
	cmp esi, 0
	je koniec_petli ; petle konczymy jak skoncza nam sie znaki, lub bedziemy mieli juz cala liczbe
	cmp eax, 0
	je koniec_petli
	dec esi

	xor edx, edx ; edx = 0
	div dword ptr dwanascie ; dzielimy eax na 12, teraz reszta jest w edx a wynik w eax
	
	;wpisanie nowego znaku
	cmp dl, 11
	je dodajB
	cmp dl, 10
	je dodajA
	
	add dl, '0' ; zamiana liczby w edx na licze w kodzie ascii
	mov wyjscie[esi], dl
	jmp kolejna_litera
dodajA:
	mov wyjscie[esi], 'A'
	jmp kolejna_litera
dodajB:
	mov wyjscie[esi], 'B'
	jmp kolejna_litera

koniec_petli:

	push dword PTR 19 ; liczba wyœwietlanych znaków
	push dword PTR OFFSET wyjscie ; adres wyœw. obszaru
	push dword PTR 1; numer urz¹dzenia (ekran ma numer 1)
	call __write ; wyœwietlenie liczby na ekranie
	add esp, 12 ; usuniêcie parametrów ze stosu
	popa
	ret
wyswietl_EAX_12 ENDP

wczytaj_EAX_12 PROC
	push ebx
	push ecx
	push edx
	push esi
	push edi
	push ebp

	push dword PTR 12
	push dword PTR OFFSET bufor ; adres obszaru pamiêci
	push dword PTR 0; numer urz¹dzenia (0 dla klawiatury)
	call __read ; odczytywanie znaków z klawiatury
	; (dwa znaki podkreœlenia przed read)
	add esp, 12 ; usuniêcie parametrów ze stosu
	; w polu obszar mamy nasza liczbe w systemie dwunastkowym

	xor esi, esi ; esi = 0
	xor eax, eax ; eax = 0
	xor ecx, ecx ; ecx = 0

nowy_znak:
	mov cl, bufor[esi]
	cmp cl, 10 ; sprawdza czy enter
	je koniec
	inc esi
	cmp cl, 'A'
	je znakA
	cmp cl, 'B'
	je znakB
	cmp cl, 'a'
	je znakA
	cmp cl, 'b'
	je znakB
	cmp cl, '0'
	jb nieliczba
	cmp cl, '9'
	ja nieliczba

	; jest to liczbaW
	sub cl, '0'
	jmp koncowka

znakB:
	mov cl, 11
	jmp koncowka

znakA:
	mov cl, 10
	jmp koncowka

nieliczba:
	mov zlaliczba, 1 ; flaga ze wczytana zla liczbe
	jmp koniec

koncowka:
	mul dword ptr dwanascie
	add eax, ecx
	cmp esi, 12
	je koniec
	jmp nowy_znak

koniec:
	pop ebp
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	ret
wczytaj_EAX_12 ENDP



; main
_main PROC
	
	call wczytaj_EAX_12
	cmp zlaliczba, 1
	je koniec_programu
	mov ecx, eax
	call wczytaj_EAX_12
	cmp zlaliczba, 1
	je koniec_programu

	; pierwsza liczba w ecx a druga w eax
	; ecx = n           eax = p

	; ecx jest iteratorem
	xor esi, esi ; esi = 0
kolejna_liczba:
	call wyswietl_EAX_12
	inc esi
	dec ecx
	cmp ecx, 0 ; sprawdzamy, czy wypisalismy juz n kolejnych liczb w ciagu
	je koniec_programu
	cmp czyOdjac, 1 ; sprawdzamy czy mamy odjac czy dodac
	je odjac

	; dodawanie esi
	add eax, esi
	mov czyOdjac, 1
	jmp kolejna_liczba

	;odejmowanie esi
odjac:
	sub eax, esi
	mov czyOdjac, 0
	jmp kolejna_liczba
	
koniec_programu:
	push dword PTR 0 ; kod powrotu programu
	call _ExitProcess@4
_main ENDP
END