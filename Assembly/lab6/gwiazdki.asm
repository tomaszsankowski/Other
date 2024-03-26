
.386
rozkazy SEGMENT use16
ASSUME CS:rozkazy


obsluga_klawiatury PROC
; przechowanie u�ywanych rejestr�w
push ax
push bx
push es
push dx
cmp cs:konieczek, 1
jnz nie_konczymy
in al, 60h
cmp al, 128
jb nie_konczymy
mov byte ptr cs:koniec_koncow, 1
nie_konczymy:
cmp cs:indeks, 5
jz pelen_bufor
in al, 60h
cmp al, 128
jae pelen_bufor

mov bx, offset tablica
mov ah, 0
add bx, ax
mov al, cs:[bx]

mov cl, cs:indeks
inc cs:indeks
mov bx, offset buforek
mov ch, 0
add bx, cx
mov cs:[bx], al
pelen_bufor:
pop dx
pop es
pop bx
pop ax
; skok do oryginalnej procedury obs�ugi przerwania klawiatury
jmp dword PTR cs:wektor9
tablica db "..1234567890....qwertyuiop....asdfghjkl.....zxcvbnm"
wektor9 dd ?
indeks db 0
buforek db '00000'
koniec_koncow db 0
obsluga_klawiatury ENDP
;============================================================
; procedura obs�ugi przerwania zegarowego
obsluga_zegara PROC
; przechowanie u�ywanych rejestr�w
push ax
push bx
push es
push fs
push dx
cmp cs:kanter, 0
jnz dalej
mov cs:konieczek, 1
cmp word ptr cs:licznik, 200
jb nie_koniec

nie_koniec:
mov ax, 0B800h ;adres pami�ci ekranu
mov es, ax
; zmienna 'licznik' zawiera adres bie��cy w pami�ci ekranu
mov cl, 5
mov dx, offset buforek
ptl:
mov bx, dx
mov al, cs:[bx]
mov bx, cs:licznik
add cs:licznik, 2
mov byte PTR es:[bx],al
mov byte PTR es:[bx+1], 00000111b
inc dx
loop ptl
jmp konieccccc
dalej:
dec cs:kanter
konieccccc:
; odtworzenie rejestr�w
pop dx
pop fs
pop es
pop bx
pop ax
; skok do oryginalnej procedury obs�ugi przerwania zegarowego
jmp dword PTR cs:wektor8
; dane programu ze wzgl�du na specyfik� obs�ugi przerwa�
; umieszczone s� w segmencie kodu
licznik dw 0 ; wy�wietlanie pocz�wszy od 2. wiersza
wektor8 dd ?
kanter db 18*5
konieczek dw 0
obsluga_zegara ENDP
;============================================================
; program g��wny - instalacja i deinstalacja procedury
; obs�ugi przerwa�
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

mov ax, SEG obsluga_zegara ; cz�� segmentowa adresu
mov bx, OFFSET obsluga_zegara ; offset adresu
mov cx, SEG obsluga_klawiatury ; cz�� segmentowa adresu
mov dx, OFFSET obsluga_klawiatury ; offset adresu
cli ; zablokowanie przerwa�
; zapisanie adresu procedury do wektora nr 8
mov ds:[32], bx ; OFFSET
mov ds:[34], ax ; cz. segmentowa
mov ds:[36], dx ; cz. segmentowa
mov ds:[38], cx ; cz. segmentowa


sti ;odblokowanie przerwa�
; oczekiwanie na naci�ni�cie klawisza 'x'
;czek:
;mov cx, cs:konieczek
;cmp cx, 1
;jne czek ; skok, gdy inny znak

czekaj:
mov al, cs:koniec_koncow
cmp al, 1
jnz czekaj
; deinstalacja procedury obs�ugi przerwania zegarowego
; odtworzenie oryginalnej zawarto�ci wektora nr 8
mov eax, cs:wektor8
mov ebx, cs:wektor9
cli
mov ds:[32], eax ; przes�anie warto�ci oryginalnej
mov ds:[36], ebx ; przes�anie warto�ci oryginalnej
; do wektora 8 w tablicy wektor�w
; przerwa�
sti
; zako�czenie programu
mov al, 0
mov ah, 4CH
int 21H
rozkazy ENDS
nasz_stos SEGMENT stack
	db 128 dup (?)
nasz_stos ENDS
END zacznij
