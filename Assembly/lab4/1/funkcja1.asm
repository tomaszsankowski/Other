.686
.model flat

public _zamien_znaki
.code
_zamien_znaki PROC
	push ebp
	mov ebp,esp
	push ebx
	push esi
	mov ebx, [ebp+8] ; w ebx adres tablicy znak�w
	mov eax, 0 ; eax liczy zamienione znaki
ptl:
	cmp dword ptr [ebx], 0 ; czy znak null ( koniec stringa )
	je koniec
	mov edx, [ebp+12] ; w dl l1
	cmp dl, [ebx] ; por�wnujemy znak w tablicy ze znakiem do zaminay
	jne nie_ten ; skacz je�li znak jest inny ni� chcemy zamienia�
	mov edx, [ebp+16] ; w dl mamy teraz nasze l2
	mov [ebx], dl ; zamieniamy znak l1 na l2
	inc eax
nie_ten:
	inc ebx ; zwi�kszamy adres tablicy o 1 bajt(char)
	jmp ptl
koniec:
	pop esi
	pop ebx
	pop ebp
	ret
_zamien_znaki ENDP

END