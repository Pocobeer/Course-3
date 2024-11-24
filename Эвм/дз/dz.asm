PrintByte proc
	.386
Met: in al, PORTC
	bt ax,4
	jc Met
	mov al,data
	out PORTA, al
	mov al, 0
	out PORTC, al
	call Time
	mov al,1 
	out PORTC, al
	ret
PrintByte endp