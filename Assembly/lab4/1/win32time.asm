.686
.model flat
extern _GetSystemTime@4 : PROC
public _czas
.data
tajm dw 10 dup (?)
.code
_czas PROC
	push ebp
	mov ebp,esp
	push dword ptr offset tajm
	call _GetSystemTime@4
	mov ax, word ptr tajm[10] ; i w EAX mamy aktualn¹ iloœæ minut
	movzx eax, ax
	pop ebp
	ret
_czas ENDP
END