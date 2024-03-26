.686
.model flat

public _merge
.data
tablica dd 32 dup (?)
.code
_merge PROC
	push ebp
	mov ebp, esp
	push edi
	mov ecx, [ebp+16] ; w ecx size tablicy
	cmp ecx, 16 ; sprawdzamy, czy tablice s¹ mniejsze od 16
	ja za_duza
	cmp ecx, 0 ; sprawdzamy, czy tablice nie s¹ puste
	je koniec
	mov edi, 0 ; edi to indeks tablicy
	
	mov edx, [ebp+8] ; w edx adres tab1
ptl1:
	mov eax, [edx]
	mov tablica[edi], eax
	add edx, 4 ; i++ dla inta
	add edi, 4 ; i++ dla dworda
	loop ptl1 ; obs³uga pêtli

	mov ecx, [ebp+16] ; znowu do ecx dajemy size
	mov edx, [ebp+12] ; w edx adres tab2
ptl2:
	mov eax, [edx]
	mov tablica[edi], eax
	add edx, 4
	add edi, 4
	loop ptl2

	mov eax, offset tablica ; do eax dajemy pointer na nasz¹ tablice
	jmp koniec
za_duza:
	mov eax, 0 ; do EAX dajemy NULL
koniec:
	pop edi
	pop ebp
	ret
_merge ENDP
END