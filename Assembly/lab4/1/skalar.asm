.686
.model flat

public _iloczyn_skalarny
.code

_iloczyn_skalarny PROC
	push ebp
	mov ebp, esp
	push ebx
	push edi
	mov ebx, [ebp+8] ; tab1 (adres)
	mov edx, [ebp+12] ; tab2 (adres)
	mov ecx, [ebp+16] ; size (wartoœæ)
	mov edi, 0 ; edi bêdzie naszym wynikiem
	cmp ecx, 0
	je koniec
ptl:
	mov eax, [ebx] ; w eax tab1[i]
	push edx
	mul dword ptr [edx] ; mno¿ymy tab1[i]*tab2[i], wynik w EAX
	pop edx
	add edi, eax ; size += tab1[i]+tab2[i]
	add ebx, 4 ; i++ dla int
	add edx, 4 ; i++ dla int
	loop ptl

koniec:
	mov eax, edi ; przenosimy wynik do eax, bo w nim go zwracamy
	pop edi
	pop ebx
	pop ebp
	ret
_iloczyn_skalarny ENDP
END