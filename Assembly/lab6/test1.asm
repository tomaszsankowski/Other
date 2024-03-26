; Program linie.asm
; Wyœwietlanie znaków * w takt przerwañ zegarowych
; Uruchomienie w trybie rzeczywistym procesora x86
; lub na maszynie wirtualnej
; zakoñczenie programu po naciœniêciu dowolnego klawisza
; asemblacja (MASM 4.0): masm gwiazdki.asm,,,;
; konsolidacja (LINK 3.60): link gwiazdki.obj;
.386
rozkazy SEGMENT use16
ASSUME cs:rozkazy

obsluga_klawiatury PROC
    push ax
    push cx
    push dx
    in al, 60h
    cmp al, 19
    je wcisniete
    cmp al, 147
    je zwolnione
    jmp koniec_klawiatury
wcisniete:
    mov cs:wcisniete_r, 1
    jmp koniec_klawiatury
zwolnione:
    mov cs:wcisniete_r, 0
koniec_klawiatury:
    pop dx
    pop cx
    pop ax
    jmp dword PTR cs:wektor9

wcisniete_r db 0
wektor9 dd ?
obsluga_klawiatury ENDP

linia PROC
; przechowanie rejestrów
push ax
push bx
push es
cmp cs:akt_kolor, 4
je nie_r
cmp cs:wcisniete_r, 1
jne nie_r
dec cs:counter_r
cmp cs:counter_r, 0
jnz nie_r
mov cs:akt_kolor, 4
nie_r:
; wybor koloru
dec cs:counter
cmp cs:counter, 0
jne kolor_bez_zmian
mov cs:counter, 5
mov al, cs:akt_kolor
cmp cs:kolor, al
jne kolor_zolty
mov cs:kolor, 0
jmp kolor_bez_zmian
kolor_zolty:
mov al, cs:akt_kolor
mov cs:kolor, al
kolor_bez_zmian:
mov ax, 0A000H ; adres pamiêci ekranu dla trybu 13H
mov es, ax
mov bx, 320*90+150
mov cx, 20*20
mov dx, 20
ptl:
mov al, cs:kolor
mov es:[bx], al
inc bx
dec dx
cmp dx, 0
jnz nowa_linia
mov dx, 20
add bx, 320-20
nowa_linia:
loop ptl
; odtworzenie rejestrów
pop es
pop bx
pop ax
; skok do oryginalnego podprogramu obs³ugi przerwania
; zegarowego
jmp dword PTR cs:wektor8
; zmienne procedury
; 1-niebieski; 2-zielony; 3-cyan; 4-czerwony; 5-rozowy
kolor db 14 ; bie¿¹cy numer koloru
akt_kolor db 14 ; zolty/czewony
wektor8 dd ?
counter db 5
counter_r db 36
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

mov eax, es:[36] ; odczytanie wektora nr 8
mov cs:wektor9, eax; zapamiêtanie wektora nr 8
; adres procedury 'linia' w postaci segment:offset
mov ax, SEG obsluga_klawiatury
mov bx, OFFSET obsluga_klawiatury
cli ; zablokowanie przerwañ
; zapisanie adresu procedury 'linia' do wektora nr 8
mov es:[36], bx
mov es:[36+2], ax
sti ; odblokowanie przerwañ

czekaj:
mov ah, 0 ; sprawdzenie czy jest jakiœ znak
int 16h ; w buforze klawiatury
cmp al, 'x'
jnz czekaj
mov ah, 0 ; funkcja nr 0 ustawia tryb sterownika
mov al, 3H ; nr trybu
int 10H
; odtworzenie oryginalnej zawartoœci wektora nr 8
mov eax, cs:wektor8
mov es:[32], eax

mov eax, cs:wektor9
mov es:[36], eax
; zakoñczenie wykonywania programu
mov ax, 4C00H
int 21H
rozkazy ENDS
stosik SEGMENT stack
db 256 dup (?)
stosik ENDS
END zacznij