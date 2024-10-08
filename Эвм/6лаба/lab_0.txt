;Демонстрационная программа сложения двух
;одноразрядных беззнаковых чисел
;Для построения рабочей версии используйте
;команды:
; >tasm demo;
; >tlink demo;
; >demo
; Резервирoвание места под стек
sseg segment stack 'stack'
 dw 256 dup(?)
sseg ends
data segment
msg1 db 10,13,'Programm that subbing two numbers'
 db 10,13,'Enter first number: ','$'
msg2 db 10,13,'Enter second num: ','$'
msg3 db 10,13,'Result = ','$'
data ends
code segment
assume cs:code,ds:data,ss:sseg
start: mov ax,data 
 mov ds,ax 
 lea dx,msg1 
 call print_msg
 call input_digit
 mov bl,al 
 lea dx,msg2 
 call print_msg
 call input_digit
 lea dx,msg3 
 call print_msg
 call sub_and_show
 mov ah,4ch 
 int 21h 
print_msg proc
 push ax 
 mov ah,09h 
 int 21h 
 pop ax 
 ret 
print_msg endp
input_digit proc
input_again:
 mov ah,01h 
 int 21h
 cmp al,'0' 
 jl input_again 
 cmp al,'9'
 jg input_again
 sub al,30h
 ret 
input_digit endp
sub_and_show proc
 sub bl,al
 jns not_carry
 neg bl
 mov ah,2h
 mov dl,'-' 
 int 21h
not_carry: add bl,30h 
 mov ah,2h 
 mov dl,bl 
 int 21h 
 ret 
sub_and_show endp
code ends
end start