.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC
public _main
.data
	; deklaracja tablicy 12-bajtowej do przechowywania
	; tworzonych cyfr
	db 0Ah
	znaki db 10 dup (?)
	db 0Ah
.code

;funkcja wypisuj�ca kolejn� liczb� ci�gu 1,2,4,7,11,16,22,...
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
	push dword PTR 12 ; liczba wy�wietlanych znak�w
	push dword PTR OFFSET znaki ; adres wy�w. obszaru
	push dword PTR 1; numer urz�dzenia (ekran ma numer 1)
	call __write ; wy�wietlenie liczby na ekranie
	add esp, 12 ; usuni�cie parametr�w ze stosu
	; zako�czenie wykonywania programu
	popa
	ret
wyswietl_EAX ENDP

_main PROC
	mov eax,1
	mov ecx,1
ciag_powiekszalny:
	call wyswietl_eax ; wy�wietl kolejn� liczb� ci�gu
	add eax, ecx ; dodaj aktualny indeks aby uzyska� kolejny wyraz ci�gu
	inc ecx ; zwi�ksz indeks o 1
	cmp ecx,50
	jbe ciag_powiekszalny ; sprawdz czy przeprowadzilismy to juz 50 razy

	push dword PTR 0 ; kod powrotu programu
	call _ExitProcess@4
_main ENDP
END