; Przyk�ad wywo�ywania funkcji MessageBoxA i MessageBoxW
.686
.model flat
extern _ExitProcess@4 : PROC
extern _MessageBoxA@16 : PROC
extern _MessageBoxW@16 : PROC
public _main
.data 
tytul_Unicode dw 'Z','n','a','k','i', 0
tekst_Unicode dw 'T','o', ' ', 'j','e','s','t', ' ','r','a','k','i','e','t','a',' '
	;dd 0DE80D83Dh
	dw 0D83Dh, 0DE80h
	dw ' ', 'i',' ','h','e','l','i','k','o','p','t','e','r',' '
	;dd 0DE81D83Dh
	dw 0D83Dh, 0DE81h
	dw '.', 0 
.code
_main PROC
	push 0 ; stala MB_OK
	; adres obszaru zawieraj�cego tytu�
	push OFFSET tytul_Unicode
	; adres obszaru zawieaj�cego tekst
	push OFFSET tekst_Unicode
	push 0 ; NULL
	call _MessageBoxW@16
	push 0 ; kod powrotu programu

	call _ExitProcess@4
_main ENDP
END