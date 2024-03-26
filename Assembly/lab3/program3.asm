	; wczytywanie liczby dziesi�tnej z klawiatury � po
	; wprowadzeniu cyfr nale�y nacisn�� klawisz Enter
	; liczba po konwersji na posta� binarn� zostaje wpisana
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
	znaki db 10 dup (?)
	db 0Ah
	obszar db 12 dup (?)
	dziesiec dd 10 ; mno�nik
.code

; funkcja
wyswietl_EAX PROC
	pusha
	mov esi, 9 ; indeks w tablicy 'znaki'
	mov ebx, 10 ; dzielnik r�wny 10
	konwersja:
	mov edx, 0 ; zerowanie starszej cz�ci dzielnej
	div ebx ; dzielenie przez 10, reszta w EDX,
	; iloraz w EAX
	add dl, 30H ; zamiana reszty z dzielenia na kod
	; ASCII
	mov znaki [esi], dl; zapisanie cyfry w kodzie ASCII
	dec esi ; zmniejszenie indeksu
	cmp eax, 0 ; sprawdzenie czy iloraz = 0
	jne konwersja ; skok, gdy iloraz niezerowy
	; wype�nienie pozosta�ych bajt�w spacjami i wpisanie
	; znak�w nowego wiersza
	wypeln:
	cmp esi,0
	jl wyswietl ; skok, gdy ESI < 0
	mov byte PTR znaki [esi], 20H ; kod spacji
	dec esi ; zmniejszenie indeksu
	jmp wypeln
	wyswietl:
	; wy�wietlenie cyfr na ekranie
	push dword PTR 11 ; liczba wy�wietlanych znak�w
	push dword PTR OFFSET znaki ; adres wy�w. obszaru
	push dword PTR 1; numer urz�dzenia (ekran ma numer 1)
	call __write ; wy�wietlenie liczby na ekranie
	add esp, 12 ; usuni�cie parametr�w ze stosu
	; zako�czenie wykonywania programu
	popa
	ret
wyswietl_EAX ENDP

wczytaj_do_EAX PROC

	push ebx
	push ecx
	push edx
	push edi
	push esi
	push ebp
	; max ilo�� znak�w wczytywanej liczby
	push dword PTR 12
	push dword PTR OFFSET obszar ; adres obszaru pami�ci
	push dword PTR 0; numer urz�dzenia (0 dla klawiatury)
	call __read ; odczytywanie znak�w z klawiatury
	; (dwa znaki podkre�lenia przed read)
	add esp, 12 ; usuni�cie parametr�w ze stosu
	; bie��ca warto�� przekszta�canej liczby przechowywana jest
	; w rejestrze EAX; przyjmujemy 0 jako warto�� pocz�tkow�
	mov eax, 0
	mov ebx, OFFSET obszar ; adres obszaru ze znakami
pobieraj_znaki:
	mov cl, [ebx] ; pobranie kolejnej cyfry w kodzie
	; ASCII
	inc ebx ; zwi�kszenie indeksu
	cmp cl,10 ; sprawdzenie czy naci�ni�to Enter
	je byl_enter ; skok, gdy naci�ni�to Enter
	sub cl, 30H ; zamiana kodu ASCII na warto�� cyfry
	movzx ecx, cl ; przechowanie warto�ci cyfry w rejestrze ECX
	; mno�enie wcze�niej obliczonej warto�ci razy 10
	mul dword PTR dziesiec
	add eax, ecx ; dodanie ostatnio odczytanej cyfry
	jmp pobieraj_znaki ; skok na pocz�tek p�tli
byl_enter:
	; warto�� binarna wprowadzonej liczby znajduje si� teraz w rejestrze EAX
	pop ebp
	pop esi
	pop edi
	pop edx
	pop ecx
	pop ebx
	ret
wczytaj_do_EAX ENDP

; main
_main PROC
	call wczytaj_do_EAX
	mul eax
	call wyswietl_EAX
	push dword PTR 0 ; kod powrotu programu
	call _ExitProcess@4
_main ENDP
END