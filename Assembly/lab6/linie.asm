; Program linie.asm
; Uruchomienie w trybie rzeczywistym procesora x86
; lub na maszynie wirtualnej
.386
rozkazy SEGMENT use16
ASSUME cs:rozkazy
linia PROC
; przechowanie rejestrów
push ax
push bx
push es
push dx
mov ax, cs:koniec_malowanie
cmp ax, 1
jz koniec
mov ax, 0A000H ; adres pamiêci ekranu dla trybu 13H
mov es, ax
mov bx, cs:piksel_gora ; adres bie¿¹cy piksela
mov dx, cs:piksel_dol
mov al, cs:kolor
mov es:[bx], al ; wpisanie kodu koloru do pamiêci ekranu
xchg bx, dx
mov es:[bx], al
xchg bx, dx
; pierwsza przekatna
mov dx, 0
mov ax, cs:przyrost
div cs:tysiac
mov cx, ax
add cs:przyrost, 625
mov ax, cs:przyrost
mov dx, 0
div cs:tysiac
cmp cx, ax
je ta_sama_linia
add bx, 320
sub cs:piksel_dol, 320
ta_sama_linia:
add bx, 1
add cs:piksel_dol, 1
cmp bx, 320*200
jae koniec
; zapisanie adresu bie¿¹cego piksela
mov cs:piksel_gora, bx
jmp koniec_koncow
; druga przekatna
koniec:
mov cs:koniec_malowanie, 1
koniec_koncow:
; odtworzenie rejestrów
pop dx
pop es
pop bx
pop ax
; skok do oryginalnego podprogramu obs³ugi przerwania
; zegarowego
jmp dword PTR cs:wektor8
; zmienne procedury
tysiac dw 1000
kolor db 1 ; bie¿¹cy numer koloru
piksel_gora dw 0 ; bie¿¹cy adres piksela
piksel_dol dw 320*199
przyrost dw 0
koniec_malowanie dw 0
wektor8 dd ?
linia ENDP
; INT 10H, funkcja nr 0 ustawia tryb sterownika graficznego
zacznij:
mov ah, 0
mov al, 13H ; nr trybu
int 10H
mov bx, 0
mov es, bx ; zerowanie rejestru ES
mov eax, es:[32] ; odczytanie wektora nr 8
mov cs:wektor8, eax; zapamiêtanie wektora nr 8
; adres procedury 'linia' w postaci segment:offset
mov ax, SEG linia
mov bx, OFFSET linia
cli ; zablokowanie przerwañ
; zapisanie adresu procedury 'linia' do wektora nr 8
mov es:[32], bx
mov es:[32+2], ax
sti ; odblokowanie przerwañ
czekaj:
mov ah, 1 ; sprawdzenie czy jest jakiœ znak
int 16h ; w buforze klawiatury
jz czekaj
mov ah, 0 ; funkcja nr 0 ustawia tryb sterownika
mov al, 3H ; nr trybu
int 10H
; odtworzenie oryginalnej zawartoœci wektora nr 8
mov eax, cs:wektor8
mov es:[32], eax
; zakoñczenie wykonywania programu
mov ax, 4C00H
int 21H
rozkazy ENDS
stosik SEGMENT stack
db 256 dup (?)
stosik ENDS
END zacznij