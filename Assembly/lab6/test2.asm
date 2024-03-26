.386
rozkazy SEGMENT use16
ASSUME CS:rozkazy
obsluga_zegara PROC
	; przechowanie u¿ywanych rejestrów
	push ax
	push bx
	push cx
	push es


	; end if koniec
	mov cx, cs:koniec
	cmp cx, 1
	je finish

	; timer start
	mov cx, cs:timer
	or cx, cx
	jz cont
	dec cx
	mov cs:timer, cx
	jmp finish
cont:
	; timer end
	mov ax, 1
	mov cs:wczytano, ax

	
	mov ax, 0B800h ;adres pamiêci ekranu
	mov es, ax
	mov bx, cs:licznik
	mov cx, 5
	mov si ,0

	; draw loop
ptl3:
	mov al, byte ptr cs:bufor[si]
	mov byte PTR es:[bx], al ; kod ASCII
	mov byte PTR es:[bx+1], 00000111B ; kolor
	add bx,2
	cmp bx,4000
	jb ignore
	mov bx, 0
ignore:
	inc si
	dec cx
	jnz ptl3


wysw_dalej:
	mov cs:licznik,bx
finish:
	; odtworzenie rejestrów
	pop es
	pop cx
	pop bx
	pop ax
	; skok do oryginalnej procedury obs³ugi przerwania zegarowego
	jmp dword PTR cs:wektor8
	; dane programu ze wzglêdu na specyfikê obs³ugi przerwañ
	; umieszczone s¹ w segmencie kodu
	licznik dw 0 ; wyœwietlanie pocz¹wszy od 2. wiersza
	counter dw 27 ; 26 gwiazdek + 1
	maxtimer dw 18*5
	timer dw 18*5
	wczytano dw 0
	koniec dw 0
	wektor8 dd ?
	wektor9 dd ?
obsluga_zegara ENDP


obsluga_klaw proc
	push ax
	push bx
	push cx
	push es


	mov ax, cs:wczytano
	cmp ax, 1
	je afterwczyt

	mov ax, cs:cur_char
	cmp ax, 5
	jae ending

	in al, 60h
	; scancode '1' = 2
	; scancode 'm' = 50
	cmp al, 2
	jb ending
	cmp al, 50
	ja ending
	xor ah,ah
	sub al, 2 ; align with tablica[]
	mov bx, ax
	mov cl, byte ptr cs:tablica[bx] ; get char
	cmp cl, '.'
	je ending
	mov bx, cs:cur_char
	mov byte ptr cs:bufor[bx], cl
	inc bx
	mov cs:cur_char, bx
	jmp ending
afterwczyt:
	in al, 60h
	cmp al, 80h
	jae ending
	mov ax, 1
	mov cs:koniec, ax


ending:
	pop es
	pop cx
	pop bx
	pop ax
	; skok do oryginalnej procedury obs³ugi przerwania zegarowego
	jmp dword PTR cs:wektor9
	tablica db "1234567890....qwertyuiop....asdfghjkl.....zxcvbnm"
	bufor db 5 dup ('0')
	cur_char dw 0
obsluga_klaw endp
;============================================================
; program g³ówny - instalacja i deinstalacja procedury
; obs³ugi przerwañ
; ustalenie strony nr 0 dla trybu tekstowego
zacznij:
	mov al, 0
	mov ah, 5
	int 10
	mov ax, 0
	mov ds,ax
	mov eax,ds:[32] 
	mov cs:wektor8, eax
	mov eax, ds:[36]
	mov cs:wektor9, eax

	mov ax, SEG obsluga_zegara ; czêœæ segmentowa adresu
	mov bx, OFFSET obsluga_zegara ; offset adresu
	mov cx, SEG obsluga_klaw ; czêœæ segmentowa adresu
	mov dx, OFFSET obsluga_klaw ; offset adresu
	cli ; zablokowanie przerwañ
	; zapisanie adresu procedury do wektora nr 8
	mov ds:[32], bx ; OFFSET
	mov ds:[34], ax ; cz. segmentowa
	mov ds:[36], dx ; cz. segmentowa
	mov ds:[38], cx ; cz. segmentowa


	sti ;odblokowanie przerwañ
	; oczekiwanie na naciœniêcie klawisza 'x'
ptl:
	mov cx, cs:koniec
	cmp cx, 1
	jne ptl ; skok, gdy inny znak

	; deinstalacja procedury obs³ugi przerwania zegarowego
	; odtworzenie oryginalnej zawartoœci wektora nr 8
	mov eax, cs:wektor8
	mov ebx, cs:wektor9
	cli
	mov ds:[32], eax ; przes³anie wartoœci oryginalnej
	mov ds:[36], ebx ; przes³anie wartoœci oryginalnej
	; do wektora 8 w tablicy wektorów
	; przerwañ
	sti
	; zakoñczenie programu
	mov al, 0
	mov ah, 4CH
	int 21H
rozkazy ENDS
nasz_stos SEGMENT stack
	db 128 dup (?)
nasz_stos ENDS
END zacznij
