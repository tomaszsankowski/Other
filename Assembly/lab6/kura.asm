.386
rozkazy SEGMENT use16
ASSUME CS:rozkazy
;============================================================
; procedura obs³ugi przerwania zegarowego
obsluga_zegara PROC
; przechowanie u¿ywanych rejestrów
push ax
push bx
push es
push di
mov di, offset tekst
mov ax, 0B800h ;adres pamiêci ekranu
mov es, ax
; zmienna 'licznik' zawiera adres bie¿¹cy w pamiêci ekranu
mov bx, cs:licznik
add di, cx
mov al, byte ptr cs:[di]
sub di, cx
mov es:[bx], al ; kod ASCII
add cx, 1
mov byte PTR es:[bx+1], 01110000B ; kolor
; zwiêkszenie o 2 adresu bie¿¹cego w pamiêci ekranu
add bx,2
; sprawdzenie czy adres bie¿¹cy osi¹gn¹³ koniec pamiêci ekranu
cmp bx,4000
jb wysw_dalej ; skok gdy nie koniec ekranu
; wyzerowanie adresu bie¿¹cego, gdy ca³y ekran zapisany
mov bx, 0
;zapisanie adresu bie¿¹cego do zmiennej 'licznik'
wysw_dalej:
mov cs:licznik,bx
; odtworzenie rejestrów
pop di
pop es
pop bx
pop ax
; skok do oryginalnej procedury obs³ugi przerwania zegarowego
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
mov ax, SEG obsluga_zegara ; czêœæ segmentowa adresu
mov bx, OFFSET obsluga_zegara ; offset adresu
cli ; zablokowanie przerwañ
mov ds:[32], bx ; OFFSET
mov ds:[34], ax ; cz. segmentowa
sti ;odblokowanie przerwañ
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
cmp al, 'x' ; porównanie z kodem litery 'x'
jne aktywne_oczekiwanie
mov eax, cs:wektor8
cli
mov ds:[32], eax
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