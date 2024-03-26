.386
rozkazy SEGMENT use16
ASSUME CS:rozkazy
;============================================================
; procedura obs�ugi przerwania zegarowego
obsluga_zegara PROC
; przechowanie u�ywanych rejestr�w
push ax
push bx
push es
push di
mov di, offset tekst
mov ax, 0B800h ;adres pami�ci ekranu
mov es, ax
; zmienna 'licznik' zawiera adres bie��cy w pami�ci ekranu
mov bx, cs:licznik
add di, cx
mov al, byte ptr cs:[di]
sub di, cx
mov es:[bx], al ; kod ASCII
add cx, 1
mov byte PTR es:[bx+1], 01110000B ; kolor
; zwi�kszenie o 2 adresu bie��cego w pami�ci ekranu
add bx,2
; sprawdzenie czy adres bie��cy osi�gn�� koniec pami�ci ekranu
cmp bx,4000
jb wysw_dalej ; skok gdy nie koniec ekranu
; wyzerowanie adresu bie��cego, gdy ca�y ekran zapisany
mov bx, 0
;zapisanie adresu bie��cego do zmiennej 'licznik'
wysw_dalej:
mov cs:licznik,bx
; odtworzenie rejestr�w
pop di
pop es
pop bx
pop ax
; skok do oryginalnej procedury obs�ugi przerwania zegarowego
jmp dword PTR cs:wektor8
licznik dw 0
wektor8 dd ?
tekst db 'Kura sie wypierdala  '
obsluga_zegara ENDP


zacznij:
mov al, 0
mov ah, 5
int 10
mov ax, 0
mov cx, 0
mov ds,ax ;
mov eax,ds:[32] ; adres fizyczny 0*16 + 32 = 32
mov cs:wektor8, eax
mov ax, SEG obsluga_zegara ; cz�� segmentowa adresu
mov bx, OFFSET obsluga_zegara ; offset adresu
cli ; zablokowanie przerwa�
mov ds:[32], bx ; OFFSET
mov ds:[34], ax ; cz. segmentowa
sti ;odblokowanie przerwa�
aktywne_oczekiwanie:
mov ah,1
cmp cx, 21
jnz etk
xor cx, cx
etk: 
int 16H
jz aktywne_oczekiwanie
mov ah, 0
int 16H
cmp al, 'x' ; por�wnanie z kodem litery 'x'
jne aktywne_oczekiwanie
mov eax, cs:wektor8
cli
mov ds:[32], eax
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