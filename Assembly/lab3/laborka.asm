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
	dekoder db '0123456789ABCDEF'
	czyKoniecZer db 0
.code

_putst proc
	push esi
	mov esi, [esp + 8]
	pusha
	; wy�wietlenie cyfr na ekranie
	push dword PTR 11 ; liczba wy�wietlanych znak�w
	push dword PTR esi ; adres wy�w. obszaru
	push dword PTR 1; numer urz�dzenia (ekran ma numer 1)
	call __write ; wy�wietlenie liczby na ekranie
	add esp, 12 ; usuni�cie parametr�w ze stosu
	; zako�czenie wykonywania programu
	popa
	pop esi
	ret
_putst endp

wyswietl_EAX PROC
	push ebx
	mov ebx, [esp + 4]
	add dword ptr [esp + 4], 8
	pusha
	mov eax, [ebx]
	add eax, [ebx + 4]
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
	lea eax, znaki
	push eax
	call _putst
	pop eax
	popa
	pop ebx
	ret
wyswietl_EAX ENDP

; main
_main PROC

	call wyswietl_EAX
	dd 123456789
	dd 1
	mov edx, 17
	;mov dl, znaki[ebx]
	push dword PTR 0 ; kod powrotu programu
	call _ExitProcess@4
_main ENDP
END