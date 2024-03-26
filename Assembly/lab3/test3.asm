	; wczytywanie liczby dziesiêtnej z klawiatury – po
	; wprowadzeniu cyfr nale¿y nacisn¹æ klawisz Enter
	; liczba po konwersji na postaæ binarn¹ zostaje wpisana
	; do rejestru EAX
.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC
extern __read : PROC
public _main
.data
	; deklaracja tablicy do przechowywania wprowadzanych cyfr
	; (w obszarze danych)
	dwadziescia dd 20
	dziesiec dd 10
	wynik db 8 dup (?)
	db 0Ah
.code
	
wczytaj_do_eax_20 proc
	push ebx
	push ecx
	push edx
	push esi
	push edi
	push ebp

	sub esp, 4 ; rezerwacja poprzez zmniejszenie ESP
	mov esi, esp ; adres zarezerwowanego obszaru pamiêci
	push dword PTR 4 ; max iloœæ znaków wczytyw. liczby
	push esi ; adres obszaru pamiêci
	push dword PTR 0; numer urz¹dzenia (0 dla klawiatury)
	call __read ; odczytywanie znaków z klawiatury
	; (dwa znaki podkreœlenia przed read)
	add esp, 12 ; usuniêcie parametrów ze stosu
	
; zamiana liczby w formacie tekstowym na cyfre dziesiêtn¹ w eax

	mov eax, 0
	mov edx, 0

kolejny_znak:
	mov dl, [esi] ; w rejestrze edx jest kod ascii liczby w systemie dwudziestkowym
	inc esi
	cmp dl, 10 ; sprawdzamy czy wczytany znak nie jest znakiem nowej linii
	je koniec_wczytywania
	cmp dl, 'A'
	jb nie_znak_duzy
	cmp dl, 'J'
	ja nie_znak_duzy
	; pobralismy znak duzy
	sub dl, 'A'
	add dl, 10
	jmp mamy_cyfre
nie_znak_duzy:
	cmp dl, 'a'
	jb nie_znak_maly
	cmp dl, 'j'
	jb nie_znak_maly
	; pobralismy znak maly
	sub dl, 'a'
	add dl, 10
	jmp mamy_cyfre
nie_znak_maly:
	; pobralismy liczbe
	sub dl, '0'
	
mamy_cyfre: ; w edx mamy ju¿ licbê wynikaj¹c¹ ze znaku w kodzie dwudziestkowym, np. 11 dla B
	push edx
	mul dwadziescia
	pop edx
	add eax, edx
	jmp kolejny_znak

koniec_wczytywania:
	add esp,4
	pop ebp
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	ret
wczytaj_do_eax_20 endp


_main PROC
	call wczytaj_do_eax_20
	mov ebx, eax ; przenosimy pierwsz¹ liczbê do ebc
	call wczytaj_do_eax_20

	; eax -> druga liczba     ebx -> pierwsza liczba
	xchg eax, ebx
	xor edx, edx
	; eax -> pierwsza liczba     ebx -> druga liczba
	div ebx
	push edx
	mov esi,3
konwersja:
	mov edx, 0
	div dword ptr dziesiec
	add dl, '0' ; w dl mamy kod ascii liczby
	mov wynik[esi], dl
	dec esi
	cmp eax, 0
	jne konwersja
wypeln:
	cmp esi, 0
	jl mamy_calkowita
	mov wynik[esi], ' '
	dec esi
	jmp wypeln
mamy_calkowita:
	pop edx
	; teraz dodajemy do tekstu nasza czesc dziesietna
	mov wynik[4], ','

	mov ecx,3
	mov esi,5

kolejny_ulamek:
	mov eax, edx
	mul dword ptr dziesiec ; eax * 10
	div ebx
	add al, '0'
	mov wynik[esi],al
	inc esi
	loop kolejny_ulamek
	; w edi mamy na przyk³ad 1 ( dla mianownika 5)
	; jak zamieniæ to na 0,05?


	; wypisanie liczby z przecinkiem
	push dword PTR 8 ; liczba wyœwietlanych znaków
	push dword PTR OFFSET wynik ; adres wyœw. obszaru
	push dword PTR 1; numer urz¹dzenia (ekran ma numer 1)
	call __write ; wyœwietlenie liczby na ekranie
	add esp, 12 ; usuniêcie parametrów ze stosu
	push dword PTR 0 ; kod powrotu programu
	call _ExitProcess@4
_main ENDP
END