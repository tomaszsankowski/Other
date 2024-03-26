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

;funkcja wypisuj¹ca kolejn¹ liczbê ci¹gu 1,2,4,7,11,16,22,...
wyswietl_EAX PROC
	pusha
	mov esi, 9 ; indeks w tablicy 'znaki'
	mov ebx, 10 ; dzielnik równy 10
	konwersja:
	mov edx, 0 ; zerowanie starszej czêœci dzielnej
	div ebx ; dzielenie przez 10, reszta w EDX,
	; iloraz w EAX
	add dl, 30H ; zamiana reszty z dzielenia na kod
	; ASCII
	mov znaki [esi], dl; zapisanie cyfry w kodzie ASCII
	dec esi ; zmniejszenie indeksu
	cmp eax, 0 ; sprawdzenie czy iloraz = 0
	jne konwersja ; skok, gdy iloraz niezerowy
	; wype³nienie pozosta³ych bajtów spacjami i wpisanie
	; znaków nowego wiersza
	wypeln:
	cmp esi,0
	jl wyswietl ; skok, gdy ESI < 0
	mov byte PTR znaki [esi], 20H ; kod spacji
	dec esi ; zmniejszenie indeksu
	jmp wypeln
	wyswietl:
	; wyœwietlenie cyfr na ekranie
	push dword PTR 12 ; liczba wyœwietlanych znaków
	push dword PTR OFFSET znaki ; adres wyœw. obszaru
	push dword PTR 1; numer urz¹dzenia (ekran ma numer 1)
	call __write ; wyœwietlenie liczby na ekranie
	add esp, 12 ; usuniêcie parametrów ze stosu
	; zakoñczenie wykonywania programu
	popa
	ret
wyswietl_EAX ENDP

_main PROC
	mov eax,1
	mov ecx,1
ciag_powiekszalny:
	call wyswietl_eax ; wyœwietl kolejn¹ liczbê ci¹gu
	add eax, ecx ; dodaj aktualny indeks aby uzyskaæ kolejny wyraz ci¹gu
	inc ecx ; zwiêksz indeks o 1
	cmp ecx,50
	jbe ciag_powiekszalny ; sprawdz czy przeprowadzilismy to juz 50 razy

	push dword PTR 0 ; kod powrotu programu
	call _ExitProcess@4
_main ENDP
END