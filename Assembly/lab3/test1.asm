	; wypisywanie liczby dwunastkowej z eax na ekran konsoli
.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC
extern __read : PROC
public _main
.data
	obszar db 12 dup (?)
	dziesiec dd 10 ; mno¿nik
	dwanascie dd 12 ; dzielna
	znaki db 18 dup (?)
	db 10 ; znak nowego wiersza
	dekoder db '0123456789AB'
.code


wczytaj_do_EAX PROC

	push ebx
	push ecx
	push edx
	push edi
	push esi
	push ebp
	; max iloœæ znaków wczytywanej liczby
	push dword PTR 12
	push dword PTR OFFSET obszar ; adres obszaru pamiêci
	push dword PTR 0; numer urz¹dzenia (0 dla klawiatury)
	call __read ; odczytywanie znaków z klawiatury
	; (dwa znaki podkreœlenia przed read)
	add esp, 12 ; usuniêcie parametrów ze stosu
	; bie¿¹ca wartoœæ przekszta³canej liczby przechowywana jest
	; w rejestrze EAX; przyjmujemy 0 jako wartoœæ pocz¹tkow¹
	mov eax, 0
	mov ebx, OFFSET obszar ; adres obszaru ze znakami
pobieraj_znaki:
	mov cl, [ebx] ; pobranie kolejnej cyfry w kodzie ASCII
	inc ebx ; zwiêkszenie indeksu
	cmp cl,10 ; sprawdzenie czy naciœniêto Enter
	je byl_enter ; skok, gdy naciœniêto Enter
	sub cl, 30H ; zamiana kodu ASCII na wartoœæ cyfry
	movzx ecx, cl ; przechowanie wartoœci cyfry w rejestrze ECX
	; mno¿enie wczeœniej obliczonej wartoœci razy 10
	mul dword PTR dziesiec
	add eax, ecx ; dodanie ostatnio odczytanej cyfry
	jmp pobieraj_znaki ; skok na pocz¹tek pêtli
byl_enter:
	; wartoœæ binarna wprowadzonej liczby znajduje siê teraz w rejestrze EAX
	pop ebp
	pop esi
	pop edi
	pop edx
	pop ecx
	pop ebx
	ret
wczytaj_do_EAX ENDP

wyswietl_EAX_12 PROC
	push ebx
	push ecx
	push edx
	push esi
	push edi
	push ebp
	mov esi, 18
	mov cl, 3
kolejna_cyfra:
	cmp cl,0 ; sprawdzamy czy pora wstawiæ spacje ¿eby oddzieliæ co xow¹ cyfrê
	jne nie_wstawiamy_spacji
	mov znaki[esi-1], ' '
	dec esi
	mov cl, 3
	jmp kolejna_cyfra
nie_wstawiamy_spacji:
	xor edx, edx ; zerowanie rejestru z reszt¹ z dzielenia
	div dword ptr dwanascie
	cmp edx, 10 ; sprawdzamy czy reszta z dzielenia bêdzie liczb¹ czy liter¹ a lub b
	je dodajA ; kolejny znak to A
	ja dodajB ; kolejny znak to B
	add dl, '0' ; kolejny znak to liczba ( dodajemy wartoœæ liczbow¹ 0 zeby uzyskac liczbe w kodzie ascii)
	jmp dodawanie_znaku
dodajA:
	mov dl, 'A'
	jmp dodawanie_znaku
dodajB:
	mov dl, 'B'

dodawanie_znaku:
	mov znaki[esi-1], dl
	cmp eax, 0
	je koniec_liczby
	dec esi
	dec cl
	cmp esi, 0
	jne kolejna_cyfra

koniec_liczby:
	push dword PTR 19 ; liczba wyœwietlanych znaków
	push dword PTR OFFSET znaki ; adres wyœw. obszaru
	push dword PTR 1; numer urz¹dzenia (ekran ma numer 1)
	call __write ; wyœwietlenie liczby na ekranie
	add esp, 12

	pop ebp
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	ret
wyswietl_EAX_12 ENDP
; main
_main PROC
	
	call wczytaj_do_EAX
	call wyswietl_EAX_12
	push dword PTR 0 ; kod powrotu programu
	call _ExitProcess@4
_main ENDP
END